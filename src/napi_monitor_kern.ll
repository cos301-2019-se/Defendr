; ModuleID = 'napi_monitor_kern.c'
source_filename = "napi_monitor_kern.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.napi_poll_ctx = type { i16, i8, i8, i32, %struct.napi_struct*, i32, i32, i32 }
%struct.napi_struct = type { %struct.list_head, i64, i32, i32, i32 (%struct.napi_struct*, i32)*, i32, %struct.net_device*, %struct.sk_buff*, %struct.sk_buff*, %struct.hrtimer, %struct.list_head, %struct.hlist_node, i32 }
%struct.net_device = type { [16 x i8], %struct.hlist_node, %struct.dev_ifalias*, i64, i64, i64, i32, %struct.atomic_t, i64, %struct.list_head, %struct.list_head, %struct.list_head, %struct.list_head, %struct.list_head, %struct.list_head, %struct.anon.78, i64, i64, i64, i64, i64, i64, i64, i32, i32, %struct.net_device_stats, %struct.atomic64_t, %struct.atomic64_t, %struct.atomic64_t, %struct.iw_handler_def*, %struct.iw_public_data*, %struct.net_device_ops*, %struct.ethtool_ops*, %struct.switchdev_ops*, %struct.l3mdev_ops*, %struct.ndisc_ops*, %struct.xfrmdev_ops*, %struct.header_ops*, i32, i32, i16, i16, i8, i8, i8, i8, i32, i32, i32, i16, i16, i8, i16, i16, [32 x i8], i8, i8, i16, i16, i16, %struct.spinlock, i8, i8, %struct.netdev_hw_addr_list, %struct.netdev_hw_addr_list, %struct.netdev_hw_addr_list, %struct.kset*, i32, i32, %struct.vlan_info*, %struct.dsa_port*, %struct.tipc_bearer*, i8*, %struct.in_device*, %struct.dn_dev*, %struct.inet6_dev*, i8*, %struct.wireless_dev*, %struct.wpan_dev*, %struct.mpls_dev*, i8*, %struct.netdev_rx_queue*, i32, i32, %struct.bpf_prog*, i64, i32 (%struct.sk_buff**)*, i8*, %struct.mini_Qdisc*, %struct.netdev_queue*, %struct.nf_hook_entries*, [32 x i8], %struct.cpu_rmap*, %struct.hlist_node, [8 x i8], %struct.netdev_queue*, i32, i32, %struct.Qdisc*, [16 x %struct.hlist_head], i32, %struct.spinlock, i32, %struct.xps_dev_maps*, %struct.mini_Qdisc*, %struct.timer_list, i32*, %struct.list_head, %struct.list_head, i8, i8, i16, i8, void (%struct.net_device*)*, %struct.netpoll_info*, %struct.possible_net_t, %union.anon.88, %struct.garp_port*, %struct.mrp_port*, %struct.device, [4 x %struct.attribute_group*], %struct.attribute_group*, %struct.rtnl_link_ops*, i32, i16, %struct.dcbnl_rtnl_ops*, i8, [16 x %struct.netdev_tc_txq], [16 x i8], i32, %struct.netprio_map*, %struct.phy_device*, %struct.lock_class_key*, %struct.lock_class_key*, i8, [47 x i8] }
%struct.dev_ifalias = type { %struct.callback_head, [0 x i8] }
%struct.callback_head = type { %struct.callback_head*, void (%struct.callback_head*)* }
%struct.atomic_t = type { i32 }
%struct.anon.78 = type { %struct.list_head, %struct.list_head }
%struct.net_device_stats = type { i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64 }
%struct.atomic64_t = type { i64 }
%struct.iw_handler_def = type opaque
%struct.iw_public_data = type opaque
%struct.net_device_ops = type { i32 (%struct.net_device*)*, void (%struct.net_device*)*, i32 (%struct.net_device*)*, i32 (%struct.net_device*)*, i32 (%struct.sk_buff*, %struct.net_device*)*, i64 (%struct.sk_buff*, %struct.net_device*, i64)*, i16 (%struct.net_device*, %struct.sk_buff*, i8*, i16 (%struct.net_device*, %struct.sk_buff*)*)*, void (%struct.net_device*, i32)*, void (%struct.net_device*)*, i32 (%struct.net_device*, i8*)*, i32 (%struct.net_device*)*, i32 (%struct.net_device*, %struct.ifreq*, i32)*, i32 (%struct.net_device*, %struct.ifmap*)*, i32 (%struct.net_device*, i32)*, i32 (%struct.net_device*, %struct.neigh_parms*)*, void (%struct.net_device*)*, void (%struct.net_device*, %struct.rtnl_link_stats64*)*, i1 (%struct.net_device*, i32)*, i32 (i32, %struct.net_device*, i8*)*, %struct.net_device_stats* (%struct.net_device*)*, i32 (%struct.net_device*, i16, i16)*, i32 (%struct.net_device*, i16, i16)*, void (%struct.net_device*)*, i32 (%struct.net_device*, %struct.netpoll_info*)*, void (%struct.net_device*)*, i32 (%struct.net_device*, i32, i8*)*, i32 (%struct.net_device*, i32, i16, i8, i16)*, i32 (%struct.net_device*, i32, i32, i32)*, i32 (%struct.net_device*, i32, i1)*, i32 (%struct.net_device*, i32, i1)*, i32 (%struct.net_device*, i32, %struct.ifla_vf_info*)*, i32 (%struct.net_device*, i32, i32)*, i32 (%struct.net_device*, i32, %struct.ifla_vf_stats*)*, i32 (%struct.net_device*, i32, %struct.nlattr**)*, i32 (%struct.net_device*, i32, %struct.sk_buff*)*, i32 (%struct.net_device*, i32, i64, i32)*, i32 (%struct.net_device*, i32, i1)*, i32 (%struct.net_device*, i32, i8*)*, i32 (%struct.net_device*)*, i32 (%struct.net_device*)*, i32 (%struct.net_device*, i16, %struct.scatterlist*, i32)*, i32 (%struct.net_device*, i16)*, i32 (%struct.net_device*, i16, %struct.scatterlist*, i32)*, i32 (%struct.net_device*, %struct.netdev_fcoe_hbainfo*)*, i32 (%struct.net_device*, i64*, i32)*, i32 (%struct.net_device*, %struct.sk_buff*, i16, i32)*, i32 (%struct.net_device*, %struct.net_device*, %struct.netlink_ext_ack*)*, i32 (%struct.net_device*, %struct.net_device*)*, i64 (%struct.net_device*, i64)*, i32 (%struct.net_device*, i64)*, i32 (%struct.net_device*, %struct.neighbour*)*, void (%struct.net_device*, %struct.neighbour*)*, i32 (%struct.ndmsg*, %struct.nlattr**, %struct.net_device*, i8*, i16, i16)*, i32 (%struct.ndmsg*, %struct.nlattr**, %struct.net_device*, i8*, i16)*, i32 (%struct.sk_buff*, %struct.netlink_callback*, %struct.net_device*, %struct.net_device*, i32*)*, i32 (%struct.net_device*, %struct.nlmsghdr*, i16)*, i32 (%struct.sk_buff*, i32, i32, %struct.net_device*, i32, i32)*, i32 (%struct.net_device*, %struct.nlmsghdr*, i16)*, i32 (%struct.net_device*, i1)*, i32 (%struct.net_device*, %struct.netdev_phys_item_id*)*, i32 (%struct.net_device*, i8*, i64)*, void (%struct.net_device*, %struct.udp_tunnel_info*)*, void (%struct.net_device*, %struct.udp_tunnel_info*)*, i8* (%struct.net_device*, %struct.net_device*)*, void (%struct.net_device*, i8*)*, i32 (%struct.net_device*)*, i32 (%struct.net_device*, i32, i32)*, i32 (%struct.net_device*)*, i32 (%struct.net_device*, i1)*, i32 (%struct.net_device*, %struct.sk_buff*)*, void (%struct.net_device*, i32)*, i32 (%struct.net_device*, %struct.netdev_bpf*)*, i32 (%struct.net_device*, %struct.xdp_buff*)*, void (%struct.net_device*)* }
%struct.ifreq = type { %union.anon.79, %union.anon.80 }
%union.anon.79 = type { [16 x i8] }
%union.anon.80 = type { %struct.ifmap }
%struct.ifmap = type { i64, i64, i16, i8, i8, i8 }
%struct.neigh_parms = type opaque
%struct.rtnl_link_stats64 = type { i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64 }
%struct.ifla_vf_info = type { i32, [32 x i8], i32, i32, i32, i32, i32, i32, i32, i32, i16 }
%struct.ifla_vf_stats = type { i64, i64, i64, i64, i64, i64 }
%struct.nlattr = type { i16, i16 }
%struct.scatterlist = type { i64, i32, i32, i64, i32 }
%struct.netdev_fcoe_hbainfo = type { [64 x i8], [64 x i8], [64 x i8], [64 x i8], [64 x i8], [64 x i8], [256 x i8], [256 x i8] }
%struct.netlink_ext_ack = type { i8*, %struct.nlattr*, [20 x i8], i8 }
%struct.neighbour = type opaque
%struct.ndmsg = type { i8, i8, i16, i32, i16, i8, i8 }
%struct.netlink_callback = type { %struct.sk_buff*, %struct.nlmsghdr*, i32 (%struct.netlink_callback*)*, i32 (%struct.sk_buff*, %struct.netlink_callback*)*, i32 (%struct.netlink_callback*)*, i8*, %struct.module*, i16, i16, i32, i32, [6 x i64] }
%struct.nlmsghdr = type { i32, i16, i16, i32, i32 }
%struct.module = type opaque
%struct.netdev_phys_item_id = type { [32 x i8], i8 }
%struct.udp_tunnel_info = type opaque
%struct.netdev_bpf = type { i32, %union.anon.82 }
%union.anon.82 = type { %struct.anon.83 }
%struct.anon.83 = type { i32, %struct.bpf_prog*, %struct.netlink_ext_ack* }
%struct.xdp_buff = type opaque
%struct.ethtool_ops = type { i32 (%struct.net_device*, %struct.ethtool_cmd*)*, i32 (%struct.net_device*, %struct.ethtool_cmd*)*, void (%struct.net_device*, %struct.ethtool_drvinfo*)*, i32 (%struct.net_device*)*, void (%struct.net_device*, %struct.ethtool_regs*, i8*)*, void (%struct.net_device*, %struct.ethtool_wolinfo*)*, i32 (%struct.net_device*, %struct.ethtool_wolinfo*)*, i32 (%struct.net_device*)*, void (%struct.net_device*, i32)*, i32 (%struct.net_device*)*, i32 (%struct.net_device*)*, i32 (%struct.net_device*)*, i32 (%struct.net_device*, %struct.ethtool_eeprom*, i8*)*, i32 (%struct.net_device*, %struct.ethtool_eeprom*, i8*)*, i32 (%struct.net_device*, %struct.ethtool_coalesce*)*, i32 (%struct.net_device*, %struct.ethtool_coalesce*)*, void (%struct.net_device*, %struct.ethtool_ringparam*)*, i32 (%struct.net_device*, %struct.ethtool_ringparam*)*, void (%struct.net_device*, %struct.ethtool_pauseparam*)*, i32 (%struct.net_device*, %struct.ethtool_pauseparam*)*, void (%struct.net_device*, %struct.ethtool_test*, i64*)*, void (%struct.net_device*, i32, i8*)*, i32 (%struct.net_device*, i32)*, void (%struct.net_device*, %struct.ethtool_stats*, i64*)*, i32 (%struct.net_device*)*, void (%struct.net_device*)*, i32 (%struct.net_device*)*, i32 (%struct.net_device*, i32)*, i32 (%struct.net_device*, i32)*, i32 (%struct.net_device*, %struct.ethtool_rxnfc*, i32*)*, i32 (%struct.net_device*, %struct.ethtool_rxnfc*)*, i32 (%struct.net_device*, %struct.ethtool_flash*)*, i32 (%struct.net_device*, i32*)*, i32 (%struct.net_device*)*, i32 (%struct.net_device*)*, i32 (%struct.net_device*, i32*, i8*, i8*)*, i32 (%struct.net_device*, i32*, i8*, i8)*, void (%struct.net_device*, %struct.ethtool_channels*)*, i32 (%struct.net_device*, %struct.ethtool_channels*)*, i32 (%struct.net_device*, %struct.ethtool_dump*)*, i32 (%struct.net_device*, %struct.ethtool_dump*, i8*)*, i32 (%struct.net_device*, %struct.ethtool_dump*)*, i32 (%struct.net_device*, %struct.ethtool_ts_info*)*, i32 (%struct.net_device*, %struct.ethtool_modinfo*)*, i32 (%struct.net_device*, %struct.ethtool_eeprom*, i8*)*, i32 (%struct.net_device*, %struct.ethtool_eee*)*, i32 (%struct.net_device*, %struct.ethtool_eee*)*, i32 (%struct.net_device*, %struct.ethtool_tunable*, i8*)*, i32 (%struct.net_device*, %struct.ethtool_tunable*, i8*)*, i32 (%struct.net_device*, i32, %struct.ethtool_coalesce*)*, i32 (%struct.net_device*, i32, %struct.ethtool_coalesce*)*, i32 (%struct.net_device*, %struct.ethtool_link_ksettings*)*, i32 (%struct.net_device*, %struct.ethtool_link_ksettings*)*, i32 (%struct.net_device*, %struct.ethtool_fecparam*)*, i32 (%struct.net_device*, %struct.ethtool_fecparam*)* }
%struct.ethtool_cmd = type { i32, i32, i32, i16, i8, i8, i8, i8, i8, i8, i32, i32, i16, i8, i8, i32, [2 x i32] }
%struct.ethtool_drvinfo = type { i32, [32 x i8], [32 x i8], [32 x i8], [32 x i8], [32 x i8], [12 x i8], i32, i32, i32, i32, i32 }
%struct.ethtool_regs = type { i32, i32, i32, [0 x i8] }
%struct.ethtool_wolinfo = type { i32, i32, i32, [6 x i8] }
%struct.ethtool_coalesce = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32 }
%struct.ethtool_ringparam = type { i32, i32, i32, i32, i32, i32, i32, i32, i32 }
%struct.ethtool_pauseparam = type { i32, i32, i32, i32 }
%struct.ethtool_test = type { i32, i32, i32, i32, [0 x i64] }
%struct.ethtool_stats = type { i32, i32, [0 x i64] }
%struct.ethtool_rxnfc = type { i32, i32, i64, %struct.ethtool_rx_flow_spec, i32, [0 x i32] }
%struct.ethtool_rx_flow_spec = type { i32, %union.ethtool_flow_union, %struct.ethtool_flow_ext, %union.ethtool_flow_union, %struct.ethtool_flow_ext, i64, i32 }
%union.ethtool_flow_union = type { %struct.ethtool_tcpip6_spec, [12 x i8] }
%struct.ethtool_tcpip6_spec = type { [4 x i32], [4 x i32], i16, i16, i8 }
%struct.ethtool_flow_ext = type { [2 x i8], [6 x i8], i16, i16, [2 x i32] }
%struct.ethtool_flash = type { i32, i32, [128 x i8] }
%struct.ethtool_channels = type { i32, i32, i32, i32, i32, i32, i32, i32, i32 }
%struct.ethtool_dump = type { i32, i32, i32, i32, [0 x i8] }
%struct.ethtool_ts_info = type { i32, i32, i32, i32, [3 x i32], i32, [3 x i32] }
%struct.ethtool_modinfo = type { i32, i32, i32, [8 x i32] }
%struct.ethtool_eeprom = type { i32, i32, i32, i32, [0 x i8] }
%struct.ethtool_eee = type { i32, i32, i32, i32, i32, i32, i32, i32, [2 x i32] }
%struct.ethtool_tunable = type { i32, i32, i32, i32, [0 x i8*] }
%struct.ethtool_link_ksettings = type { %struct.ethtool_link_settings, %struct.anon.87 }
%struct.ethtool_link_settings = type { i32, i32, i8, i8, i8, i8, i8, i8, i8, i8, i8, [3 x i8], [7 x i32], [0 x i32] }
%struct.anon.87 = type { [1 x i64], [1 x i64], [1 x i64] }
%struct.ethtool_fecparam = type { i32, i32, i32, i32 }
%struct.switchdev_ops = type opaque
%struct.l3mdev_ops = type opaque
%struct.ndisc_ops = type opaque
%struct.xfrmdev_ops = type { i32 (%struct.xfrm_state*)*, void (%struct.xfrm_state*)*, void (%struct.xfrm_state*)*, i1 (%struct.sk_buff*, %struct.xfrm_state*)* }
%struct.xfrm_state = type opaque
%struct.header_ops = type { i32 (%struct.sk_buff*, %struct.net_device*, i16, i8*, i8*, i32)*, i32 (%struct.sk_buff*, i8*)*, i32 (%struct.neighbour*, %struct.hh_cache*, i16)*, void (%struct.hh_cache*, %struct.net_device*, i8*)*, i1 (i8*, i32)* }
%struct.hh_cache = type { i32, %struct.seqlock_t, [16 x i64] }
%struct.seqlock_t = type { %struct.seqcount, %struct.spinlock }
%struct.seqcount = type { i32 }
%struct.netdev_hw_addr_list = type { %struct.list_head, i32 }
%struct.kset = type { %struct.list_head, %struct.spinlock, %struct.kobject, %struct.kset_uevent_ops* }
%struct.kobject = type { i8*, %struct.list_head, %struct.kobject*, %struct.kset*, %struct.kobj_type*, %struct.kernfs_node*, %struct.kref, i8 }
%struct.kobj_type = type { void (%struct.kobject*)*, %struct.sysfs_ops*, %struct.attribute**, %struct.kobj_ns_type_operations* (%struct.kobject*)*, i8* (%struct.kobject*)* }
%struct.sysfs_ops = type { i64 (%struct.kobject*, %struct.attribute*, i8*)*, i64 (%struct.kobject*, %struct.attribute*, i8*, i64)* }
%struct.attribute = type { i8*, i16 }
%struct.kobj_ns_type_operations = type { i32, i1 ()*, i8* ()*, i8* (%struct.sock*)*, i8* ()*, void (i8*)* }
%struct.sock = type opaque
%struct.kernfs_node = type { %struct.atomic_t, %struct.atomic_t, %struct.kernfs_node*, i8*, %struct.rb_node, i8*, i32, %union.anon.58, i8*, %union.kernfs_node_id, i16, i16, %struct.kernfs_iattrs* }
%struct.rb_node = type { i64, %struct.rb_node*, %struct.rb_node* }
%union.anon.58 = type { %struct.kernfs_elem_attr }
%struct.kernfs_elem_attr = type { %struct.kernfs_ops*, %struct.kernfs_open_node*, i64, %struct.kernfs_node* }
%struct.kernfs_ops = type { i32 (%struct.kernfs_open_file*)*, void (%struct.kernfs_open_file*)*, i32 (%struct.seq_file*, i8*)*, i8* (%struct.seq_file*, i64*)*, i8* (%struct.seq_file*, i8*, i64*)*, void (%struct.seq_file*, i8*)*, i64 (%struct.kernfs_open_file*, i8*, i64, i64)*, i64, i8, i64 (%struct.kernfs_open_file*, i8*, i64, i64)*, i32 (%struct.kernfs_open_file*, %struct.vm_area_struct*)* }
%struct.kernfs_open_file = type { %struct.kernfs_node*, %struct.file*, %struct.seq_file*, i8*, %struct.mutex, %struct.mutex, i32, %struct.list_head, i8*, i64, i8, %struct.vm_operations_struct* }
%struct.file = type { %union.anon, %struct.path, %struct.inode*, %struct.file_operations*, %struct.spinlock, i32, %struct.atomic64_t, i32, i32, %struct.mutex, i64, %struct.fown_struct, %struct.cred*, %struct.file_ra_state, i64, i8*, i8*, %struct.list_head, %struct.list_head, %struct.address_space*, i32 }
%union.anon = type { %struct.callback_head }
%struct.path = type { %struct.vfsmount*, %struct.dentry* }
%struct.vfsmount = type opaque
%struct.dentry = type { i32, %struct.seqcount, %struct.hlist_bl_node, %struct.dentry*, %struct.qstr, %struct.inode*, [32 x i8], %struct.lockref, %struct.dentry_operations*, %struct.super_block*, i64, i8*, %union.anon.26, %struct.list_head, %struct.list_head, %union.anon.27 }
%struct.hlist_bl_node = type { %struct.hlist_bl_node*, %struct.hlist_bl_node** }
%struct.qstr = type { %union.anon.0, i8* }
%union.anon.0 = type { i64 }
%struct.lockref = type { %union.anon.24 }
%union.anon.24 = type { i64 }
%struct.dentry_operations = type { i32 (%struct.dentry*, i32)*, i32 (%struct.dentry*, i32)*, i32 (%struct.dentry*, %struct.qstr*)*, i32 (%struct.dentry*, i32, i8*, %struct.qstr*)*, i32 (%struct.dentry*)*, i32 (%struct.dentry*)*, void (%struct.dentry*)*, void (%struct.dentry*)*, void (%struct.dentry*, %struct.inode*)*, i8* (%struct.dentry*, i8*, i32)*, %struct.vfsmount* (%struct.path*)*, i32 (%struct.path*, i1)*, %struct.dentry* (%struct.dentry*, %struct.inode*, i32, i32)*, [24 x i8] }
%struct.super_block = type { %struct.list_head, i32, i8, i64, i64, %struct.file_system_type*, %struct.super_operations*, %struct.dquot_operations*, %struct.quotactl_ops*, %struct.export_operations*, i64, i64, i64, %struct.dentry*, %struct.rw_semaphore, i32, %struct.atomic_t, i8*, %struct.xattr_handler**, %struct.fscrypt_operations*, %struct.hlist_bl_head, %struct.list_head, %struct.block_device*, %struct.backing_dev_info*, %struct.mtd_info*, %struct.hlist_node, i32, %struct.quota_info, %struct.sb_writers, [32 x i8], %struct.uuid_t, i8*, i32, i32, i32, %struct.mutex, i8*, %struct.dentry_operations*, i32, %struct.shrinker, %struct.atomic64_t, i32, %struct.workqueue_struct*, %struct.hlist_head, %struct.user_namespace*, %struct.list_lru, [40 x i8], %struct.list_lru, %struct.callback_head, %struct.work_struct, %struct.mutex, i32, [20 x i8], %struct.spinlock, %struct.list_head, %struct.spinlock, %struct.list_head, [16 x i8] }
%struct.file_system_type = type { i8*, i32, %struct.dentry* (%struct.file_system_type*, i32, i8*, i8*)*, void (%struct.super_block*)*, %struct.module*, %struct.file_system_type*, %struct.hlist_head, %struct.lock_class_key, %struct.lock_class_key, %struct.lock_class_key, [3 x %struct.lock_class_key], %struct.lock_class_key, %struct.lock_class_key, %struct.lock_class_key }
%struct.lock_class_key = type {}
%struct.super_operations = type { %struct.inode* (%struct.super_block*)*, void (%struct.inode*)*, void (%struct.inode*, i32)*, i32 (%struct.inode*, %struct.writeback_control*)*, i32 (%struct.inode*)*, void (%struct.inode*)*, void (%struct.super_block*)*, i32 (%struct.super_block*, i32)*, i32 (%struct.super_block*)*, i32 (%struct.super_block*)*, i32 (%struct.super_block*)*, i32 (%struct.super_block*)*, i32 (%struct.dentry*, %struct.kstatfs*)*, i32 (%struct.super_block*, i32*, i8*)*, void (%struct.super_block*)*, i32 (%struct.seq_file*, %struct.dentry*)*, i32 (%struct.seq_file*, %struct.dentry*)*, i32 (%struct.seq_file*, %struct.dentry*)*, i32 (%struct.seq_file*, %struct.dentry*)*, i64 (%struct.super_block*, i32, i8*, i64, i64)*, i64 (%struct.super_block*, i32, i8*, i64, i64)*, %struct.dquot** (%struct.inode*)*, i32 (%struct.super_block*, %struct.page*, i32)*, i64 (%struct.super_block*, %struct.shrink_control*)*, i64 (%struct.super_block*, %struct.shrink_control*)*, %struct.file* (%struct.file*)* }
%struct.writeback_control = type opaque
%struct.kstatfs = type opaque
%struct.dquot = type { %struct.hlist_node, %struct.list_head, %struct.list_head, %struct.list_head, %struct.mutex, %struct.spinlock, %struct.atomic_t, %struct.super_block*, %struct.kqid, i64, i64, %struct.mem_dqblk }
%struct.kqid = type { %union.anon.3, i32 }
%union.anon.3 = type { %struct.kuid_t }
%struct.kuid_t = type { i32 }
%struct.mem_dqblk = type { i64, i64, i64, i64, i64, i64, i64, i64, i64 }
%struct.page = type { i64, %union.anon.4, %union.anon.9, %union.anon.10, %union.anon.14, %union.anon.18, %struct.mem_cgroup* }
%union.anon.4 = type { %struct.address_space* }
%union.anon.9 = type { i64 }
%union.anon.10 = type { i64 }
%union.anon.14 = type { %struct.list_head }
%union.anon.18 = type { i64 }
%struct.mem_cgroup = type opaque
%struct.shrink_control = type { i32, i64, i64, i32, %struct.mem_cgroup* }
%struct.dquot_operations = type { i32 (%struct.dquot*)*, %struct.dquot* (%struct.super_block*, i32)*, void (%struct.dquot*)*, i32 (%struct.dquot*)*, i32 (%struct.dquot*)*, i32 (%struct.dquot*)*, i32 (%struct.super_block*, i32)*, i64* (%struct.inode*)*, i32 (%struct.inode*, %struct.kprojid_t*)*, i32 (%struct.inode*, i64*)*, i32 (%struct.super_block*, %struct.kqid*)* }
%struct.kprojid_t = type { i32 }
%struct.quotactl_ops = type { i32 (%struct.super_block*, i32, i32, %struct.path*)*, i32 (%struct.super_block*, i32)*, i32 (%struct.super_block*, i32)*, i32 (%struct.super_block*, i32)*, i32 (%struct.super_block*, i32)*, i32 (%struct.super_block*, i32, %struct.qc_info*)*, i32 (%struct.super_block*, i64, %struct.qc_dqblk*)*, i32 (%struct.super_block*, %struct.kqid*, %struct.qc_dqblk*)*, i32 (%struct.super_block*, i64, %struct.qc_dqblk*)*, i32 (%struct.super_block*, %struct.qc_state*)*, i32 (%struct.super_block*, i32)* }
%struct.qc_info = type { i32, i32, i32, i32, i32, i32, i32, i32 }
%struct.qc_dqblk = type { i32, i64, i64, i64, i64, i64, i64, i64, i64, i32, i32, i64, i64, i64, i64, i32 }
%struct.qc_state = type { i32, [3 x %struct.qc_type_state] }
%struct.qc_type_state = type { i32, i32, i32, i32, i32, i32, i32, i64, i64, i64 }
%struct.export_operations = type opaque
%struct.rw_semaphore = type { %struct.atomic64_t, %struct.list_head, %struct.raw_spinlock, %struct.optimistic_spin_queue, %struct.task_struct* }
%struct.raw_spinlock = type { %struct.qspinlock }
%struct.qspinlock = type { %struct.atomic_t }
%struct.optimistic_spin_queue = type { %struct.atomic_t }
%struct.task_struct = type { %struct.thread_info, i64, i8*, %struct.atomic_t, i32, i32, %struct.llist_node, i32, i32, i32, i64, %struct.task_struct*, i32, i32, i32, i32, i32, i32, %struct.sched_class*, [8 x i8], %struct.sched_entity, %struct.sched_rt_entity, %struct.task_group*, %struct.sched_dl_entity, %struct.hlist_head, i32, i32, i32, %struct.cpumask, i64, i8, i8, i32, %struct.list_head, %struct.sched_info, %struct.list_head, %struct.plist_node, %struct.rb_node, %struct.mm_struct*, %struct.mm_struct*, %struct.vmacache, %struct.task_rss_stat, i32, i32, i32, i32, i64, i32, i8, [3 x i8], i8, i64, %struct.restart_block, i32, i32, i64, %struct.task_struct*, %struct.task_struct*, %struct.list_head, %struct.list_head, %struct.task_struct*, %struct.list_head, %struct.list_head, [3 x %struct.pid_link], %struct.list_head, %struct.list_head, %struct.completion*, i32*, i32*, i64, i64, i64, %struct.prev_cputime, i64, i64, i64, i64, i64, i64, %struct.task_cputime, [3 x %struct.list_head], %struct.cred*, %struct.cred*, %struct.cred*, [16 x i8], %struct.nameidata*, %struct.sysv_sem, %struct.sysv_shm, i64, %struct.fs_struct*, %struct.files_struct*, %struct.nsproxy*, %struct.signal_struct*, %struct.sighand_struct*, %struct.sigset_t, %struct.sigset_t, %struct.sigset_t, %struct.sigpending, i64, i64, i32, %struct.callback_head*, %struct.audit_context*, %struct.kuid_t, i32, %struct.seccomp, i32, i32, %struct.spinlock, %struct.raw_spinlock, %struct.wake_q_node, %struct.rb_root_cached, %struct.task_struct*, %struct.rt_mutex_waiter*, i8*, %struct.bio_list*, %struct.blk_plug*, %struct.reclaim_state*, %struct.backing_dev_info*, %struct.io_context*, i64, %struct.siginfo*, %struct.task_io_accounting, i64, i64, i64, %struct.nodemask_t, %struct.seqcount, i32, i32, %struct.css_set*, %struct.list_head, i32, i32, %struct.robust_list_head*, %struct.compat_robust_list_head*, %struct.list_head, %struct.futex_pi_state*, [2 x %struct.perf_event_context*], %struct.mutex, %struct.list_head, %struct.mempolicy*, i16, i16, i32, i32, i32, i32, i64, i64, i64, i64, %struct.callback_head, %struct.list_head, %struct.numa_group*, i64*, i64, [3 x i64], i64, %struct.tlbflush_unmap_batch, %struct.callback_head, %struct.pipe_inode_info*, %struct.page_frag, %struct.task_delay_info*, i32, i32, i64, i64, i64, i32, %struct.ftrace_ret_stack*, i64, %struct.atomic_t, %struct.atomic_t, i64, i64, %struct.mem_cgroup*, i32, i32, i32, %struct.uprobe_task*, i32, i32, i32, %struct.task_struct*, %struct.vm_struct*, %struct.atomic_t, i32, i8*, [16 x i8], %struct.thread_struct }
%struct.thread_info = type { i64, i32 }
%struct.llist_node = type { %struct.llist_node* }
%struct.sched_class = type opaque
%struct.sched_entity = type { %struct.load_weight, i64, %struct.rb_node, %struct.list_head, i32, i64, i64, i64, i64, i64, %struct.sched_statistics, i32, %struct.sched_entity*, %struct.cfs_rq*, %struct.cfs_rq*, [24 x i8], %struct.sched_avg, [8 x i8] }
%struct.load_weight = type { i64, i32 }
%struct.sched_statistics = type { i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64 }
%struct.cfs_rq = type opaque
%struct.sched_avg = type { i64, i64, i64, i32, i32, i64, i64, i64 }
%struct.sched_rt_entity = type { %struct.list_head, i64, i64, i32, i16, i16, %struct.sched_rt_entity* }
%struct.task_group = type opaque
%struct.sched_dl_entity = type { %struct.rb_node, i64, i64, i64, i64, i64, i64, i64, i32, i8, %struct.hrtimer, %struct.hrtimer }
%struct.cpumask = type { [128 x i64] }
%struct.sched_info = type { i64, i64, i64, i64 }
%struct.plist_node = type { i32, %struct.list_head, %struct.list_head }
%struct.mm_struct = type { %struct.vm_area_struct*, %struct.rb_root, i32, i64 (%struct.file*, i64, i64, i64, i64)*, i64, i64, i64, i64, i64, i64, %struct.pgd_t*, %struct.atomic_t, %struct.atomic_t, %struct.atomic64_t, i32, %struct.spinlock, %struct.rw_semaphore, %struct.list_head, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, [46 x i64], %struct.mm_rss_stat, %struct.linux_binfmt*, %struct.cpumask*, %struct.mm_context_t, i64, %struct.core_state*, %struct.atomic_t, %struct.spinlock, %struct.kioctx_table*, %struct.task_struct*, %struct.user_namespace*, %struct.file*, %struct.mmu_notifier_mm*, %struct.cpumask, i64, i64, i32, %struct.atomic_t, i8, %struct.uprobes_state, %struct.atomic64_t, %struct.work_struct, %struct.hmm* }
%struct.vm_area_struct = type { i64, i64, %struct.vm_area_struct*, %struct.vm_area_struct*, %struct.rb_node, i64, %struct.mm_struct*, %struct.pgprot, i64, %struct.anon, %struct.list_head, %struct.anon_vma*, %struct.vm_operations_struct*, i64, %struct.file*, %struct.file*, i8*, %struct.atomic64_t, %struct.mempolicy*, %struct.vm_userfaultfd_ctx }
%struct.pgprot = type { i64 }
%struct.anon = type { %struct.rb_node, i64 }
%struct.anon_vma = type opaque
%struct.vm_userfaultfd_ctx = type { %struct.userfaultfd_ctx* }
%struct.userfaultfd_ctx = type opaque
%struct.rb_root = type { %struct.rb_node* }
%struct.pgd_t = type { i64 }
%struct.mm_rss_stat = type { [4 x %struct.atomic64_t] }
%struct.linux_binfmt = type opaque
%struct.mm_context_t = type { i64, %struct.atomic64_t, %struct.rw_semaphore, %struct.ldt_struct*, i16, %struct.mutex, i8*, %struct.vdso_image*, %struct.atomic_t, i16, i16, i8* }
%struct.ldt_struct = type opaque
%struct.vdso_image = type opaque
%struct.core_state = type { %struct.atomic_t, %struct.core_thread, %struct.completion }
%struct.core_thread = type { %struct.task_struct*, %struct.core_thread* }
%struct.completion = type { i32, %struct.wait_queue_head }
%struct.wait_queue_head = type { %struct.spinlock, %struct.list_head }
%struct.kioctx_table = type opaque
%struct.mmu_notifier_mm = type opaque
%struct.uprobes_state = type { %struct.xol_area* }
%struct.xol_area = type opaque
%struct.hmm = type opaque
%struct.vmacache = type { i32, [4 x %struct.vm_area_struct*] }
%struct.task_rss_stat = type { i32, [4 x i32] }
%struct.restart_block = type { i64 (%struct.restart_block*)*, %union.anon.30 }
%union.anon.30 = type { %struct.anon.31 }
%struct.anon.31 = type { i32*, i32, i32, i32, i64, i32* }
%struct.pid_link = type { %struct.hlist_node, %struct.pid* }
%struct.pid = type { %struct.atomic_t, i32, [3 x %struct.hlist_head], %struct.callback_head, [1 x %struct.upid] }
%struct.upid = type { i32, %struct.pid_namespace* }
%struct.pid_namespace = type opaque
%struct.prev_cputime = type { i64, i64, %struct.raw_spinlock }
%struct.task_cputime = type { i64, i64, i64 }
%struct.nameidata = type opaque
%struct.sysv_sem = type { %struct.sem_undo_list* }
%struct.sem_undo_list = type opaque
%struct.sysv_shm = type { %struct.list_head }
%struct.fs_struct = type opaque
%struct.files_struct = type opaque
%struct.nsproxy = type { %struct.atomic_t, %struct.uts_namespace*, %struct.ipc_namespace*, %struct.mnt_namespace*, %struct.pid_namespace*, %struct.net*, %struct.cgroup_namespace* }
%struct.uts_namespace = type opaque
%struct.ipc_namespace = type opaque
%struct.mnt_namespace = type opaque
%struct.net = type { %struct.refcount_struct, %struct.atomic_t, %struct.spinlock, %struct.atomic64_t, %struct.list_head, %struct.list_head, %struct.list_head, %struct.user_namespace*, %struct.ucounts*, %struct.spinlock, %struct.idr, %struct.ns_common, %struct.proc_dir_entry*, %struct.proc_dir_entry*, %struct.ctl_table_set, %struct.sock*, %struct.sock*, %struct.list_head, %struct.hlist_head*, %struct.hlist_head*, i32, i32, i32, %struct.list_head, %struct.list_head, %struct.net_device*, %struct.netns_core, %struct.netns_mib, %struct.netns_packet, %struct.netns_unix, [24 x i8], %struct.netns_ipv4, %struct.netns_ipv6, %struct.netns_ieee802154_lowpan, %struct.netns_sctp, %struct.netns_dccp, %struct.netns_nf, %struct.netns_xt, %struct.netns_ct, %struct.netns_nftables, [40 x i8], %struct.netns_nf_frag, %struct.sock*, %struct.sock*, %struct.list_head, %struct.list_head, %struct.sk_buff_head, %struct.net_generic*, [48 x i8], %struct.netns_xfrm, %struct.netns_ipvs*, %struct.netns_mpls, %struct.netns_can, %struct.sock*, %struct.atomic_t, [36 x i8] }
%struct.refcount_struct = type { %struct.atomic_t }
%struct.ucounts = type { %struct.hlist_node, %struct.user_namespace*, %struct.kuid_t, i32, [9 x %struct.atomic_t] }
%struct.idr = type { %struct.radix_tree_root, i32 }
%struct.radix_tree_root = type { i32, %struct.radix_tree_node* }
%struct.radix_tree_node = type { i8, i8, i8, i8, %struct.radix_tree_node*, %struct.radix_tree_root*, %union.anon.5, [64 x i8*], [3 x [1 x i64]] }
%union.anon.5 = type { %struct.list_head }
%struct.ns_common = type { %struct.atomic64_t, %struct.proc_ns_operations*, i32 }
%struct.proc_ns_operations = type opaque
%struct.proc_dir_entry = type opaque
%struct.ctl_table_set = type { i32 (%struct.ctl_table_set*)*, %struct.ctl_dir }
%struct.ctl_dir = type { %struct.ctl_table_header, %struct.rb_root }
%struct.ctl_table_header = type { %union.anon.60, %struct.completion*, %struct.ctl_table*, %struct.ctl_table_root*, %struct.ctl_table_set*, %struct.ctl_dir*, %struct.ctl_node*, %struct.hlist_head }
%union.anon.60 = type { %struct.anon.61 }
%struct.anon.61 = type { %struct.ctl_table*, i32, i32, i32 }
%struct.ctl_table = type { i8*, i8*, i32, i16, %struct.ctl_table*, i32 (%struct.ctl_table*, i32, i8*, i64*, i64*)*, %struct.ctl_table_poll*, i8*, i8* }
%struct.ctl_table_poll = type { %struct.atomic_t, %struct.wait_queue_head }
%struct.ctl_table_root = type { %struct.ctl_table_set, %struct.ctl_table_set* (%struct.ctl_table_root*)*, void (%struct.ctl_table_header*, %struct.ctl_table*, %struct.kuid_t*, %struct.kgid_t*)*, i32 (%struct.ctl_table_header*, %struct.ctl_table*)* }
%struct.kgid_t = type { i32 }
%struct.ctl_node = type { %struct.rb_node, %struct.ctl_table_header* }
%struct.netns_core = type { %struct.ctl_table_header*, i32, %struct.prot_inuse* }
%struct.prot_inuse = type opaque
%struct.netns_mib = type { %struct.tcp_mib*, %struct.ipstats_mib*, %struct.linux_mib*, %struct.udp_mib*, %struct.udp_mib*, %struct.icmp_mib*, %struct.icmpmsg_mib*, %struct.proc_dir_entry*, %struct.udp_mib*, %struct.udp_mib*, %struct.ipstats_mib*, %struct.icmpv6_mib*, %struct.icmpv6msg_mib*, %struct.linux_xfrm_mib* }
%struct.tcp_mib = type { [16 x i64] }
%struct.linux_mib = type { [112 x i64] }
%struct.icmp_mib = type { [28 x i64] }
%struct.icmpmsg_mib = type { [512 x %struct.atomic64_t] }
%struct.udp_mib = type { [9 x i64] }
%struct.ipstats_mib = type { [36 x i64], %struct.u64_stats_sync }
%struct.u64_stats_sync = type {}
%struct.icmpv6_mib = type { [6 x i64] }
%struct.icmpv6msg_mib = type { [512 x %struct.atomic64_t] }
%struct.linux_xfrm_mib = type { [29 x i64] }
%struct.netns_packet = type { %struct.mutex, %struct.hlist_head }
%struct.netns_unix = type { i32, %struct.ctl_table_header* }
%struct.netns_ipv4 = type { %struct.ctl_table_header*, %struct.ctl_table_header*, %struct.ctl_table_header*, %struct.ctl_table_header*, %struct.ctl_table_header*, %struct.ipv4_devconf*, %struct.ipv4_devconf*, %struct.fib_rules_ops*, i8, %struct.fib_table*, %struct.fib_table*, i8, i32, %struct.hlist_head*, i8, %struct.sock*, %struct.sock**, %struct.sock*, %struct.inet_peer_base*, %struct.sock**, [40 x i8], %struct.netns_frags, %struct.xt_table*, %struct.xt_table*, %struct.xt_table*, %struct.xt_table*, %struct.xt_table*, %struct.xt_table*, i32, i32, i32, i32, i32, i32, %struct.local_ports, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, [3 x i32], [3 x i32], [32 x i8], %struct.inet_timewait_death_row, i32, i32, %struct.tcp_congestion_ops*, %struct.tcp_fastopen_context*, %struct.spinlock, i32, %struct.atomic_t, i64, i32, i32, i32, i32, i32, %struct.ping_group_range, %struct.atomic_t, i64*, i32, %struct.mr_table*, i32, i32, %struct.fib_notifier_ops*, i32, %struct.fib_notifier_ops*, i32, %struct.atomic_t, [40 x i8] }
%struct.ipv4_devconf = type opaque
%struct.fib_rules_ops = type opaque
%struct.fib_table = type opaque
%struct.inet_peer_base = type opaque
%struct.netns_frags = type { %struct.atomic_t, i32, i32, i32, i32, [44 x i8] }
%struct.xt_table = type opaque
%struct.local_ports = type { %struct.seqlock_t, [2 x i32], i8 }
%struct.inet_timewait_death_row = type { %struct.atomic_t, [60 x i8], %struct.inet_hashinfo*, i32, [52 x i8] }
%struct.inet_hashinfo = type opaque
%struct.tcp_congestion_ops = type opaque
%struct.tcp_fastopen_context = type opaque
%struct.ping_group_range = type { %struct.seqlock_t, [2 x %struct.kgid_t] }
%struct.mr_table = type opaque
%struct.fib_notifier_ops = type opaque
%struct.netns_ipv6 = type { %struct.netns_sysctl_ipv6, %struct.ipv6_devconf*, %struct.ipv6_devconf*, %struct.inet_peer_base*, [32 x i8], %struct.netns_frags, %struct.xt_table*, %struct.xt_table*, %struct.xt_table*, %struct.xt_table*, %struct.xt_table*, %struct.rt6_info*, %struct.rt6_statistics*, %struct.timer_list, %struct.hlist_head*, %struct.fib6_table*, %struct.list_head, %struct.dst_ops, %struct.rwlock_t, %struct.spinlock, i32, i64, i8, %struct.rt6_info*, %struct.rt6_info*, %struct.fib6_table*, %struct.fib_rules_ops*, %struct.sock**, %struct.sock*, %struct.sock*, %struct.sock*, %struct.sock*, %struct.list_head, %struct.fib_rules_ops*, %struct.atomic_t, %struct.atomic_t, %struct.seg6_pernet_data*, %struct.fib_notifier_ops*, %struct.anon.75, [24 x i8] }
%struct.netns_sysctl_ipv6 = type { %struct.ctl_table_header*, %struct.ctl_table_header*, %struct.ctl_table_header*, %struct.ctl_table_header*, %struct.ctl_table_header*, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32 }
%struct.ipv6_devconf = type opaque
%struct.rt6_statistics = type opaque
%struct.dst_ops = type { i16, i32, i32 (%struct.dst_ops*)*, %struct.dst_entry* (%struct.dst_entry*, i32)*, i32 (%struct.dst_entry*)*, i32 (%struct.dst_entry*)*, i32* (%struct.dst_entry*, i64)*, void (%struct.dst_entry*)*, void (%struct.dst_entry*, %struct.net_device*, i32)*, %struct.dst_entry* (%struct.dst_entry*)*, void (%struct.sk_buff*)*, void (%struct.dst_entry*, %struct.sock*, %struct.sk_buff*, i32)*, void (%struct.dst_entry*, %struct.sock*, %struct.sk_buff*)*, i32 (%struct.net*, %struct.sock*, %struct.sk_buff*)*, %struct.neighbour* (%struct.dst_entry*, %struct.sk_buff*, i8*)*, void (%struct.dst_entry*, i8*)*, %struct.kmem_cache*, %struct.percpu_counter, [24 x i8] }
%struct.dst_entry = type opaque
%struct.kmem_cache = type opaque
%struct.percpu_counter = type { %struct.raw_spinlock, i64, %struct.list_head, i32* }
%struct.rwlock_t = type { %struct.qrwlock }
%struct.qrwlock = type { %union.anon.28, %struct.qspinlock }
%union.anon.28 = type { %struct.atomic_t }
%struct.rt6_info = type opaque
%struct.fib6_table = type opaque
%struct.seg6_pernet_data = type opaque
%struct.anon.75 = type { %struct.hlist_head, %struct.spinlock, i32 }
%struct.netns_ieee802154_lowpan = type { %struct.netns_sysctl_lowpan, [56 x i8], %struct.netns_frags }
%struct.netns_sysctl_lowpan = type { %struct.ctl_table_header* }
%struct.netns_sctp = type { %struct.sctp_mib*, %struct.proc_dir_entry*, %struct.ctl_table_header*, %struct.sock*, %struct.list_head, %struct.list_head, %struct.timer_list, %struct.list_head, %struct.spinlock, %struct.spinlock, i32, i32, i32, i32, i32, i32, i32, i8*, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i64 }
%struct.sctp_mib = type opaque
%struct.netns_dccp = type { %struct.sock*, %struct.sock* }
%struct.netns_nf = type { %struct.proc_dir_entry*, %struct.nf_queue_handler*, [13 x %struct.nf_logger*], %struct.ctl_table_header*, [13 x [8 x %struct.nf_hook_entries*]], i8, i8 }
%struct.nf_queue_handler = type opaque
%struct.nf_logger = type opaque
%struct.netns_xt = type { [13 x %struct.list_head], i8, i8, %struct.ebt_table*, %struct.ebt_table*, %struct.ebt_table* }
%struct.ebt_table = type opaque
%struct.netns_ct = type { %struct.atomic_t, i32, %struct.delayed_work, i8, %struct.ctl_table_header*, %struct.ctl_table_header*, %struct.ctl_table_header*, %struct.ctl_table_header*, %struct.ctl_table_header*, i32, i32, i32, i32, i8, i32, i32, %struct.ct_pcpu*, %struct.ip_conntrack_stat*, %struct.nf_ct_event_notifier*, %struct.nf_exp_event_notifier*, %struct.nf_ip_net, i32 }
%struct.delayed_work = type { %struct.work_struct, %struct.timer_list, %struct.workqueue_struct*, i32 }
%struct.ct_pcpu = type { %struct.spinlock, %struct.hlist_nulls_head, %struct.hlist_nulls_head }
%struct.hlist_nulls_head = type { %struct.hlist_nulls_node* }
%struct.hlist_nulls_node = type { %struct.hlist_nulls_node*, %struct.hlist_nulls_node** }
%struct.ip_conntrack_stat = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32 }
%struct.nf_ct_event_notifier = type opaque
%struct.nf_exp_event_notifier = type opaque
%struct.nf_ip_net = type { %struct.nf_generic_net, %struct.nf_tcp_net, %struct.nf_udp_net, %struct.nf_icmp_net, %struct.nf_icmp_net, %struct.nf_dccp_net, %struct.nf_sctp_net }
%struct.nf_generic_net = type { %struct.nf_proto_net, i32 }
%struct.nf_proto_net = type { %struct.ctl_table_header*, %struct.ctl_table*, i32 }
%struct.nf_tcp_net = type { %struct.nf_proto_net, [14 x i32], i32, i32, i32 }
%struct.nf_udp_net = type { %struct.nf_proto_net, [2 x i32] }
%struct.nf_icmp_net = type { %struct.nf_proto_net, i32 }
%struct.nf_dccp_net = type { %struct.nf_proto_net, i32, [10 x i32] }
%struct.nf_sctp_net = type { %struct.nf_proto_net, [10 x i32] }
%struct.netns_nftables = type { %struct.list_head, %struct.list_head, %struct.nft_af_info*, %struct.nft_af_info*, %struct.nft_af_info*, %struct.nft_af_info*, %struct.nft_af_info*, %struct.nft_af_info*, i32, i8 }
%struct.nft_af_info = type opaque
%struct.netns_nf_frag = type { %struct.netns_sysctl_ipv6, [56 x i8], %struct.netns_frags }
%struct.sk_buff_head = type { %struct.sk_buff*, %struct.sk_buff*, i32, %struct.spinlock }
%struct.net_generic = type opaque
%struct.netns_xfrm = type { %struct.list_head, %struct.hlist_head*, %struct.hlist_head*, %struct.hlist_head*, i32, i32, %struct.work_struct, %struct.list_head, %struct.hlist_head*, i32, [3 x %struct.hlist_head], [3 x %struct.xfrm_policy_hash], [6 x i32], %struct.work_struct, %struct.xfrm_policy_hthresh, %struct.sock*, %struct.sock*, i32, i32, i32, i32, %struct.ctl_table_header*, [56 x i8], %struct.dst_ops, %struct.dst_ops, %struct.spinlock, %struct.spinlock, %struct.mutex, [24 x i8] }
%struct.xfrm_policy_hash = type { %struct.hlist_head*, i32, i8, i8, i8, i8 }
%struct.xfrm_policy_hthresh = type { %struct.work_struct, %struct.seqlock_t, i8, i8, i8, i8 }
%struct.netns_ipvs = type opaque
%struct.netns_mpls = type { i32, i32, i64, %struct.mpls_route**, %struct.ctl_table_header* }
%struct.mpls_route = type opaque
%struct.netns_can = type { %struct.proc_dir_entry*, %struct.proc_dir_entry*, %struct.proc_dir_entry*, %struct.proc_dir_entry*, %struct.proc_dir_entry*, %struct.proc_dir_entry*, %struct.proc_dir_entry*, %struct.proc_dir_entry*, %struct.proc_dir_entry*, %struct.proc_dir_entry*, %struct.proc_dir_entry*, %struct.dev_rcv_lists*, %struct.spinlock, %struct.timer_list, %struct.s_stats*, %struct.s_pstats*, %struct.hlist_head }
%struct.dev_rcv_lists = type opaque
%struct.s_stats = type opaque
%struct.s_pstats = type opaque
%struct.cgroup_namespace = type { %struct.refcount_struct, %struct.ns_common, %struct.user_namespace*, %struct.ucounts*, %struct.css_set* }
%struct.signal_struct = type opaque
%struct.sighand_struct = type opaque
%struct.sigset_t = type { [1 x i64] }
%struct.sigpending = type { %struct.list_head, %struct.sigset_t }
%struct.audit_context = type opaque
%struct.seccomp = type { i32, %struct.seccomp_filter* }
%struct.seccomp_filter = type opaque
%struct.wake_q_node = type { %struct.wake_q_node* }
%struct.rb_root_cached = type { %struct.rb_root, %struct.rb_node* }
%struct.rt_mutex_waiter = type opaque
%struct.bio_list = type opaque
%struct.blk_plug = type opaque
%struct.reclaim_state = type opaque
%struct.io_context = type opaque
%struct.siginfo = type { i32, i32, i32, %union.anon.35 }
%union.anon.35 = type { %struct.anon.39, [80 x i8] }
%struct.anon.39 = type { i32, i32, i32, i64, i64 }
%struct.task_io_accounting = type { i64, i64, i64, i64, i64, i64, i64 }
%struct.nodemask_t = type { [16 x i64] }
%struct.css_set = type { [13 x %struct.cgroup_subsys_state*], %struct.refcount_struct, %struct.css_set*, %struct.cgroup*, i32, %struct.list_head, %struct.list_head, %struct.list_head, [13 x %struct.list_head], %struct.list_head, %struct.list_head, %struct.hlist_node, %struct.list_head, %struct.list_head, %struct.list_head, %struct.cgroup*, %struct.cgroup*, %struct.css_set*, i8, %struct.callback_head }
%struct.cgroup_subsys_state = type { %struct.cgroup*, %struct.cgroup_subsys*, %struct.percpu_ref, %struct.list_head, %struct.list_head, i32, i32, i64, %struct.atomic_t, %struct.callback_head, %struct.work_struct, %struct.cgroup_subsys_state* }
%struct.cgroup_subsys = type { %struct.cgroup_subsys_state* (%struct.cgroup_subsys_state*)*, i32 (%struct.cgroup_subsys_state*)*, void (%struct.cgroup_subsys_state*)*, void (%struct.cgroup_subsys_state*)*, void (%struct.cgroup_subsys_state*)*, void (%struct.cgroup_subsys_state*)*, i32 (%struct.seq_file*, %struct.cgroup_subsys_state*)*, i32 (%struct.cgroup_taskset*)*, void (%struct.cgroup_taskset*)*, void (%struct.cgroup_taskset*)*, void ()*, i32 (%struct.task_struct*)*, void (%struct.task_struct*)*, void (%struct.task_struct*)*, void (%struct.task_struct*)*, void (%struct.task_struct*)*, void (%struct.cgroup_subsys_state*)*, i8, i32, i8*, i8*, %struct.cgroup_root*, %struct.idr, %struct.list_head, %struct.cftype*, %struct.cftype*, i32 }
%struct.cgroup_taskset = type opaque
%struct.cgroup_root = type { %struct.kernfs_root*, i32, i32, %struct.cgroup, i32, %struct.atomic_t, %struct.list_head, i32, %struct.idr, [4096 x i8], [64 x i8] }
%struct.kernfs_root = type { %struct.kernfs_node*, i32, %struct.idr, i32, %struct.kernfs_syscall_ops*, %struct.list_head, %struct.wait_queue_head }
%struct.kernfs_syscall_ops = type { i32 (%struct.kernfs_root*, i32*, i8*)*, i32 (%struct.seq_file*, %struct.kernfs_root*)*, i32 (%struct.kernfs_node*, i8*, i16)*, i32 (%struct.kernfs_node*)*, i32 (%struct.kernfs_node*, %struct.kernfs_node*, i8*)*, i32 (%struct.seq_file*, %struct.kernfs_node*, %struct.kernfs_root*)* }
%struct.cgroup = type { %struct.cgroup_subsys_state, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, %struct.kernfs_node*, %struct.cgroup_file, %struct.cgroup_file, i16, i16, i16, i16, [13 x %struct.cgroup_subsys_state*], %struct.cgroup_root*, %struct.list_head, [13 x %struct.list_head], %struct.cgroup*, %struct.cgroup_cpu_stat*, %struct.cgroup_stat, %struct.cgroup_stat, %struct.list_head, %struct.mutex, %struct.wait_queue_head, %struct.work_struct, %struct.cgroup_bpf, [0 x i32] }
%struct.cgroup_file = type { %struct.kernfs_node* }
%struct.cgroup_cpu_stat = type { %struct.u64_stats_sync, %struct.task_cputime, %struct.task_cputime, %struct.cgroup*, %struct.cgroup* }
%struct.cgroup_stat = type { %struct.task_cputime, %struct.prev_cputime }
%struct.cgroup_bpf = type { [17 x %struct.bpf_prog_array*], [17 x %struct.list_head], [17 x i32], %struct.bpf_prog_array* }
%struct.bpf_prog_array = type opaque
%struct.cftype = type { [64 x i8], i64, i64, i32, i32, %struct.cgroup_subsys*, %struct.list_head, %struct.kernfs_ops*, i32 (%struct.kernfs_open_file*)*, void (%struct.kernfs_open_file*)*, i64 (%struct.cgroup_subsys_state*, %struct.cftype*)*, i64 (%struct.cgroup_subsys_state*, %struct.cftype*)*, i32 (%struct.seq_file*, i8*)*, i8* (%struct.seq_file*, i64*)*, i8* (%struct.seq_file*, i8*, i64*)*, void (%struct.seq_file*, i8*)*, i32 (%struct.cgroup_subsys_state*, %struct.cftype*, i64)*, i32 (%struct.cgroup_subsys_state*, %struct.cftype*, i64)*, i64 (%struct.kernfs_open_file*, i8*, i64, i64)* }
%struct.percpu_ref = type { %struct.atomic64_t, i64, void (%struct.percpu_ref*)*, void (%struct.percpu_ref*)*, i8, %struct.callback_head }
%struct.robust_list_head = type opaque
%struct.compat_robust_list_head = type { %struct.compat_robust_list, i32, i32 }
%struct.compat_robust_list = type { i32 }
%struct.futex_pi_state = type opaque
%struct.perf_event_context = type opaque
%struct.mempolicy = type opaque
%struct.numa_group = type opaque
%struct.tlbflush_unmap_batch = type { %struct.arch_tlbflush_unmap_batch, i8, i8 }
%struct.arch_tlbflush_unmap_batch = type { %struct.cpumask }
%struct.pipe_inode_info = type { %struct.mutex, %struct.wait_queue_head, i32, i32, i32, i32, i32, i32, i32, i32, i32, %struct.page*, %struct.fasync_struct*, %struct.fasync_struct*, %struct.pipe_buffer*, %struct.user_struct* }
%struct.fasync_struct = type { %struct.spinlock, i32, i32, %struct.fasync_struct*, %struct.file*, %struct.callback_head }
%struct.pipe_buffer = type { %struct.page*, i32, i32, %struct.pipe_buf_operations*, i32, i64 }
%struct.pipe_buf_operations = type { i32, i32 (%struct.pipe_inode_info*, %struct.pipe_buffer*)*, void (%struct.pipe_inode_info*, %struct.pipe_buffer*)*, i32 (%struct.pipe_inode_info*, %struct.pipe_buffer*)*, void (%struct.pipe_inode_info*, %struct.pipe_buffer*)* }
%struct.user_struct = type { %struct.atomic_t, %struct.atomic_t, %struct.atomic_t, %struct.atomic_t, %struct.atomic64_t, i64, i64, i64, %struct.atomic64_t, %struct.key*, %struct.key*, %struct.hlist_node, %struct.kuid_t, %struct.atomic64_t }
%struct.key = type { %struct.refcount_struct, i32, %union.anon.52, %struct.rw_semaphore, %struct.key_user*, i8*, %union.anon.53, i64, %struct.kuid_t, %struct.kgid_t, i32, i16, i16, i16, i64, %union.anon.54, %union.anon.56, %struct.key_restriction* }
%union.anon.52 = type { %struct.rb_node }
%struct.key_user = type opaque
%union.anon.53 = type { i64 }
%union.anon.54 = type { %struct.keyring_index_key }
%struct.keyring_index_key = type { %struct.key_type*, i8*, i64 }
%struct.key_type = type opaque
%union.anon.56 = type { %union.key_payload }
%union.key_payload = type { [4 x i8*] }
%struct.key_restriction = type { i32 (%struct.key*, %struct.key_type*, %union.key_payload*, %struct.key*)*, %struct.key*, %struct.key_type* }
%struct.page_frag = type { %struct.page*, i32, i32 }
%struct.task_delay_info = type opaque
%struct.ftrace_ret_stack = type opaque
%struct.uprobe_task = type { i32, %union.anon.45, %struct.uprobe*, i64, %struct.return_instance*, i32 }
%union.anon.45 = type { %struct.anon.46 }
%struct.anon.46 = type { %struct.arch_uprobe_task, i64 }
%struct.arch_uprobe_task = type { i64, i32, i32 }
%struct.uprobe = type opaque
%struct.return_instance = type { %struct.uprobe*, i64, i64, i64, i8, %struct.return_instance* }
%struct.vm_struct = type { %struct.vm_struct*, i8*, i64, i64, %struct.page**, i32, i64, i8* }
%struct.thread_struct = type { [3 x %struct.desc_struct], i64, i16, i16, i16, i16, i64, i64, [4 x %struct.perf_event*], i64, i64, i64, i64, i64, i64*, i64, i32, %struct.mm_segment_t, i8, [31 x i8], %struct.fpu }
%struct.desc_struct = type { i16, i16, i32 }
%struct.perf_event = type opaque
%struct.mm_segment_t = type { i64 }
%struct.fpu = type { i32, i8, [59 x i8], %union.fpregs_state }
%union.fpregs_state = type { %struct.xregs_state, [3520 x i8] }
%struct.xregs_state = type { %struct.fxregs_state, %struct.xstate_header, [0 x i8] }
%struct.fxregs_state = type { i16, i16, i16, i16, %union.anon.48, i32, i32, [32 x i32], [64 x i32], [12 x i32], %union.anon.51 }
%union.anon.48 = type { %struct.anon.49 }
%struct.anon.49 = type { i64, i64 }
%union.anon.51 = type { [12 x i32] }
%struct.xstate_header = type { i64, i64, [6 x i64] }
%struct.xattr_handler = type opaque
%struct.fscrypt_operations = type opaque
%struct.hlist_bl_head = type { %struct.hlist_bl_node* }
%struct.block_device = type { i32, i32, %struct.inode*, %struct.super_block*, %struct.mutex, i8*, i8*, i32, i8, %struct.list_head, %struct.block_device*, i32, i8, %struct.hd_struct*, i32, i32, %struct.gendisk*, %struct.request_queue*, %struct.backing_dev_info*, %struct.list_head, i64, i32, %struct.mutex }
%struct.hd_struct = type opaque
%struct.gendisk = type opaque
%struct.request_queue = type opaque
%struct.backing_dev_info = type opaque
%struct.mtd_info = type opaque
%struct.quota_info = type { i32, %struct.rw_semaphore, [3 x %struct.inode*], [3 x %struct.mem_dqinfo], [3 x %struct.quota_format_ops*] }
%struct.mem_dqinfo = type { %struct.quota_format_type*, i32, %struct.list_head, i64, i32, i32, i64, i64, i8* }
%struct.quota_format_type = type { i32, %struct.quota_format_ops*, %struct.module*, %struct.quota_format_type* }
%struct.quota_format_ops = type { i32 (%struct.super_block*, i32)*, i32 (%struct.super_block*, i32)*, i32 (%struct.super_block*, i32)*, i32 (%struct.super_block*, i32)*, i32 (%struct.dquot*)*, i32 (%struct.dquot*)*, i32 (%struct.dquot*)*, i32 (%struct.super_block*, %struct.kqid*)* }
%struct.sb_writers = type { i32, %struct.wait_queue_head, [3 x %struct.percpu_rw_semaphore] }
%struct.percpu_rw_semaphore = type { %struct.rcu_sync, i32*, %struct.rw_semaphore, %struct.rcuwait, i32 }
%struct.rcu_sync = type { i32, i32, %struct.wait_queue_head, i32, %struct.callback_head, i32 }
%struct.rcuwait = type { %struct.task_struct* }
%struct.uuid_t = type { [16 x i8] }
%struct.shrinker = type { i64 (%struct.shrinker*, %struct.shrink_control*)*, i64 (%struct.shrinker*, %struct.shrink_control*)*, i32, i64, i64, %struct.list_head, %struct.atomic64_t* }
%struct.workqueue_struct = type opaque
%struct.hlist_head = type { %struct.hlist_node* }
%struct.user_namespace = type { %struct.uid_gid_map, %struct.uid_gid_map, %struct.uid_gid_map, %struct.atomic_t, %struct.user_namespace*, i32, %struct.kuid_t, %struct.kgid_t, %struct.ns_common, i64, %struct.key*, %struct.rw_semaphore, %struct.work_struct, %struct.ctl_table_set, %struct.ctl_table_header*, %struct.ucounts*, [9 x i32] }
%struct.uid_gid_map = type { i32, %union.anon.76 }
%union.anon.76 = type { %struct.anon.77, [48 x i8] }
%struct.anon.77 = type { %struct.uid_gid_extent*, %struct.uid_gid_extent* }
%struct.uid_gid_extent = type { i32, i32, i32 }
%struct.list_lru = type { %struct.list_lru_node*, %struct.list_head }
%struct.list_lru_node = type { %struct.spinlock, %struct.list_lru_one, %struct.list_lru_memcg*, i64, [16 x i8] }
%struct.list_lru_one = type { %struct.list_head, i64 }
%struct.list_lru_memcg = type { [0 x %struct.list_lru_one*] }
%struct.work_struct = type { %struct.atomic64_t, %struct.list_head, void (%struct.work_struct*)* }
%union.anon.26 = type { %struct.list_head }
%union.anon.27 = type { %struct.hlist_node }
%struct.inode = type { i16, i16, %struct.kuid_t, %struct.kgid_t, i32, %struct.posix_acl*, %struct.posix_acl*, %struct.inode_operations*, %struct.super_block*, %struct.address_space*, i8*, i64, %union.anon.19, i32, i64, %struct.timespec, %struct.timespec, %struct.timespec, %struct.spinlock, i16, i32, i32, i64, i64, %struct.rw_semaphore, i64, i64, %struct.hlist_node, %struct.list_head, %struct.bdi_writeback*, i32, i16, i16, %struct.list_head, %struct.list_head, %struct.list_head, %union.anon.20, i64, %struct.atomic_t, %struct.atomic_t, %struct.atomic_t, %struct.atomic_t, %struct.file_operations*, %struct.file_lock_context*, %struct.address_space, %struct.list_head, %union.anon.23, i32, i32, %struct.fsnotify_mark_connector*, %struct.fscrypt_info*, i8* }
%struct.posix_acl = type opaque
%struct.inode_operations = type { %struct.dentry* (%struct.inode*, %struct.dentry*, i32)*, i8* (%struct.dentry*, %struct.inode*, %struct.delayed_call*)*, i32 (%struct.inode*, i32)*, %struct.posix_acl* (%struct.inode*, i32)*, i32 (%struct.dentry*, i8*, i32)*, i32 (%struct.inode*, %struct.dentry*, i16, i1)*, i32 (%struct.dentry*, %struct.inode*, %struct.dentry*)*, i32 (%struct.inode*, %struct.dentry*)*, i32 (%struct.inode*, %struct.dentry*, i8*)*, i32 (%struct.inode*, %struct.dentry*, i16)*, i32 (%struct.inode*, %struct.dentry*)*, i32 (%struct.inode*, %struct.dentry*, i16, i32)*, i32 (%struct.inode*, %struct.dentry*, %struct.inode*, %struct.dentry*, i32)*, i32 (%struct.dentry*, %struct.iattr*)*, i32 (%struct.path*, %struct.kstat*, i32, i32)*, i64 (%struct.dentry*, i8*, i64)*, i32 (%struct.inode*, %struct.fiemap_extent_info*, i64, i64)*, i32 (%struct.inode*, %struct.timespec*, i32)*, i32 (%struct.inode*, %struct.dentry*, %struct.file*, i32, i16, i32*)*, i32 (%struct.inode*, %struct.dentry*, i16)*, i32 (%struct.inode*, %struct.posix_acl*, i32)*, [24 x i8] }
%struct.delayed_call = type { void (i8*)*, i8* }
%struct.iattr = type { i32, i16, %struct.kuid_t, %struct.kgid_t, i64, %struct.timespec, %struct.timespec, %struct.timespec, %struct.file* }
%struct.kstat = type { i32, i16, i32, i32, i64, i64, i64, i32, i32, %struct.kuid_t, %struct.kgid_t, i64, %struct.timespec, %struct.timespec, %struct.timespec, %struct.timespec, i64 }
%struct.fiemap_extent_info = type { i32, i32, i32, %struct.fiemap_extent* }
%struct.fiemap_extent = type { i64, i64, i64, [2 x i64], i32, [3 x i32] }
%union.anon.19 = type { i32 }
%struct.timespec = type { i64, i64 }
%struct.bdi_writeback = type opaque
%union.anon.20 = type { %struct.callback_head }
%struct.file_lock_context = type { %struct.spinlock, %struct.list_head, %struct.list_head, %struct.list_head }
%struct.address_space = type { %struct.inode*, %struct.radix_tree_root, %struct.spinlock, %struct.atomic_t, %struct.rb_root_cached, %struct.rw_semaphore, i64, i64, i64, %struct.address_space_operations*, i64, %struct.spinlock, i32, %struct.list_head, i8*, i32 }
%struct.address_space_operations = type { i32 (%struct.page*, %struct.writeback_control*)*, i32 (%struct.file*, %struct.page*)*, i32 (%struct.address_space*, %struct.writeback_control*)*, i32 (%struct.page*)*, i32 (%struct.file*, %struct.address_space*, %struct.list_head*, i32)*, i32 (%struct.file*, %struct.address_space*, i64, i32, i32, %struct.page**, i8**)*, i32 (%struct.file*, %struct.address_space*, i64, i32, i32, %struct.page*, i8*)*, i64 (%struct.address_space*, i64)*, void (%struct.page*, i32, i32)*, i32 (%struct.page*, i32)*, void (%struct.page*)*, i64 (%struct.kiocb*, %struct.iov_iter*)*, i32 (%struct.address_space*, %struct.page*, %struct.page*, i32)*, i1 (%struct.page*, i32)*, void (%struct.page*)*, i32 (%struct.page*)*, i32 (%struct.page*, i64, i64)*, void (%struct.page*, i8*, i8*)*, i32 (%struct.address_space*, %struct.page*)*, i32 (%struct.swap_info_struct*, %struct.file*, i64*)*, void (%struct.file*)* }
%struct.kiocb = type { %struct.file*, i64, void (%struct.kiocb*, i64, i64)*, i8*, i32, i32 }
%struct.iov_iter = type { i32, i64, i64, %union.anon.6, %union.anon.7 }
%union.anon.6 = type { %struct.iovec* }
%struct.iovec = type { i8*, i64 }
%union.anon.7 = type { i64 }
%struct.swap_info_struct = type opaque
%union.anon.23 = type { %struct.pipe_inode_info* }
%struct.fsnotify_mark_connector = type opaque
%struct.fscrypt_info = type opaque
%struct.file_operations = type { %struct.module*, i64 (%struct.file*, i64, i32)*, i64 (%struct.file*, i8*, i64, i64*)*, i64 (%struct.file*, i8*, i64, i64*)*, i64 (%struct.kiocb*, %struct.iov_iter*)*, i64 (%struct.kiocb*, %struct.iov_iter*)*, i32 (%struct.file*, %struct.dir_context*)*, i32 (%struct.file*, %struct.dir_context*)*, i32 (%struct.file*, %struct.poll_table_struct*)*, i64 (%struct.file*, i32, i64)*, i64 (%struct.file*, i32, i64)*, i32 (%struct.file*, %struct.vm_area_struct*)*, i64, i32 (%struct.inode*, %struct.file*)*, i32 (%struct.file*, i8*)*, i32 (%struct.inode*, %struct.file*)*, i32 (%struct.file*, i64, i64, i32)*, i32 (i32, %struct.file*, i32)*, i32 (%struct.file*, i32, %struct.file_lock*)*, i64 (%struct.file*, %struct.page*, i32, i64, i64*, i32)*, i64 (%struct.file*, i64, i64, i64, i64)*, i32 (i32)*, i32 (%struct.file*, i64)*, i32 (%struct.file*, i32, %struct.file_lock*)*, i64 (%struct.pipe_inode_info*, %struct.file*, i64*, i64, i32)*, i64 (%struct.file*, i64*, %struct.pipe_inode_info*, i64, i32)*, i32 (%struct.file*, i64, %struct.file_lock**, i8**)*, i64 (%struct.file*, i32, i64, i64)*, void (%struct.seq_file*, %struct.file*)*, i64 (%struct.file*, i64, %struct.file*, i64, i64, i32)*, i32 (%struct.file*, i64, %struct.file*, i64, i64)*, i64 (%struct.file*, i64, i64, %struct.file*, i64)* }
%struct.dir_context = type { i32 (%struct.dir_context*, i8*, i32, i64, i64, i32)*, i64 }
%struct.poll_table_struct = type opaque
%struct.file_lock = type { %struct.file_lock*, %struct.list_head, %struct.hlist_node, %struct.list_head, i8*, i32, i8, i32, i32, %struct.wait_queue_head, %struct.file*, i64, i64, %struct.fasync_struct*, i64, i64, %struct.file_lock_operations*, %struct.lock_manager_operations*, %union.anon.21 }
%struct.file_lock_operations = type { void (%struct.file_lock*, %struct.file_lock*)*, void (%struct.file_lock*)* }
%struct.lock_manager_operations = type { i32 (%struct.file_lock*, %struct.file_lock*)*, i64 (%struct.file_lock*)*, i8* (i8*)*, void (i8*)*, void (%struct.file_lock*)*, i32 (%struct.file_lock*, i32)*, i1 (%struct.file_lock*)*, i32 (%struct.file_lock*, i32, %struct.list_head*)*, void (%struct.file_lock*, i8**)* }
%union.anon.21 = type { %struct.nfs_lock_info }
%struct.nfs_lock_info = type { i32, %struct.nlm_lockowner*, %struct.list_head }
%struct.nlm_lockowner = type opaque
%struct.fown_struct = type { %struct.rwlock_t, %struct.pid*, i32, %struct.kuid_t, %struct.kuid_t, i32 }
%struct.cred = type { %struct.atomic_t, %struct.kuid_t, %struct.kgid_t, %struct.kuid_t, %struct.kgid_t, %struct.kuid_t, %struct.kgid_t, %struct.kuid_t, %struct.kgid_t, i32, %struct.kernel_cap_struct, %struct.kernel_cap_struct, %struct.kernel_cap_struct, %struct.kernel_cap_struct, %struct.kernel_cap_struct, i8, %struct.key*, %struct.key*, %struct.key*, %struct.key*, i8*, %struct.user_struct*, %struct.user_namespace*, %struct.group_info*, %struct.callback_head }
%struct.kernel_cap_struct = type { [2 x i32] }
%struct.group_info = type { %struct.atomic_t, i32, [0 x %struct.kgid_t] }
%struct.file_ra_state = type { i64, i32, i32, i32, i32, i64 }
%struct.seq_file = type { i8*, i64, i64, i64, i64, i64, i64, i64, %struct.mutex, %struct.seq_operations*, i32, %struct.file*, i8* }
%struct.seq_operations = type { i8* (%struct.seq_file*, i64*)*, void (%struct.seq_file*, i8*)*, i8* (%struct.seq_file*, i8*, i64*)*, i32 (%struct.seq_file*, i8*)* }
%struct.mutex = type { %struct.atomic64_t, %struct.spinlock, %struct.optimistic_spin_queue, %struct.list_head }
%struct.vm_operations_struct = type { void (%struct.vm_area_struct*)*, void (%struct.vm_area_struct*)*, i32 (%struct.vm_area_struct*, i64)*, i32 (%struct.vm_area_struct*)*, i32 (%struct.vm_fault*)*, i32 (%struct.vm_fault*, i32)*, void (%struct.vm_fault*, i64, i64)*, i32 (%struct.vm_fault*)*, i32 (%struct.vm_fault*)*, i32 (%struct.vm_area_struct*, i64, i8*, i32, i32)*, i8* (%struct.vm_area_struct*)*, i32 (%struct.vm_area_struct*, %struct.mempolicy*)*, %struct.mempolicy* (%struct.vm_area_struct*, i64)*, %struct.page* (%struct.vm_area_struct*, i64)* }
%struct.vm_fault = type { %struct.vm_area_struct*, i32, i32, i64, i64, %struct.pmd_t*, %struct.pud_t*, %struct.pte_t, %struct.page*, %struct.mem_cgroup*, %struct.page*, %struct.pte_t*, %struct.spinlock*, %struct.page* }
%struct.pmd_t = type { i64 }
%struct.pud_t = type { i64 }
%struct.pte_t = type { i64 }
%struct.kernfs_open_node = type opaque
%union.kernfs_node_id = type { i64 }
%struct.kernfs_iattrs = type opaque
%struct.kref = type { %struct.refcount_struct }
%struct.kset_uevent_ops = type { i32 (%struct.kset*, %struct.kobject*)*, i8* (%struct.kset*, %struct.kobject*)*, i32 (%struct.kset*, %struct.kobject*, %struct.kobj_uevent_env*)* }
%struct.kobj_uevent_env = type { [3 x i8*], [32 x i8*], i32, [2048 x i8], i32 }
%struct.vlan_info = type opaque
%struct.dsa_port = type opaque
%struct.tipc_bearer = type opaque
%struct.in_device = type opaque
%struct.dn_dev = type opaque
%struct.inet6_dev = type opaque
%struct.wireless_dev = type opaque
%struct.wpan_dev = type opaque
%struct.mpls_dev = type opaque
%struct.netdev_rx_queue = type { %struct.rps_map*, %struct.rps_dev_flow_table*, %struct.kobject, %struct.net_device*, [40 x i8] }
%struct.rps_map = type { i32, %struct.callback_head, [0 x i16] }
%struct.rps_dev_flow_table = type { i32, %struct.callback_head, [0 x %struct.rps_dev_flow] }
%struct.rps_dev_flow = type { i16, i16, i32 }
%struct.bpf_prog = type opaque
%struct.nf_hook_entries = type opaque
%struct.cpu_rmap = type opaque
%struct.netdev_queue = type { %struct.net_device*, %struct.Qdisc*, %struct.Qdisc*, %struct.kobject, i32, i64, i64, [16 x i8], %struct.spinlock, i32, i64, i64, [40 x i8], %struct.dql }
%struct.dql = type { i32, i32, i32, [52 x i8], i32, i32, i32, i32, i32, i32, i64, i32, i32, i32, [20 x i8] }
%struct.Qdisc = type opaque
%struct.spinlock = type { %union.anon.2 }
%union.anon.2 = type { %struct.raw_spinlock }
%struct.xps_dev_maps = type { %struct.callback_head, [0 x %struct.xps_map*] }
%struct.xps_map = type { i32, i32, %struct.callback_head, [0 x i16] }
%struct.mini_Qdisc = type opaque
%struct.timer_list = type { %struct.hlist_node, i64, void (%struct.timer_list*)*, i32 }
%struct.netpoll_info = type opaque
%struct.possible_net_t = type { %struct.net* }
%union.anon.88 = type { i8* }
%struct.garp_port = type opaque
%struct.mrp_port = type opaque
%struct.device = type { %struct.device*, %struct.device_private*, %struct.kobject, i8*, %struct.device_type*, %struct.mutex, %struct.bus_type*, %struct.device_driver*, i8*, i8*, %struct.dev_links_info, %struct.dev_pm_info, %struct.dev_pm_domain*, %struct.irq_domain*, %struct.dev_pin_info*, %struct.list_head, i32, %struct.dma_map_ops*, i64*, i64, i64, %struct.device_dma_parameters*, %struct.list_head, %struct.dma_coherent_mem*, %struct.dev_archdata, %struct.device_node*, %struct.fwnode_handle*, i32, i32, %struct.spinlock, %struct.list_head, %struct.klist_node, %struct.class*, %struct.attribute_group**, void (%struct.device*)*, %struct.iommu_group*, %struct.iommu_fwspec*, i8 }
%struct.device_private = type opaque
%struct.device_type = type { i8*, %struct.attribute_group**, i32 (%struct.device*, %struct.kobj_uevent_env*)*, i8* (%struct.device*, i16*, %struct.kuid_t*, %struct.kgid_t*)*, void (%struct.device*)*, %struct.dev_pm_ops* }
%struct.dev_pm_ops = type { i32 (%struct.device*)*, void (%struct.device*)*, i32 (%struct.device*)*, i32 (%struct.device*)*, i32 (%struct.device*)*, i32 (%struct.device*)*, i32 (%struct.device*)*, i32 (%struct.device*)*, i32 (%struct.device*)*, i32 (%struct.device*)*, i32 (%struct.device*)*, i32 (%struct.device*)*, i32 (%struct.device*)*, i32 (%struct.device*)*, i32 (%struct.device*)*, i32 (%struct.device*)*, i32 (%struct.device*)*, i32 (%struct.device*)*, i32 (%struct.device*)*, i32 (%struct.device*)*, i32 (%struct.device*)*, i32 (%struct.device*)*, i32 (%struct.device*)* }
%struct.bus_type = type { i8*, i8*, %struct.device*, %struct.attribute_group**, %struct.attribute_group**, %struct.attribute_group**, i32 (%struct.device*, %struct.device_driver*)*, i32 (%struct.device*, %struct.kobj_uevent_env*)*, i32 (%struct.device*)*, i32 (%struct.device*)*, void (%struct.device*)*, i32 (%struct.device*)*, i32 (%struct.device*)*, i32 (%struct.device*, i32)*, i32 (%struct.device*)*, i32 (%struct.device*)*, %struct.dev_pm_ops*, %struct.iommu_ops*, %struct.subsys_private*, %struct.lock_class_key, i8 }
%struct.iommu_ops = type opaque
%struct.subsys_private = type opaque
%struct.device_driver = type { i8*, %struct.bus_type*, %struct.module*, i8*, i8, i32, %struct.of_device_id*, %struct.acpi_device_id*, i32 (%struct.device*)*, i32 (%struct.device*)*, void (%struct.device*)*, i32 (%struct.device*, i32)*, i32 (%struct.device*)*, %struct.attribute_group**, %struct.dev_pm_ops*, %struct.driver_private* }
%struct.of_device_id = type opaque
%struct.acpi_device_id = type opaque
%struct.driver_private = type opaque
%struct.dev_links_info = type { %struct.list_head, %struct.list_head, i32 }
%struct.dev_pm_info = type { %struct.pm_message, i16, i32, %struct.spinlock, %struct.list_head, %struct.completion, %struct.wakeup_source*, i8, %struct.timer_list, i64, %struct.work_struct, %struct.wait_queue_head, %struct.wake_irq*, %struct.atomic_t, %struct.atomic_t, i16, i32, i32, i32, i32, i32, i64, i64, i64, i64, %struct.pm_subsys_data*, void (%struct.device*, i32)*, %struct.dev_pm_qos* }
%struct.pm_message = type { i32 }
%struct.wakeup_source = type { i8*, %struct.list_head, %struct.spinlock, %struct.wake_irq*, %struct.timer_list, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i8 }
%struct.wake_irq = type opaque
%struct.pm_subsys_data = type { %struct.spinlock, i32, %struct.list_head, %struct.pm_domain_data* }
%struct.pm_domain_data = type opaque
%struct.dev_pm_qos = type opaque
%struct.dev_pm_domain = type { %struct.dev_pm_ops, void (%struct.device*, i1)*, i32 (%struct.device*)*, void (%struct.device*)*, void (%struct.device*)* }
%struct.irq_domain = type opaque
%struct.dev_pin_info = type { %struct.pinctrl*, %struct.pinctrl_state*, %struct.pinctrl_state*, %struct.pinctrl_state*, %struct.pinctrl_state* }
%struct.pinctrl = type opaque
%struct.pinctrl_state = type opaque
%struct.dma_map_ops = type { i8* (%struct.device*, i64, i64*, i32, i64)*, void (%struct.device*, i64, i8*, i64, i64)*, i32 (%struct.device*, %struct.vm_area_struct*, i8*, i64, i64, i64)*, i32 (%struct.device*, %struct.sg_table*, i8*, i64, i64, i64)*, i64 (%struct.device*, %struct.page*, i64, i64, i32, i64)*, void (%struct.device*, i64, i64, i32, i64)*, i32 (%struct.device*, %struct.scatterlist*, i32, i32, i64)*, void (%struct.device*, %struct.scatterlist*, i32, i32, i64)*, i64 (%struct.device*, i64, i64, i32, i64)*, void (%struct.device*, i64, i64, i32, i64)*, void (%struct.device*, i64, i64, i32)*, void (%struct.device*, i64, i64, i32)*, void (%struct.device*, %struct.scatterlist*, i32, i32)*, void (%struct.device*, %struct.scatterlist*, i32, i32)*, void (%struct.device*, i8*, i64, i32)*, i32 (%struct.device*, i64)*, i32 (%struct.device*, i64)*, i32 }
%struct.sg_table = type { %struct.scatterlist*, i32, i32 }
%struct.device_dma_parameters = type { i32, i64 }
%struct.dma_coherent_mem = type opaque
%struct.dev_archdata = type { i8* }
%struct.device_node = type opaque
%struct.fwnode_handle = type { %struct.fwnode_handle*, %struct.fwnode_operations* }
%struct.fwnode_operations = type { %struct.fwnode_handle* (%struct.fwnode_handle*)*, void (%struct.fwnode_handle*)*, i1 (%struct.fwnode_handle*)*, i1 (%struct.fwnode_handle*, i8*)*, i32 (%struct.fwnode_handle*, i8*, i32, i8*, i64)*, i32 (%struct.fwnode_handle*, i8*, i8**, i64)*, %struct.fwnode_handle* (%struct.fwnode_handle*)*, %struct.fwnode_handle* (%struct.fwnode_handle*, %struct.fwnode_handle*)*, %struct.fwnode_handle* (%struct.fwnode_handle*, i8*)*, i32 (%struct.fwnode_handle*, i8*, i8*, i32, i32, %struct.fwnode_reference_args*)*, %struct.fwnode_handle* (%struct.fwnode_handle*, %struct.fwnode_handle*)*, %struct.fwnode_handle* (%struct.fwnode_handle*)*, %struct.fwnode_handle* (%struct.fwnode_handle*)*, i32 (%struct.fwnode_handle*, %struct.fwnode_endpoint*)* }
%struct.fwnode_reference_args = type { %struct.fwnode_handle*, i32, [8 x i32] }
%struct.fwnode_endpoint = type { i32, i32, %struct.fwnode_handle* }
%struct.klist_node = type { i8*, %struct.list_head, %struct.kref }
%struct.class = type { i8*, %struct.module*, %struct.attribute_group**, %struct.attribute_group**, %struct.kobject*, i32 (%struct.device*, %struct.kobj_uevent_env*)*, i8* (%struct.device*, i16*)*, void (%struct.class*)*, void (%struct.device*)*, i32 (%struct.device*)*, %struct.kobj_ns_type_operations*, i8* (%struct.device*)*, %struct.dev_pm_ops*, %struct.subsys_private* }
%struct.iommu_group = type opaque
%struct.iommu_fwspec = type opaque
%struct.attribute_group = type { i8*, i16 (%struct.kobject*, %struct.attribute*, i32)*, i16 (%struct.kobject*, %struct.bin_attribute*, i32)*, %struct.attribute**, %struct.bin_attribute** }
%struct.bin_attribute = type { %struct.attribute, i64, i8*, i64 (%struct.file*, %struct.kobject*, %struct.bin_attribute*, i8*, i64, i64)*, i64 (%struct.file*, %struct.kobject*, %struct.bin_attribute*, i8*, i64, i64)*, i32 (%struct.file*, %struct.kobject*, %struct.bin_attribute*, %struct.vm_area_struct*)* }
%struct.rtnl_link_ops = type opaque
%struct.dcbnl_rtnl_ops = type { i32 (%struct.net_device*, %struct.ieee_ets*)*, i32 (%struct.net_device*, %struct.ieee_ets*)*, i32 (%struct.net_device*, %struct.ieee_maxrate*)*, i32 (%struct.net_device*, %struct.ieee_maxrate*)*, i32 (%struct.net_device*, %struct.ieee_qcn*)*, i32 (%struct.net_device*, %struct.ieee_qcn*)*, i32 (%struct.net_device*, %struct.ieee_qcn_stats*)*, i32 (%struct.net_device*, %struct.ieee_pfc*)*, i32 (%struct.net_device*, %struct.ieee_pfc*)*, i32 (%struct.net_device*, %struct.dcb_app*)*, i32 (%struct.net_device*, %struct.dcb_app*)*, i32 (%struct.net_device*, %struct.dcb_app*)*, i32 (%struct.net_device*, %struct.ieee_ets*)*, i32 (%struct.net_device*, %struct.ieee_pfc*)*, i8 (%struct.net_device*)*, i8 (%struct.net_device*, i8)*, void (%struct.net_device*, i8*)*, void (%struct.net_device*, i32, i8, i8, i8, i8)*, void (%struct.net_device*, i32, i8)*, void (%struct.net_device*, i32, i8, i8, i8, i8)*, void (%struct.net_device*, i32, i8)*, void (%struct.net_device*, i32, i8*, i8*, i8*, i8*)*, void (%struct.net_device*, i32, i8*)*, void (%struct.net_device*, i32, i8*, i8*, i8*, i8*)*, void (%struct.net_device*, i32, i8*)*, void (%struct.net_device*, i32, i8)*, void (%struct.net_device*, i32, i8*)*, i8 (%struct.net_device*)*, i8 (%struct.net_device*, i32, i8*)*, i32 (%struct.net_device*, i32, i8*)*, i32 (%struct.net_device*, i32, i8)*, i8 (%struct.net_device*)*, void (%struct.net_device*, i8)*, void (%struct.net_device*, i32, i32*)*, void (%struct.net_device*, i32, i32)*, void (%struct.net_device*, i32, i8*)*, void (%struct.net_device*, i32, i8)*, i32 (%struct.net_device*, i8, i16, i8)*, i32 (%struct.net_device*, i8, i16)*, i8 (%struct.net_device*, i32, i8*)*, i8 (%struct.net_device*, i32, i8)*, i8 (%struct.net_device*)*, i8 (%struct.net_device*, i8)*, i32 (%struct.net_device*, %struct.dcb_peer_app_info*, i16*)*, i32 (%struct.net_device*, %struct.dcb_app*)*, i32 (%struct.net_device*, %struct.cee_pg*)*, i32 (%struct.net_device*, %struct.cee_pfc*)* }
%struct.ieee_maxrate = type { [8 x i64] }
%struct.ieee_qcn = type { [8 x i8], [8 x i32], [8 x i32], [8 x i32], [8 x i32], [8 x i32], [8 x i32], [8 x i32], [8 x i32], [8 x i32], [8 x i32], [8 x i32] }
%struct.ieee_qcn_stats = type { [8 x i64], [8 x i32] }
%struct.ieee_ets = type { i8, i8, i8, [8 x i8], [8 x i8], [8 x i8], [8 x i8], [8 x i8], [8 x i8], [8 x i8] }
%struct.ieee_pfc = type { i8, i8, i8, i16, [8 x i64], [8 x i64] }
%struct.dcb_peer_app_info = type { i8, i8 }
%struct.dcb_app = type { i8, i8, i16 }
%struct.cee_pg = type { i8, i8, i8, i8, [8 x i8], [8 x i8] }
%struct.cee_pfc = type { i8, i8, i8, i8 }
%struct.netdev_tc_txq = type { i16, i16 }
%struct.netprio_map = type { %struct.callback_head, i32, [0 x i32] }
%struct.phy_device = type opaque
%struct.sk_buff = type { %union.anon.62, %struct.sock*, %union.anon.65, [48 x i8], %union.anon.66, %struct.sec_path*, i64, %struct.nf_bridge_info*, i32, i32, i16, i16, i16, [0 x i8], i8, [0 x i32], [0 x i8], [5 x i8], i16, %union.anon.70, i32, i32, i32, i16, i16, %union.anon.72, i32, %union.anon.73, %union.anon.74, i16, i16, i16, i16, i16, i16, i16, [0 x i32], i32, i32, i8*, i8*, i32, %struct.refcount_struct }
%union.anon.62 = type { %struct.anon.63 }
%struct.anon.63 = type { %struct.sk_buff*, %struct.sk_buff*, %union.anon.64 }
%union.anon.64 = type { %struct.net_device* }
%union.anon.65 = type { i64 }
%union.anon.66 = type { %struct.anon.67 }
%struct.anon.67 = type { i64, {}* }
%struct.sec_path = type opaque
%struct.nf_bridge_info = type { %struct.refcount_struct, i16, i16, %struct.net_device*, %struct.net_device*, %union.anon.68 }
%union.anon.68 = type { %struct.in6_addr }
%struct.in6_addr = type { %union.anon.69 }
%union.anon.69 = type { [4 x i32] }
%union.anon.70 = type { i32 }
%union.anon.72 = type { i32 }
%union.anon.73 = type { i32 }
%union.anon.74 = type { i16 }
%struct.hrtimer = type { %struct.timerqueue_node, i64, i32 (%struct.hrtimer*)*, %struct.hrtimer_clock_base*, i8, i8 }
%struct.timerqueue_node = type { %struct.rb_node, i64 }
%struct.hrtimer_clock_base = type { %struct.hrtimer_cpu_base*, i32, i32, %struct.timerqueue_head, i64 ()*, i64, [16 x i8] }
%struct.hrtimer_cpu_base = type { %struct.raw_spinlock, %struct.seqcount, %struct.hrtimer*, i32, i32, i32, i8, i8, i8, i64, %struct.hrtimer*, i32, i32, i32, i32, [4 x %struct.hrtimer_clock_base] }
%struct.timerqueue_head = type { %struct.rb_root, %struct.timerqueue_node* }
%struct.list_head = type { %struct.list_head*, %struct.list_head* }
%struct.hlist_node = type { %struct.hlist_node*, %struct.hlist_node** }
%struct.bulk_event_type = type { i64, i64, i64 }
%struct.irq_ctx = type { i16, i8, i8, i32, i32 }
%struct.softirq_cnt = type { i64, i64, i64 }

