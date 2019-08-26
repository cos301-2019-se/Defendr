/* Copyright(c) 2017 Jesper Dangaard Brouer, Red Hat, Inc.
 *  Copyright(c) 2017 Andy Gospodarek, Broadcom Limited, Inc.
 */
static const char *__doc__=
 " XDP: DDoS protection via IPv4 blacklist\n"
 "\n"
 "This program loads the XDP eBPF program into the kernel.\n"
 "Use the cmdline tool for add/removing source IPs to the blacklist\n"
 "and read statistics.\n"
 ;

#include <linux/bpf.h>

#include <assert.h>
#include <errno.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <unistd.h>


#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <pwd.h>

#include <sys/resource.h>
#include <getopt.h>
#include <net/if.h>

#include <sys/statfs.h>
#include <libgen.h>  /* dirname */

#include <arpa/inet.h>
#include <linux/if_link.h>

#include "bpf_load.h"
#include "bpf_util.h"
#include "libbpf.h"

#include "defendr_xdp_common.h"

static char ifname_buf[IF_NAMESIZE];
static char *ifname = NULL;
static int ifindex = -1;

#define NR_MAPS 7
int maps_marked_for_export[MAX_MAPS] = { 0 };

// Retreives sum of values on each cpu for given map file descriptor and key.


static void print_ipv4(__u32 ip, __u64 count)
{
	char ip_txt[INET_ADDRSTRLEN] = {0};
	if (!inet_ntop(AF_INET, &ip, ip_txt, sizeof(ip_txt))) {
		fprintf(stderr,
			"ERR: Cannot convert u32 IP:0x%X to IP-txt\n", ip);
		exit(EXIT_FAIL_IP);
	}
	printf("\n \"%s\" : %llu", ip_txt, count);
}

static const char* map_idx_to_export_filename(int idx)
{
	const char *file = NULL;

	// Mapping map_fd[idx] to filenames.
	switch (idx) {
	case 0: 
		file =   file_blacklist;
		break;
	case 1: 
		file =   file_whitelist;
		break;
	case 2: 
		file =   file_ip_watchlist;
		break;
	case 3: 
		file =   file_logs;
		break;
	case 4: 
		file =   file_services;
		break;
	case 5: 
		file =   file_destinations;
		break;
	case 6: 
		file =   file_system_stats;
		break;
	default:
		break;
	}
	return file;
}

static void remove_xdp_program(int ifindex, const char *ifname, __u32 xdp_flags){
	int i;
	fprintf(stderr, "Removing XDP program on ifindex:%d device:%s\n",
		ifindex, ifname);
	if (ifindex > -1)
		set_link_xdp_fd(ifindex, -1, xdp_flags);

	for (i = 0; i < NR_MAPS; i++) {
		const char *file = map_idx_to_export_filename(i);

		if (unlink(file) < 0) {
			printf("WARN: cannot rm map(%s) file:%s err(%d):%s\n",
			       map_data[i].name, file, errno, strerror(errno));
		}
	}
}

static const struct option long_options[] = {
	{"help",	no_argument,		NULL, 'h' },
	{"remove",	no_argument,		NULL, 'r' },
	{"dev",		required_argument,	NULL, 'd' },
	{"quiet",	no_argument,		NULL, 'q' },
	{"owner",	required_argument,	NULL, 'o' },
	{"skb-mode",	no_argument,		NULL, 'S' },
	{0, 0, NULL,  0 }
};

