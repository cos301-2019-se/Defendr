; ModuleID = 'xdp_ddos01_blacklist_kern.c'
source_filename = "xdp_ddos01_blacklist_kern.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.udphdr = type { i16, i16, i16, i16 }
%struct.tcphdr = type { i16, i16, i32, i32, i16, i16, i16, i16 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.iphdr = type { i8, i8, i16, i16, i16, i8, i8, i16, i32, i32 }

@blacklist = global %struct.bpf_map_def { i32 5, i32 4, i32 8, i32 100000, i32 1, i32 0, i32 0 }, section "maps", align 4
@ip_watchlist = global %struct.bpf_map_def { i32 5, i32 4, i32 8, i32 100000, i32 1, i32 0, i32 0 }, section "maps", align 4
@enter_logs = global %struct.bpf_map_def { i32 5, i32 4, i32 8, i32 100000, i32 1, i32 0, i32 0 }, section "maps", align 4
@drop_logs = global %struct.bpf_map_def { i32 5, i32 4, i32 8, i32 100000, i32 1, i32 0, i32 0 }, section "maps", align 4
@pass_logs = global %struct.bpf_map_def { i32 5, i32 4, i32 8, i32 100000, i32 1, i32 0, i32 0 }, section "maps", align 4
@verdict_cnt = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 4, i32 0, i32 0, i32 0 }, section "maps", align 4
@port_blacklist = global %struct.bpf_map_def { i32 6, i32 4, i32 4, i32 65536, i32 0, i32 0, i32 0 }, section "maps", align 4
@port_blacklist_drop_count_tcp = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 65536, i32 0, i32 0, i32 0 }, section "maps", align 4
@port_blacklist_drop_count_udp = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 65536, i32 0, i32 0, i32 0 }, section "maps", align 4
@_license = global [4 x i8] c"GPL\00", section "license", align 1
@llvm.used = appending global [11 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @blacklist to i8*), i8* bitcast (%struct.bpf_map_def* @drop_logs to i8*), i8* bitcast (%struct.bpf_map_def* @enter_logs to i8*), i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* bitcast (%struct.bpf_map_def* @pass_logs to i8*), i8* bitcast (%struct.bpf_map_def* @port_blacklist to i8*), i8* bitcast (%struct.bpf_map_def* @port_blacklist_drop_count_tcp to i8*), i8* bitcast (%struct.bpf_map_def* @port_blacklist_drop_count_udp to i8*), i8* bitcast (%struct.bpf_map_def* @verdict_cnt to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_program to i8*)], section "llvm.metadata"

; Function Attrs: nounwind uwtable
define i32 @parse_port(%struct.xdp_md* nocapture readonly, i8 zeroext, i8* readonly) local_unnamed_addr #0 {
  %4 = alloca i32, align 4
  %5 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %6 = load i32, i32* %5, align 4, !tbaa !2
  %7 = zext i32 %6 to i64
  %8 = bitcast i32* %4 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %8) #3
  switch i8 %1, label %48 [
    i8 17, label %9
    i8 6, label %14
  ]

; <label>:9:                                      ; preds = %3
  %10 = getelementptr inbounds i8, i8* %2, i64 8
  %11 = bitcast i8* %10 to %struct.udphdr*
  %12 = inttoptr i64 %7 to %struct.udphdr*
  %13 = icmp ugt %struct.udphdr* %11, %12
  br i1 %13, label %48, label %19

; <label>:14:                                     ; preds = %3
  %15 = getelementptr inbounds i8, i8* %2, i64 20
  %16 = bitcast i8* %15 to %struct.tcphdr*
  %17 = inttoptr i64 %7 to %struct.tcphdr*
  %18 = icmp ugt %struct.tcphdr* %16, %17
  br i1 %18, label %48, label %19

