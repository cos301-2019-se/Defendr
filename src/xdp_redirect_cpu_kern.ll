; ModuleID = 'xdp_redirect_cpu_kern.c'
source_filename = "xdp_redirect_cpu_kern.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.iphdr = type { i8, i8, i16, i16, i16, i8, i8, i16, i32, i32 }
%struct.ipv6hdr = type { i8, [3 x i8], i16, i8, i8, %struct.in6_addr, %struct.in6_addr }
%struct.in6_addr = type { %union.anon }
%union.anon = type { [4 x i32] }
%struct.udphdr = type { i16, i16, i16, i16 }
%struct.xdp_redirect_ctx = type { i64, i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_exception_ctx = type { i64, i32, i32, i32 }
%struct.cpumap_enqueue_ctx = type { i64, i32, i32, i32, i32, i32, i32 }
%struct.cpumap_kthread_ctx = type { i64, i32, i32, i32, i32, i32, i32 }

@cpu_map = global %struct.bpf_map_def { i32 16, i32 4, i32 4, i32 12, i32 0, i32 0, i32 0 }, section "maps", align 4
@rx_cnt = global %struct.bpf_map_def { i32 6, i32 4, i32 24, i32 1, i32 0, i32 0, i32 0 }, section "maps", align 4
@redirect_err_cnt = global %struct.bpf_map_def { i32 6, i32 4, i32 24, i32 2, i32 0, i32 0, i32 0 }, section "maps", align 4
@cpumap_enqueue_cnt = global %struct.bpf_map_def { i32 6, i32 4, i32 24, i32 12, i32 0, i32 0, i32 0 }, section "maps", align 4
@cpumap_kthread_cnt = global %struct.bpf_map_def { i32 6, i32 4, i32 24, i32 1, i32 0, i32 0, i32 0 }, section "maps", align 4
@cpus_available = global %struct.bpf_map_def { i32 2, i32 4, i32 4, i32 12, i32 0, i32 0, i32 0 }, section "maps", align 4
@cpus_count = global %struct.bpf_map_def { i32 2, i32 4, i32 4, i32 1, i32 0, i32 0, i32 0 }, section "maps", align 4
@cpus_iterator = global %struct.bpf_map_def { i32 6, i32 4, i32 4, i32 1, i32 0, i32 0, i32 0 }, section "maps", align 4
@exception_cnt = global %struct.bpf_map_def { i32 6, i32 4, i32 24, i32 1, i32 0, i32 0, i32 0 }, section "maps", align 4
@_license = global [4 x i8] c"GPL\00", section "license", align 1
@llvm.used = appending global [21 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @cpu_map to i8*), i8* bitcast (%struct.bpf_map_def* @cpumap_enqueue_cnt to i8*), i8* bitcast (%struct.bpf_map_def* @cpumap_kthread_cnt to i8*), i8* bitcast (%struct.bpf_map_def* @cpus_available to i8*), i8* bitcast (%struct.bpf_map_def* @cpus_count to i8*), i8* bitcast (%struct.bpf_map_def* @cpus_iterator to i8*), i8* bitcast (%struct.bpf_map_def* @exception_cnt to i8*), i8* bitcast (%struct.bpf_map_def* @redirect_err_cnt to i8*), i8* bitcast (%struct.bpf_map_def* @rx_cnt to i8*), i8* bitcast (i32 (%struct.cpumap_enqueue_ctx*)* @trace_xdp_cpumap_enqueue to i8*), i8* bitcast (i32 (%struct.cpumap_kthread_ctx*)* @trace_xdp_cpumap_kthread to i8*), i8* bitcast (i32 (%struct.xdp_exception_ctx*)* @trace_xdp_exception to i8*), i8* bitcast (i32 (%struct.xdp_redirect_ctx*)* @trace_xdp_redirect_err to i8*), i8* bitcast (i32 (%struct.xdp_redirect_ctx*)* @trace_xdp_redirect_map_err to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_prognum0_no_touch to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_prognum1_touch_data to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_prognum2_round_robin to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_prognum3_proto_separate to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_prognum4_ddos_filter_pktgen to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_prognum5_ip_l3_flow_hash to i8*)], section "llvm.metadata"

; Function Attrs: nounwind uwtable
define i32 @xdp_prognum0_no_touch(%struct.xdp_md* nocapture readnone) #0 section "xdp_cpu_map0" {
  %2 = alloca i32, align 4
  %3 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #3
  store i32 0, i32* %2, align 4, !tbaa !2
  %4 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @cpus_available to i8*), i8* nonnull %3) #3
  %5 = icmp eq i8* %4, null
  br i1 %5, label %23, label %6

; <label>:6:                                      ; preds = %1
  %7 = bitcast i8* %4 to i32*
  %8 = load i32, i32* %7, align 4, !tbaa !2
  %9 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @rx_cnt to i8*), i8* nonnull %3) #3
  %10 = icmp eq i8* %9, null
  br i1 %10, label %23, label %11

; <label>:11:                                     ; preds = %6
  %12 = bitcast i8* %9 to i64*
  %13 = load i64, i64* %12, align 8, !tbaa !6
  %14 = add i64 %13, 1
  store i64 %14, i64* %12, align 8, !tbaa !6
  %15 = icmp ugt i32 %8, 11
  br i1 %15, label %16, label %21

; <label>:16:                                     ; preds = %11
  %17 = getelementptr inbounds i8, i8* %9, i64 16
  %18 = bitcast i8* %17 to i64*
  %19 = load i64, i64* %18, align 8, !tbaa !9
  %20 = add i64 %19, 1
  store i64 %20, i64* %18, align 8, !tbaa !9
  br label %23

; <label>:21:                                     ; preds = %11
  %22 = call i32 inttoptr (i64 51 to i32 (i8*, i32, i32)*)(i8* bitcast (%struct.bpf_map_def* @cpu_map to i8*), i32 %8, i32 0) #3
  br label %23

; <label>:23:                                     ; preds = %6, %1, %21, %16
  %24 = phi i32 [ 0, %16 ], [ %22, %21 ], [ 0, %1 ], [ 0, %6 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #3
  ret i32 %24
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1

; Function Attrs: nounwind uwtable
define i32 @xdp_prognum1_touch_data(%struct.xdp_md* nocapture readonly) #0 section "xdp_cpu_map1_touch_data" {
  %2 = alloca i32, align 4
  %3 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %4 = load i32, i32* %3, align 4, !tbaa !10
  %5 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0
  %6 = load i32, i32* %5, align 4, !tbaa !12
  %7 = zext i32 %6 to i64
  %8 = inttoptr i64 %7 to %struct.ethhdr*
  %9 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %9) #3
  store i32 0, i32* %2, align 4, !tbaa !2
  %10 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @cpus_available to i8*), i8* nonnull %9) #3
  %11 = icmp eq i8* %10, null
  br i1 %11, label %44, label %12

