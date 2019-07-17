/*  XDP program responsible for packet filtering and load balancing*/

#define KBUILD_MODNAME "foo"
#include <uapi/linux/bpf.h>
#include <uapi/linux/if_ether.h>
#include <uapi/linux/if_packet.h>
#include <uapi/linux/if_vlan.h>
#include <uapi/linux/ip.h>
#include <uapi/linux/in.h>
#include <linux/ipv6.h>
#include <uapi/linux/tcp.h>
#include <uapi/linux/udp.h>
#include "bpf_helpers.h"
#include "structs.h"
#include <net/checksum.h>
#include <linux/skbuff.h>

#define BPF_ANY       0 /* create new element or update existing */
#define BPF_NOEXIST   1 /* create new element only if it didn't exist */
#define BPF_EXIST     2 /* only update existing element */
#define MAX_SERVERS 512
#define JHASH_INITVAL	0xdeadbeef
#define IP_FRAGMENTED 65343

void *malloc(size_t);

enum {
	DDOS_FILTER_TCP = 0,
	DDOS_FILTER_UDP,
	DDOS_FILTER_MAX,
};

// Structure for storing packet meta data used for packet filtering.
struct pkt_meta {
	__be32 src;
	__be32 dst;
	union {
		__u32 ports;
		__u16 port16[2];
	};
};

// Map containing blacklisted ips.
struct bpf_map_def SEC("maps") blacklist = {
	.type        = BPF_MAP_TYPE_PERCPU_HASH,
	.key_size    = sizeof(u32),
	.value_size  = sizeof(u64),
	.max_entries = 100000,
	.map_flags   = BPF_F_NO_PREALLOC,
};

// Map keeping track of suspisous ips
struct bpf_map_def SEC("maps") ip_watchlist = {
	.type        = BPF_MAP_TYPE_PERCPU_HASH,
	.key_size    = sizeof(u32),
	.value_size  = sizeof(u64), 
	.max_entries = 100000,
	.map_flags   = BPF_F_NO_PREALLOC,
};

// Map used for logging incoming trafic as well as decisions that have been made.
struct bpf_map_def SEC("maps") logs = {
    .type        = BPF_MAP_TYPE_HASH,
	.key_size    = sizeof(u64),
	.value_size  = sizeof(struct log), 
	.max_entries = 100000,
	.map_flags   = BPF_F_NO_PREALLOC,
};

// Map containing registered back-end instances
struct bpf_map_def SEC("maps") servers = {
	.type = BPF_MAP_TYPE_HASH,
	.key_size = sizeof(u32),
	.value_size = sizeof(struct dest_info),
	.max_entries = MAX_SERVERS,
};

// Map containing registered services
struct bpf_map_def SEC("maps") services = {
	.type = BPF_MAP_TYPE_HASH,
	.key_size = sizeof(u32),
	.value_size = sizeof(struct service),
	.max_entries = MAX_SERVERS,
};

// Map that keeps track of destinatin instances of tcp connections
struct bpf_map_def SEC("maps") destinations = {
	.type = BPF_MAP_TYPE_HASH,
	.key_size = sizeof(u32),
	.value_size = sizeof(u32),
	.max_entries = MAX_SERVERS,
};

#define XDP_ACTION_MAX (XDP_TX + 1)

// Map acting as counter per XDP "action" verdict */
struct bpf_map_def SEC("maps") verdict_cnt = {
	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
	.key_size = sizeof(u32),
	.value_size = sizeof(long),
	.max_entries = XDP_ACTION_MAX,
};

struct bpf_map_def SEC("maps") port_blacklist = {
	.type        = BPF_MAP_TYPE_PERCPU_ARRAY,
	.key_size    = sizeof(u32),
	.value_size  = sizeof(u32),
	.max_entries = 65536,
};


// Map for keeping tcp drop counter 
struct bpf_map_def SEC("maps") port_blacklist_drop_count_tcp = {
	.type        = BPF_MAP_TYPE_PERCPU_ARRAY,
	.key_size    = sizeof(u32),
	.value_size  = sizeof(u64),
	.max_entries = 65536,
};

// Map for keeping udp drop counter 
struct bpf_map_def SEC("maps") port_blacklist_drop_count_udp = {
	.type        = BPF_MAP_TYPE_PERCPU_ARRAY,
	.key_size    = sizeof(u32),
	.value_size  = sizeof(u64),
	.max_entries = 65536,
};

/* Computes hash based on packet meta data.
 * @param a Packet ip source address.
 * @param b Packet source and destination port.
 * @param initval Maximum amount of servers.
 * @return Calculated hash.
 */
