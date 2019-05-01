/* Copyright(c) 2017 Jesper Dangaard Brouer, Red Hat, Inc.
 */
static const char *__doc__=
" XDP bench02: measure effect of different drop patterns\n\n"
" This program simply drop half of all incoming packets.\n"
"  Instead of dropping every second packet, half of the packets can also\n"
"  be dropped by dropping N-packets followed by accepting N-packets.\n"
"  Such a N-drop-N-accept pattern, resembles what RX-stages can achieve\n"
"  by handling the XDP stage before netstack stage.\n";

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
#include <net/if.h>
#include <time.h>

#include <arpa/inet.h>
#include <linux/if_link.h>

#include "bpf_load.h"
#include "bpf_util.h"
#include "libbpf.h"

static int ifindex = -1;
static __u32 xdp_flags = 0;
static char ifname_buf[IF_NAMESIZE];
static char *ifname = NULL;

/* Exit return codes */
#define EXIT_OK                 0
#define EXIT_FAIL               1
#define EXIT_FAIL_OPTION        2
#define EXIT_FAIL_XDP           3

static void int_exit(int sig)
{
	fprintf(stderr,
		"Interrupted: Removing XDP program on ifindex:%d device:%s\n",
		ifindex, ifname);
	if (ifindex > -1)
		set_link_xdp_fd(ifindex, -1, xdp_flags);
	exit(EXIT_OK);
}

static const struct option long_options[] = {
	{"help",	no_argument,		NULL, 'h' },
	{"dev",		required_argument,	NULL, 'd' },
	{"sec", 	required_argument,	NULL, 's' },
	{"pattern1", 	required_argument,	NULL, '1' },
	{"action", 	required_argument,	NULL, 'a' },
	{"notouch", 	no_argument,		NULL, 'n' },
	{"skbmode", 	no_argument,		NULL, 'S' },
	{0, 0, NULL,  0 }
};

struct pattern {
	/* Remember: sync with _kern.c */
	union {
		struct {
			__u32 type;
			__u32 arg;
		};
		__u64 raw;
	};
};

#define XDP_ACTION_MAX (XDP_TX + 2) /* Extra fake "rx_total" */
#define RX_TOTAL (XDP_TX + 1)
#define XDP_ACTION_MAX_STRLEN 11
static const char *xdp_action_names[XDP_ACTION_MAX] = {
	[XDP_ABORTED]	= "XDP_ABORTED",
	[XDP_DROP]	= "XDP_DROP",
	[XDP_PASS]	= "XDP_PASS",
	[XDP_TX]	= "XDP_TX",
	[RX_TOTAL]	= "rx_total",
};
static const char *action2str(int action)
{
	if (action < XDP_ACTION_MAX)
		return xdp_action_names[action];
	return NULL;
}

static bool set_xdp_action(__u64 action)
{
	__u64 value = action;
	__u32 key = 0;

	/* map_fd[6] == map(xdp_action) */
	if ((bpf_map_update_elem(map_fd[6], &key, &value, BPF_ANY)) != 0) {
		fprintf(stderr, "ERR %s(): bpf_map_update_elem failed\n",
			__func__);
		return false;
	}
	return true;
}

static int parse_xdp_action(char *action_str)
{
	size_t maxlen;
	__u64 action = -1;
	int i;

	for (i = 0; i < XDP_ACTION_MAX; i++) {
		maxlen = XDP_ACTION_MAX_STRLEN;
		if (strncmp(xdp_action_names[i], action_str, maxlen) == 0) {
			action = i;
			break;
		}
	}
	return action;
}

static void list_xdp_action(void)
{
	int i;

	printf("Available XDP **OVERRIDE** --action <options>\n");
	for (i = 0; i < XDP_ACTION_MAX; i++) {
		printf("\t%s\n", xdp_action_names[i]);
	}
	printf("\n");
}

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
	list_xdp_action();
}

