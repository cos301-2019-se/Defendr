/* Copyright(c) 2017 Jesper Dangaard Brouer, Red Hat, Inc.
   Copyright(c) 2017 Andy Gospodarek, Broadcom Limited, Inc.
 */
static const char *__doc__=
 " XDP ddos01: command line tool";

#include <assert.h>
#include <errno.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <unistd.h>
#include <locale.h>

#include <sys/resource.h>
#include <getopt.h>
#include <time.h>

#include <arpa/inet.h>
#include <netdb.h> 
#include <sys/types.h> 
#include <sys/socket.h> 
#include <netinet/in.h> 
#include <stdio.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <net/if.h>
#include <linux/unistd.h>     
#include <linux/kernel.h>       
#include <sys/sysinfo.h>

/* libbpf.h defines bpf_* function helpers for syscalls,
 * indirectly via ./tools/lib/bpf/bpf.h */
#include "libbpf.h"

#include "bpf_util.h"

#include "xdp_ddos01_blacklist_common.h"
#include "structs.h"

#define BPF_ANY       0 /* create new element or update existing */
#define BPF_NOEXIST   1 /* create new element only if it didn't exist */
#define BPF_EXIST     2 /* only update existing element */

static const struct option long_options[] = {
	{"help",	no_argument,		NULL, 'h' },
	{"add",		no_argument,		NULL, 'a' },
	{"del",		no_argument,		NULL, 'x' },
	{"ip",		required_argument,	NULL, 'i' },
	{"stats",	no_argument,		NULL, 's' },
	{"sec",		required_argument,	NULL, 's' },
	{"list",	no_argument,		NULL, 'l' },
	{"udp-dport",	required_argument,	NULL, 'u' },
	{"tcp-dport",	required_argument,	NULL, 't' },
	{"dynamic",	no_argument,		NULL, 'd' },
	{"log",	no_argument,		NULL, 'g' },
	{"backend",	required_argument,		NULL, 'b' },
	{"port",	required_argument,		NULL, 'p' },
	{"service",	required_argument,		NULL, 'n' },
	{"mac",	required_argument,		NULL, 'm' },
	{0, 0, NULL,  0 }
};

#define XDP_ACTION_MAX (XDP_TX + 1)
#define XDP_ACTION_MAX_STRLEN 11
static const char *xdp_action_names[XDP_ACTION_MAX] = {
	[XDP_ABORTED]	= "XDP_ABORTED",
	[XDP_DROP]	= "XDP_DROP",
	[XDP_PASS]	= "XDP_PASS",
	[XDP_TX]	= "XDP_TX",
};

static const char *xdp_proto_filter_names[DDOS_FILTER_MAX] = {
	[DDOS_FILTER_TCP]	= "TCP",
	[DDOS_FILTER_UDP]	= "UDP",
};

static const char *action2str(int action)
{
	if (action < XDP_ACTION_MAX)
		return xdp_action_names[action];
	return NULL;
}

struct record {
	__u64 counter;
	__u64 timestamp;
};

struct stats_record {
	struct record xdp_action[XDP_ACTION_MAX];
};

static void usage(char *argv[])
{
	int i;
	printf("\nDOCUMENTATION:\n%s\n", __doc__);
	printf("\n");
	printf(" Usage: %s (options-see-below)\n",
	       argv[0]);
	printf(" Listing options:\n");
	for (i = 0; long_options[i].name != 0; i++) {
		printf(" --%-12s", long_options[i].name);
		if (long_options[i].flag != NULL)
			printf(" flag (internal value:%d)",
			       *long_options[i].flag);
		else
			printf(" short-option: -%c",
			       long_options[i].val);
		printf("\n");
	}
	printf("\n");
}

int open_bpf_map(const char *file)
{
	int fd;

	fd = bpf_obj_get(file);
	if (fd < 0) {
		printf("ERR: Failed to open bpf map file:%s err(%d):%s\n",
		       file, errno, strerror(errno));
		exit(EXIT_FAIL_MAP_FILE);
	}
	return fd;
}