; <label>:12:                                     ; preds = %1
  %13 = bitcast i8* %10 to i32*
  %14 = zext i32 %4 to i64
  %15 = load i32, i32* %13, align 4, !tbaa !2
  %16 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %8, i64 1
  %17 = inttoptr i64 %14 to %struct.ethhdr*
  %18 = icmp ugt %struct.ethhdr* %16, %17
  br i1 %18, label %44, label %19

; <label>:19:                                     ; preds = %12
  %20 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @rx_cnt to i8*), i8* nonnull %9) #3
  %21 = icmp eq i8* %20, null
  br i1 %21, label %44, label %22

; <label>:22:                                     ; preds = %19
  %23 = bitcast i8* %20 to i64*
  %24 = load i64, i64* %23, align 8, !tbaa !6
  %25 = add i64 %24, 1
  store i64 %25, i64* %23, align 8, !tbaa !6
  %26 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %8, i64 0, i32 2
  %27 = load i16, i16* %26, align 1, !tbaa !13
  %28 = trunc i16 %27 to i8
  %29 = icmp ult i8 %28, 6
  br i1 %29, label %30, label %35

; <label>:30:                                     ; preds = %22
  %31 = getelementptr inbounds i8, i8* %20, i64 8
  %32 = bitcast i8* %31 to i64*
  %33 = load i64, i64* %32, align 8, !tbaa !16
  %34 = add i64 %33, 1
  store i64 %34, i64* %32, align 8, !tbaa !16
  br label %44

; <label>:35:                                     ; preds = %22
  %36 = icmp ugt i32 %15, 11
  br i1 %36, label %37, label %42

; <label>:37:                                     ; preds = %35
  %38 = getelementptr inbounds i8, i8* %20, i64 16
  %39 = bitcast i8* %38 to i64*
  %40 = load i64, i64* %39, align 8, !tbaa !9
  %41 = add i64 %40, 1
  store i64 %41, i64* %39, align 8, !tbaa !9
  br label %44

; <label>:42:                                     ; preds = %35
  %43 = call i32 inttoptr (i64 51 to i32 (i8*, i32, i32)*)(i8* bitcast (%struct.bpf_map_def* @cpu_map to i8*), i32 %15, i32 0) #3
  br label %44

; <label>:44:                                     ; preds = %19, %12, %1, %42, %37, %30
  %45 = phi i32 [ 1, %30 ], [ 0, %37 ], [ %43, %42 ], [ 0, %1 ], [ 0, %12 ], [ 0, %19 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %9) #3
  ret i32 %45
}

; Function Attrs: nounwind uwtable
define i32 @xdp_prognum2_round_robin(%struct.xdp_md* nocapture readnone) #0 section "xdp_cpu_map2_round_robin" {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %4) #3
  store i32 0, i32* %2, align 4, !tbaa !2
  %5 = bitcast i32* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %5) #3
  %6 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @cpus_count to i8*), i8* nonnull %4) #3
  %7 = bitcast i8* %6 to i32*
  %8 = icmp eq i8* %6, null
  br i1 %8, label %39, label %9

; <label>:9:                                      ; preds = %1
  %10 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @cpus_iterator to i8*), i8* nonnull %4) #3
  %11 = bitcast i8* %10 to i32*
  %12 = icmp eq i8* %10, null
  br i1 %12, label %39, label %13

; <label>:13:                                     ; preds = %9
  %14 = load i32, i32* %11, align 4, !tbaa !2
  store i32 %14, i32* %3, align 4, !tbaa !2
  %15 = load i32, i32* %11, align 4, !tbaa !2
  %16 = add i32 %15, 1
  store i32 %16, i32* %11, align 4, !tbaa !2
  %17 = load i32, i32* %7, align 4, !tbaa !2
  %18 = icmp eq i32 %16, %17
  %19 = select i1 %18, i32 0, i32 %16
  store i32 %19, i32* %11, align 4
  %20 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @cpus_available to i8*), i8* nonnull %5) #3
  %21 = icmp eq i8* %20, null
  br i1 %21, label %39, label %22

; <label>:22:                                     ; preds = %13
  %23 = bitcast i8* %20 to i32*
  %24 = load i32, i32* %23, align 4, !tbaa !2
  %25 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @rx_cnt to i8*), i8* nonnull %4) #3
  %26 = icmp eq i8* %25, null
  br i1 %26, label %39, label %27

; <label>:27:                                     ; preds = %22
  %28 = bitcast i8* %25 to i64*
  %29 = load i64, i64* %28, align 8, !tbaa !6
  %30 = add i64 %29, 1
  store i64 %30, i64* %28, align 8, !tbaa !6
  %31 = icmp ugt i32 %24, 11
  br i1 %31, label %32, label %37

; <label>:32:                                     ; preds = %27
  %33 = getelementptr inbounds i8, i8* %25, i64 16
  %34 = bitcast i8* %33 to i64*
  %35 = load i64, i64* %34, align 8, !tbaa !9
  %36 = add i64 %35, 1
  store i64 %36, i64* %34, align 8, !tbaa !9
  br label %39

; <label>:37:                                     ; preds = %27
  %38 = call i32 inttoptr (i64 51 to i32 (i8*, i32, i32)*)(i8* bitcast (%struct.bpf_map_def* @cpu_map to i8*), i32 %24, i32 0) #3
  br label %39

; <label>:39:                                     ; preds = %22, %13, %9, %1, %37, %32
  %40 = phi i32 [ 0, %32 ], [ %38, %37 ], [ 0, %1 ], [ 0, %9 ], [ 0, %13 ], [ 0, %22 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %5) #3
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %4) #3
  ret i32 %40
}