@napi_hist_map = global %struct.bpf_map_def { i32 6, i32 4, i32 592, i32 1, i32 0, i32 0, i32 0 }, section "maps", align 4
@softirq_map = global %struct.bpf_map_def { i32 6, i32 4, i32 240, i32 1, i32 0, i32 0, i32 0 }, section "maps", align 4
@cnt_map = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 1, i32 0, i32 0, i32 0 }, section "maps", align 4
@_license = global [4 x i8] c"GPL\00", section "license", align 1
@llvm.used = appending global [8 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @cnt_map to i8*), i8* bitcast (%struct.bpf_map_def* @napi_hist_map to i8*), i8* bitcast (i32 (%struct.napi_poll_ctx*)* @napi_poll to i8*), i8* bitcast (i32 (%struct.irq_ctx*)* @softirq_entry to i8*), i8* bitcast (i32 (%struct.irq_ctx*)* @softirq_exit to i8*), i8* bitcast (%struct.bpf_map_def* @softirq_map to i8*), i8* bitcast (i32 (%struct.irq_ctx*)* @softirq_raise to i8*)], section "llvm.metadata"

; Function Attrs: nounwind uwtable
define i32 @napi_poll(%struct.napi_poll_ctx* nocapture readonly) #0 section "tracepoint/napi/napi_poll" {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = getelementptr inbounds %struct.napi_poll_ctx, %struct.napi_poll_ctx* %0, i64 0, i32 7
  %5 = load i32, i32* %4, align 8, !tbaa !3
  %6 = getelementptr inbounds %struct.napi_poll_ctx, %struct.napi_poll_ctx* %0, i64 0, i32 6
  %7 = load i32, i32* %6, align 4, !tbaa !10
  %8 = getelementptr inbounds %struct.napi_poll_ctx, %struct.napi_poll_ctx* %0, i64 0, i32 4
  %9 = load %struct.napi_struct*, %struct.napi_struct** %8, align 8, !tbaa !11
  %10 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %10) #2
  store i32 0, i32* %2, align 4, !tbaa !12
  %11 = bitcast i32* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %11) #2
  store i32 0, i32* %3, align 4, !tbaa !12
  %12 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @napi_hist_map to i8*), i8* nonnull %10) #2
  %13 = icmp eq i8* %12, null
  br i1 %13, label %50, label %14