static __u64 get_key32_value64_percpu(int fd, __u32 key)
{
	/* For percpu maps, userspace gets a value per possible CPU */
	unsigned int nr_cpus = bpf_num_possible_cpus();
	__u64 values[nr_cpus];
	__u64 sum = 0;
	int i;

	if ((bpf_map_lookup_elem(fd, &key, values)) != 0) {
		fprintf(stderr,
			"ERR: bpf_map_lookup_elem failed key:0x%X\n", key);
		return 0;
	}

	/* Sum values from each CPU */
	for (i = 0; i < nr_cpus; i++) {
		sum += values[i];
	}
	return sum;
}

static void stats_print_headers(void)
{
	/* clear screen */
	printf("\033[2J");
	printf("%-12s %-10s %-8s %-9s\n",
	       "XDP_action", "pps ", "#packets", "period/sec");
}

static void stats_print(struct stats_record *record,
			struct stats_record *prev)
{
	int i;
	static int actionCounters[] = {0,0,0,0};
	int total = 0;

	for (i = 0; i < XDP_ACTION_MAX; i++) {
		struct record *r = &record->xdp_action[i];
		struct record *p = &prev->xdp_action[i];
		__u64 period  = 0;
		__u64 packets = 0;
		double pps = 0;
		double period_ = 0;

		actionCounters[i]  = r->counter;
		if (p->timestamp) {
			packets = r->counter - p->counter;
			period  = r->timestamp - p->timestamp;
			pps = packets;
			if (period > 0) {
				period_ = ((double) period / NANOSEC_PER_SEC);
				pps = packets / period_;
			}
		}
		
		total  = total +actionCounters[i];
		printf("%-12s %-10.0f %'-18d %f\n",
		       action2str(i), pps, actionCounters[i], period_);
	}
	printf("%-13s  %-9d\n","Total_Packets", total);
}

static void stats_collect(int fd, struct stats_record *rec)
{
	int i;

	for (i = 0; i < XDP_ACTION_MAX; i++) {
		rec->xdp_action[i].timestamp = gettime();
		rec->xdp_action[i].counter = get_key32_value64_percpu(fd, i);
	}
}

static void stats_poll(int interval)
{
	struct stats_record record, prev;
	int fd;

	/* TODO: Howto handle reload and clearing of maps */
	fd = open_bpf_map(file_verdict);

	memset(&record, 0, sizeof(record));

	/* Trick to pretty printf with thousands separators use %' */
	setlocale(LC_NUMERIC, "en_US");

	while (1) {
		memcpy(&prev, &record, sizeof(record));
		stats_print_headers();
		stats_collect(fd, &record);
		stats_print(&record, &prev);
		sleep(interval);
	}
	/* Not reached, but (hint) remember to close fd in other code */
	close(fd);
}

static void blacklist_print_ipv4(__u32 ip, __u64 count)
{
	char ip_txt[INET_ADDRSTRLEN] = {0};

	/* Convert IPv4 addresses from binary to text form */
	if (!inet_ntop(AF_INET, &ip, ip_txt, sizeof(ip_txt))) {
		fprintf(stderr,
			"ERR: Cannot convert u32 IP:0x%X to IP-txt\n", ip);
		exit(EXIT_FAIL_IP);
	}
	printf("\n \"%s\" : %llu", ip_txt, count);
}

static void blacklist_print_proto(int key, __u64 count)
{
	printf("\n\t\"%s\" : %llu", xdp_proto_filter_names[key], count);
}

static void blacklist_print_port(int key, __u32 val, int countfds[])
{
	int i;
	__u64 count;
	bool started = false;

	printf("\n \"%d\" : ", key);
	for (i = 0; i < DDOS_FILTER_MAX; i++) {
		if (val & (1 << i)) {
			printf("%s", started ? "," : "{");
			started = true;
			count = get_key32_value64_percpu(countfds[i], key);
			blacklist_print_proto(i, count);
		}
	}
	if (started)
		printf("\n }");
}

