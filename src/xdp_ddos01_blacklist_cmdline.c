/* Commandline tool for managing defender configurations*/

static const char *__doc__=
 " XDP ddos01: command line tool";

#include <mongoc.h>
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
#include <sys/ioctl.h>
#include <net/if.h>
#include <linux/unistd.h>     
#include <linux/kernel.h>       
#include <sys/sysinfo.h>
#include "IP2Location.h"
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
	{"blacklist",		no_argument,		NULL, 'z' },
	{"whitelist",		no_argument,		NULL, 'w' },
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
#define TOTAL_PPS 0
#define TOTAL_CPS 1
#define TOTAL_BPS 2
#define TOTAL_PPS_DROPED 3
#define TOTAL_BPS_DROPED 4
#define STATS_CATAGORIES_MAX 5

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

const int LOW = 1;
const int MED = 0;
const int HIGH = -1;
const char *uri_str = "mongodb+srv://darknites:D%40rkN1t3s@defendr-1vnvv.azure.mongodb.net/test?retryWrites=true&ssl=true";
mongoc_client_t *client = NULL;
mongoc_database_t *database = NULL;
mongoc_collection_t *collection = NULL;
mongoc_cursor_t *cursor = NULL;
bson_t *bson, *query;
bson_error_t error;
char *str;
bool retval;	    

static void init_db(){
		mongoc_init ();
		client = mongoc_client_new (uri_str);
		mongoc_client_set_appname (client, "defendr-logging");
		database = mongoc_client_get_database (client, "Defendr");
}

static void close_db(){
	mongoc_client_destroy (client);
	mongoc_cleanup (); 
}

static void insert_into_packets_list ( char* ip_source,  char* status,  char* timestamp,  char* country_id,  char* ip_destination,  char* server,  char* reason)
{
    collection = mongoc_client_get_collection (client, "Defendr", "packets_list");
	char *string;
	char *json;
	asprintf(&json,"{\"ip_source\":\"%s\",\"status\":\"%s\",\"timestamp\":\"%s\",\"country_id\":\"%s\",\"ip_destination\":\"%s\",\"server\":\"%s\",\"reason\":\"%s\"}", ip_source, status, timestamp, country_id, ip_destination, server, reason);
	//if(verbose) printf("%s\n", json);
	bson = bson_new_from_json ((const uint8_t *)json, -1, &error);

	if(!bson)
	{
		fprintf(stderr, "HERE: %s\n", error.message);
		return;
	}

	string = bson_as_canonical_extended_json (bson, NULL);
	//printf("%s\n", string);

	if(!mongoc_collection_insert_one(collection, bson, NULL, NULL, &error))
		fprintf(stderr, "%s\n", error.message);

	bson_free (string);
	bson_free (json);
	bson_destroy(bson);
	mongoc_collection_destroy(collection);
	return;
}

void insert_into_blacklist (const char *ip)
{
	collection = mongoc_client_get_collection (client, "Defendr", "blacklist");
	char *string;
	char* json;
	asprintf(&json,"{\"ip\":\"%s\"}", ip);
	if(verbose) printf("%s\n", json);
	bson = bson_new_from_json ((const uint8_t *)json, -1, &error);

	if(!bson)
	{
		fprintf(stderr, "HERE: %s\n", error.message);
		return;
	}

	string = bson_as_canonical_extended_json (bson, NULL);
	//printf("%s\n", string);

	if(!mongoc_collection_insert_one(collection, bson, NULL, NULL, &error))
		fprintf(stderr, "%s\n", error.message);

	bson_free (string);
	bson_free (json);
	bson_destroy(bson);
	mongoc_collection_destroy(collection);

	return;
}