; <label>:19:                                     ; preds = %14, %9
  %20 = phi i32 [ 1, %9 ], [ 0, %14 ]
  %21 = getelementptr inbounds i8, i8* %2, i64 2
  %22 = bitcast i8* %21 to i16*
  %23 = load i16, i16* %22, align 2, !tbaa !7
  %24 = tail call i16 @llvm.bswap.i16(i16 %23) #3
  %25 = zext i16 %24 to i32
  store i32 %25, i32* %4, align 4, !tbaa !9
  %26 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @port_blacklist to i8*), i8* nonnull %8) #3
  %27 = icmp eq i8* %26, null
  br i1 %27, label %48, label %28

; <label>:28:                                     ; preds = %19
  %29 = bitcast i8* %26 to i32*
  %30 = load i32, i32* %29, align 4, !tbaa !9
  %31 = shl i32 1, %20
  %32 = and i32 %30, %31
  %33 = icmp eq i32 %32, 0
  br i1 %33, label %48, label %34

; <label>:34:                                     ; preds = %28
  %35 = icmp eq i32 %20, 0
  %36 = select i1 %35, %struct.bpf_map_def* @port_blacklist_drop_count_tcp, %struct.bpf_map_def* null
  %37 = icmp eq i32 %20, 1
  %38 = select i1 %37, %struct.bpf_map_def* @port_blacklist_drop_count_udp, %struct.bpf_map_def* %36
  %39 = icmp eq %struct.bpf_map_def* %38, null
  br i1 %39, label %48, label %40

; <label>:40:                                     ; preds = %34
  %41 = bitcast %struct.bpf_map_def* %38 to i8*
  %42 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* %41, i8* nonnull %8) #3
  %43 = bitcast i8* %42 to i32*
  %44 = icmp eq i8* %42, null
  br i1 %44, label %48, label %45

; <label>:45:                                     ; preds = %40
  %46 = load i32, i32* %43, align 4, !tbaa !9
  %47 = add i32 %46, 1
  store i32 %47, i32* %43, align 4, !tbaa !9
  br label %48

; <label>:48:                                     ; preds = %19, %28, %45, %34, %40, %3, %14, %9
  %49 = phi i32 [ 0, %9 ], [ 0, %14 ], [ 2, %3 ], [ 1, %40 ], [ 1, %34 ], [ 1, %45 ], [ 2, %28 ], [ 2, %19 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %8) #3
  ret i32 %49
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1

; Function Attrs: nounwind uwtable
define i32 @xdp_program(%struct.xdp_md* nocapture readonly) #0 section "xdp_prog" {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca i32, align 4
  %9 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %10 = load i32, i32* %9, align 4, !tbaa !2
  %11 = zext i32 %10 to i64
  %12 = inttoptr i64 %11 to i8*
  %13 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0
  %14 = load i32, i32* %13, align 4, !tbaa !10
  %15 = zext i32 %14 to i64
  %16 = inttoptr i64 %15 to %struct.ethhdr*
  %17 = getelementptr %struct.ethhdr, %struct.ethhdr* %16, i64 0, i32 0, i64 14
  %18 = icmp ugt i8* %17, %12
  br i1 %18, label %165, label %19

; <label>:19:                                     ; preds = %1
  %20 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %16, i64 0, i32 2
  %21 = load i16, i16* %20, align 1, !tbaa !11
  %22 = trunc i16 %21 to i8
  %23 = icmp ult i8 %22, 6
  br i1 %23, label %165, label %24, !prof !13

; <label>:24:                                     ; preds = %19
  switch i16 %21, label %32 [
    i16 129, label %25
    i16 -22392, label %25
  ]

; <label>:25:                                     ; preds = %24, %24
  %26 = getelementptr %struct.ethhdr, %struct.ethhdr* %16, i64 0, i32 0, i64 18
  %27 = icmp ugt i8* %26, %12
  br i1 %27, label %165, label %28

; <label>:28:                                     ; preds = %25
  %29 = getelementptr %struct.ethhdr, %struct.ethhdr* %16, i64 0, i32 0, i64 16
  %30 = bitcast i8* %29 to i16*
  %31 = load i16, i16* %30, align 2, !tbaa !14
  br label %32

