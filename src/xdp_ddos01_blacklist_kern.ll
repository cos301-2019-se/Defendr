; ModuleID = 'xdp_ddos01_blacklist_kern.c'
source_filename = "xdp_ddos01_blacklist_kern.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.log = type { i32, i32, i32, i32, [6 x i8] }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.dest_info = type { i32, i32, i32, i64, i64, i64, [6 x i8] }

@blacklist = global %struct.bpf_map_def { i32 5, i32 4, i32 8, i32 100000, i32 1, i32 0, i32 0 }, section "maps", align 4
@whitelist = global %struct.bpf_map_def { i32 5, i32 4, i32 8, i32 100000, i32 1, i32 0, i32 0 }, section "maps", align 4
@ip_watchlist = global %struct.bpf_map_def { i32 5, i32 4, i32 8, i32 100000, i32 1, i32 0, i32 0 }, section "maps", align 4
@logs = global %struct.bpf_map_def { i32 1, i32 8, i32 24, i32 100000, i32 1, i32 0, i32 0 }, section "maps", align 4
@servers = global %struct.bpf_map_def { i32 1, i32 4, i32 48, i32 512, i32 0, i32 0, i32 0 }, section "maps", align 4
@services = global %struct.bpf_map_def { i32 1, i32 4, i32 576, i32 512, i32 0, i32 0, i32 0 }, section "maps", align 4
@destinations = global %struct.bpf_map_def { i32 1, i32 4, i32 4, i32 512, i32 0, i32 0, i32 0 }, section "maps", align 4
@system_stats = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 5, i32 0, i32 0, i32 0 }, section "maps", align 4
@verdict_cnt = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 4, i32 0, i32 0, i32 0 }, section "maps", align 4
@port_blacklist = global %struct.bpf_map_def { i32 6, i32 4, i32 4, i32 65536, i32 0, i32 0, i32 0 }, section "maps", align 4
@port_blacklist_drop_count_tcp = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 65536, i32 0, i32 0, i32 0 }, section "maps", align 4
@port_blacklist_drop_count_udp = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 65536, i32 0, i32 0, i32 0 }, section "maps", align 4
@_license = global [4 x i8] c"GPL\00", section "license", align 1
@llvm.used = appending global [14 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @blacklist to i8*), i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* bitcast (%struct.bpf_map_def* @port_blacklist to i8*), i8* bitcast (%struct.bpf_map_def* @port_blacklist_drop_count_tcp to i8*), i8* bitcast (%struct.bpf_map_def* @port_blacklist_drop_count_udp to i8*), i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* bitcast (%struct.bpf_map_def* @services to i8*), i8* bitcast (%struct.bpf_map_def* @system_stats to i8*), i8* bitcast (%struct.bpf_map_def* @verdict_cnt to i8*), i8* bitcast (%struct.bpf_map_def* @whitelist to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_program to i8*)], section "llvm.metadata"

; Function Attrs: nounwind uwtable
define void @add_to_system_stats(i32, i64) local_unnamed_addr #0 {
  %3 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !2
  %4 = icmp ugt i32 %0, 4
  br i1 %4, label %13, label %5

; <label>:5:                                      ; preds = %2
  %6 = bitcast i32* %3 to i8*
  %7 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @system_stats to i8*), i8* nonnull %6) #2
  %8 = bitcast i8* %7 to i64*
  %9 = icmp eq i8* %7, null
  br i1 %9, label %13, label %10

; <label>:10:                                     ; preds = %5
  %11 = load i64, i64* %8, align 8, !tbaa !6
  %12 = add i64 %11, %1
  store i64 %12, i64* %8, align 8, !tbaa !6
  br label %13

; <label>:13:                                     ; preds = %10, %5, %2
  ret void
}

; <label>:112:                                    ; preds = %110, %107
  %113 = getelementptr inbounds i8, i8* %25, i64 23
  %114 = load i8, i8* %113, align 1, !tbaa !24
  %115 = icmp eq i8 %114, 6
  br i1 %115, label %139, label %116

