#ifndef __STRUCTS_H
#define __STRUCTS_H

#define MAX_INSTANCES 10

struct dest_info {
	__u32 saddr;
	__u32 daddr;
	__u32 port;
	__u64 bytes;
	__u64 pkts;
	__u8 dmac[6];
};

struct service{
	__u64 last_used;
	__u64 num_servers;
	__u64 id;
};
#endif
