#include "Database.h"
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

static const struct option long_options[] = {
	{"help",	no_argument,		NULL, 'h' },
	{"log",		no_argument,		NULL, 'l' },
	{"packet",		no_argument,		NULL, 'p' },	
	{"ip",		required_argument,	NULL, 'i' },
	{"status",	required_argument,		NULL, 's' },
	{"time",		required_argument,	NULL, 't' },
	{"country",	required_argument,		NULL, 'c' },
	{"destination",	required_argument,	NULL, 'd' },
	{"server",	required_argument,	NULL, 'x' },
	{"reason",	required_argument,		NULL, 'r' },
	{0, 0, NULL,  0 }
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

int main(int argc, char **argv)
{
#	define STR_MAX 42 /* For trivial input validation */
	char _ip_buf[STR_MAX] = {};
	char *ip = NULL;
	char _destination_buf[STR_MAX] = {};
	char *destination = NULL;
	char country_buf[STR_MAX] = {};
	char *country = NULL;
	char server_buf[STR_MAX] = {};
	char *server = NULL;
	char time_buf[STR_MAX] = {};
	char *time = NULL;
	char reason_buf[STR_MAX] = {};
	char *reason = NULL;
	char status_buf[STR_MAX] = {};
	char *status = NULL;
	int longindex = 0;
	int opt;
	bool log;
	char type;

	while ((opt = getopt_long(argc, argv, "adshi:t:u:",
				  long_options, &longindex)) != -1) {
		switch (opt) {
		case 'l':
			log = true;
			break;
		case 'p':
			type = 'p';
			break;
		case 'x':
			action |= ACTION_DEL;
			break;
		case 's':
			if (!optarg || strlen(optarg) >= STR_MAX) {
				printf("ERR:  ip too long or NULL\n");
				goto fail_opt;
			}
			server = (char *)&server_buf;
			strncpy(server, optarg, STR_MAX);
			break;
		case 't':
			if (!optarg || strlen(optarg) >= STR_MAX) {
				printf("ERR: port number too long or NULL\n");
				goto fail_opt;
			}
			time = (char *)&time_buf;
			strncpy(time, optarg, STR_MAX);
			break;
		case 'i':
			if (!optarg || strlen(optarg) >= STR_MAX) {
				printf("ERR: service ip too long or NULL\n");
				goto fail_opt;
			}
			ip = (char *)&ip_buf;
			strncpy(ip, optarg, STR_MAX);
			break;
		case 'r':
			if (!optarg || strlen(optarg) >= STR_MAX) {
				printf("ERR: mac address too long or NULL\n");
				goto fail_opt;
			}
			reason = (char *)&reason_buf;
			strncpy(reason, optarg, STR_MAX);
			break;
		case 's':
			if (!optarg || strlen(optarg) >= STR_MAX) {
				printf("ERR: mac address too long or NULL\n");
				goto fail_opt;
			}
			status = (char *)&status_buf;
			strncpy(status);
			break;
		case 'd':
			if (!optarg || strlen(optarg) >= STR_MAX) {
				printf("ERR: mac address too long or NULL\n");
				goto fail_opt;
			}
			destination = (char *)&destination_buf;
			strncpy(destination);
			break;
		case 'c':
			if (!optarg || strlen(optarg) >= STR_MAX) {
				printf("ERR: mac address too long or NULL\n");
				goto fail_opt;
			}
			country = (char *)&country_buf;
			strncpy(country);
			break;
		case 'h':
		fail_opt:
		default:
			usage(argv);
			return EXIT_FAIL_OPTION;
		}
	}
	
	if(log){
		if(type = 'p'){
			insert_into_packets_list(ip,status,time,country,destination,server,reason);
		}
	}


}