; <label>:32:                                     ; preds = %28, %24
  %33 = phi i64 [ 14, %24 ], [ 18, %28 ]
  %34 = phi i16 [ %21, %24 ], [ %31, %28 ]
  switch i16 %34, label %44 [
    i16 129, label %35
    i16 -22392, label %35
  ]

; <label>:35:                                     ; preds = %32, %32
  %36 = add nuw nsw i64 %33, 4
  %37 = getelementptr %struct.ethhdr, %struct.ethhdr* %16, i64 0, i32 0, i64 %36
  %38 = icmp ugt i8* %37, %12
  br i1 %38, label %165, label %39

; <label>:39:                                     ; preds = %35
  %40 = getelementptr %struct.ethhdr, %struct.ethhdr* %16, i64 0, i32 0, i64 %33
  %41 = getelementptr inbounds i8, i8* %40, i64 2
  %42 = bitcast i8* %41 to i16*
  %43 = load i16, i16* %42, align 2, !tbaa !14
  br label %44

; <label>:44:                                     ; preds = %39, %32
  %45 = phi i64 [ %33, %32 ], [ %36, %39 ]
  %46 = phi i16 [ %34, %32 ], [ %43, %39 ]
  %47 = icmp eq i16 %46, 8
  br i1 %47, label %48, label %155

; <label>:48:                                     ; preds = %44
  %49 = inttoptr i64 %15 to i8*
  %50 = getelementptr i8, i8* %49, i64 %45
  %51 = bitcast i32* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %51) #3
  %52 = bitcast i64* %4 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %52) #3
  store i64 1, i64* %4, align 8, !tbaa !16
  %53 = bitcast i64* %5 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %53) #3
  store i64 1, i64* %5, align 8, !tbaa !16
  %54 = bitcast i64* %6 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %54) #3
  store i64 1, i64* %6, align 8, !tbaa !16
  %55 = bitcast i64* %7 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %55) #3
  store i64 1, i64* %7, align 8, !tbaa !16
  %56 = getelementptr inbounds i8, i8* %50, i64 20
  %57 = bitcast i8* %56 to %struct.iphdr*
  %58 = inttoptr i64 %11 to %struct.iphdr*
  %59 = icmp ugt %struct.iphdr* %57, %58
  br i1 %59, label %153, label %60

; <label>:60:                                     ; preds = %48
  %61 = getelementptr inbounds i8, i8* %50, i64 12
  %62 = bitcast i8* %61 to i32*
  %63 = load i32, i32* %62, align 4, !tbaa !18
  %64 = tail call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %63) #4, !srcloc !20
  store i32 %64, i32* %3, align 4, !tbaa !9
  %65 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @enter_logs to i8*), i8* nonnull %51) #3
  %66 = bitcast i8* %65 to i64*
  %67 = icmp eq i8* %65, null
  br i1 %67, label %71, label %68

; <label>:68:                                     ; preds = %60
  %69 = load i64, i64* %66, align 8, !tbaa !16
  %70 = add i64 %69, 1
  store i64 %70, i64* %66, align 8, !tbaa !16
  br label %73

; <label>:71:                                     ; preds = %60
  %72 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @enter_logs to i8*), i8* nonnull %51, i8* nonnull %53, i64 1) #3
  br label %73

; <label>:73:                                     ; preds = %71, %68
  %74 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @blacklist to i8*), i8* nonnull %51) #3
  %75 = bitcast i8* %74 to i64*
  %76 = icmp eq i8* %74, null
  br i1 %76, label %88, label %77

; <label>:77:                                     ; preds = %73
  %78 = load i64, i64* %75, align 8, !tbaa !16
  %79 = add i64 %78, 1
  store i64 %79, i64* %75, align 8, !tbaa !16
  %80 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @drop_logs to i8*), i8* nonnull %51) #3
  %81 = bitcast i8* %80 to i64*
  %82 = icmp eq i8* %80, null
  br i1 %82, label %86, label %83

