#ifndef __XDP_DDOS01_BLACKLIST_COMMON_H
#define __XDP_DDOS01_BLACKLIST_COMMON_H

#include <time.h>
#include "structs.h"

/* Exit return codes */
#define	EXIT_OK			0
#define EXIT_FAIL		1
#define EXIT_FAIL_OPTION	2
#define EXIT_FAIL_XDP		3
#define EXIT_FAIL_MAP		20
#define EXIT_FAIL_MAP_KEY	21
#define EXIT_FAIL_MAP_FILE	22
#define EXIT_FAIL_MAP_FS	23
#define EXIT_FAIL_IP		30
#define EXIT_FAIL_PORT		31
#define EXIT_FAIL_BPF		40
#define EXIT_FAIL_BPF_ELF	41
#define EXIT_FAIL_BPF_RELOCATE	42

static int verbose = 1;

/* Export eBPF map for IPv4 blacklist as a file
 * Gotcha need to mount:
 *   mount -t bpf bpf /sys/fs/bpf/
 */
static const char *file_blacklist = "/sys/fs/bpf/defendr_blacklist";
static const char *file_whitelist = "/sys/fs/bpf/defendr_whitelist";
static const char *file_system_stats   = "/sys/fs/bpf/defendr_system_stats";
static const char *file_verdict   = "/sys/fs/bpf/defendr_stat_verdict";
static const char *file_ip_watchlist   = "/sys/fs/bpf/defendr_ip_watchlist";
static const char *file_logs   = "/sys/fs/bpf/defendr_logs";
static const char *file_servers   = "/sys/fs/bpf/defendr_servers";
static const char *file_services   = "/sys/fs/bpf/defendr_services";
static const char *file_destinations   = "/sys/fs/bpf/defendr_destinations";


static const char *file_port_blacklist = "/sys/fs/bpf/ddos_port_blacklist";
static const char *file_port_blacklist_count[] = {
	"/sys/fs/bpf/ddos_port_blacklist_count_tcp",
	"/sys/fs/bpf/ddos_port_blacklist_count_udp"
};

// TODO: create subdir per ifname, to allow more XDP progs

/* gettime returns the current time of day in nanoseconds.
 * Cost: clock_gettime (ns) => 26ns (CLOCK_MONOTONIC)
 *       clock_gettime (ns) =>  9ns (CLOCK_MONOTONIC_COARSE)
 */
#define NANOSEC_PER_SEC 1000000000 /* 10^9 */
uint64_t gettime(void)
{
	struct timespec t;
	int res;

	res = clock_gettime(CLOCK_MONOTONIC, &t);
	if (res < 0) {
		fprintf(stderr, "Error with gettimeofday! (%i)\n", res);
		exit(EXIT_FAIL);
	}
	return (uint64_t) t.tv_sec * NANOSEC_PER_SEC + t.tv_nsec;
}

/* Blacklist operations */
#define ACTION_ADD	(1 << 0)
#define ACTION_DEL	(1 << 1)

enum {
	DDOS_FILTER_TCP = 0,
	DDOS_FILTER_UDP,
	DDOS_FILTER_MAX
};

static int blacklist_modify(int fd, char *ip_string, unsigned int action)
{
	unsigned int nr_cpus = bpf_num_possible_cpus();
	__u64 values[nr_cpus];
	__u32 key;
	int res;

	memset(values, 0, sizeof(__u64) * nr_cpus);

	/* Convert IP-string into 32-bit network byte-order value */
	res = inet_pton(AF_INET, ip_string, &key);
	if (res <= 0) {
		if (res == 0)
			fprintf(stderr,
				"ERR: IPv4 \"%s\" not in presentation format\n",
				ip_string);
		else
			perror("inet_pton");
		return EXIT_FAIL_IP;
	}

	if (action == ACTION_ADD) {
		res = bpf_map_update_elem(fd, &key, values, BPF_NOEXIST);
	} else if (action == ACTION_DEL) {
		res = bpf_map_delete_elem(fd, &key);
	} else {
		fprintf(stderr, "ERR: %s() invalid action 0x%x\n",
			__func__, action);
		return EXIT_FAIL_OPTION;
	}

	if (res != 0) { /* 0 == success */
		fprintf(stderr,
			"%s() IP:%s key:0x%X errno(%d/%s)",
			__func__, ip_string, key, errno, strerror(errno));

		if (errno == 17) {
			fprintf(stderr, ": Already in blacklist\n");
			return EXIT_OK;
		}
		fprintf(stderr, "\n");
		return EXIT_FAIL_MAP_KEY;
	}
	if (verbose)
		fprintf(stderr,
			"%s() IP:%s key:0x%X\n", __func__, ip_string, key);
	return EXIT_OK;
}