; <label>:116:                                    ; preds = %112
  %117 = bitcast %struct.log* %10 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %117) #2
  %118 = getelementptr inbounds %struct.log, %struct.log* %10, i64 0, i32 4, i64 0
  %119 = bitcast i8* %118 to i64*
  store i64 0, i64* %119, align 4
  %120 = load i32, i32* %6, align 4, !tbaa !16
  %121 = getelementptr inbounds %struct.log, %struct.log* %10, i64 0, i32 0
  store i32 %120, i32* %121, align 4, !tbaa !18
  %122 = getelementptr inbounds %struct.log, %struct.log* %10, i64 0, i32 1
  store i32 1, i32* %122, align 4, !tbaa !20
  %123 = getelementptr inbounds %struct.log, %struct.log* %10, i64 0, i32 2
  store i32 4, i32* %123, align 4, !tbaa !21
  %124 = getelementptr inbounds %struct.log, %struct.log* %10, i64 0, i32 3
  store i32 %44, i32* %124, align 4, !tbaa !22
  %125 = load i8, i8* %52, align 1, !tbaa !23
  %126 = getelementptr inbounds %struct.log, %struct.log* %10, i64 0, i32 4, i64 0
  store i8 %125, i8* %126, align 4, !tbaa !23
  %127 = load i8, i8* %52, align 1, !tbaa !23
  %128 = getelementptr inbounds %struct.log, %struct.log* %10, i64 0, i32 4, i64 1
  store i8 %127, i8* %128, align 1, !tbaa !23
  %129 = load i8, i8* %52, align 1, !tbaa !23
  %130 = getelementptr inbounds %struct.log, %struct.log* %10, i64 0, i32 4, i64 2
  store i8 %129, i8* %130, align 2, !tbaa !23
  %131 = load i8, i8* %52, align 1, !tbaa !23
  %132 = getelementptr inbounds %struct.log, %struct.log* %10, i64 0, i32 4, i64 3
  store i8 %131, i8* %132, align 1, !tbaa !23
  %133 = load i8, i8* %52, align 1, !tbaa !23
  %134 = getelementptr inbounds %struct.log, %struct.log* %10, i64 0, i32 4, i64 4
  store i8 %133, i8* %134, align 4, !tbaa !23
  %135 = load i8, i8* %52, align 1, !tbaa !23
  %136 = getelementptr inbounds %struct.log, %struct.log* %10, i64 0, i32 4, i64 5
  store i8 %135, i8* %136, align 1, !tbaa !23
  %137 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %137, i64* %7, align 8, !tbaa !2
  %138 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %17, i8* nonnull %117, i64 0) #2
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %117) #2
  br label %409

; Function Attrs: nounwind uwtable
define i32 @xdp_program(%struct.xdp_md* nocapture readonly) #0 section "xdp_prog" {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i64, align 8
  %14 = alloca i32, align 4
  %15 = alloca i64, align 8
  %16 = alloca %struct.log, align 4
  %17 = alloca %struct.log, align 4
  %18 = alloca %struct.log, align 4
  %19 = alloca i32, align 4
  %20 = alloca %struct.log, align 4
  %21 = alloca %struct.log, align 4
  %22 = alloca %struct.log, align 4
  %23 = bitcast i64* %13 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %23) #2
  store i64 1, i64* %13, align 8, !tbaa !6
  %24 = bitcast i32* %14 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %24) #2
  %25 = bitcast i64* %15 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %25) #2
  %26 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %27 = load i32, i32* %26, align 4, !tbaa !8
  %28 = zext i32 %27 to i64
  %29 = inttoptr i64 %28 to i8*
  %30 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0
  %31 = load i32, i32* %30, align 4, !tbaa !10
  %32 = zext i32 %31 to i64
  %33 = inttoptr i64 %32 to i8*
  %34 = inttoptr i64 %32 to %struct.ethhdr*
  %35 = getelementptr i8, i8* %33, i64 14
  %36 = icmp ugt i8* %35, %29
  br i1 %36, label %427, label %37

; <label>:37:                                     ; preds = %1
  %38 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %34, i64 0, i32 2
  %39 = load i16, i16* %38, align 1, !tbaa !11
  %40 = icmp eq i16 %39, 8
  br i1 %40, label %41, label %427

; <label>:41:                                     ; preds = %37
  %42 = getelementptr i8, i8* %33, i64 34
  %43 = icmp ugt i8* %42, %29
  br i1 %43, label %427, label %44

; <label>:44:                                     ; preds = %41
  %45 = getelementptr inbounds i8, i8* %33, i64 26
  %46 = bitcast i8* %45 to i32*
  %47 = load i32, i32* %46, align 4, !tbaa !14
  %48 = tail call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %47) #3, !srcloc !16
  store i32 %48, i32* %14, align 4, !tbaa !2
  %49 = getelementptr inbounds i8, i8* %33, i64 30
  %50 = bitcast i8* %49 to i32*
  %51 = load i32, i32* %50, align 4, !tbaa !17
  %52 = tail call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %51) #3, !srcloc !16
  %53 = bitcast %struct.log* %16 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %53) #2
  %54 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 4, i64 0
  %55 = bitcast i8* %54 to i64*
  store i64 0, i64* %55, align 4
  %56 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 0
  store i32 %48, i32* %56, align 4, !tbaa !18
  %57 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 1
  store i32 0, i32* %57, align 4, !tbaa !20
  %58 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 2
  store i32 0, i32* %58, align 4, !tbaa !21
  %59 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 3
  store i32 %52, i32* %59, align 4, !tbaa !22
  %60 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %34, i64 0, i32 0, i64 0
  %61 = load i8, i8* %60, align 1, !tbaa !23
  %62 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 4, i64 0
  store i8 %61, i8* %62, align 4, !tbaa !23
  %63 = load i8, i8* %60, align 1, !tbaa !23
  %64 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 4, i64 1
  store i8 %63, i8* %64, align 1, !tbaa !23
  %65 = load i8, i8* %60, align 1, !tbaa !23
  %66 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 4, i64 2
  store i8 %65, i8* %66, align 2, !tbaa !23
  %67 = load i8, i8* %60, align 1, !tbaa !23
  %68 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 4, i64 3
  store i8 %67, i8* %68, align 1, !tbaa !23
  %69 = load i8, i8* %60, align 1, !tbaa !23
  %70 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 4, i64 4
  store i8 %69, i8* %70, align 4, !tbaa !23
  %71 = load i8, i8* %60, align 1, !tbaa !23
  %72 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 4, i64 5
  store i8 %71, i8* %72, align 1, !tbaa !23
  %73 = tail call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %73, i64* %15, align 8, !tbaa !6
  %74 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %25, i8* nonnull %53, i64 0) #2
  %75 = sub nsw i64 %28, %32
  %76 = bitcast i32* %12 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %76)
  store i32 0, i32* %12, align 4, !tbaa !2
  %77 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @system_stats to i8*), i8* nonnull %76) #2
  %78 = bitcast i8* %77 to i64*
  %79 = icmp eq i8* %77, null
  br i1 %79, label %83, label %80