; <label>:83:                                     ; preds = %77
  %84 = load i64, i64* %81, align 8, !tbaa !16
  %85 = add i64 %84, 1
  store i64 %85, i64* %81, align 8, !tbaa !16
  br label %153

; <label>:86:                                     ; preds = %77
  %87 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @drop_logs to i8*), i8* nonnull %51, i8* nonnull %52, i64 1) #3
  br label %153

; <label>:88:                                     ; preds = %73
  %89 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* nonnull %51) #3
  %90 = bitcast i8* %89 to i64*
  %91 = icmp eq i8* %89, null
  br i1 %91, label %95, label %92

; <label>:92:                                     ; preds = %88
  %93 = load i64, i64* %90, align 8, !tbaa !16
  %94 = add i64 %93, 1
  store i64 %94, i64* %90, align 8, !tbaa !16
  br label %97

; <label>:95:                                     ; preds = %88
  %96 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* nonnull %51, i8* nonnull %55, i64 1) #3
  br label %97

; <label>:97:                                     ; preds = %95, %92
  %98 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @pass_logs to i8*), i8* nonnull %51) #3
  %99 = bitcast i8* %98 to i64*
  %100 = icmp eq i8* %98, null
  br i1 %100, label %104, label %101

; <label>:101:                                    ; preds = %97
  %102 = load i64, i64* %99, align 8, !tbaa !16
  %103 = add i64 %102, 1
  store i64 %103, i64* %99, align 8, !tbaa !16
  br label %106

; <label>:104:                                    ; preds = %97
  %105 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @pass_logs to i8*), i8* nonnull %51, i8* nonnull %54, i64 1) #3
  br label %106

; <label>:106:                                    ; preds = %104, %101
  %107 = getelementptr inbounds i8, i8* %50, i64 9
  %108 = load i8, i8* %107, align 1, !tbaa !21
  %109 = load i32, i32* %9, align 4, !tbaa !2
  %110 = zext i32 %109 to i64
  %111 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %111) #3
  switch i8 %108, label %151 [
    i8 17, label %112
    i8 6, label %117
  ]

; <label>:112:                                    ; preds = %106
  %113 = getelementptr inbounds i8, i8* %56, i64 8
  %114 = bitcast i8* %113 to %struct.udphdr*
  %115 = inttoptr i64 %110 to %struct.udphdr*
  %116 = icmp ugt %struct.udphdr* %114, %115
  br i1 %116, label %151, label %122

; <label>:117:                                    ; preds = %106
  %118 = getelementptr inbounds i8, i8* %56, i64 20
  %119 = bitcast i8* %118 to %struct.tcphdr*
  %120 = inttoptr i64 %110 to %struct.tcphdr*
  %121 = icmp ugt %struct.tcphdr* %119, %120
  br i1 %121, label %151, label %122

; <label>:122:                                    ; preds = %117, %112
  %123 = phi i32 [ 1, %112 ], [ 0, %117 ]
  %124 = getelementptr inbounds i8, i8* %56, i64 2
  %125 = bitcast i8* %124 to i16*
  %126 = load i16, i16* %125, align 2, !tbaa !7
  %127 = call i16 @llvm.bswap.i16(i16 %126) #3
  %128 = zext i16 %127 to i32
  store i32 %128, i32* %2, align 4, !tbaa !9
  %129 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @port_blacklist to i8*), i8* nonnull %111) #3
  %130 = icmp eq i8* %129, null
  br i1 %130, label %151, label %131

; <label>:131:                                    ; preds = %122
  %132 = bitcast i8* %129 to i32*
  %133 = load i32, i32* %132, align 4, !tbaa !9
  %134 = shl i32 1, %123
  %135 = and i32 %133, %134
  %136 = icmp eq i32 %135, 0
  br i1 %136, label %151, label %137