static int service_modify(int fd_services,int fd_servers, char *service_ip,char *backend_ip,unsigned int port,char* mac_addr, unsigned int action)
{
	int server_id;
   	FILE *fptr;
	fptr = fopen("id.txt","r");
	  if(fptr != NULL){
		fscanf(fptr,"%d", &server_id); 
		fclose(fptr);          
	  }

	struct service *value = (struct service*)malloc(sizeof(struct service));
	__u32 key,backendIP,backend_id,prev_key;
	int res;
	
	//value = node;
	//memset(value, 0, sizeof(__u64));

	/* Convert IP-string into 32-bit network byte-order value */
	res = inet_pton(AF_INET, service_ip, &key);
	if (res <= 0) {
		if (res == 0)
			fprintf(stderr,
				"ERR: IPv4 \"%s\" not in presentation format\n",
				service_ip);
		else
			perror("inet_pton");
		return EXIT_FAIL_IP;
	}

	res = inet_pton(AF_INET, backend_ip, &backendIP);
	if (res <= 0) {
		if (res == 0)
			fprintf(stderr,
				"ERR: IPv4 \"%s\" not in presentation format\n",
				backend_ip);
		else
			perror("inet_pton");
		return EXIT_FAIL_IP;
	}

	if (action == ACTION_ADD) {	
		res = bpf_map_lookup_elem(fd_services,&key,value); 
		if(res != 0){
			value->last_used = 0;
			value->num_servers = 1;
			value->id = server_id;
			//server_id += MAX_INSTANCES;
			fptr = fopen("id.txt","w");
	   		if(fptr != NULL){
				fprintf(fptr,"%d",server_id+MAX_INSTANCES); 
				fclose(fptr);          
	        }

			res = bpf_map_update_elem(fd_services, &key, value, BPF_NOEXIST);
		}else{
			value->num_servers = value->num_servers+1;	
			res = bpf_map_update_elem(fd_services, &key, value, BPF_EXIST);
		}
		struct dest_info *backend = (struct dest_info*)malloc(sizeof(struct dest_info));
		backend->daddr = backendIP;
		backend->saddr = key;
		backend->bytes = 0;
		backend->pkts = 0;
		backend->cons = 0;
		backend->port = port;		

		/*convert mac address into desired format*/
		uint8_t bytes[6];
		int values[6];
		int i;

		if( 6 == sscanf( mac_addr, "%x:%x:%x:%x:%x:%x%*c",
			&values[0], &values[1], &values[2],
			&values[3], &values[4], &values[5] ) )
		{
			/* convert to uint8_t */
			for( i = 0; i < 6; ++i )
				bytes[i] = (uint8_t) values[i];
		}else{
			printf("mac address in invalid format.\n");
		}
		
		/*assign converted mac address to backend*/
		backend->dmac[0] = bytes[0];
		backend->dmac[1] = bytes[1];
		backend->dmac[2] = bytes[2];
		backend->dmac[3] = bytes[3];
		backend->dmac[4] = bytes[4];
		backend->dmac[5] = bytes[5];

		key = NULL;
		prev_key = NULL;
		backend_id = value->id+1;
		bool found = false;
		while (!found && backend_id < (value->id+10)) {
			struct dest_info *backend = (struct dest_info*)malloc(sizeof(struct dest_info));
			res = bpf_map_lookup_elem(fd_servers,&backend_id,backend); 
			if(res==0){
				backend_id += 1;	
			}else{
				found = true;
			}
		 	prev_key = &key;
		}
		res = bpf_map_update_elem(fd_servers, &backend_id, backend, BPF_ANY);

	} else if (action == ACTION_DEL) {
		res = bpf_map_lookup_elem(fd_services,&key,value); 
		if(res == 0){
			value->last_used = 0;
			if(value->num_servers > 0) value->num_servers = value->num_servers-1;
			res = bpf_map_update_elem(fd_services, &key, value, BPF_EXIST);
		}
		backend_id = value->id;

		key = NULL;
		prev_key = NULL;
		bool found = false;
		while (bpf_map_get_next_key(fd_servers, prev_key, &key) == 0 && !found) {
			struct dest_info *backend = (struct dest_info*)malloc(sizeof(struct dest_info));
			res = bpf_map_lookup_elem(fd_servers,&key,backend); 
			if(res==0){
				if(backend->daddr == backendIP){
					res = bpf_map_delete_elem(fd_servers, &backend_id);
					found = true;
				}
			}
		 	prev_key = &key;
		}
		
	} else {
		fprintf(stderr, "ERR: %s() invalid action 0x%x\n",
			__func__, action);
		return EXIT_FAIL_OPTION;
	}

	/*if (res != 0) {
		fprintf(stderr,
			"%s() IP:%s key:0x%X errno(%d/%s)",
			__func__, ip_string, key, errno, strerror(errno));

		if (errno == 17) {
			fprintf(stderr, ": Already in blacklist\n");
			return EXIT_OK;
		}
		fprintf(stderr, "\n");
		return EXIT_FAIL_MAP_KEY;
	}
	if (verbose)
		fprintf(stderr,
			"%s() IP:%s key:0x%X\n", __func__, ip_string, key);
	return EXIT_OK;*/
}