static void blacklist_list_all_ipv4(int fd)
{
	__u32 key, *prev_key = NULL;
	__u64 value;

	while (bpf_map_get_next_key(fd, prev_key, &key) == 0) {
		printf("%s", key ? "," : "" );
		value = get_key32_value64_percpu(fd, key);
		blacklist_print_ipv4(key, value);
		prev_key = &key;
	}
	printf("%s", key ? "," : "");

}

static void blacklist_list_all_ports(int portfd, int countfds[])
{
	__u32 key, *prev_key = NULL;
	__u64 value;
	bool started = false;

	/* printf("{\n"); */
	while (bpf_map_get_next_key(portfd, prev_key, &key) == 0) {
		if ((bpf_map_lookup_elem(portfd, &key, &value)) != 0) {
			fprintf(stderr,
				"ERR: bpf_map_lookup_elem(%d) failed key:0x%X\n", portfd, key);
		}

		if (value) {
			printf("%s", started ? "," : "");
			started = true;
			blacklist_print_port(key, value, countfds);
		}
		prev_key = &key;
	}
}

static  void activate_dynamic_blacklist(){
	    int fd_watchlist;		

		//startup run
			sleep(1);
<<<<<<< HEAD
			fd_watchlist = open_bpf_map(file_ip_watchlist);
		    __u32 key, *prev_key = NULL;
	        __u64 value;
	        char* ipsToRemove[1000];
			int numToRemove = 0;
			while (bpf_map_get_next_key(fd_watchlist, prev_key, &key) == 0) {
				value = get_key32_value64_percpu(fd_watchlist, key);
				char ip_txt[INET_ADDRSTRLEN] = {0};
				if (inet_ntop(AF_INET, &key, ip_txt, sizeof(ip_txt))) {	
					ipsToRemove[numToRemove] = malloc(strlen(ip_txt) + 1); 
					strcpy(ipsToRemove[numToRemove], ip_txt);
					++numToRemove;	
				}				
				prev_key = &key;
			}
			for(int i = 0; i < numToRemove;++i){
				watchlist_modify(fd_watchlist,ipsToRemove[i], ACTION_DEL);
				free(ipsToRemove[i]);
			}
			close(fd_watchlist);

		// continous monitor

		while(1){
			sleep(1);
=======
>>>>>>> packet_dropper
			fd_watchlist = open_bpf_map(file_ip_watchlist);
		    __u32 key, *prev_key = NULL;
	        __u64 value;
	        char* ipsToRemove[1000];
			int numToRemove = 0;
			while (bpf_map_get_next_key(fd_watchlist, prev_key, &key) == 0) {
				value = get_key32_value64_percpu(fd_watchlist, key);
				char ip_txt[INET_ADDRSTRLEN] = {0};
				if (inet_ntop(AF_INET, &key, ip_txt, sizeof(ip_txt))) {	
<<<<<<< HEAD
					printf("%s %s %llu \n","monitor ", ip_txt,value);							
					if(value > 3){
						int fd_blacklist = open_bpf_map(file_blacklist);						
						blacklist_modify(fd_blacklist,ip_txt, ACTION_ADD);
						close(fd_blacklist);	
						printf("%s %s %llu \n","blacklisted ", ip_txt,value);
					}	
=======
>>>>>>> packet_dropper
					ipsToRemove[numToRemove] = malloc(strlen(ip_txt) + 1); 
					strcpy(ipsToRemove[numToRemove], ip_txt);
					++numToRemove;	
				}				
				prev_key = &key;
			}
			for(int i = 0; i < numToRemove;++i){
				watchlist_modify(fd_watchlist,ipsToRemove[i], ACTION_DEL);
				free(ipsToRemove[i]);
			}
			close(fd_watchlist);

		// continous monitor

		while(1){
<<<<<<< HEAD
			//sleep(0.2);
			fd_enter_logs = open_bpf_map(file_enter_logs);
			fd_pass_logs = open_bpf_map(file_pass_logs);
			fd_drop_logs = open_bpf_map(file_drop_logs);
=======
			sleep(1);
			fd_watchlist = open_bpf_map(file_ip_watchlist);
>>>>>>> packet_dropper
		    __u32 key, *prev_key = NULL;
	        __u64 value;
	        char* ipsToRemove[1000];
			int numToRemove = 0;
			while (bpf_map_get_next_key(fd_watchlist, prev_key, &key) == 0) {
				value = get_key32_value64_percpu(fd_watchlist, key);
				char ip_txt[INET_ADDRSTRLEN] = {0};
				if (inet_ntop(AF_INET, &key, ip_txt, sizeof(ip_txt))) {	
<<<<<<< HEAD
					//value -= 1;			
					printf("%s %s \n","entered ", ip_txt);
					//printf("c1 %d %s \n",value, ip_txt);						
					//if(value <= 0){		
						enterLogsToRemove[numEnterLogsToRemove] = malloc(strlen(ip_txt) + 1); 
						strcpy(enterLogsToRemove[numEnterLogsToRemove], ip_txt);
						++numEnterLogsToRemove;					
					//}	

=======
					printf("%s %s %llu \n","monitor ", ip_txt,value);							
					if(value > 3){
						int fd_blacklist = open_bpf_map(file_blacklist);						
						blacklist_modify(fd_blacklist,ip_txt, ACTION_ADD);
						close(fd_blacklist);	
						printf("%s %s %llu \n","blacklisted ", ip_txt,value);
					}	
					ipsToRemove[numToRemove] = malloc(strlen(ip_txt) + 1); 
					strcpy(ipsToRemove[numToRemove], ip_txt);
					++numToRemove;	
>>>>>>> packet_dropper
				}				
				prev_key = &key;
			}
			for(int i = 0; i < numToRemove;++i){
				watchlist_modify(fd_watchlist,ipsToRemove[i], ACTION_DEL);
				free(ipsToRemove[i]);
			}
			close(fd_watchlist);
		}		
}

static  void start_logging(){
	    struct sysinfo s_info;
		int error = sysinfo(&s_info);
		long boot_time =  (unsigned long)time(NULL)-s_info.uptime;
		printf("time of boot is: %d\n",boot_time);
		while(1){
			sleep(1);
			int fd_logs = open_bpf_map(file_logs);
			__u64 key, *prev_key = NULL;
			__u64 logsToRemove[1000];
			int numLogsToRemove = 0;
			struct log *packet_log = (struct log*)malloc(sizeof(struct log));
			int count = 0;
			key = NULL;
			prev_key = NULL;
<<<<<<< HEAD
			//sleep(0.2);
			while (bpf_map_get_next_key(fd_pass_logs, prev_key, &key) == 0) {
				value = get_key32_value64_percpu(fd_pass_logs, key);
				char ip_txt[INET_ADDRSTRLEN] = {0};
				if (inet_ntop(AF_INET, &key, ip_txt, sizeof(ip_txt))) {	
					//value -= 1;
					printf("%s %s \n","passed ", ip_txt);		
					//printf("c2 %d %s \n",value, ip_txt);							
					//if(value <= 0){
						passLogsToRemove[numPassLogsToRemove] = malloc(strlen(ip_txt) + 1); 
						strcpy(passLogsToRemove[numPassLogsToRemove], ip_txt);
						++numPassLogsToRemove;
					//}			
				}				
				prev_key = &key;
=======
			while (bpf_map_get_next_key(fd_logs, prev_key, &key) == 0) {
				count++;
				 int res = bpf_map_lookup_elem(fd_logs,&key,packet_log); 
				 if(res == 0){
					char src_ip[INET_ADDRSTRLEN] = {0};
					char dest_ip[INET_ADDRSTRLEN] = {0};
					if (inet_ntop(AF_INET, &packet_log->src_ip, src_ip, sizeof(src_ip)) && inet_ntop(AF_INET, &packet_log->destination_ip, dest_ip, sizeof(dest_ip))) {		
						long time = boot_time+ (key/1000000000);
						char mac_str[18];
						snprintf(mac_str, sizeof(mac_str), "%02x:%02x:%02x:%02x:%02x:%02x",packet_log->server[0], packet_log->server[1], packet_log->server[2], packet_log->server[3], packet_log->server[4], packet_log->server[5]);
						char* reason;
						char* status;
						if(packet_log->reason == REASON_NONE) reason = "none";
						else if(packet_log->reason == REASON_BLACKLIST) reason = "blacklisted";
						else if(packet_log->reason == REASON_NOSERVER) reason = "no available server";
						else if(packet_log->reason == REASON_NON_TCP) reason = "not tcp";

						if(packet_log->status == LOG_ENTER){
							status= "enter";
						}else if(packet_log->status == LOG_PASS){
							status= "pass";
						}else if(packet_log->status == LOG_DROP){
							status= "drop";
						}else{
							status= "unknown";
						}

						//if(verbose) printf("Packet( %s ):ip_src-%s, ip_dest-%s, server-%s, country-%s, reason-%s, time-%d\n",status,src_ip,dest_ip,mac_str,"SA",reason,time);
						char command[350] = {};
						snprintf(command, sizeof(command),"cd log_db && sudo ./main.o --log --packet --ip %s --status %s  --time %d --country SA  --destination %s --server %s --reason %s &",src_ip,status,time,dest_ip,mac_str,reason);						
						system(command);
						logsToRemove[numLogsToRemove] = key; 
						++numLogsToRemove;					
					}else{
						printf("conversion failed\n");
					}									 
				 }else{
					fprintf(stderr,"ERR: bpf_map_lookup_elem failed key:0x%X\n", key);
				 }
				 prev_key = &key;
>>>>>>> packet_dropper
			}
			key = NULL;
			prev_key = NULL;
<<<<<<< HEAD
			//sleep(0.2);
			while (bpf_map_get_next_key(fd_drop_logs, prev_key, &key) == 0) {
				value = get_key32_value64_percpu(fd_drop_logs, key);
				char ip_txt[INET_ADDRSTRLEN] = {0};
				if (inet_ntop(AF_INET, &key, ip_txt, sizeof(ip_txt))) {	
					value -= 1;
					printf("%s %s \n","dropped ", ip_txt);								
					//if(value <= 0){
						dropLogsToRemove[numDropLogsToRemove] = malloc(strlen(ip_txt) + 1); 
						strcpy(dropLogsToRemove[numDropLogsToRemove], ip_txt);
						++numDropLogsToRemove;		
					//}	
	
				}				
				prev_key = &key;
			}
			
			for(int i = 0; i < numEnterLogsToRemove;++i){
				log_modify(fd_enter_logs,enterLogsToRemove[i], ACTION_DEL);
				free(enterLogsToRemove[i]);
			}
			for(int i = 0; i < numPassLogsToRemove;++i){
				log_modify(fd_pass_logs,passLogsToRemove[i], ACTION_DEL);
				free(passLogsToRemove[i]);
			}
			for(int i = 0; i < numDropLogsToRemove;++i){
				log_modify(fd_drop_logs,dropLogsToRemove[i], ACTION_DEL);
				free(dropLogsToRemove[i]);
=======
			packet_log = NULL;
			for(int i = 0; i < numLogsToRemove;++i){
				__u64 keyToDel = logsToRemove[i];
				bpf_map_delete_elem(fd_logs,&keyToDel);
				
>>>>>>> packet_dropper
			}
			close(fd_logs);
		}		    
}

/*add backend server*/
static void addBackend(char* service_ip,char* backend_ip,char* backend_port,char* mac_addr){
	if (verbose) printf("adding backend with ip %s and mac %s listening on port %s to service %s\n",backend_ip,mac_addr,backend_port,service_ip);
    int fd_services = open_bpf_map(file_services); 
    int fd_servers = open_bpf_map(file_servers);  
	service_modify(fd_services,fd_servers, service_ip,backend_ip, atoi(backend_port),mac_addr,ACTION_ADD);
	close(fd_services);
	close(fd_servers);
}

/*remove backend server*/
static void removeBackend(char* service_ip,char* backend_ip){
	if (verbose) printf("removing backend with ip %s from service %s\n",backend_ip,service_ip);	
	int fd_services = open_bpf_map(file_services); 
    int fd_servers = open_bpf_map(file_servers);  
	service_modify(fd_services,fd_servers, service_ip,backend_ip,0,"",ACTION_DEL);
	close(fd_services);
	close(fd_servers);
}

static void printServiceBackends(char* service_ip){
	if(verbose) printf("Listing backends for service %s\n",service_ip);
	 __u32 key,prev_key;
	 int res = inet_pton(AF_INET, service_ip, &key);
	 if (res <= 0) {
		if (res == 0)
			fprintf(stderr,
				"ERR: IPv4 \"%s\" not in presentation format\n",
				service_ip);
		else
			perror("inet_pton");
		return EXIT_FAIL_IP;
	 }
	 
	 struct service *value = (struct service*)malloc(sizeof(struct service));
	 int fd_services = open_bpf_map(file_services);  
	 int fd_servers = open_bpf_map(file_servers);  
	 res = bpf_map_lookup_elem(fd_services,&key,value); 
	 if(res == 0){
		for(int i = 0;i < value->num_servers;++i){
			 struct dest_info *backend =(struct dest_info*)malloc(sizeof(struct dest_info));
			__u32 id = value->id+i+1;
			res = bpf_map_lookup_elem(fd_servers,&id,backend); 
			if(res==0){
					char ip_txt[INET_ADDRSTRLEN] = {0};
					if (inet_ntop(AF_INET, &(backend->daddr), ip_txt, sizeof(ip_txt))) {	
						printf("server %s with id %d listening on port %d \n", ip_txt,id,backend->port);								
					}			
			}

		 }	
	 }
	 close(fd_services);
	 close(fd_servers);
}

/*Interface for interacting with bpf maps*/
int main(int argc, char **argv)
{
#	define STR_MAX 42 /* For trivial input validation */
	char _ip_string_buf[STR_MAX] = {};
	char *ip_string = NULL;
	char _service_ip_buf[STR_MAX] = {};
	char *service_ip = NULL;
	/*char _backend_ip_buf[STR_MAX] = {};
	char *backend_ip = NULL;*/
	char _mac_addr_buf[STR_MAX] = {};
	char *mac_addr = NULL;
	char _backend_port_buf[STR_MAX] = {};
	char *backend_port = NULL;
	unsigned int action = 0;
	bool stats = false;
	int interval = 1;
	int fd_blacklist;
	int fd_verdict;
	int fd_port_blacklist;
	int fd_port_blacklist_count;
	int longindex = 0;
	bool do_list = false;
	bool dynamic_blacklist = false;
	bool log = false;
	int opt;
	int dport = 0;
	int proto = IPPROTO_TCP;
	int filter = DDOS_FILTER_TCP;
	while ((opt = getopt_long(argc, argv, "adshi:t:u:",
				  long_options, &longindex)) != -1) {
		switch (opt) {
		case 'a':
			action |= ACTION_ADD;
			break;
		case 'x':
			action |= ACTION_DEL;
			break;
		case 'i':
			if (!optarg || strlen(optarg) >= STR_MAX) {
				printf("ERR:  ip too long or NULL\n");
				goto fail_opt;
			}
			ip_string = (char *)&_ip_string_buf;
			strncpy(ip_string, optarg, STR_MAX);
			break;
		case 'p':
			if (!optarg || strlen(optarg) >= STR_MAX) {
				printf("ERR: port number too long or NULL\n");
				goto fail_opt;
			}
			backend_port = (char *)&_backend_port_buf;
			strncpy(backend_port, optarg, STR_MAX);
			break;
		case 'n':
			if (!optarg || strlen(optarg) >= STR_MAX) {
				printf("ERR: service ip too long or NULL\n");
				goto fail_opt;
			}
			service_ip = (char *)&_service_ip_buf;
			strncpy(service_ip, optarg, STR_MAX);
			break;
		case 'm':
			if (!optarg || strlen(optarg) >= STR_MAX) {
				printf("ERR: mac address too long or NULL\n");
				goto fail_opt;
			}
			mac_addr = (char *)&_mac_addr_buf;
			strncpy(mac_addr, optarg, STR_MAX);
			break;
		case 'u':
			proto = IPPROTO_UDP;
			filter = DDOS_FILTER_UDP;
		case 't':
			if (optarg)
				dport = atoi(optarg);
			break;
		case 's': /* shared: --stats && --sec */
			stats = true;
			if (optarg)
				interval = atoi(optarg);
			break;
		case 'l':
			do_list = true;
			break;
		case 'd':
			dynamic_blacklist = true;
			break;
		case 'g':
			log = true;
			break;
		case 'h':
		fail_opt:
		default:
			usage(argv);
			return EXIT_FAIL_OPTION;
		}
	}
	fd_verdict = open_bpf_map(file_verdict);

	/* Update blacklist */
	if (action) {
		int res = 0;

		if (!ip_string && !dport) {
			fprintf(stderr,
			  "");
			goto fail_opt;
		}
		
		if(service_ip){			
			if(action == ACTION_ADD){
				addBackend(service_ip,ip_string,backend_port,mac_addr);
			}else{
				removeBackend(service_ip,ip_string);
			}
		}else if (ip_string) {
			fd_blacklist = open_bpf_map(file_blacklist);
			res = blacklist_modify(fd_blacklist, ip_string, action);
			close(fd_blacklist);
		}

		if (dport) {
			fd_port_blacklist = open_bpf_map(file_port_blacklist);
			fd_port_blacklist_count = open_bpf_map(file_port_blacklist_count[filter]);
			res = blacklist_port_modify(fd_port_blacklist, fd_port_blacklist_count, dport, action, proto);
			close(fd_port_blacklist);
			close(fd_port_blacklist_count);
		}
		return res;
	}

	/* Catch non-option arguments */
	if (argv[optind] != NULL) {
		fprintf(stderr, "ERR: Unknown non-option argument: %s\n",
			argv[optind]);
		goto fail_opt;
	}

	if (do_list) {
		if(service_ip){
			printServiceBackends(service_ip);
		}else{
			printf("{");
			int fd_port_blacklist_count_array[DDOS_FILTER_MAX];
			int i;

			fd_blacklist = open_bpf_map(file_blacklist);
			blacklist_list_all_ipv4(fd_blacklist);
			close(fd_blacklist);

			fd_port_blacklist = open_bpf_map(file_port_blacklist);
			for (i = 0; i < DDOS_FILTER_MAX; i++)
				fd_port_blacklist_count_array[i] = open_bpf_map(file_port_blacklist_count[i]);
			blacklist_list_all_ports(fd_port_blacklist, fd_port_blacklist_count_array);
			close(fd_port_blacklist);
			printf("\n}\n");
			for (i = 0; i < DDOS_FILTER_MAX; i++)
			close(fd_port_blacklist_count_array[i]);
		}
	}

	/* Show statistics by polling */
	if (stats) {
		stats_poll(interval);
	}
	
	if(dynamic_blacklist){
		activate_dynamic_blacklist();
	}

	if(log){
		start_logging();
	}
	// TODO: implement stats for verdicts
	// Hack: keep it open to inspect /proc/pid/fdinfo/3
	close(fd_verdict);
}

static void display_all(){
	    int fd_blacklist;
		fd_blacklist = open_bpf_map(file_blacklist);
		blacklist_list_all_ipv4(fd_blacklist);
		close(fd_blacklist);
}