; <label>:137:                                    ; preds = %131
  %138 = icmp eq i32 %123, 0
  %139 = select i1 %138, %struct.bpf_map_def* @port_blacklist_drop_count_tcp, %struct.bpf_map_def* null
  %140 = icmp eq i32 %123, 1
  %141 = select i1 %140, %struct.bpf_map_def* @port_blacklist_drop_count_udp, %struct.bpf_map_def* %139
  %142 = icmp eq %struct.bpf_map_def* %141, null
  br i1 %142, label %151, label %143

; <label>:143:                                    ; preds = %137
  %144 = bitcast %struct.bpf_map_def* %141 to i8*
  %145 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* %144, i8* nonnull %111) #3
  %146 = bitcast i8* %145 to i32*
  %147 = icmp eq i8* %145, null
  br i1 %147, label %151, label %148

; <label>:148:                                    ; preds = %143
  %149 = load i32, i32* %146, align 4, !tbaa !9
  %150 = add i32 %149, 1
  store i32 %150, i32* %146, align 4, !tbaa !9
  br label %151

; <label>:151:                                    ; preds = %148, %143, %137, %131, %122, %117, %112, %106
  %152 = phi i32 [ 0, %112 ], [ 0, %117 ], [ 2, %106 ], [ 1, %143 ], [ 1, %137 ], [ 1, %148 ], [ 2, %131 ], [ 2, %122 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %111) #3
  br label %153

; <label>:153:                                    ; preds = %151, %86, %83, %48
  %154 = phi i32 [ %152, %151 ], [ 0, %48 ], [ 1, %86 ], [ 1, %83 ]
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %55) #3
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %54) #3
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %53) #3
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %52) #3
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %51) #3
  br label %155

; <label>:155:                                    ; preds = %153, %44
  %156 = phi i32 [ %154, %153 ], [ 2, %44 ]
  %157 = bitcast i32* %8 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %157)
  store i32 %156, i32* %8, align 4, !tbaa !9
  %158 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @verdict_cnt to i8*), i8* nonnull %157) #3
  %159 = bitcast i8* %158 to i64*
  %160 = icmp eq i8* %158, null
  br i1 %160, label %164, label %161

; <label>:161:                                    ; preds = %155
  %162 = load i64, i64* %159, align 8, !tbaa !16
  %163 = add i64 %162, 1
  store i64 %163, i64* %159, align 8, !tbaa !16
  br label %164

; <label>:164:                                    ; preds = %155, %161
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %157)
  br label %165

; <label>:165:                                    ; preds = %35, %25, %19, %1, %164
  %166 = phi i32 [ %156, %164 ], [ 2, %1 ], [ 2, %19 ], [ 2, %25 ], [ 2, %35 ]
  ret i32 %166
}

; Function Attrs: nounwind readnone speculatable
declare i16 @llvm.bswap.i16(i16) #2

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { nounwind readnone speculatable }
attributes #3 = { nounwind }
attributes #4 = { nounwind readnone }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
!2 = !{!3, !4, i64 4}
!3 = !{!"xdp_md", !4, i64 0, !4, i64 4, !4, i64 8, !4, i64 12, !4, i64 16}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = !{!8, !8, i64 0}
!8 = !{!"short", !5, i64 0}
!9 = !{!4, !4, i64 0}
!10 = !{!3, !4, i64 0}
!11 = !{!12, !8, i64 12}
!12 = !{!"ethhdr", !5, i64 0, !5, i64 6, !8, i64 12}
!13 = !{!"branch_weights", i32 1, i32 2000}
!14 = !{!15, !8, i64 2}
!15 = !{!"vlan_hdr", !8, i64 0, !8, i64 2}
!16 = !{!17, !17, i64 0}
!17 = !{!"long long", !5, i64 0}
!18 = !{!19, !4, i64 12}
!19 = !{!"iphdr", !5, i64 0, !5, i64 0, !5, i64 1, !8, i64 2, !8, i64 4, !8, i64 6, !5, i64 8, !5, i64 9, !8, i64 10, !4, i64 12, !4, i64 16}
!20 = !{i32 537202}
!21 = !{!19, !5, i64 9}