; Function Attrs: nounwind uwtable
define i32 @xdp_prognum3_proto_separate(%struct.xdp_md* nocapture readonly) #0 section "xdp_cpu_map3_proto_separate" {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %5 = load i32, i32* %4, align 4, !tbaa !10
  %6 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0
  %7 = load i32, i32* %6, align 4, !tbaa !12
  %8 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %8) #3
  store i32 0, i32* %2, align 4, !tbaa !2
  %9 = bitcast i32* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %9) #3
  store i32 0, i32* %3, align 4, !tbaa !2
  %10 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @rx_cnt to i8*), i8* nonnull %9) #3
  %11 = icmp eq i8* %10, null
  br i1 %11, label %88, label %12

; <label>:12:                                     ; preds = %1
  %13 = zext i32 %7 to i64
  %14 = inttoptr i64 %13 to %struct.ethhdr*
  %15 = zext i32 %5 to i64
  %16 = inttoptr i64 %15 to i8*
  %17 = bitcast i8* %10 to i64*
  %18 = load i64, i64* %17, align 8, !tbaa !6
  %19 = add i64 %18, 1
  store i64 %19, i64* %17, align 8, !tbaa !6
  %20 = getelementptr %struct.ethhdr, %struct.ethhdr* %14, i64 0, i32 0, i64 14
  %21 = icmp ugt i8* %20, %16
  br i1 %21, label %88, label %22

; <label>:22:                                     ; preds = %12
  %23 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %14, i64 0, i32 2
  %24 = load i16, i16* %23, align 1, !tbaa !13
  %25 = trunc i16 %24 to i8
  %26 = icmp ult i8 %25, 6
  br i1 %26, label %88, label %27, !prof !17

; <label>:27:                                     ; preds = %22
  switch i16 %24, label %35 [
    i16 129, label %28
    i16 -22392, label %28
  ]

; <label>:28:                                     ; preds = %27, %27
  %29 = getelementptr %struct.ethhdr, %struct.ethhdr* %14, i64 0, i32 0, i64 18
  %30 = icmp ugt i8* %29, %16
  br i1 %30, label %88, label %31

; <label>:31:                                     ; preds = %28
  %32 = getelementptr %struct.ethhdr, %struct.ethhdr* %14, i64 0, i32 0, i64 16
  %33 = bitcast i8* %32 to i16*
  %34 = load i16, i16* %33, align 2, !tbaa !18
  br label %35

; <label>:35:                                     ; preds = %31, %27
  %36 = phi i16 [ %24, %27 ], [ %34, %31 ]
  %37 = phi i64 [ 14, %27 ], [ 18, %31 ]
  %38 = call i16 @llvm.bswap.i16(i16 %36) #3
  switch i16 %38, label %66 [
    i16 2048, label %39
    i16 -31011, label %52
    i16 2054, label %65
  ]

; <label>:39:                                     ; preds = %35
  %40 = load i32, i32* %4, align 4, !tbaa !10
  %41 = zext i32 %40 to i64
  %42 = load i32, i32* %6, align 4, !tbaa !12
  %43 = zext i32 %42 to i64
  %44 = inttoptr i64 %43 to i8*
  %45 = getelementptr i8, i8* %44, i64 %37
  %46 = getelementptr inbounds i8, i8* %45, i64 20
  %47 = bitcast i8* %46 to %struct.iphdr*
  %48 = inttoptr i64 %41 to %struct.iphdr*
  %49 = icmp ugt %struct.iphdr* %47, %48
  br i1 %49, label %73, label %50

; <label>:50:                                     ; preds = %39
  %51 = getelementptr inbounds i8, i8* %45, i64 9
  br label %67

; <label>:52:                                     ; preds = %35
  %53 = load i32, i32* %4, align 4, !tbaa !10
  %54 = zext i32 %53 to i64
  %55 = load i32, i32* %6, align 4, !tbaa !12
  %56 = zext i32 %55 to i64
  %57 = inttoptr i64 %56 to i8*
  %58 = getelementptr i8, i8* %57, i64 %37
  %59 = getelementptr inbounds i8, i8* %58, i64 40
  %60 = bitcast i8* %59 to %struct.ipv6hdr*
  %61 = inttoptr i64 %54 to %struct.ipv6hdr*
  %62 = icmp ugt %struct.ipv6hdr* %60, %61
  br i1 %62, label %73, label %63

; <label>:63:                                     ; preds = %52
  %64 = getelementptr inbounds i8, i8* %58, i64 6
  br label %67

; <label>:65:                                     ; preds = %35
  store i32 0, i32* %2, align 4, !tbaa !2
  br label %72

; <label>:66:                                     ; preds = %35
  store i32 0, i32* %2, align 4, !tbaa !2
  br label %72

; <label>:67:                                     ; preds = %63, %50
  %68 = phi i8* [ %51, %50 ], [ %64, %63 ]
  %69 = load i8, i8* %68, align 1, !tbaa !20
  switch i8 %69, label %73 [
    i8 1, label %70
    i8 58, label %70
    i8 6, label %71
    i8 17, label %72
  ]

; <label>:70:                                     ; preds = %67, %67
  store i32 2, i32* %2, align 4, !tbaa !2
  br label %74

; <label>:71:                                     ; preds = %67
  store i32 0, i32* %2, align 4, !tbaa !2
  br label %74

; <label>:72:                                     ; preds = %65, %66, %67
  store i32 1, i32* %2, align 4, !tbaa !2
  br label %74

; <label>:73:                                     ; preds = %52, %39, %67
  store i32 0, i32* %2, align 4, !tbaa !2
  br label %74

; <label>:74:                                     ; preds = %73, %72, %71, %70
  %75 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @cpus_available to i8*), i8* nonnull %8) #3
  %76 = icmp eq i8* %75, null
  br i1 %76, label %88, label %77

; <label>:77:                                     ; preds = %74
  %78 = bitcast i8* %75 to i32*
  %79 = load i32, i32* %78, align 4, !tbaa !2
  %80 = icmp ugt i32 %79, 11
  br i1 %80, label %81, label %86

; <label>:81:                                     ; preds = %77
  %82 = getelementptr inbounds i8, i8* %10, i64 16
  %83 = bitcast i8* %82 to i64*
  %84 = load i64, i64* %83, align 8, !tbaa !9
  %85 = add i64 %84, 1
  store i64 %85, i64* %83, align 8, !tbaa !9
  br label %88

; <label>:86:                                     ; preds = %77
  %87 = call i32 inttoptr (i64 51 to i32 (i8*, i32, i32)*)(i8* bitcast (%struct.bpf_map_def* @cpu_map to i8*), i32 %79, i32 0) #3
  br label %88