static int log_modify(int fd, char *ip_string, unsigned int action)
{
	unsigned int nr_cpus = bpf_num_possible_cpus();
	__u64 values[nr_cpus];
	__u32 key;
	int res;

	memset(values, 0, sizeof(__u64) * nr_cpus);

	/* Convert IP-string into 32-bit network byte-order value */
	res = inet_pton(AF_INET, ip_string, &key);
	if (res <= 0) {
		if (res == 0)
			fprintf(stderr,
				"ERR: IPv4 \"%s\" not in presentation format\n",
				ip_string);
		else
			perror("inet_pton");
		return EXIT_FAIL_IP;
	}

	if (action == ACTION_ADD) {
		res = bpf_map_update_elem(fd, &key, values, BPF_NOEXIST);
	} else if (action == ACTION_DEL) {
		res = bpf_map_delete_elem(fd, &key);
	} else {
		fprintf(stderr, "ERR: %s() invalid action 0x%x\n",
			__func__, action);
		return EXIT_FAIL_OPTION;
	}

	if (res != 0) { /* 0 == success */
		fprintf(stderr,
			"%s() IP:%s key:0x%X errno(%d/%s)",
			__func__, ip_string, key, errno, strerror(errno));

		if (errno == 17) {
			fprintf(stderr, ": Already in blacklist\n");
			return EXIT_OK;
		}
		fprintf(stderr, "\n");
		return EXIT_FAIL_MAP_KEY;
	}
	if (verbose)
		fprintf(stderr,
			"%s() IP:%s key:0x%X\n", __func__, ip_string, key);
	return EXIT_OK;
}



static int watchlist_modify(int fd, char *ip_string, unsigned int action)
{
	unsigned int nr_cpus = bpf_num_possible_cpus();
	__u64 values[nr_cpus];
	__u32 key;
	int res;

	memset(values, 0, sizeof(__u64) * nr_cpus);
	/* Convert IP-string into 32-bit network byte-order value */
	res = inet_pton(AF_INET, ip_string, &key);
	if (res <= 0) {
		if (res == 0)
			fprintf(stderr,
				"ERR: IPv4 \"%s\" not in presentation format\n",
				ip_string);
		else
			perror("inet_pton");
		return EXIT_FAIL_IP;
	}

	if (action == ACTION_ADD) {
		res = bpf_map_update_elem(fd, &key, values, BPF_NOEXIST);
	} else if (action == ACTION_DEL) {
		res = bpf_map_delete_elem(fd, &key);
	} else {
		fprintf(stderr, "ERR: %s() invalid action 0x%x\n",
			__func__, action);
		return EXIT_FAIL_OPTION;
	}

	if (res != 0) { /* 0 == success */
		fprintf(stderr,
			"%s() IP:%s key:0x%X errno(%d/%s)",
			__func__, ip_string, key, errno, strerror(errno));

		if (errno == 17) {
			fprintf(stderr, ": Already in blacklist\n");
			return EXIT_OK;
		}
		fprintf(stderr, "\n");
		return EXIT_FAIL_MAP_KEY;
	}
	if (verbose)
		fprintf(stderr,
			"%s() IP:%s key:0x%X\n", __func__, ip_string, key);
	return EXIT_OK;
}

