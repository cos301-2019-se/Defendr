#ifndef __STRUCTS_H
#define __STRUCTS_H

#define MAX_INSTANCES 10

<<<<<<< HEAD
=======
#define LOG_ENTER 0
#define LOG_PASS 1
#define LOG_DROP 2

#define REASON_NONE 0
#define REASON_BLACKLIST 1
#define REASON_NOSERVER 2
#define REASON_NON_IP 3
#define REASON_NON_TCP 4

>>>>>>> packet_dropper
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
<<<<<<< HEAD
=======

struct log{
	__u32 src_ip;
	__u32 status;
	__u32 reason;
	__u32 destination_ip;
	__u8 server[6];
};

>>>>>>> packet_dropper
#endif