; <label>:80:                                     ; preds = %44
  %81 = load i64, i64* %78, align 8, !tbaa !6
  %82 = add i64 %81, 1
  store i64 %82, i64* %78, align 8, !tbaa !6
  br label %83

; <label>:83:                                     ; preds = %44, %80
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %76)
  %84 = bitcast i32* %11 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %84)
  store i32 1, i32* %11, align 4, !tbaa !2
  %85 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @system_stats to i8*), i8* nonnull %84) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %84)
  %86 = and i64 %75, 65535
  %87 = bitcast i32* %10 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %87)
  store i32 2, i32* %10, align 4, !tbaa !2
  %88 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @system_stats to i8*), i8* nonnull %87) #2
  %89 = bitcast i8* %88 to i64*
  %90 = icmp eq i8* %88, null
  br i1 %90, label %94, label %91

; <label>:91:                                     ; preds = %83
  %92 = load i64, i64* %89, align 8, !tbaa !6
  %93 = add i64 %92, %86
  store i64 %93, i64* %89, align 8, !tbaa !6
  br label %94

; <label>:94:                                     ; preds = %83, %91
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %87)
  %95 = getelementptr i8, i8* %33, i64 54
  %96 = icmp ugt i8* %95, %29
  br i1 %96, label %425, label %97

; <label>:97:                                     ; preds = %94
  %98 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @blacklist to i8*), i8* nonnull %24) #2
  %99 = bitcast i8* %98 to i64*
  %100 = icmp eq i8* %98, null
  br i1 %100, label %147, label %101

; <label>:101:                                    ; preds = %97
  %102 = load i64, i64* %99, align 8, !tbaa !6
  %103 = add i64 %102, 1
  store i64 %103, i64* %99, align 8, !tbaa !6
  %104 = bitcast %struct.log* %17 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %104) #2
  %105 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 4, i64 0
  %106 = bitcast i8* %105 to i64*
  store i64 0, i64* %106, align 4
  %107 = load i32, i32* %14, align 4, !tbaa !2
  %108 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 0
  store i32 %107, i32* %108, align 4, !tbaa !18
  %109 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 1
  store i32 2, i32* %109, align 4, !tbaa !20
  %110 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 2
  store i32 1, i32* %110, align 4, !tbaa !21
  %111 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 3
  store i32 %52, i32* %111, align 4, !tbaa !22
  %112 = load i8, i8* %60, align 1, !tbaa !23
  %113 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 4, i64 0
  store i8 %112, i8* %113, align 4, !tbaa !23
  %114 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %34, i64 0, i32 0, i64 1
  %115 = load i8, i8* %114, align 1, !tbaa !23
  %116 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 4, i64 1
  store i8 %115, i8* %116, align 1, !tbaa !23
  %117 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %34, i64 0, i32 0, i64 2
  %118 = load i8, i8* %117, align 1, !tbaa !23
  %119 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 4, i64 2
  store i8 %118, i8* %119, align 2, !tbaa !23
  %120 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %34, i64 0, i32 0, i64 3
  %121 = load i8, i8* %120, align 1, !tbaa !23
  %122 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 4, i64 3
  store i8 %121, i8* %122, align 1, !tbaa !23
  %123 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %34, i64 0, i32 0, i64 4
  %124 = load i8, i8* %123, align 1, !tbaa !23
  %125 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 4, i64 4
  store i8 %124, i8* %125, align 4, !tbaa !23
  %126 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %34, i64 0, i32 0, i64 5
  %127 = load i8, i8* %126, align 1, !tbaa !23
  %128 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 4, i64 5
  store i8 %127, i8* %128, align 1, !tbaa !23
  %129 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %129, i64* %15, align 8, !tbaa !6
  %130 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %25, i8* nonnull %104, i64 0) #2
  %131 = bitcast i32* %9 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %131)
  store i32 3, i32* %9, align 4, !tbaa !2
  %132 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @system_stats to i8*), i8* nonnull %131) #2
  %133 = bitcast i8* %132 to i64*
  %134 = icmp eq i8* %132, null
  br i1 %134, label %138, label %135