; <label>:88:                                     ; preds = %28, %22, %12, %74, %1, %86, %81
  %89 = phi i32 [ 0, %81 ], [ %87, %86 ], [ 0, %1 ], [ 0, %74 ], [ 2, %12 ], [ 2, %22 ], [ 2, %28 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %9) #3
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %8) #3
  ret i32 %89
}

; Function Attrs: nounwind uwtable
define i32 @xdp_prognum4_ddos_filter_pktgen(%struct.xdp_md* nocapture readonly) #0 section "xdp_cpu_map4_ddos_filter_pktgen" {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %5 = load i32, i32* %4, align 4, !tbaa !10
  %6 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0
  %7 = load i32, i32* %6, align 4, !tbaa !12
  %8 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %8) #3
  store i32 0, i32* %2, align 4, !tbaa !2
  %9 = bitcast i32* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %9) #3
  store i32 0, i32* %3, align 4, !tbaa !2
  %10 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @rx_cnt to i8*), i8* nonnull %9) #3
  %11 = icmp eq i8* %10, null
  br i1 %11, label %117, label %12

; <label>:12:                                     ; preds = %1
  %13 = zext i32 %7 to i64
  %14 = inttoptr i64 %13 to %struct.ethhdr*
  %15 = zext i32 %5 to i64
  %16 = inttoptr i64 %15 to i8*
  %17 = bitcast i8* %10 to i64*
  %18 = load i64, i64* %17, align 8, !tbaa !6
  %19 = add i64 %18, 1
  store i64 %19, i64* %17, align 8, !tbaa !6
  %20 = getelementptr %struct.ethhdr, %struct.ethhdr* %14, i64 0, i32 0, i64 14
  %21 = icmp ugt i8* %20, %16
  br i1 %21, label %117, label %22

; <label>:22:                                     ; preds = %12
  %23 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %14, i64 0, i32 2
  %24 = load i16, i16* %23, align 1, !tbaa !13
  %25 = trunc i16 %24 to i8
  %26 = icmp ult i8 %25, 6
  br i1 %26, label %117, label %27, !prof !17

; <label>:27:                                     ; preds = %22
  switch i16 %24, label %35 [
    i16 129, label %28
    i16 -22392, label %28
  ]

; <label>:28:                                     ; preds = %27, %27
  %29 = getelementptr %struct.ethhdr, %struct.ethhdr* %14, i64 0, i32 0, i64 18
  %30 = icmp ugt i8* %29, %16
  br i1 %30, label %117, label %31

; <label>:31:                                     ; preds = %28
  %32 = getelementptr %struct.ethhdr, %struct.ethhdr* %14, i64 0, i32 0, i64 16
  %33 = bitcast i8* %32 to i16*
  %34 = load i16, i16* %33, align 2, !tbaa !18
  br label %35

; <label>:35:                                     ; preds = %31, %27
  %36 = phi i16 [ %24, %27 ], [ %34, %31 ]
  %37 = phi i64 [ 14, %27 ], [ 18, %31 ]
  %38 = call i16 @llvm.bswap.i16(i16 %36) #3
  switch i16 %38, label %66 [
    i16 2048, label %39
    i16 -31011, label %52
    i16 2054, label %65
  ]

; <label>:39:                                     ; preds = %35
  %40 = load i32, i32* %4, align 4, !tbaa !10
  %41 = zext i32 %40 to i64
  %42 = load i32, i32* %6, align 4, !tbaa !12
  %43 = zext i32 %42 to i64
  %44 = inttoptr i64 %43 to i8*
  %45 = getelementptr i8, i8* %44, i64 %37
  %46 = getelementptr inbounds i8, i8* %45, i64 20
  %47 = bitcast i8* %46 to %struct.iphdr*
  %48 = inttoptr i64 %41 to %struct.iphdr*
  %49 = icmp ugt %struct.iphdr* %47, %48
  br i1 %49, label %102, label %50

; <label>:50:                                     ; preds = %39
  %51 = getelementptr inbounds i8, i8* %45, i64 9
  br label %67

; <label>:52:                                     ; preds = %35
  %53 = load i32, i32* %4, align 4, !tbaa !10
  %54 = zext i32 %53 to i64
  %55 = load i32, i32* %6, align 4, !tbaa !12
  %56 = zext i32 %55 to i64
  %57 = inttoptr i64 %56 to i8*
  %58 = getelementptr i8, i8* %57, i64 %37
  %59 = getelementptr inbounds i8, i8* %58, i64 40
  %60 = bitcast i8* %59 to %struct.ipv6hdr*
  %61 = inttoptr i64 %54 to %struct.ipv6hdr*
  %62 = icmp ugt %struct.ipv6hdr* %60, %61
  br i1 %62, label %102, label %63

; <label>:63:                                     ; preds = %52
  %64 = getelementptr inbounds i8, i8* %58, i64 6
  br label %67

; <label>:65:                                     ; preds = %35
  store i32 0, i32* %2, align 4, !tbaa !2
  br label %72

; <label>:66:                                     ; preds = %35
  store i32 0, i32* %2, align 4, !tbaa !2
  br label %72

; <label>:67:                                     ; preds = %63, %50
  %68 = phi i8* [ %51, %50 ], [ %64, %63 ]
  %69 = load i8, i8* %68, align 1, !tbaa !20
  switch i8 %69, label %102 [
    i8 1, label %70
    i8 58, label %70
    i8 6, label %71
    i8 17, label %72
  ]

; <label>:70:                                     ; preds = %67, %67
  store i32 2, i32* %2, align 4, !tbaa !2
  br label %103

; <label>:71:                                     ; preds = %67
  store i32 0, i32* %2, align 4, !tbaa !2
  br label %103

; <label>:72:                                     ; preds = %65, %66, %67
  store i32 1, i32* %2, align 4, !tbaa !2
  %73 = load i32, i32* %4, align 4, !tbaa !10
  %74 = zext i32 %73 to i64
  %75 = load i32, i32* %6, align 4, !tbaa !12
  %76 = zext i32 %75 to i64
  %77 = inttoptr i64 %76 to i8*
  %78 = getelementptr i8, i8* %77, i64 %37
  %79 = getelementptr inbounds i8, i8* %78, i64 20
  %80 = bitcast i8* %79 to %struct.iphdr*
  %81 = inttoptr i64 %74 to %struct.iphdr*
  %82 = icmp ugt %struct.iphdr* %80, %81
  br i1 %82, label %103, label %83