int get_status_by_country_id(const char* country_id)
{
	collection = mongoc_client_get_collection (client, "Defendr", "country");
	const bson_t *doc;
	char *str;
	int status = 0;
	
	query = bson_new ();
	BSON_APPEND_UTF8 (query, "country_id", country_id);
	cursor = mongoc_collection_find_with_opts (collection, query, NULL, NULL);
	
	mongoc_cursor_next (cursor, &doc);

	if(!doc || !cursor)
	{
		printf("The id %s cannot be found.  Assigning status type HIGH", country_id);
		return HIGH;
	}

	str = bson_as_canonical_extended_json (doc, NULL);
	
	if(strstr(str,"High"))
	{
		status = HIGH;
	}
	else if(strstr(str,"Low"))
	{
		status = LOW;
	}

	bson_free (str);
	bson_destroy (query);
	mongoc_cursor_destroy (cursor);
	mongoc_collection_destroy (collection);
	return status;
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

static void blacklist_print_ipv4(__u32 ip)
{
	char ip_txt[INET_ADDRSTRLEN] = {0};

	/* Convert IPv4 addresses from binary to text form */
	if (!inet_ntop(AF_INET, &ip, ip_txt, sizeof(ip_txt))) {
		fprintf(stderr,
			"ERR: Cannot convert u32 IP:0x%X to IP-txt\n", ip);
		exit(EXIT_FAIL_IP);
	}
	printf("\n \"%s\"", ip_txt);
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
		//value = get_key32_value64_percpu(fd, key);
		blacklist_print_ipv4(key);
		prev_key = &key;
		printf("%s", key ? "," : "" );
	}

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

static void clear_system_stats(){
	int fd_system_stats = open_bpf_map(file_system_stats);	
	for (int i = 0; i < STATS_CATAGORIES_MAX; i++) {
		long zero = 0;
		bpf_map_update_elem(fd_system_stats, &i, &zero, BPF_EXIST);
	}
	close(fd_system_stats);
	
	__u64 key, *prev_key = NULL;	
	key = NULL;
	prev_key = NULL;
	int fd_servers= open_bpf_map(file_servers);
	while (bpf_map_get_next_key(fd_servers, prev_key, &key) == 0) {
		 struct dest_info *backend =(struct dest_info*)malloc(sizeof(struct dest_info));
		int res = bpf_map_lookup_elem(fd_servers,&key,backend); 
		if(res==0){
			backend->pkts = 0;
			//backend->cons = 0;
			backend->bytes = 0;
			bpf_map_update_elem(fd_servers, &key, backend, BPF_EXIST);
		}
		
		prev_key = &key;
	}
	close(fd_servers);
}

static  void activate_dynamic_blacklist(){
		IP2Location *IP2LocationObj = IP2Location_open("data/IP-COUNTRY.BIN");

	        int fd_watchlist;

		//startup run
			sleep(1);
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
			fd_watchlist = open_bpf_map(file_ip_watchlist);
			__u32 key, *prev_key = NULL;
			__u64 value;
			char* ipsToRemove[1000];
			int numToRemove = 0;
			while (bpf_map_get_next_key(fd_watchlist, prev_key, &key) == 0) {
				value = get_key32_value64_percpu(fd_watchlist, key);
				char ip_txt[INET_ADDRSTRLEN] = {0};
				if (inet_ntop(AF_INET, &key, ip_txt, sizeof(ip_txt))) {	
					printf("%s %s %llu \n","monitor ", ip_txt,value);							
					if(value > 3){
						IP2LocationRecord *record = IP2Location_get_all(IP2LocationObj,ip_txt);
						char* country = record->country_short;
						init_db();
						int risk = get_status_by_country_id(country);
						close_db();
							if(risk == HIGH){
							int fd_blacklist = open_bpf_map(file_blacklist);						
							blacklist_modify(fd_blacklist,ip_txt, ACTION_ADD);
							close(fd_blacklist);	
							printf("blacklisted %s with count %llu and risk %d\n",ip_txt,value,risk);
							init_db();
							insert_into_blacklist(ip_txt);
							close_db();							
						}else if (risk == MED && value > 5){
							int fd_blacklist = open_bpf_map(file_blacklist);						
							blacklist_modify(fd_blacklist,ip_txt, ACTION_ADD);
							close(fd_blacklist);	
							printf("blacklisted %s with count %llu and risk %d\n",ip_txt,value,risk);	
							init_db();
							insert_into_blacklist(ip_txt);
							close_db();							
						}else if (risk == LOW && value > 10){
							int fd_blacklist = open_bpf_map(file_blacklist);						
							blacklist_modify(fd_blacklist,ip_txt, ACTION_ADD);
							close(fd_blacklist);	
							printf("blacklisted %s with count %llu and risk %d\n",ip_txt,value,risk);	
							init_db();
							insert_into_blacklist(ip_txt);
							close_db();						
						}
						IP2Location_free_record(record);

					}	
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
			clear_system_stats();
		}		
		IP2Location_close(IP2LocationObj);
}


/* Function used for logging incoming traffic in database*/
static  void start_logging(){
	IP2Location *IP2LocationObj = IP2Location_open("data/IP-COUNTRY.BIN");	
	init_db();
	struct sysinfo s_info;
	int error = sysinfo(&s_info);
	long boot_time =  (unsigned long)time(NULL)-s_info.uptime;
	if(verbose) printf("time of boot is: %ld\n",boot_time);
	
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
					else if(packet_log->reason == REASON_NOSERVER) reason = "no_available_server";
					else if(packet_log->reason == REASON_NON_TCP) reason = "not_tcp";
					else reason = "unknown";

					if(packet_log->status == LOG_ENTER){
						status= "enter";
					}else if(packet_log->status == LOG_PASS){
						status= "pass";
					}else if(packet_log->status == LOG_DROP){
						status= "drop";
					}else{
						status= "unknown";
					}
					char *country = "ZA";	
					IP2LocationRecord *record = IP2Location_get_all(IP2LocationObj,src_ip);
					
					if(record != NULL){
						country = record->country_short;
					}			
					
					if(strlen(country)<= 1){
						 country = "ZA";	
					}
					 
					char time_str[30];
					snprintf(time_str, 10, "%ld", time);

					if(verbose) printf("Packet( %s ):ip_src-%s, ip_dest-%s, server-%s, country-%s, reason-%s, time-%ld\n",status,src_ip,dest_ip,mac_str,country,reason,time);
					insert_into_packets_list(src_ip,status,time_str,country,dest_ip,mac_str,reason);
					logsToRemove[numLogsToRemove] = key; 
					++numLogsToRemove;		
					
					if(record != NULL){ 
						IP2Location_free_record(record);
					}	
				}else{
					printf("conversion failed\n");
				}									 
			}else{
				fprintf(stderr,"ERR: bpf_map_lookup_elem failed key:0x%llX\n", key);
			}
			prev_key = &key;
		}
			
		key = NULL;
		prev_key = NULL;
		packet_log = NULL;
		for(int i = 0; i < numLogsToRemove;++i){
			__u64 keyToDel = logsToRemove[i];
			bpf_map_delete_elem(fd_logs,&keyToDel);		
		}
		
		close(fd_logs);
	}		  
	close_db(); 
	IP2Location_close(IP2LocationObj);
}