static int logs_modify(int fd, char *ip_string, unsigned int action)
{
	unsigned int nr_cpus = bpf_num_possible_cpus();
	__u64 values[nr_cpus];
	__u32 key;
	int res;

	memset(values, 0, sizeof(__u64) * nr_cpus);
	/* Convert IP-string into 32-bit network byte-order value */
	res = inet_pton(AF_INET, ip_string, &key);
	if (res <= 0) {
		if (res == 0)
			fprintf(stderr,
				"ERR: IPv4 \"%s\" not in presentation format\n",
				ip_string);
		else
			perror("inet_pton");
		return EXIT_FAIL_IP;
	}

	if (action == ACTION_ADD) {
		res = bpf_map_update_elem(fd, &key, values, BPF_NOEXIST);
	} else if (action == ACTION_DEL) {
		res = bpf_map_delete_elem(fd, &key);
	} else {
		fprintf(stderr, "ERR: %s() invalid action 0x%x\n",
			__func__, action);
		return EXIT_FAIL_OPTION;
	}

	if (res != 0) { /* 0 == success */
		fprintf(stderr,
			"%s() IP:%s key:0x%X errno(%d/%s)",
			__func__, ip_string, key, errno, strerror(errno));

		if (errno == 17) {
			fprintf(stderr, ": Already in blacklist\n");
			return EXIT_OK;
		}
		fprintf(stderr, "\n");
		return EXIT_FAIL_MAP_KEY;
	}
	if (verbose)
		fprintf(stderr,
			"%s() IP:%s key:0x%X\n", __func__, ip_string, key);
	return EXIT_OK;
}

static int blacklist_port_modify(int fd, int countfd, int dport, unsigned int action, int proto)
{
	unsigned int nr_cpus = bpf_num_possible_cpus();
	__u64 curr_values[nr_cpus];
	__u64 stat_values[nr_cpus];
	__u64 value;
	__u32 key = dport;
	int res;
	int i;

	if (action != ACTION_ADD && action != ACTION_DEL)
	{
		fprintf(stderr, "ERR: %s() invalid action 0x%x\n",
			__func__, action);
		return EXIT_FAIL_OPTION;
	}

	if (proto == IPPROTO_TCP)
		value = 1 << DDOS_FILTER_TCP;
	else if (proto == IPPROTO_UDP)
		value = 1 << DDOS_FILTER_UDP;
	else {
		fprintf(stderr, "ERR: %s() invalid action 0x%x\n",
			__func__, action);
		return EXIT_FAIL_OPTION;
	}

	memset(curr_values, 0, sizeof(__u64) * nr_cpus);

	if (dport > 65535) {
		fprintf(stderr,
			"ERR: destination port \"%d\" invalid\n",
			dport);
		return EXIT_FAIL_PORT;
	}

	if (bpf_map_lookup_elem(fd, &key, curr_values)) {
		fprintf(stderr,
			"%s() 1 bpf_map_lookup_elem(key:0x%X) failed errno(%d/%s)",
			__func__, key, errno, strerror(errno));
	}

	if (action == ACTION_ADD) {
		/* add action set bit */
		for (i=0; i<nr_cpus; i++)
			curr_values[i] |= value;
	} else if (action == ACTION_DEL) {
		/* delete action clears bit */
		for (i=0; i<nr_cpus; i++)
			curr_values[i] &= ~(value);
	}

	res = bpf_map_update_elem(fd, &key, &curr_values, BPF_EXIST);

	if (res != 0) { /* 0 == success */
		fprintf(stderr,
			"%s() dport:%d key:0x%X value errno(%d/%s)",
			__func__, dport, key, errno, strerror(errno));

		if (errno == 17) {
			fprintf(stderr, ": Port already in blacklist\n");
			return EXIT_OK;
		}
		fprintf(stderr, "\n");
		return EXIT_FAIL_MAP_KEY;
	}

	if (action == ACTION_DEL) {
		/* clear stats on delete */
		memset(stat_values, 0, sizeof(__u64) * nr_cpus);
		res = bpf_map_update_elem(countfd, &key, &stat_values, BPF_EXIST);

		if (res != 0) { /* 0 == success */
			fprintf(stderr,
				"%s() dport:%d key:0x%X value errno(%d/%s)",
				__func__, dport, key, errno, strerror(errno));

			fprintf(stderr, "\n");
			return EXIT_FAIL_MAP_KEY;
		}
	}

	if (verbose)
		fprintf(stderr,
			"%s() dport:%d key:0x%X\n", __func__, dport, key);
	return EXIT_OK;
}

#endif