; <label>:83:                                     ; preds = %72
  %84 = getelementptr inbounds i8, i8* %78, i64 9
  %85 = load i8, i8* %84, align 1, !tbaa !21
  %86 = icmp eq i8 %85, 17
  br i1 %86, label %87, label %103

; <label>:87:                                     ; preds = %83
  %88 = getelementptr inbounds i8, i8* %79, i64 8
  %89 = bitcast i8* %88 to %struct.udphdr*
  %90 = inttoptr i64 %74 to %struct.udphdr*
  %91 = icmp ugt %struct.udphdr* %89, %90
  br i1 %91, label %103, label %92

; <label>:92:                                     ; preds = %87
  %93 = getelementptr inbounds i8, i8* %79, i64 2
  %94 = bitcast i8* %93 to i16*
  %95 = load i16, i16* %94, align 2, !tbaa !23
  %96 = icmp eq i16 %95, 2304
  br i1 %96, label %97, label %103

; <label>:97:                                     ; preds = %92
  %98 = getelementptr inbounds i8, i8* %10, i64 8
  %99 = bitcast i8* %98 to i64*
  %100 = load i64, i64* %99, align 8, !tbaa !16
  %101 = add i64 %100, 1
  store i64 %101, i64* %99, align 8, !tbaa !16
  br label %117

; <label>:102:                                    ; preds = %52, %39, %67
  store i32 0, i32* %2, align 4, !tbaa !2
  br label %103

; <label>:103:                                    ; preds = %87, %83, %72, %92, %102, %71, %70
  %104 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @cpus_available to i8*), i8* nonnull %8) #3
  %105 = icmp eq i8* %104, null
  br i1 %105, label %117, label %106

; <label>:106:                                    ; preds = %103
  %107 = bitcast i8* %104 to i32*
  %108 = load i32, i32* %107, align 4, !tbaa !2
  %109 = icmp ugt i32 %108, 11
  br i1 %109, label %110, label %115

; <label>:110:                                    ; preds = %106
  %111 = getelementptr inbounds i8, i8* %10, i64 16
  %112 = bitcast i8* %111 to i64*
  %113 = load i64, i64* %112, align 8, !tbaa !9
  %114 = add i64 %113, 1
  store i64 %114, i64* %112, align 8, !tbaa !9
  br label %117

; <label>:115:                                    ; preds = %106
  %116 = call i32 inttoptr (i64 51 to i32 (i8*, i32, i32)*)(i8* bitcast (%struct.bpf_map_def* @cpu_map to i8*), i32 %108, i32 0) #3
  br label %117

; <label>:117:                                    ; preds = %28, %22, %12, %103, %1, %115, %110, %97
  %118 = phi i32 [ 0, %110 ], [ %116, %115 ], [ 1, %97 ], [ 0, %1 ], [ 0, %103 ], [ 2, %12 ], [ 2, %22 ], [ 2, %28 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %9) #3
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %8) #3
  ret i32 %118
}

; Function Attrs: nounwind uwtable
define i32 @xdp_prognum5_ip_l3_flow_hash(%struct.xdp_md* nocapture readonly) #0 section "xdp_cpu_map5_ip_l3_flow_hash" {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %5 = load i32, i32* %4, align 4, !tbaa !10
  %6 = zext i32 %5 to i64
  %7 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0
  %8 = load i32, i32* %7, align 4, !tbaa !12
  %9 = zext i32 %8 to i64
  %10 = inttoptr i64 %9 to i8*
  %11 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %11) #3
  store i32 0, i32* %2, align 4, !tbaa !2
  %12 = bitcast i32* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %12) #3
  store i32 0, i32* %3, align 4, !tbaa !2
  %13 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @rx_cnt to i8*), i8* nonnull %12) #3
  %14 = icmp eq i8* %13, null
  br i1 %14, label %187, label %15

; <label>:15:                                     ; preds = %1
  %16 = inttoptr i64 %6 to i8*
  %17 = inttoptr i64 %9 to %struct.ethhdr*
  %18 = bitcast i8* %13 to i64*
  %19 = load i64, i64* %18, align 8, !tbaa !6
  %20 = add i64 %19, 1
  store i64 %20, i64* %18, align 8, !tbaa !6
  %21 = getelementptr %struct.ethhdr, %struct.ethhdr* %17, i64 0, i32 0, i64 14
  %22 = icmp ugt i8* %21, %16
  br i1 %22, label %187, label %23

; <label>:23:                                     ; preds = %15
  %24 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %17, i64 0, i32 2
  %25 = load i16, i16* %24, align 1, !tbaa !13
  %26 = trunc i16 %25 to i8
  %27 = icmp ult i8 %26, 6
  br i1 %27, label %187, label %28, !prof !17

; <label>:28:                                     ; preds = %23
  switch i16 %25, label %36 [
    i16 129, label %29
    i16 -22392, label %29
  ]

; <label>:29:                                     ; preds = %28, %28
  %30 = getelementptr %struct.ethhdr, %struct.ethhdr* %17, i64 0, i32 0, i64 18
  %31 = icmp ugt i8* %30, %16
  br i1 %31, label %187, label %32

; <label>:32:                                     ; preds = %29
  %33 = getelementptr %struct.ethhdr, %struct.ethhdr* %17, i64 0, i32 0, i64 16
  %34 = bitcast i8* %33 to i16*
  %35 = load i16, i16* %34, align 2, !tbaa !18
  br label %36

; <label>:36:                                     ; preds = %32, %28
  %37 = phi i16 [ %25, %28 ], [ %35, %32 ]
  %38 = phi i64 [ 14, %28 ], [ 18, %32 ]
  %39 = call i16 @llvm.bswap.i16(i16 %37) #3
  switch i16 %39, label %166 [
    i16 2048, label %40
    i16 -31011, label %79
    i16 2054, label %187
  ]

; <label>:40:                                     ; preds = %36
  %41 = getelementptr i8, i8* %10, i64 %38
  %42 = getelementptr inbounds i8, i8* %41, i64 20
  %43 = bitcast i8* %42 to %struct.iphdr*
  %44 = inttoptr i64 %6 to %struct.iphdr*
  %45 = icmp ugt %struct.iphdr* %43, %44
  br i1 %45, label %187, label %46