struct record {
	__u64 counter;
	__u64 timestamp;
};

struct stats_record {
	struct record xdp_action[XDP_ACTION_MAX];
	__u64 touch_mem;
	struct pattern pattern;
};

static __u64 get_xdp_pattern(void)
{
	struct pattern p = {0};
	__u32 key = 0;

	/* map_fd[1] == map(xdp_pattern) */
	if ((bpf_map_lookup_elem(map_fd[1], &key, &p)) != 0) {
		fprintf(stderr, "ERR %s(): bpf_map_lookup_elem failed\n",
			__func__);
		exit(EXIT_FAIL_XDP);
	}
	return p.raw;
}

static bool set_xdp_pattern(__u32 type, __u32 arg)
{
	struct pattern p = {0};
	__u32 key = 0;

	p.type = type;
	p.arg  = arg;

	/* map_fd[1] == map(xdp_pattern) */
	if ((bpf_map_update_elem(map_fd[1], &key, &p, BPF_ANY)) != 0) {
		fprintf(stderr, "ERR %s(): bpf_map_update_elem failed\n",
			__func__);
		return false;
	}
	return true;
}

enum touch_mem_type {
	NO_TOUCH = 0x0ULL,
	READ_MEM = 0x1ULL,
};
static char* mem2str(enum touch_mem_type touch_mem)
{
	if (touch_mem == NO_TOUCH)
		return "no_touch";
	if (touch_mem == READ_MEM)
		return "read";
	fprintf(stderr, "ERR: Unknown memory touch type");
	exit(EXIT_FAIL);
}

static __u64 get_touch_mem(void)
{
	__u64 value;
	__u32 key = 0;

	/* map_fd[2] == map(touch_memory) */
	if ((bpf_map_lookup_elem(map_fd[2], &key, &value)) != 0) {
		fprintf(stderr, "ERR: %s(): bpf_map_lookup_elem failed\n",
			__func__);
		exit(EXIT_FAIL_XDP);
	}
	return value;
}

static bool set_touch_mem(__u64 value)
{
	__u32 key = 0;

	/* map_fd[2] == map(touch_memory) */
	if ((bpf_map_update_elem(map_fd[2], &key, &value, BPF_ANY)) != 0) {
		fprintf(stderr, "ERR: %s(): bpf_map_update_elem failed\n",
			__func__);
		return false;
	}
	return true;
}

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

static void stats_print(struct stats_record *record,
			struct stats_record *prev)
{
	int i;

	for (i = 0; i < XDP_ACTION_MAX; i++) {
		struct record *r = &record->xdp_action[i];
		struct record *p = &prev->xdp_action[i];
		__u64 period  = 0;
		__u64 packets = 0;
		double pps = 0;
		double period_ = 0;

		if (p->timestamp) {
			packets = r->counter - p->counter;
			period  = r->timestamp - p->timestamp;
			if (period > 0) {
				period_ = ((double) period / NANOSEC_PER_SEC);
				pps = packets / period_;
			}
		}

		printf("%-12s %-10.0f %'-18.0f %f"
		       "  %s patN:%d\n",
		       action2str(i), pps, pps, period_,
		       mem2str(record->touch_mem), record->pattern.arg
			);
	}
	printf("\n");
}

static bool stats_collect(struct stats_record *rec)
{
	int i, fd;

	fd = map_fd[3]; /* map: verdict_cnt */
	for (i = 0; i < (XDP_ACTION_MAX - 1) ; i++) {
		rec->xdp_action[i].timestamp = gettime();
		rec->xdp_action[i].counter = get_key32_value64_percpu(fd, i);
	}
	/* Global counter */
	fd = map_fd[0]; /* map: rx_cnt */
	rec->xdp_action[RX_TOTAL].timestamp = gettime();
	rec->xdp_action[RX_TOTAL].counter = get_key32_value64_percpu(fd, 0);

	return true;
}