; <label>:135:                                    ; preds = %101
  %136 = load i64, i64* %133, align 8, !tbaa !6
  %137 = add i64 %136, 1
  store i64 %137, i64* %133, align 8, !tbaa !6
  br label %138

; <label>:138:                                    ; preds = %101, %135
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %131)
  %139 = bitcast i32* %8 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %139)
  store i32 4, i32* %8, align 4, !tbaa !2
  %140 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @system_stats to i8*), i8* nonnull %139) #2
  %141 = bitcast i8* %140 to i64*
  %142 = icmp eq i8* %140, null
  br i1 %142, label %146, label %143

; <label>:143:                                    ; preds = %138
  %144 = load i64, i64* %141, align 8, !tbaa !6
  %145 = add i64 %144, %86
  store i64 %145, i64* %141, align 8, !tbaa !6
  br label %146

; <label>:146:                                    ; preds = %138, %143
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %139)
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %104) #2
  br label %425

; <label>:147:                                    ; preds = %97
  %148 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* nonnull %24) #2
  %149 = bitcast i8* %148 to i64*
  %150 = icmp eq i8* %148, null
  br i1 %150, label %154, label %151

; <label>:151:                                    ; preds = %147
  %152 = load i64, i64* %149, align 8, !tbaa !6
  %153 = add i64 %152, 1
  store i64 %153, i64* %149, align 8, !tbaa !6
  br label %156

; <label>:154:                                    ; preds = %147
  %155 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* nonnull %24, i8* nonnull %23, i64 1) #2
  br label %156

; <label>:156:                                    ; preds = %154, %151
  %157 = getelementptr inbounds i8, i8* %33, i64 23
  %158 = load i8, i8* %157, align 1, !tbaa !24
  %159 = icmp eq i8 %158, 6
  br i1 %159, label %183, label %160

; <label>:160:                                    ; preds = %156
  %161 = bitcast %struct.log* %18 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %161) #2
  %162 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 4, i64 0
  %163 = bitcast i8* %162 to i64*
  store i64 0, i64* %163, align 4
  %164 = load i32, i32* %14, align 4, !tbaa !2
  %165 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 0
  store i32 %164, i32* %165, align 4, !tbaa !18
  %166 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 1
  store i32 1, i32* %166, align 4, !tbaa !20
  %167 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 2
  store i32 4, i32* %167, align 4, !tbaa !21
  %168 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 3
  store i32 %52, i32* %168, align 4, !tbaa !22
  %169 = load i8, i8* %60, align 1, !tbaa !23
  %170 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 4, i64 0
  store i8 %169, i8* %170, align 4, !tbaa !23
  %171 = load i8, i8* %60, align 1, !tbaa !23
  %172 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 4, i64 1
  store i8 %171, i8* %172, align 1, !tbaa !23
  %173 = load i8, i8* %60, align 1, !tbaa !23
  %174 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 4, i64 2
  store i8 %173, i8* %174, align 2, !tbaa !23
  %175 = load i8, i8* %60, align 1, !tbaa !23
  %176 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 4, i64 3
  store i8 %175, i8* %176, align 1, !tbaa !23
  %177 = load i8, i8* %60, align 1, !tbaa !23
  %178 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 4, i64 4
  store i8 %177, i8* %178, align 4, !tbaa !23
  %179 = load i8, i8* %60, align 1, !tbaa !23
  %180 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 4, i64 5
  store i8 %179, i8* %180, align 1, !tbaa !23
  %181 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %181, i64* %15, align 8, !tbaa !6
  %182 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %25, i8* nonnull %161, i64 0) #2
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %161) #2
  br label %425

; <label>:183:                                    ; preds = %156
  %184 = load i32, i32* %46, align 4, !tbaa !14
  %185 = load i32, i32* %50, align 4, !tbaa !17
  %186 = bitcast i8* %42 to i16*
  %187 = load i16, i16* %186, align 4, !tbaa !25
  %188 = zext i16 %187 to i32
  %189 = getelementptr inbounds i8, i8* %33, i64 36
  %190 = bitcast i8* %189 to i16*
  %191 = load i16, i16* %190, align 2, !tbaa !27
  %192 = zext i16 %191 to i32
  %193 = shl nuw i32 %192, 16
  %194 = or i32 %193, %188
  %195 = getelementptr inbounds i8, i8* %33, i64 46
  %196 = bitcast i8* %195 to i16*
  %197 = load i16, i16* %196, align 4
  %198 = and i16 %197, 512
  %199 = icmp eq i16 %198, 0
  br i1 %199, label %210, label %200