/* Add backend server*/
static void addBackend(char* service_ip,char* backend_ip,char* backend_port,char* mac_addr){
	if (verbose) printf("adding backend with ip %s and mac %s listening on port %s to service %s\n",backend_ip,mac_addr,backend_port,service_ip);
    int fd_services = open_bpf_map(file_services); 
    int fd_servers = open_bpf_map(file_servers);  
	service_modify(fd_services,fd_servers, service_ip,backend_ip, atoi(backend_port),mac_addr,ACTION_ADD);
	close(fd_services);
	close(fd_servers);
}

/* Remove backend server*/
static void removeBackend(char* service_ip,char* backend_ip){
	if (verbose) printf("removing backend with ip %s from service %s\n",backend_ip,service_ip);	
	int fd_services = open_bpf_map(file_services); 
    int fd_servers = open_bpf_map(file_servers);  
	service_modify(fd_services,fd_servers, service_ip,backend_ip,0,"",ACTION_DEL);
	close(fd_services);
	close(fd_servers);
}

/* Print all back-end instanses for particular service */
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

static void get_stats(){
	int fd_system_stats = open_bpf_map(file_system_stats);	
	__u64 value = 0;
	const char *catagories[5];
	catagories[0] = "pps";
	catagories[1] = "num_con";
	catagories[2] = "bps";
	catagories[3] = "pps_droped";
	catagories[4] = "bps_droped";
	printf("{\n");
	
	printf("\"system\":{\n");
	for (int i = 0; i < STATS_CATAGORIES_MAX; i++) {
		value = get_key32_value64_percpu(fd_system_stats,i);
		printf("\%s\": %d\n",catagories[i],value);
	}
	printf("},\n");
	close(fd_system_stats);
	
	printf("\"services\":[\n");
	__u64 service_key, *service_prev_key = NULL;	
	service_key = NULL;
	service_prev_key = NULL;
	int fd_services = open_bpf_map(file_services);
	while (bpf_map_get_next_key(fd_services, service_prev_key, &service_key) == 0) {
		char service_ip_txt[INET_ADDRSTRLEN] = {0};
		if (inet_ntop(AF_INET, &service_key, service_ip_txt, sizeof(service_ip_txt))){
			printf("\"%s\":{\n",service_ip_txt);
			printf("\"backends\":[\n");
				 struct service *app = (struct service*)malloc(sizeof(struct service));
				 int fd_servers = open_bpf_map(file_servers);  
				 int res = bpf_map_lookup_elem(fd_services,&service_key,app); 
				 if(res == 0){
					for(int i = 0;i < app->num_servers;++i){
						 struct dest_info *backend =(struct dest_info*)malloc(sizeof(struct dest_info));
						__u32 id = app->id+i+1;
						res = bpf_map_lookup_elem(fd_servers,&id,backend); 
						if(res==0){
								char backend_ip_txt[INET_ADDRSTRLEN] = {0};
								if (inet_ntop(AF_INET, &(backend->daddr), backend_ip_txt, sizeof(backend_ip_txt))) {	
									printf("\"%s\":{\n",backend_ip_txt);		
									printf("\%s\": %d\n","pps",backend->pkts);
									printf("\%s\": %d\n","num_con",backend->cons);
									printf("\%s\": %d\n","bps",backend->bytes);
									printf("}\n");										
								}			
						}

					 }	
				 }
			printf("]\n");
			printf("}\n");
		}			
		service_prev_key = &service_key;
	}
	close(fd_services);
	printf("]\n");
	printf("}\n");
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
	bool modify_blacklist = false;
	bool modify_whitelist = false;
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
		case 'z':
			modify_blacklist = true;
			break;
		case 'w':
			modify_whitelist = true;
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

	// Update blacklist
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
			if(modify_whitelist){
				fd_blacklist = open_bpf_map(file_whitelist);
			}else{
				fd_blacklist = open_bpf_map(file_blacklist);
			}
			res = blacklist_modify(fd_blacklist, ip_string, action);
			close(fd_blacklist);
			if(action == ACTION_ADD){
				if(modify_whitelist){
					
				}else{
					init_db();
					insert_into_blacklist(ip_string);
					close_db();
				}
			}
			
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
			if(modify_whitelist){
				fd_blacklist = open_bpf_map(file_whitelist);
			}else{
				fd_blacklist = open_bpf_map(file_blacklist);
			}
			
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

	// Show statistics by polling
	if (stats) {
		get_stats();
	}
	
	if(dynamic_blacklist){
		activate_dynamic_blacklist();
	}

	if(log){
		start_logging();
	}
	// TODO: implement stats for verdicts
	close(fd_verdict);
}

static void display_all(){
	    int fd_blacklist;
		fd_blacklist = open_bpf_map(file_blacklist);
		blacklist_list_all_ipv4(fd_blacklist);
		close(fd_blacklist);
}