; <label>:46:                                     ; preds = %40
  %47 = getelementptr inbounds i8, i8* %41, i64 12
  %48 = bitcast i8* %47 to i32*
  %49 = load i32, i32* %48, align 4, !tbaa !25
  %50 = getelementptr inbounds i8, i8* %41, i64 16
  %51 = bitcast i8* %50 to i32*
  %52 = load i32, i32* %51, align 4, !tbaa !26
  %53 = getelementptr inbounds i8, i8* %41, i64 9
  %54 = load i8, i8* %53, align 1, !tbaa !21
  %55 = zext i8 %54 to i32
  %56 = add nuw nsw i32 %55, 15487911
  %57 = xor i32 %52, %49
  %58 = and i32 %57, 65535
  %59 = add nuw nsw i32 %56, %58
  %60 = lshr i32 %57, 16
  %61 = shl nuw nsw i32 %60, 11
  %62 = xor i32 %59, %61
  %63 = shl i32 %59, 16
  %64 = xor i32 %62, %63
  %65 = lshr i32 %64, 11
  %66 = add i32 %65, %64
  %67 = shl i32 %66, 3
  %68 = xor i32 %67, %66
  %69 = lshr i32 %68, 5
  %70 = add i32 %69, %68
  %71 = shl i32 %70, 4
  %72 = xor i32 %71, %70
  %73 = lshr i32 %72, 17
  %74 = add i32 %73, %72
  %75 = shl i32 %74, 25
  %76 = xor i32 %75, %74
  %77 = lshr i32 %76, 6
  %78 = add i32 %77, %76
  br label %166

; <label>:79:                                     ; preds = %36
  %80 = getelementptr i8, i8* %10, i64 %38
  %81 = getelementptr inbounds i8, i8* %80, i64 40
  %82 = bitcast i8* %81 to %struct.ipv6hdr*
  %83 = inttoptr i64 %6 to %struct.ipv6hdr*
  %84 = icmp ugt %struct.ipv6hdr* %82, %83
  br i1 %84, label %187, label %85

; <label>:85:                                     ; preds = %79
  %86 = getelementptr inbounds i8, i8* %80, i64 8
  %87 = bitcast i8* %86 to i32*
  %88 = load i32, i32* %87, align 4
  %89 = getelementptr inbounds i8, i8* %80, i64 12
  %90 = bitcast i8* %89 to i32*
  %91 = load i32, i32* %90, align 4
  %92 = getelementptr inbounds i8, i8* %80, i64 16
  %93 = bitcast i8* %92 to i32*
  %94 = load i32, i32* %93, align 4
  %95 = getelementptr inbounds i8, i8* %80, i64 20
  %96 = bitcast i8* %95 to i32*
  %97 = load i32, i32* %96, align 4
  %98 = getelementptr inbounds i8, i8* %80, i64 24
  %99 = bitcast i8* %98 to i32*
  %100 = load i32, i32* %99, align 4
  %101 = getelementptr inbounds i8, i8* %80, i64 28
  %102 = bitcast i8* %101 to i32*
  %103 = load i32, i32* %102, align 4
  %104 = getelementptr inbounds i8, i8* %80, i64 32
  %105 = bitcast i8* %104 to i32*
  %106 = load i32, i32* %105, align 4
  %107 = getelementptr inbounds i8, i8* %80, i64 36
  %108 = bitcast i8* %107 to i32*
  %109 = load i32, i32* %108, align 4
  %110 = getelementptr inbounds i8, i8* %80, i64 6
  %111 = load i8, i8* %110, align 2, !tbaa !27
  %112 = zext i8 %111 to i32
  %113 = xor i32 %100, %88
  %114 = xor i32 %103, %91
  %115 = xor i32 %106, %94
  %116 = xor i32 %109, %97
  %117 = and i32 %113, 65535
  %118 = add nuw nsw i32 %117, 15520388
  %119 = add nuw nsw i32 %118, %112
  %120 = lshr i32 %113, 16
  %121 = shl nuw nsw i32 %120, 11
  %122 = xor i32 %119, %121
  %123 = shl i32 %119, 16
  %124 = xor i32 %122, %123
  %125 = lshr i32 %124, 11
  %126 = and i32 %114, 65535
  %127 = add i32 %124, %126
  %128 = add i32 %127, %125
  %129 = lshr i32 %114, 16
  %130 = shl nuw nsw i32 %129, 11
  %131 = xor i32 %128, %130
  %132 = shl i32 %128, 16
  %133 = xor i32 %131, %132
  %134 = lshr i32 %133, 11
  %135 = and i32 %115, 65535
  %136 = add i32 %133, %135
  %137 = add i32 %136, %134
  %138 = lshr i32 %115, 16
  %139 = shl nuw nsw i32 %138, 11
  %140 = xor i32 %137, %139
  %141 = shl i32 %137, 16
  %142 = xor i32 %140, %141
  %143 = lshr i32 %142, 11
  %144 = and i32 %116, 65535
  %145 = add i32 %142, %144
  %146 = add i32 %145, %143
  %147 = lshr i32 %116, 16
  %148 = shl nuw nsw i32 %147, 11
  %149 = xor i32 %146, %148
  %150 = shl i32 %146, 16
  %151 = xor i32 %149, %150
  %152 = lshr i32 %151, 11
  %153 = add i32 %152, %151
  %154 = shl i32 %153, 3
  %155 = xor i32 %154, %153
  %156 = lshr i32 %155, 5
  %157 = add i32 %156, %155
  %158 = shl i32 %157, 4
  %159 = xor i32 %158, %157
  %160 = lshr i32 %159, 17
  %161 = add i32 %160, %159
  %162 = shl i32 %161, 25
  %163 = xor i32 %162, %161
  %164 = lshr i32 %163, 6
  %165 = add i32 %164, %163
  br label %166

; <label>:166:                                    ; preds = %36, %85, %46
  %167 = phi i32 [ %165, %85 ], [ %78, %46 ], [ 0, %36 ]
  %168 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @cpus_count to i8*), i8* nonnull %12) #3
  %169 = icmp eq i8* %168, null
  br i1 %169, label %187, label %170

; <label>:170:                                    ; preds = %166
  %171 = bitcast i8* %168 to i32*
  %172 = load i32, i32* %171, align 4, !tbaa !2
  %173 = urem i32 %167, %172
  store i32 %173, i32* %2, align 4, !tbaa !2
  %174 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @cpus_available to i8*), i8* nonnull %11) #3
  %175 = icmp eq i8* %174, null
  br i1 %175, label %187, label %176