; <label>:14:                                     ; preds = %1
  %15 = icmp eq %struct.napi_struct* %9, null
  br i1 %15, label %20, label %16

; <label>:16:                                     ; preds = %14
  %17 = getelementptr inbounds %struct.napi_struct, %struct.napi_struct* %9, i64 0, i32 12
  %18 = bitcast i32* %17 to i8*
  %19 = call i32 inttoptr (i64 4 to i32 (i8*, i32, i8*)*)(i8* nonnull %11, i32 4, i8* nonnull %18) #2
  br label %20

; <label>:20:                                     ; preds = %14, %16
  %21 = icmp ugt i32 %7, %5
  br i1 %21, label %34, label %22

; <label>:22:                                     ; preds = %20
  %23 = icmp ult i32 %7, 65
  br i1 %23, label %24, label %30

; <label>:24:                                     ; preds = %22
  %25 = bitcast i8* %12 to [65 x i64]*
  %26 = zext i32 %7 to i64
  %27 = getelementptr inbounds [65 x i64], [65 x i64]* %25, i64 0, i64 %26
  %28 = load i64, i64* %27, align 8, !tbaa !13
  %29 = add i64 %28, 1
  store i64 %29, i64* %27, align 8, !tbaa !13
  br label %30

; <label>:30:                                     ; preds = %24, %22
  %31 = call i64 inttoptr (i64 14 to i64 ()*)() #2
  %32 = icmp ne i64 %31, 0
  %33 = zext i1 %32 to i64
  br label %34