; <label>:200:                                    ; preds = %183
  %201 = bitcast i32* %7 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %201)
  store i32 1, i32* %7, align 4, !tbaa !2
  %202 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @system_stats to i8*), i8* nonnull %201) #2
  %203 = bitcast i8* %202 to i64*
  %204 = icmp eq i8* %202, null
  br i1 %204, label %208, label %205

; <label>:205:                                    ; preds = %200
  %206 = load i64, i64* %203, align 8, !tbaa !6
  %207 = add i64 %206, 1
  store i64 %207, i64* %203, align 8, !tbaa !6
  br label %208

; <label>:208:                                    ; preds = %200, %205
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %201)
  %209 = load i32, i32* %50, align 4, !tbaa !17
  br label %210

; <label>:210:                                    ; preds = %183, %208
  %211 = phi i32 [ %185, %183 ], [ %209, %208 ]
  %212 = bitcast i32* %19 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %212) #2
  %213 = call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %211) #3, !srcloc !16
  store i32 %213, i32* %19, align 4, !tbaa !2
  %214 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @services to i8*), i8* nonnull %212) #2
  %215 = icmp eq i8* %214, null
  br i1 %215, label %395, label %216

; <label>:216:                                    ; preds = %210
  %217 = bitcast i32* %4 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %217) #2
  %218 = bitcast i32* %5 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %218) #2
  %219 = bitcast i32* %6 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %219) #2
  store i32 513, i32* %6, align 4, !tbaa !2
  %220 = add i32 %184, -559038217
  %221 = add i32 %194, -559038217
  %222 = add i32 %185, -559038217
  %223 = xor i32 %221, %222
  %224 = shl i32 %221, 14
  %225 = lshr i32 %221, 18
  %226 = or i32 %225, %224
  %227 = sub i32 %223, %226
  %228 = xor i32 %227, %220
  %229 = shl i32 %227, 11
  %230 = lshr i32 %227, 21
  %231 = or i32 %230, %229
  %232 = sub i32 %228, %231
  %233 = xor i32 %232, %221
  %234 = shl i32 %232, 25
  %235 = lshr i32 %232, 7
  %236 = or i32 %235, %234
  %237 = sub i32 %233, %236
  %238 = xor i32 %237, %227
  %239 = shl i32 %237, 16
  %240 = lshr i32 %237, 16
  %241 = or i32 %240, %239
  %242 = sub i32 %238, %241
  %243 = xor i32 %242, %232
  %244 = shl i32 %242, 4
  %245 = lshr i32 %242, 28
  %246 = or i32 %245, %244
  %247 = sub i32 %243, %246
  %248 = xor i32 %247, %237
  %249 = shl i32 %247, 14
  %250 = lshr i32 %247, 18
  %251 = or i32 %250, %249
  %252 = sub i32 %248, %251
  %253 = xor i32 %252, %242
  %254 = lshr i32 %252, 8
  %255 = sub i32 %253, %254
  %256 = and i32 %255, 511
  store i32 %256, i32* %5, align 4, !tbaa !2
  %257 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %218) #2
  %258 = bitcast i8* %257 to i32*
  %259 = call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %185) #3, !srcloc !16
  store i32 %259, i32* %4, align 4, !tbaa !2
  %260 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @services to i8*), i8* nonnull %217) #2
  %261 = icmp eq i8* %260, null
  br i1 %261, label %304, label %262

; <label>:262:                                    ; preds = %216
  %263 = icmp eq i8* %257, null
  br i1 %263, label %273, label %264

; <label>:264:                                    ; preds = %262
  %265 = load i32, i32* %258, align 4, !tbaa !2
  %266 = icmp ugt i32 %265, 9
  %267 = select i1 %266, i32 0, i32 %265
  store i32 %267, i32* %6, align 4
  %268 = getelementptr inbounds i8, i8* %260, i64 96
  %269 = bitcast i8* %268 to [10 x %struct.dest_info]*
  %270 = zext i32 %267 to i64
  %271 = getelementptr inbounds [10 x %struct.dest_info], [10 x %struct.dest_info]* %269, i64 0, i64 %270
  %272 = bitcast i8* %260 to i64*
  br label %298

; <label>:273:                                    ; preds = %262
  %274 = bitcast i8* %260 to i64*
  %275 = load i64, i64* %274, align 8, !tbaa !28
  %276 = add i64 %275, 1
  %277 = icmp ult i64 %276, 10
  %278 = select i1 %277, i64 %276, i64 0
  store i64 %278, i64* %274, align 8, !tbaa !28
  %279 = getelementptr inbounds i8, i8* %260, i64 16
  %280 = bitcast i8* %279 to [10 x i64]*
  %281 = getelementptr inbounds [10 x i64], [10 x i64]* %280, i64 0, i64 %278
  %282 = load i64, i64* %281, align 8, !tbaa !6
  %283 = icmp eq i64 %282, 0
  br i1 %283, label %288, label %284