; <label>:176:                                    ; preds = %170
  %177 = bitcast i8* %174 to i32*
  %178 = load i32, i32* %177, align 4, !tbaa !2
  %179 = icmp ugt i32 %178, 11
  br i1 %179, label %180, label %185

; <label>:180:                                    ; preds = %176
  %181 = getelementptr inbounds i8, i8* %13, i64 16
  %182 = bitcast i8* %181 to i64*
  %183 = load i64, i64* %182, align 8, !tbaa !9
  %184 = add i64 %183, 1
  store i64 %184, i64* %182, align 8, !tbaa !9
  br label %187

; <label>:185:                                    ; preds = %176
  %186 = call i32 inttoptr (i64 51 to i32 (i8*, i32, i32)*)(i8* bitcast (%struct.bpf_map_def* @cpu_map to i8*), i32 %178, i32 0) #3
  br label %187

; <label>:187:                                    ; preds = %29, %23, %15, %170, %166, %36, %79, %40, %1, %185, %180
  %188 = phi i32 [ 0, %180 ], [ %186, %185 ], [ 0, %1 ], [ 0, %40 ], [ 0, %79 ], [ 2, %36 ], [ 0, %166 ], [ 0, %170 ], [ 2, %15 ], [ 2, %23 ], [ 2, %29 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %12) #3
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %11) #3
  ret i32 %188
}

; Function Attrs: nounwind uwtable
define i32 @trace_xdp_redirect_err(%struct.xdp_redirect_ctx* nocapture readonly) #0 section "tracepoint/xdp/xdp_redirect_err" {
  %2 = alloca i32, align 4
  %3 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #3
  %4 = getelementptr inbounds %struct.xdp_redirect_ctx, %struct.xdp_redirect_ctx* %0, i64 0, i32 4
  %5 = load i32, i32* %4, align 4, !tbaa !30
  %6 = icmp ne i32 %5, 0
  %7 = zext i1 %6 to i32
  store i32 %7, i32* %2, align 4
  %8 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @redirect_err_cnt to i8*), i8* nonnull %3) #3
  %9 = icmp eq i8* %8, null
  br i1 %9, label %15, label %10

; <label>:10:                                     ; preds = %1
  %11 = getelementptr inbounds i8, i8* %8, i64 8
  %12 = bitcast i8* %11 to i64*
  %13 = load i64, i64* %12, align 8, !tbaa !16
  %14 = add i64 %13, 1
  store i64 %14, i64* %12, align 8, !tbaa !16
  br label %15

; <label>:15:                                     ; preds = %1, %10
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #3
  ret i32 0
}

; Function Attrs: nounwind uwtable
define i32 @trace_xdp_redirect_map_err(%struct.xdp_redirect_ctx* nocapture readonly) #0 section "tracepoint/xdp/xdp_redirect_map_err" {
  %2 = alloca i32, align 4
  %3 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #3
  %4 = getelementptr inbounds %struct.xdp_redirect_ctx, %struct.xdp_redirect_ctx* %0, i64 0, i32 4
  %5 = load i32, i32* %4, align 4, !tbaa !30
  %6 = icmp ne i32 %5, 0
  %7 = zext i1 %6 to i32
  store i32 %7, i32* %2, align 4
  %8 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @redirect_err_cnt to i8*), i8* nonnull %3) #3
  %9 = icmp eq i8* %8, null
  br i1 %9, label %15, label %10

; <label>:10:                                     ; preds = %1
  %11 = getelementptr inbounds i8, i8* %8, i64 8
  %12 = bitcast i8* %11 to i64*
  %13 = load i64, i64* %12, align 8, !tbaa !16
  %14 = add i64 %13, 1
  store i64 %14, i64* %12, align 8, !tbaa !16
  br label %15

; <label>:15:                                     ; preds = %1, %10
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #3
  ret i32 0
}

; Function Attrs: nounwind uwtable
define i32 @trace_xdp_exception(%struct.xdp_exception_ctx* nocapture readnone) #0 section "tracepoint/xdp/xdp_exception" {
  %2 = alloca i32, align 4
  %3 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #3
  store i32 0, i32* %2, align 4, !tbaa !2
  %4 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @exception_cnt to i8*), i8* nonnull %3) #3
  %5 = icmp eq i8* %4, null
  br i1 %5, label %11, label %6

; <label>:6:                                      ; preds = %1
  %7 = getelementptr inbounds i8, i8* %4, i64 8
  %8 = bitcast i8* %7 to i64*
  %9 = load i64, i64* %8, align 8, !tbaa !16
  %10 = add i64 %9, 1
  store i64 %10, i64* %8, align 8, !tbaa !16
  br label %11

; <label>:11:                                     ; preds = %1, %6
  %12 = phi i32 [ 0, %6 ], [ 1, %1 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #3
  ret i32 %12
}

; Function Attrs: nounwind uwtable
define i32 @trace_xdp_cpumap_enqueue(%struct.cpumap_enqueue_ctx* nocapture readonly) #0 section "tracepoint/xdp/xdp_cpumap_enqueue" {
  %2 = alloca i32, align 4
  %3 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #3
  %4 = getelementptr inbounds %struct.cpumap_enqueue_ctx, %struct.cpumap_enqueue_ctx* %0, i64 0, i32 6
  %5 = load i32, i32* %4, align 4, !tbaa !32
  store i32 %5, i32* %2, align 4, !tbaa !2
  %6 = icmp ugt i32 %5, 11
  br i1 %6, label %30, label %7

; <label>:7:                                      ; preds = %1
  %8 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @cpumap_enqueue_cnt to i8*), i8* nonnull %3) #3
  %9 = icmp eq i8* %8, null
  br i1 %9, label %30, label %10

; <label>:10:                                     ; preds = %7
  %11 = getelementptr inbounds %struct.cpumap_enqueue_ctx, %struct.cpumap_enqueue_ctx* %0, i64 0, i32 5
  %12 = load i32, i32* %11, align 8, !tbaa !34
  %13 = zext i32 %12 to i64
  %14 = bitcast i8* %8 to i64*
  %15 = load i64, i64* %14, align 8, !tbaa !6
  %16 = add i64 %15, %13
  store i64 %16, i64* %14, align 8, !tbaa !6
  %17 = getelementptr inbounds %struct.cpumap_enqueue_ctx, %struct.cpumap_enqueue_ctx* %0, i64 0, i32 4
  %18 = load i32, i32* %17, align 4, !tbaa !35
  %19 = zext i32 %18 to i64
  %20 = getelementptr inbounds i8, i8* %8, i64 8
  %21 = bitcast i8* %20 to i64*
  %22 = load i64, i64* %21, align 8, !tbaa !16
  %23 = add i64 %22, %19
  store i64 %23, i64* %21, align 8, !tbaa !16
  %24 = icmp eq i32 %12, 0
  br i1 %24, label %30, label %25