; <label>:34:                                     ; preds = %30, %20
  %35 = phi i64 [ 2, %20 ], [ %33, %30 ]
  %36 = getelementptr inbounds i8, i8* %12, i64 520
  %37 = bitcast i8* %36 to [3 x %struct.bulk_event_type]*
  %38 = getelementptr inbounds [3 x %struct.bulk_event_type], [3 x %struct.bulk_event_type]* %37, i64 0, i64 %35, i32 0
  %39 = load i64, i64* %38, align 8, !tbaa !15
  %40 = add i64 %39, 1
  store i64 %40, i64* %38, align 8, !tbaa !15
  %41 = zext i32 %7 to i64
  %42 = getelementptr inbounds [3 x %struct.bulk_event_type], [3 x %struct.bulk_event_type]* %37, i64 0, i64 %35, i32 2
  %43 = load i64, i64* %42, align 8, !tbaa !17
  %44 = add i64 %43, %41
  store i64 %44, i64* %42, align 8, !tbaa !17
  %45 = icmp eq i32 %7, 0
  br i1 %45, label %46, label %50

; <label>:46:                                     ; preds = %34
  %47 = getelementptr inbounds [3 x %struct.bulk_event_type], [3 x %struct.bulk_event_type]* %37, i64 0, i64 %35, i32 1
  %48 = load i64, i64* %47, align 8, !tbaa !18
  %49 = add i64 %48, 1
  store i64 %49, i64* %47, align 8, !tbaa !18
  br label %50