; <label>:284:                                    ; preds = %273
  %285 = getelementptr inbounds i8, i8* %260, i64 96
  %286 = bitcast i8* %285 to [10 x %struct.dest_info]*
  %287 = getelementptr inbounds [10 x %struct.dest_info], [10 x %struct.dest_info]* %286, i64 0, i64 %278
  br label %295

; <label>:288:                                    ; preds = %273
  store i64 0, i64* %274, align 8, !tbaa !28
  %289 = bitcast i8* %279 to i64*
  %290 = load i64, i64* %289, align 8, !tbaa !6
  %291 = icmp eq i64 %290, 0
  br i1 %291, label %295, label %292

; <label>:292:                                    ; preds = %288
  %293 = getelementptr inbounds i8, i8* %260, i64 96
  %294 = bitcast i8* %293 to %struct.dest_info*
  br label %295

; <label>:295:                                    ; preds = %292, %288, %284
  %296 = phi %struct.dest_info* [ %287, %284 ], [ %294, %292 ], [ null, %288 ]
  %297 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @services to i8*), i8* nonnull %217, i8* nonnull %260, i64 0) #2
  br label %298

; <label>:298:                                    ; preds = %295, %264
  %299 = phi i64* [ %274, %295 ], [ %272, %264 ]
  %300 = phi %struct.dest_info* [ %296, %295 ], [ %271, %264 ]
  %301 = load i64, i64* %299, align 8, !tbaa !28
  %302 = trunc i64 %301 to i32
  store i32 %302, i32* %6, align 4, !tbaa !2
  %303 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %218, i8* nonnull %219, i64 0) #2
  br label %304

; <label>:304:                                    ; preds = %216, %298
  %305 = phi %struct.dest_info* [ %300, %298 ], [ null, %216 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %219) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %218) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %217) #2
  %306 = icmp eq %struct.dest_info* %305, null
  br i1 %306, label %307, label %351

; <label>:307:                                    ; preds = %304
  %308 = bitcast %struct.log* %20 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %308) #2
  %309 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 4, i64 0
  %310 = bitcast i8* %309 to i64*
  store i64 0, i64* %310, align 4
  %311 = load i32, i32* %14, align 4, !tbaa !2
  %312 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 0
  store i32 %311, i32* %312, align 4, !tbaa !18
  %313 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 1
  store i32 2, i32* %313, align 4, !tbaa !20
  %314 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 2
  store i32 2, i32* %314, align 4, !tbaa !21
  %315 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 3
  store i32 %52, i32* %315, align 4, !tbaa !22
  %316 = load i8, i8* %60, align 1, !tbaa !23
  %317 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 4, i64 0
  store i8 %316, i8* %317, align 4, !tbaa !23
  %318 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %34, i64 0, i32 0, i64 1
  %319 = load i8, i8* %318, align 1, !tbaa !23
  %320 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 4, i64 1
  store i8 %319, i8* %320, align 1, !tbaa !23
  %321 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %34, i64 0, i32 0, i64 2
  %322 = load i8, i8* %321, align 1, !tbaa !23
  %323 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 4, i64 2
  store i8 %322, i8* %323, align 2, !tbaa !23
  %324 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %34, i64 0, i32 0, i64 3
  %325 = load i8, i8* %324, align 1, !tbaa !23
  %326 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 4, i64 3
  store i8 %325, i8* %326, align 1, !tbaa !23
  %327 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %34, i64 0, i32 0, i64 4
  %328 = load i8, i8* %327, align 1, !tbaa !23
  %329 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 4, i64 4
  store i8 %328, i8* %329, align 4, !tbaa !23
  %330 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %34, i64 0, i32 0, i64 5
  %331 = load i8, i8* %330, align 1, !tbaa !23
  %332 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 4, i64 5
  store i8 %331, i8* %332, align 1, !tbaa !23
  %333 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %333, i64* %15, align 8, !tbaa !6
  %334 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %25, i8* nonnull %308, i64 0) #2
  %335 = bitcast i32* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %335)
  store i32 3, i32* %3, align 4, !tbaa !2
  %336 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @system_stats to i8*), i8* nonnull %335) #2
  %337 = bitcast i8* %336 to i64*
  %338 = icmp eq i8* %336, null
  br i1 %338, label %342, label %339

; <label>:339:                                    ; preds = %307
  %340 = load i64, i64* %337, align 8, !tbaa !6
  %341 = add i64 %340, 1
  store i64 %341, i64* %337, align 8, !tbaa !6
  br label %342

; <label>:342:                                    ; preds = %307, %339
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %335)
  %343 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %343)
  store i32 4, i32* %2, align 4, !tbaa !2
  %344 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @system_stats to i8*), i8* nonnull %343) #2
  %345 = bitcast i8* %344 to i64*
  %346 = icmp eq i8* %344, null
  br i1 %346, label %350, label %347