static void stats_poll(int interval)
{
	struct stats_record record, prev;

	memset(&record, 0, sizeof(record));

	/* Read current XDP pattern and touch mem setting */
	record.pattern.raw = get_xdp_pattern();
	record.touch_mem   = get_touch_mem();

	/* Trick to pretty printf with thousands separators use %' */
	setlocale(LC_NUMERIC, "en_US");

	/* Header */
	printf("%-14s %-10s %-18s %-9s\n",
	       "pattern type:N", "pps ", "pps-human-readable", "mem");

	while (1) {
		memcpy(&prev, &record, sizeof(record));
		stats_collect(&record);
		stats_print(&record, &prev);
		sleep(interval);
	}
}

int main(int argc, char **argv)
{
	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
	char action_str_buf[XDP_ACTION_MAX_STRLEN + 1 /* for \0 */] = {};
	char *action_str = NULL;
	__u64 override_action = 0; /* Default disabled */
	char filename[256];
	int longindex = 0;
	int interval = 1;
	__u64 touch_mem = READ_MEM; /* Default: touch packet memory */
	int opt;

	int pattern_arg = 1;

	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);

	/* Parse commands line args */
	while ((opt = getopt_long(argc, argv, "hSd:s:",
				  long_options, &longindex)) != -1) {
		switch (opt) {
		case 'd':
			if (strlen(optarg) >= IF_NAMESIZE) {
				fprintf(stderr, "ERR: --dev name too long\n");
				goto error;
			}
			ifname = (char *)&ifname_buf;
			strncpy(ifname, optarg, IF_NAMESIZE);
			ifindex = if_nametoindex(ifname);
			if (ifindex == 0) {
				fprintf(stderr,
					"ERR: --dev name unknown err(%d):%s\n",
					errno, strerror(errno));
				goto error;
			}
			break;
		case 's':
			interval = atoi(optarg);
			break;
		case 'a':
			action_str = (char *)&action_str_buf;
			strncpy(action_str, optarg, XDP_ACTION_MAX_STRLEN);
			break;
		case '1':
			pattern_arg = atoi(optarg);
			break;
		case 'n':
			touch_mem = NO_TOUCH;
			break;
		case 'S':
			xdp_flags |= XDP_FLAGS_SKB_MODE;
			break;
		case 'h':
		error:
		default:
			usage(argv);
			return EXIT_FAIL_OPTION;
		}
	}
	/* Required options */
	if (ifindex == -1) {
		fprintf(stderr, "ERR: required option --dev missing");
		usage(argv);
		return EXIT_FAIL_OPTION;
	}

	/* Parse action string */
	if (action_str) {
		override_action = parse_xdp_action(action_str);
		if (override_action < 0) {
			fprintf(stderr, "ERR: Invalid XDP action: %s\n",
				action_str);
			usage(argv);
			list_xdp_action();
			return EXIT_FAIL_OPTION;
		}
	}

	/* Increase resource limits */
	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
		perror("setrlimit(RLIMIT_MEMLOCK, RLIM_INFINITY)");
		return EXIT_FAIL;
	}

	if (load_bpf_file(filename)) {
		fprintf(stderr, "ERR in load_bpf_file(): %s", bpf_log_buf);
		return EXIT_FAIL;
	}

	if (!prog_fd[0]) {
		fprintf(stderr, "ERR: load_bpf_file: %s\n", strerror(errno));
		return EXIT_FAIL;
	}

	/* Control behavior of XDP program */
	set_xdp_action(override_action);
	set_touch_mem(touch_mem);
	set_xdp_pattern(1, pattern_arg);

	/* Remove XDP program when program is interrupted */
	signal(SIGINT, int_exit);

	if (set_link_xdp_fd(ifindex, prog_fd[0], xdp_flags) < 0) {
		fprintf(stderr, "link set xdp fd failed\n");
		return EXIT_FAIL_XDP;
	}

	stats_poll(interval);

	return EXIT_OK;
}