; <label>:50:                                     ; preds = %46, %34, %1
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %11) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %10) #2
  ret i32 0
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1

; Function Attrs: nounwind uwtable
define i32 @softirq_entry(%struct.irq_ctx* nocapture readonly) #0 section "tracepoint/irq/softirq_entry" {
  %2 = alloca i32, align 4
  %3 = getelementptr inbounds %struct.irq_ctx, %struct.irq_ctx* %0, i64 0, i32 4
  %4 = load i32, i32* %3, align 4, !tbaa !19
  %5 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %5) #2
  store i32 0, i32* %2, align 4, !tbaa !12
  %6 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @softirq_map to i8*), i8* nonnull %5) #2
  %7 = icmp ne i8* %6, null
  %8 = icmp ult i32 %4, 10
  %9 = and i1 %8, %7
  br i1 %9, label %10, label %16

; <label>:10:                                     ; preds = %1
  %11 = bitcast i8* %6 to [10 x %struct.softirq_cnt]*
  %12 = zext i32 %4 to i64
  %13 = getelementptr inbounds [10 x %struct.softirq_cnt], [10 x %struct.softirq_cnt]* %11, i64 0, i64 %12, i32 0
  %14 = load i64, i64* %13, align 8, !tbaa !21
  %15 = add i64 %14, 1
  store i64 %15, i64* %13, align 8, !tbaa !21
  br label %16