; <label>:347:                                    ; preds = %342
  %348 = load i64, i64* %345, align 8, !tbaa !6
  %349 = add i64 %348, %86
  store i64 %349, i64* %345, align 8, !tbaa !6
  br label %350

; <label>:350:                                    ; preds = %342, %347
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %343)
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %308) #2
  br label %423

; <label>:351:                                    ; preds = %304
  %352 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %305, i64 0, i32 6, i64 0
  %353 = load i8, i8* %352, align 8, !tbaa !23
  store i8 %353, i8* %60, align 1, !tbaa !23
  %354 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %305, i64 0, i32 6, i64 1
  %355 = load i8, i8* %354, align 1, !tbaa !23
  %356 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %34, i64 0, i32 0, i64 1
  store i8 %355, i8* %356, align 1, !tbaa !23
  %357 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %305, i64 0, i32 6, i64 2
  %358 = load i8, i8* %357, align 2, !tbaa !23
  %359 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %34, i64 0, i32 0, i64 2
  store i8 %358, i8* %359, align 1, !tbaa !23
  %360 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %305, i64 0, i32 6, i64 3
  %361 = load i8, i8* %360, align 1, !tbaa !23
  %362 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %34, i64 0, i32 0, i64 3
  store i8 %361, i8* %362, align 1, !tbaa !23
  %363 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %305, i64 0, i32 6, i64 4
  %364 = load i8, i8* %363, align 4, !tbaa !23
  %365 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %34, i64 0, i32 0, i64 4
  store i8 %364, i8* %365, align 1, !tbaa !23
  %366 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %305, i64 0, i32 6, i64 5
  %367 = load i8, i8* %366, align 1, !tbaa !23
  %368 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %34, i64 0, i32 0, i64 5
  store i8 %367, i8* %368, align 1, !tbaa !23
  %369 = bitcast %struct.log* %21 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %369) #2
  call void @llvm.memset.p0i8.i64(i8* nonnull %369, i8 0, i64 24, i32 4, i1 false)
  %370 = load i32, i32* %14, align 4, !tbaa !2
  %371 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 0
  store i32 %370, i32* %371, align 4, !tbaa !18
  %372 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 1
  store i32 1, i32* %372, align 4, !tbaa !20
  %373 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 2
  store i32 0, i32* %373, align 4, !tbaa !21
  %374 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 3
  store i32 %52, i32* %374, align 4, !tbaa !22
  %375 = load i8, i8* %352, align 8, !tbaa !23
  %376 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 4, i64 0
  store i8 %375, i8* %376, align 4, !tbaa !23
  %377 = load i8, i8* %354, align 1, !tbaa !23
  %378 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 4, i64 1
  store i8 %377, i8* %378, align 1, !tbaa !23
  %379 = load i8, i8* %357, align 2, !tbaa !23
  %380 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 4, i64 2
  store i8 %379, i8* %380, align 2, !tbaa !23
  %381 = load i8, i8* %360, align 1, !tbaa !23
  %382 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 4, i64 3
  store i8 %381, i8* %382, align 1, !tbaa !23
  %383 = load i8, i8* %363, align 4, !tbaa !23
  %384 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 4, i64 4
  store i8 %383, i8* %384, align 4, !tbaa !23
  %385 = load i8, i8* %366, align 1, !tbaa !23
  %386 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 4, i64 5
  store i8 %385, i8* %386, align 1, !tbaa !23
  %387 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %387, i64* %15, align 8, !tbaa !6
  %388 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %25, i8* nonnull %369, i64 0) #2
  %389 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %305, i64 0, i32 4
  %390 = atomicrmw add i64* %389, i64 1 seq_cst
  %391 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %305, i64 0, i32 3
  %392 = atomicrmw add i64* %391, i64 %86 seq_cst
  %393 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %305, i64 0, i32 5
  %394 = atomicrmw add i64* %393, i64 0 seq_cst
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %369) #2
  br label %423