static void usage(char *argv[]){
	int i;
	printf("\nDOCUMENTATION:\n%s\n", __doc__);
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

#ifndef BPF_FS_MAGIC
# define BPF_FS_MAGIC   0xcafe4a11
#endif

// Verifies that BPF-filesystem is mounted on given file path.
static int bpf_fs_check_path(const char *path){
	struct statfs st_fs;
	char *dname, *dir;
	int err = 0;

	if (path == NULL)
		return -EINVAL;

	dname = strdup(path);
	if (dname == NULL)
		return -ENOMEM;

	dir = dirname(dname);
	if (statfs(dir, &st_fs)) {
		fprintf(stderr, "ERR: failed to statfs %s: (%d)%s\n",
			dir, errno, strerror(errno));
		err = -errno;
	}
	free(dname);

	if (!err && st_fs.f_type != BPF_FS_MAGIC) {
		fprintf(stderr,
			"ERR: specified path %s is not on BPF FS\n\n"
			" You need to mount the BPF filesystem type like:\n"
			"  mount -t bpf bpf /sys/fs/bpf/\n\n",
			path);
		err = -EINVAL;
	}

	return err;
}

// Load existing map via filesystem.
int load_map_file(const char *file, struct bpf_map_data *map_data){
	int fd;

	if (bpf_fs_check_path(file) < 0) {
		exit(EXIT_FAIL_MAP_FS);
	}

	fd = bpf_obj_get(file);
	if (fd > 0) { 
		if (verbose)
			printf(" - Loaded bpf-map:%-30s from file:%s\n",
			       map_data->name, file);
		return fd;
	}
	return -1;
}

void pre_load_maps_via_fs(struct bpf_map_data *map_data, int idx){
	
	const char *file;
	int fd;

	file = map_idx_to_export_filename(idx);
	fd = load_map_file(file, map_data);

	if (fd > 0) {
		map_data->fd = fd;
	} else {
		maps_marked_for_export[idx] = 1;
	}
}

int export_map_idx(int map_idx){
	const char *file;

	file = map_idx_to_export_filename(map_idx);

	if (bpf_obj_pin(map_fd[map_idx], file) != 0) {
		fprintf(stderr, "ERR: Cannot pin map(%s) file:%s err(%d):%s\n",
			map_data[map_idx].name, file, errno, strerror(errno));
		return EXIT_FAIL_MAP;
	}
	if (verbose)
		printf(" - Export bpf-map:%-30s to   file:%s\n",
		       map_data[map_idx].name, file);
	return 0;
}

void export_maps(void){
	int i;

	for (i = 0; i < NR_MAPS; i++) {
		if (maps_marked_for_export[i] == 1)
			export_map_idx(i);
	}
}

void chown_maps(uid_t owner, gid_t group){
	const char *file;
	int i;

	for (i = 0; i < NR_MAPS; i++) {
		file = map_idx_to_export_filename(i);

		if (chown(file, owner, group) < 0)
			fprintf(stderr,
				"WARN: Cannot chown file:%s err(%d):%s\n",
				file, errno, strerror(errno));
	}
}

int main(int argc, char **argv){	
	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
	bool rm_xdp_prog = false;
	struct passwd *pwd = NULL;
	__u32 xdp_flags = 0;
	char filename[256];
	int longindex = 0;
	uid_t owner = -1;
	gid_t group = -1;
	int opt;

	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);

	while ((opt = getopt_long(argc, argv, "hSrqd:",
				  long_options, &longindex)) != -1) {
		switch (opt) {
		case 'q':
			verbose = 0;
			break;
		case 'r':
			rm_xdp_prog = true;
			break;
		case 'o': 
			if (!(pwd = getpwnam(optarg))) {
				fprintf(stderr,
					"ERR: unknown owner:%s err(%d):%s\n",
					optarg, errno, strerror(errno));
				goto error;
			}
			owner = pwd->pw_uid;
			group = pwd->pw_gid;
			break;
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
	// Required options.
	if (ifindex == -1) {
		printf("ERR: required option --dev missing");
		usage(argv);
		return EXIT_FAIL_OPTION;
	}
	if (rm_xdp_prog) {
		remove_xdp_program(ifindex, ifname, xdp_flags);
		return EXIT_OK;
	}
	if (verbose) {
		printf("Documentation:\n%s\n", __doc__);
		printf(" - Attached to device:%s (ifindex:%d)\n",
		       ifname, ifindex);
	}

	// Increase resource limits.
	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
		perror("setrlimit(RLIMIT_MEMLOCK, RLIM_INFINITY)");
		return 1;
	}

	// Load bpf-ELF file with callback for loading maps via filesystem.
	if (load_bpf_file_fixup_map(filename, pre_load_maps_via_fs)) {
		fprintf(stderr, "ERR in load_bpf_file(): %s", bpf_log_buf);
		return EXIT_FAIL;
	}

	if (!prog_fd[0]) {
		printf("load_bpf_file: %s\n", strerror(errno));
		return 1;
	}

	// Export maps not loaded from filesystem.
	export_maps();

	if (owner >= 0)
		chown_maps(owner, group);

	if (set_link_xdp_fd(ifindex, prog_fd[0], xdp_flags) < 0) {
		printf("link set xdp fd failed\n");
		return EXIT_FAIL_XDP;
	}		
	return EXIT_OK;
}