; <label>:16:                                     ; preds = %1, %10
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %5) #2
  ret i32 0
}

; Function Attrs: nounwind uwtable
define i32 @softirq_exit(%struct.irq_ctx* nocapture readonly) #0 section "tracepoint/irq/softirq_exit" {
  %2 = alloca i32, align 4
  %3 = getelementptr inbounds %struct.irq_ctx, %struct.irq_ctx* %0, i64 0, i32 4
  %4 = load i32, i32* %3, align 4, !tbaa !19
  %5 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %5) #2
  store i32 0, i32* %2, align 4, !tbaa !12
  %6 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @softirq_map to i8*), i8* nonnull %5) #2
  %7 = icmp ne i8* %6, null
  %8 = icmp ult i32 %4, 10
  %9 = and i1 %8, %7
  br i1 %9, label %10, label %16

; <label>:10:                                     ; preds = %1
  %11 = bitcast i8* %6 to [10 x %struct.softirq_cnt]*
  %12 = zext i32 %4 to i64
  %13 = getelementptr inbounds [10 x %struct.softirq_cnt], [10 x %struct.softirq_cnt]* %11, i64 0, i64 %12, i32 1
  %14 = load i64, i64* %13, align 8, !tbaa !23
  %15 = add i64 %14, 1
  store i64 %15, i64* %13, align 8, !tbaa !23
  br label %16