; <label>:25:                                     ; preds = %10
  %26 = getelementptr inbounds i8, i8* %8, i64 16
  %27 = bitcast i8* %26 to i64*
  %28 = load i64, i64* %27, align 8, !tbaa !9
  %29 = add i64 %28, 1
  store i64 %29, i64* %27, align 8, !tbaa !9
  br label %30

; <label>:30:                                     ; preds = %25, %10, %7, %1
  %31 = phi i32 [ 1, %1 ], [ 0, %7 ], [ 0, %10 ], [ 0, %25 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #3
  ret i32 %31
}

; Function Attrs: nounwind uwtable
define i32 @trace_xdp_cpumap_kthread(%struct.cpumap_kthread_ctx* nocapture readonly) #0 section "tracepoint/xdp/xdp_cpumap_kthread" {
  %2 = alloca i32, align 4
  %3 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #3
  store i32 0, i32* %2, align 4, !tbaa !2
  %4 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @cpumap_kthread_cnt to i8*), i8* nonnull %3) #3
  %5 = icmp eq i8* %4, null
  br i1 %5, label %28, label %6

; <label>:6:                                      ; preds = %1
  %7 = getelementptr inbounds %struct.cpumap_kthread_ctx, %struct.cpumap_kthread_ctx* %0, i64 0, i32 5
  %8 = load i32, i32* %7, align 8, !tbaa !36
  %9 = zext i32 %8 to i64
  %10 = bitcast i8* %4 to i64*
  %11 = load i64, i64* %10, align 8, !tbaa !6
  %12 = add i64 %11, %9
  store i64 %12, i64* %10, align 8, !tbaa !6
  %13 = getelementptr inbounds %struct.cpumap_kthread_ctx, %struct.cpumap_kthread_ctx* %0, i64 0, i32 4
  %14 = load i32, i32* %13, align 4, !tbaa !38
  %15 = zext i32 %14 to i64
  %16 = getelementptr inbounds i8, i8* %4, i64 8
  %17 = bitcast i8* %16 to i64*
  %18 = load i64, i64* %17, align 8, !tbaa !16
  %19 = add i64 %18, %15
  store i64 %19, i64* %17, align 8, !tbaa !16
  %20 = getelementptr inbounds %struct.cpumap_kthread_ctx, %struct.cpumap_kthread_ctx* %0, i64 0, i32 6
  %21 = load i32, i32* %20, align 4, !tbaa !39
  %22 = icmp eq i32 %21, 0
  br i1 %22, label %28, label %23

; <label>:23:                                     ; preds = %6
  %24 = getelementptr inbounds i8, i8* %4, i64 16
  %25 = bitcast i8* %24 to i64*
  %26 = load i64, i64* %25, align 8, !tbaa !9
  %27 = add i64 %26, 1
  store i64 %27, i64* %25, align 8, !tbaa !9
  br label %28

; <label>:28:                                     ; preds = %23, %6, %1
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #3
  ret i32 0
}

; Function Attrs: nounwind readnone speculatable
declare i16 @llvm.bswap.i16(i16) #2

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { nounwind readnone speculatable }
attributes #3 = { nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
!2 = !{!3, !3, i64 0}
!3 = !{!"int", !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
!6 = !{!7, !8, i64 0}
!7 = !{!"datarec", !8, i64 0, !8, i64 8, !8, i64 16}
!8 = !{!"long long", !4, i64 0}
!9 = !{!7, !8, i64 16}
!10 = !{!11, !3, i64 4}
!11 = !{!"xdp_md", !3, i64 0, !3, i64 4, !3, i64 8, !3, i64 12, !3, i64 16}
!12 = !{!11, !3, i64 0}
!13 = !{!14, !15, i64 12}
!14 = !{!"ethhdr", !4, i64 0, !4, i64 6, !15, i64 12}
!15 = !{!"short", !4, i64 0}
!16 = !{!7, !8, i64 8}
!17 = !{!"branch_weights", i32 1, i32 2000}
!18 = !{!19, !15, i64 2}
!19 = !{!"vlan_hdr", !15, i64 0, !15, i64 2}
!20 = !{!4, !4, i64 0}
!21 = !{!22, !4, i64 9}
!22 = !{!"iphdr", !4, i64 0, !4, i64 0, !4, i64 1, !15, i64 2, !15, i64 4, !15, i64 6, !4, i64 8, !4, i64 9, !15, i64 10, !3, i64 12, !3, i64 16}
!23 = !{!24, !15, i64 2}
!24 = !{!"udphdr", !15, i64 0, !15, i64 2, !15, i64 4, !15, i64 6}
!25 = !{!22, !3, i64 12}
!26 = !{!22, !3, i64 16}
!27 = !{!28, !4, i64 6}
!28 = !{!"ipv6hdr", !4, i64 0, !4, i64 0, !4, i64 1, !15, i64 4, !4, i64 6, !4, i64 7, !29, i64 8, !29, i64 24}
!29 = !{!"in6_addr", !4, i64 0}
!30 = !{!31, !3, i64 20}
!31 = !{!"xdp_redirect_ctx", !8, i64 0, !3, i64 8, !3, i64 12, !3, i64 16, !3, i64 20, !3, i64 24, !3, i64 28, !3, i64 32}
!32 = !{!33, !3, i64 28}
!33 = !{!"cpumap_enqueue_ctx", !8, i64 0, !3, i64 8, !3, i64 12, !3, i64 16, !3, i64 20, !3, i64 24, !3, i64 28}
!34 = !{!33, !3, i64 24}
!35 = !{!33, !3, i64 20}
!36 = !{!37, !3, i64 24}
!37 = !{!"cpumap_kthread_ctx", !8, i64 0, !3, i64 8, !3, i64 12, !3, i64 16, !3, i64 20, !3, i64 24, !3, i64 28}
!38 = !{!37, !3, i64 20}
!39 = !{!37, !3, i64 28}