static inline u32 hash(u32 a, u32 b, u32 initval){
	initval += JHASH_INITVAL + (2 << 2);
	a += initval;
	b += initval;
	u32 c = 0;
	c += initval;

        c ^= b; c -= rol32(b, 14);		
	a ^= c; a -= rol32(c, 11);		
	b ^= a; b -= rol32(a, 25);		
	c ^= b; c -= rol32(b, 16);		
	a ^= c; a -= rol32(c, 4);		
	b ^= a; b -= rol32(a, 14);		
	c ^= b; c -= rol32(b, 24); 

	return c;
}
//#define DEBUG 1
#ifdef  DEBUG
/* Only use this for debug output. Notice output from bpf_trace_printk()
 * end-up in /sys/kernel/debug/tracing/trace_pipe
 */
#define bpf_debug(fmt, ...)						\
		({							\
			char ____fmt[] = fmt;				\
			bpf_trace_printk(____fmt, sizeof(____fmt),	\
				     ##__VA_ARGS__);			\
		})
#else
#define bpf_debug(fmt, ...) { } while (0)
#endif

/* Calculates ip header checksum.
 * @param buf Pointer to start of ip header.
 * @param buf_size Size of ip header.
 * @return Calculated ip header cheacksum.
 * */
static inline unsigned short checksumIP(unsigned short *buf, int buf_size) {
    unsigned long sum = 0;

    while (buf_size > 1) {
        sum += *buf;
        buf++;
        buf_size -= 2;
    }

    if (buf_size == 1) {
        sum += *(unsigned char *)buf;
    }

    sum = (sum & 0xffff) + (sum >> 16);
    sum = (sum & 0xffff) + (sum >> 16);

    return ~sum;
}

/* Adds destination for new tcp connection.
 * @param pkt Packet meta data.
 */
static __always_inline void addDestination(struct pkt_meta *pkt){
	struct dest_info *tnl;
	__u32 hashKey = hash(pkt->src, pkt->ports, MAX_SERVERS) % MAX_SERVERS;
	__u32 key = ntohl(pkt->dst);;
	struct service *app = bpf_map_lookup_elem(&services, &key);
	u32 server_id  = MAX_SERVERS+1;
	u64 service_id = 10;
	if(app){
		service_id = app->id;
		server_id = app->last_used;
		#pragma clang loop unroll(full)
		for(int i = 1;i < MAX_INSTANCES+1;++i){
			server_id = (server_id + 1)%service_id + service_id;
			tnl = bpf_map_lookup_elem(&servers, &server_id);
			if(tnl){
					bpf_map_update_elem(&destinations, &hashKey,&server_id,BPF_ANY);
					app->last_used = server_id;
			}
		}
	}
}

/* REmoves destination for closed tcp connection.
 * @param pkt Packet meta data.
 */
static __always_inline void removeDestination(struct pkt_meta *pkt){
	__u32 hashKey = hash(pkt->src, pkt->ports, MAX_SERVERS) % MAX_SERVERS;
	bpf_map_delete_elem(&destinations, &hashKey);
}

/* Retrieves available back-end instance  
 * @param pkt Packet meta data.
 * @return selected back-end instance
 */
static __always_inline struct dest_info *hash_get_dest(struct pkt_meta *pkt){	
	__u32 key,hashKey;
	struct dest_info *tnl;	
	struct service *app;
	u32 *server_id_ptr;
	u32 server_id  = MAX_SERVERS+1;
	tnl =NULL;
	key =0;
	app = NULL;
	
	// Hash packet source ip with both ports to obtain a destination back-end.
	hashKey = hash(pkt->src, pkt->ports, MAX_SERVERS) % MAX_SERVERS;

	
	// Try to get previous server used.
	server_id_ptr = bpf_map_lookup_elem(&destinations, &hashKey);
	
	// Ensure key is not NULL.
	if(server_id_ptr && server_id_ptr != NULL){
		server_id = *server_id_ptr;	
	}
	
	if(server_id !=  MAX_SERVERS+1){			
			tnl = bpf_map_lookup_elem(&servers, &server_id);
			if (tnl) {
				return tnl;
			}
	}
	// Try to get alternative server.
	key = ntohl(pkt->dst);
	app = bpf_map_lookup_elem(&services, &key);
	if (app) {
		u64 service_id = app->id;	
		server_id = app->last_used;
		#pragma clang loop unroll(full)
		for(int i = 1;i < MAX_INSTANCES+1;++i){
			server_id = (server_id + 1)%service_id + service_id;
			tnl = bpf_map_lookup_elem(&servers, &server_id);
			if(tnl){
					bpf_map_update_elem(&destinations, &hashKey,&server_id,BPF_ANY);
					app->last_used = server_id;
					return tnl;
			}
		}
		
	}
	// No available server to recieve packet
	return NULL; 

}

// Keeps stats of XDP_DROP vs XDP_PASS.
static __always_inline
void stats_action_verdict(u32 action)
{
	u64 *value;

	if (action >= XDP_ACTION_MAX)
		return;

	value = bpf_map_lookup_elem(&verdict_cnt, &action);
	if (value)
		*value += 1;
}

/*Extracts source and destination udp ports.
 * @param off Udp header offset.
 * @param data_end End of data packet.
 * @return Port extraction success or failure.
 */
static __always_inline bool parse_udp(void *data, __u64 off, void *data_end,
				      struct pkt_meta *pkt)
{
	struct udphdr *udp;

	udp = data + off;
	if (udp + 1 > data_end)
		return false;

	pkt->port16[0] = udp->source;
	pkt->port16[1] = udp->dest;

	return true;
}

/*Extracts source and destination udp ports.
 * @param off Tcp header offset.
 * @param data_end End of data packet.
 * @return Port extraction success or failure.
 */
static __always_inline bool parse_tcp(void *data, __u64 off, void *data_end,
				      struct pkt_meta *pkt)
{
	struct tcphdr *tcp;

	tcp = data + off;
	if (tcp + 1 > data_end)
		return false;

	pkt->port16[0] = tcp->source;
	pkt->port16[1] = tcp->dest;

	return true;
}


/*Entry point for xdp program which gets packet data and keeps track of verdicts
 *@param ctx given packet context to be evaluated
 *@return action for given packet
 */
SEC("xdp_prog")
int  xdp_program(struct xdp_md *ctx)
{
    int rc = XDP_DROP;
    uint64_t nh_off = 0;

    unsigned short old_daddr;
    u64 *value;
	__u64 initialValue = 1;
	u32 ip_src;
	__u16 payload_len;
	struct pkt_meta pkt = {};
	struct dest_info *tnl;
	__u16 pkt_size;
	__u64 time;

    // Read data.
    void* data_end = (void*)(long)ctx->data_end;
    void* data = (void*)(long)ctx->data;

    // Retrieve ethernet frame header.
    struct ethhdr *eth = data;

    // Check frame header size.
    nh_off = sizeof(*eth);
    if (data + nh_off > data_end) {
        return rc;
    }

    // Check protocol.
    if (eth->h_proto != htons(ETH_P_IP)) {
        // Non ETH_P_IP protocols not yet supported so just let pass.
        return XDP_PASS;
    }

    // Check packet header size
    struct iphdr *iph = data + nh_off;
    nh_off += sizeof(struct iphdr);
    if (data + nh_off > data_end) {
        return rc;
    }
    payload_len = ntohs(iph->tot_len);

	ip_src = iph->saddr;
	ip_src = ntohl(ip_src); 
	__u32 destination_ip = ntohl(iph->daddr);

	struct log enter_log = {};
	enter_log.src_ip = ip_src;
	enter_log.status = LOG_ENTER;
	enter_log.reason = REASON_NONE;
	enter_log.destination_ip = destination_ip;
	enter_log.server[0] = eth->h_dest[0];
	enter_log.server[1] = eth->h_dest[0];
	enter_log.server[2] = eth->h_dest[0];
	enter_log.server[3] = eth->h_dest[0];
	enter_log.server[4] = eth->h_dest[0];
	enter_log.server[5] = eth->h_dest[0];
	time = bpf_ktime_get_ns();
	bpf_map_update_elem(&logs,&time,&enter_log,BPF_ANY);

    // Check tcp header size
    struct tcphdr *tcph = data + nh_off;
    nh_off += sizeof(struct tcphdr);
    if (data + nh_off > data_end) {
        return rc;
    }
	
	value = bpf_map_lookup_elem(&blacklist, &ip_src);
	if (value) {
		*value += 1; 		
			    
		struct log drop_log = {};
		drop_log.src_ip = ip_src;
		drop_log.status = LOG_DROP;
		drop_log.reason = REASON_BLACKLIST;
		drop_log.destination_ip = destination_ip;
		drop_log.server[0] = eth->h_dest[0];
		drop_log.server[1] = eth->h_dest[1];
		drop_log.server[2] = eth->h_dest[2];
		drop_log.server[3] = eth->h_dest[3];
		drop_log.server[4] = eth->h_dest[4];
		drop_log.server[5] = eth->h_dest[5];
	    time = bpf_ktime_get_ns();
		bpf_map_update_elem(&logs,&time,&drop_log,BPF_ANY);
		
		return XDP_DROP;
	}else{
		value = bpf_map_lookup_elem(&ip_watchlist,&ip_src);
		if (value) {
			*value += 1;
		}else{
			bpf_map_update_elem(&ip_watchlist,&ip_src,&initialValue,BPF_NOEXIST);
		}
		
		// Non IPPROTO_TCP protocols not yet supported so just let pass.
		if (iph->protocol != IPPROTO_TCP) {
				struct log pass_log = {};
				pass_log.src_ip = ip_src;
				pass_log.status = LOG_PASS;
				pass_log.reason = REASON_NON_TCP;
				pass_log.destination_ip = destination_ip;
				pass_log.server[0] = eth->h_dest[0];
				pass_log.server[1] = eth->h_dest[0];
				pass_log.server[2] = eth->h_dest[0];
				pass_log.server[3] = eth->h_dest[0];
				pass_log.server[4] = eth->h_dest[0];
				pass_log.server[5] = eth->h_dest[0];
				time = bpf_ktime_get_ns();
				bpf_map_update_elem(&logs,&time,&pass_log,BPF_ANY);
		   return XDP_PASS;
		}
		
		pkt.src = iph->saddr;
		pkt.dst = iph->daddr;
		pkt.port16[0] = tcph->source;
		pkt.port16[1] = tcph->dest;		
		
		__u32 ip_dest = ntohl(iph->daddr); 
		value = bpf_map_lookup_elem(&services,&ip_dest);
		if(value){
			
			/*if(tcph->syn == 1){
				addDestination(&pkt);
			}else if (tcph->fin == 1){
				removeDestination(&pkt);
			}*/
			
			tnl = NULL;		
			tnl = hash_get_dest(&pkt);
			if (tnl == NULL){ 
				struct log no_server_log = {};
				no_server_log.src_ip = ip_src;
				no_server_log.status = LOG_DROP;
				no_server_log.reason = REASON_NOSERVER;
				no_server_log.destination_ip = destination_ip;
				no_server_log.server[0] = eth->h_dest[0];
				no_server_log.server[1] = eth->h_dest[1];
				no_server_log.server[2] = eth->h_dest[2];
				no_server_log.server[3] = eth->h_dest[3];
				no_server_log.server[4] = eth->h_dest[4];
				no_server_log.server[5] = eth->h_dest[5];
				time = bpf_ktime_get_ns();
				bpf_map_update_elem(&logs,&time,&no_server_log,BPF_ANY);
				return XDP_DROP; 
			}
			
			// Backup old dest address.
			old_daddr = ntohs(*(unsigned short *)&iph->daddr);

			// Overwrite destination ethernet address.
			eth->h_dest[0] = tnl->dmac[0];
			eth->h_dest[1] = tnl->dmac[1];
			eth->h_dest[2] = tnl->dmac[2];
			eth->h_dest[3] = tnl->dmac[3];
			eth->h_dest[4] = tnl->dmac[4];
			eth->h_dest[5] = tnl->dmac[5];			
			
			
			struct log pass_log = {};
			pass_log.src_ip = ip_src;
			pass_log.status = LOG_PASS;
			pass_log.reason = REASON_NONE;
			pass_log.destination_ip = destination_ip;
			pass_log.server[0] = tnl->dmac[0];
			pass_log.server[1] = tnl->dmac[1];
			pass_log.server[2] = tnl->dmac[2];
			pass_log.server[3] = tnl->dmac[3];
			pass_log.server[4] = tnl->dmac[4];
			pass_log.server[5] = tnl->dmac[5];
			time = bpf_ktime_get_ns();
			bpf_map_update_elem(&logs,&time,&pass_log,BPF_ANY);			
			
			pkt_size = (__u16)(data_end - data);
			__sync_fetch_and_add(&tnl->pkts, 1);
			__sync_fetch_and_add(&tnl->bytes, pkt_size);
			return XDP_TX;
			
		}else{
			struct log pass_log = {};
			pass_log.src_ip = ip_src;
			pass_log.status = LOG_PASS;
			pass_log.reason = REASON_NONE;
			pass_log.destination_ip = destination_ip;
			pass_log.server[0] = eth->h_dest[0];
			pass_log.server[1] = eth->h_dest[1];
			pass_log.server[2] = eth->h_dest[2];
			pass_log.server[3] = eth->h_dest[3];
			pass_log.server[4] = eth->h_dest[4];
			pass_log.server[5] = eth->h_dest[5];
			time = bpf_ktime_get_ns();
			bpf_map_update_elem(&logs,&time,&pass_log,BPF_ANY);
		}
		return XDP_PASS;
		
	}		
	
	struct log pass_log = {};
	pass_log.src_ip = ip_src;
	pass_log.status = LOG_PASS;
	pass_log.reason = REASON_NONE;
	pass_log.destination_ip = destination_ip;
	pass_log.server[0] = eth->h_dest[0];
	pass_log.server[1] = eth->h_dest[1];
	pass_log.server[2] = eth->h_dest[2];
	pass_log.server[3] = eth->h_dest[3];
	pass_log.server[4] = eth->h_dest[4];
	pass_log.server[5] = eth->h_dest[5];
	time = bpf_ktime_get_ns();
	bpf_map_update_elem(&logs,&time,&pass_log,BPF_ANY);
	return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