; <label>:16:                                     ; preds = %1, %10
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %5) #2
  ret i32 0
}

; Function Attrs: nounwind uwtable
define i32 @softirq_raise(%struct.irq_ctx* nocapture readonly) #0 section "tracepoint/irq/softirq_raise" {
  %2 = alloca i32, align 4
  %3 = getelementptr inbounds %struct.irq_ctx, %struct.irq_ctx* %0, i64 0, i32 4
  %4 = load i32, i32* %3, align 4, !tbaa !19
  %5 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %5) #2
  store i32 0, i32* %2, align 4, !tbaa !12
  %6 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @softirq_map to i8*), i8* nonnull %5) #2
  %7 = icmp ne i8* %6, null
  %8 = icmp ult i32 %4, 10
  %9 = and i1 %8, %7
  br i1 %9, label %10, label %16

; <label>:10:                                     ; preds = %1
  %11 = bitcast i8* %6 to [10 x %struct.softirq_cnt]*
  %12 = zext i32 %4 to i64
  %13 = getelementptr inbounds [10 x %struct.softirq_cnt], [10 x %struct.softirq_cnt]* %11, i64 0, i64 %12, i32 2
  %14 = load i64, i64* %13, align 8, !tbaa !24
  %15 = add i64 %14, 1
  store i64 %15, i64* %13, align 8, !tbaa !24
  br label %16