; <label>:395:                                    ; preds = %210
  %396 = bitcast %struct.log* %22 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %396) #2
  %397 = getelementptr inbounds %struct.log, %struct.log* %22, i64 0, i32 4, i64 0
  %398 = bitcast i8* %397 to i64*
  store i64 0, i64* %398, align 4
  %399 = load i32, i32* %14, align 4, !tbaa !2
  %400 = getelementptr inbounds %struct.log, %struct.log* %22, i64 0, i32 0
  store i32 %399, i32* %400, align 4, !tbaa !18
  %401 = getelementptr inbounds %struct.log, %struct.log* %22, i64 0, i32 1
  store i32 1, i32* %401, align 4, !tbaa !20
  %402 = getelementptr inbounds %struct.log, %struct.log* %22, i64 0, i32 2
  store i32 0, i32* %402, align 4, !tbaa !21
  %403 = getelementptr inbounds %struct.log, %struct.log* %22, i64 0, i32 3
  store i32 %52, i32* %403, align 4, !tbaa !22
  %404 = load i8, i8* %60, align 1, !tbaa !23
  %405 = getelementptr inbounds %struct.log, %struct.log* %22, i64 0, i32 4, i64 0
  store i8 %404, i8* %405, align 4, !tbaa !23
  %406 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %34, i64 0, i32 0, i64 1
  %407 = load i8, i8* %406, align 1, !tbaa !23
  %408 = getelementptr inbounds %struct.log, %struct.log* %22, i64 0, i32 4, i64 1
  store i8 %407, i8* %408, align 1, !tbaa !23
  %409 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %34, i64 0, i32 0, i64 2
  %410 = load i8, i8* %409, align 1, !tbaa !23
  %411 = getelementptr inbounds %struct.log, %struct.log* %22, i64 0, i32 4, i64 2
  store i8 %410, i8* %411, align 2, !tbaa !23
  %412 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %34, i64 0, i32 0, i64 3
  %413 = load i8, i8* %412, align 1, !tbaa !23
  %414 = getelementptr inbounds %struct.log, %struct.log* %22, i64 0, i32 4, i64 3
  store i8 %413, i8* %414, align 1, !tbaa !23
  %415 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %34, i64 0, i32 0, i64 4
  %416 = load i8, i8* %415, align 1, !tbaa !23
  %417 = getelementptr inbounds %struct.log, %struct.log* %22, i64 0, i32 4, i64 4
  store i8 %416, i8* %417, align 4, !tbaa !23
  %418 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %34, i64 0, i32 0, i64 5
  %419 = load i8, i8* %418, align 1, !tbaa !23
  %420 = getelementptr inbounds %struct.log, %struct.log* %22, i64 0, i32 4, i64 5
  store i8 %419, i8* %420, align 1, !tbaa !23
  %421 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %421, i64* %15, align 8, !tbaa !6
  %422 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %25, i8* nonnull %396, i64 0) #2
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %396) #2
  br label %423

; <label>:423:                                    ; preds = %395, %351, %350
  %424 = phi i32 [ 1, %350 ], [ 3, %351 ], [ 2, %395 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %212) #2
  br label %425

; <label>:425:                                    ; preds = %94, %423, %160, %146
  %426 = phi i32 [ 1, %146 ], [ 2, %160 ], [ %424, %423 ], [ 1, %94 ]
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %53) #2
  br label %427

; <label>:427:                                    ; preds = %425, %41, %37, %1
  %428 = phi i32 [ 2, %1 ], [ 2, %37 ], [ %426, %425 ], [ 2, %41 ]
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %25) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %24) #2
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %23) #2
  ret i32 %428
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i32, i1) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i32, i1) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { nounwind }
attributes #3 = { nounwind readnone }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
!2 = !{!3, !3, i64 0}
!3 = !{!"int", !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
!6 = !{!7, !7, i64 0}
!7 = !{!"long long", !4, i64 0}
!8 = !{!9, !3, i64 4}
!9 = !{!"xdp_md", !3, i64 0, !3, i64 4, !3, i64 8, !3, i64 12, !3, i64 16}
!10 = !{!9, !3, i64 0}
!11 = !{!12, !13, i64 12}
!12 = !{!"ethhdr", !4, i64 0, !4, i64 6, !13, i64 12}
!13 = !{!"short", !4, i64 0}
!14 = !{!15, !3, i64 12}
!15 = !{!"iphdr", !4, i64 0, !4, i64 0, !4, i64 1, !13, i64 2, !13, i64 4, !13, i64 6, !4, i64 8, !4, i64 9, !13, i64 10, !3, i64 12, !3, i64 16}
!16 = !{i32 556300}
!17 = !{!15, !3, i64 16}
!18 = !{!19, !3, i64 0}
!19 = !{!"log", !3, i64 0, !3, i64 4, !3, i64 8, !3, i64 12, !4, i64 16}
!20 = !{!19, !3, i64 4}
!21 = !{!19, !3, i64 8}
!22 = !{!19, !3, i64 12}
!23 = !{!4, !4, i64 0}
!24 = !{!15, !4, i64 9}
!25 = !{!26, !13, i64 0}
!26 = !{!"tcphdr", !13, i64 0, !13, i64 2, !3, i64 4, !3, i64 8, !13, i64 12, !13, i64 12, !13, i64 13, !13, i64 13, !13, i64 13, !13, i64 13, !13, i64 13, !13, i64 13, !13, i64 13, !13, i64 13, !13, i64 14, !13, i64 16, !13, i64 18}
!27 = !{!26, !13, i64 2}
!28 = !{!29, !7, i64 0}
!29 = !{!"service", !7, i64 0, !3, i64 8, !3, i64 12, !4, i64 16, !4, i64 96}