; <label>:16:                                     ; preds = %1, %10
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %5) #2
  ret i32 0
}

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { nounwind }

!llvm.named.register.rsp = !{!0}
!llvm.module.flags = !{!1}
!llvm.ident = !{!2}

!0 = !{!"rsp"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
!3 = !{!4, !8, i64 24}
!4 = !{!"napi_poll_ctx", !5, i64 0, !6, i64 2, !6, i64 3, !8, i64 4, !9, i64 8, !8, i64 16, !8, i64 20, !8, i64 24}
!5 = !{!"short", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
!8 = !{!"int", !6, i64 0}
!9 = !{!"any pointer", !6, i64 0}
!10 = !{!4, !8, i64 20}
!11 = !{!4, !9, i64 8}
!12 = !{!8, !8, i64 0}
!13 = !{!14, !14, i64 0}
!14 = !{!"long", !6, i64 0}
!15 = !{!16, !14, i64 0}
!16 = !{!"bulk_event_type", !14, i64 0, !14, i64 8, !14, i64 16}
!17 = !{!16, !14, i64 16}
!18 = !{!16, !14, i64 8}
!19 = !{!20, !8, i64 8}
!20 = !{!"irq_ctx", !5, i64 0, !6, i64 2, !6, i64 3, !8, i64 4, !8, i64 8}
!21 = !{!22, !14, i64 0}
!22 = !{!"softirq_cnt", !14, i64 0, !14, i64 8, !14, i64 16}
!23 = !{!22, !14, i64 8}
!24 = !{!22, !14, i64 16}
