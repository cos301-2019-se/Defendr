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
  br i1 %18, label %161, label %19

; <label>:19:                                     ; preds = %1
  %20 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %16, i64 0, i32 2
  %21 = load i16, i16* %20, align 1, !tbaa !11
  %22 = trunc i16 %21 to i8
  %23 = icmp ult i8 %22, 6
  br i1 %23, label %161, label %24, !prof !13

; <label>:24:                                     ; preds = %19
  switch i16 %21, label %32 [
    i16 129, label %25
    i16 -22392, label %25
  ]

; <label>:25:                                     ; preds = %24, %24
  %26 = getelementptr %struct.ethhdr, %struct.ethhdr* %16, i64 0, i32 0, i64 18
  %27 = icmp ugt i8* %26, %12
  br i1 %27, label %161, label %28

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
  br i1 %38, label %161, label %39

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
  br i1 %47, label %48, label %151

; <label>:48:                                     ; preds = %44
  %49 = inttoptr i64 %15 to i8*
  %50 = getelementptr i8, i8* %49, i64 %45
  %51 = bitcast i32* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %51) #3
  %52 = bitcast i64* %4 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %52) #3
  store i64 0, i64* %4, align 8, !tbaa !16
  %53 = bitcast i64* %5 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %53) #3
  store i64 0, i64* %5, align 8, !tbaa !16
  %54 = bitcast i64* %6 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %54) #3
  store i64 0, i64* %6, align 8, !tbaa !16
  %55 = bitcast i64* %7 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %55) #3
  store i64 0, i64* %7, align 8, !tbaa !16
  %56 = getelementptr inbounds i8, i8* %50, i64 20
  %57 = bitcast i8* %56 to %struct.iphdr*
  %58 = inttoptr i64 %11 to %struct.iphdr*
  %59 = icmp ugt %struct.iphdr* %57, %58
  br i1 %59, label %149, label %60

; <label>:60:                                     ; preds = %48
  %61 = getelementptr inbounds i8, i8* %50, i64 12
  %62 = bitcast i8* %61 to i32*
  %63 = load i32, i32* %62, align 4, !tbaa !18
  %64 = tail call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %63) #4, !srcloc !20
  store i32 %64, i32* %3, align 4, !tbaa !9
  %65 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @enter_logs to i8*), i8* nonnull %51, i8* nonnull %53, i64 1) #3
  %66 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @enter_logs to i8*), i8* nonnull %51) #3
  %67 = bitcast i8* %66 to i64*
  %68 = icmp eq i8* %66, null
  br i1 %68, label %72, label %69

; <label>:69:                                     ; preds = %60
  %70 = load i64, i64* %67, align 8, !tbaa !16
  %71 = add i64 %70, 1
  store i64 %71, i64* %67, align 8, !tbaa !16
  br label %72

; <label>:72:                                     ; preds = %69, %60
  %73 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @blacklist to i8*), i8* nonnull %51) #3
  %74 = bitcast i8* %73 to i64*
  %75 = icmp eq i8* %73, null
  br i1 %75, label %86, label %76

; <label>:76:                                     ; preds = %72
  %77 = load i64, i64* %74, align 8, !tbaa !16
  %78 = add i64 %77, 1
  store i64 %78, i64* %74, align 8, !tbaa !16
  %79 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @drop_logs to i8*), i8* nonnull %51, i8* nonnull %52, i64 1) #3
  %80 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @drop_logs to i8*), i8* nonnull %51) #3
  %81 = bitcast i8* %80 to i64*
  %82 = icmp eq i8* %80, null
  br i1 %82, label %149, label %83

; <label>:83:                                     ; preds = %76
  %84 = load i64, i64* %81, align 8, !tbaa !16
  %85 = add i64 %84, 1
  store i64 %85, i64* %81, align 8, !tbaa !16
  br label %149

; <label>:86:                                     ; preds = %72
  %87 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* nonnull %51, i8* nonnull %55, i64 1) #3
  %88 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* nonnull %51) #3
  %89 = bitcast i8* %88 to i64*
  %90 = icmp eq i8* %88, null
  br i1 %90, label %94, label %91

; <label>:91:                                     ; preds = %86
  %92 = load i64, i64* %89, align 8, !tbaa !16
  %93 = add i64 %92, 1
  store i64 %93, i64* %89, align 8, !tbaa !16
  br label %94

; <label>:94:                                     ; preds = %91, %86
  %95 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @pass_logs to i8*), i8* nonnull %51, i8* nonnull %54, i64 1) #3
  %96 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @pass_logs to i8*), i8* nonnull %51) #3
  %97 = bitcast i8* %96 to i64*
  %98 = icmp eq i8* %96, null
  br i1 %98, label %102, label %99

; <label>:99:                                     ; preds = %94
  %100 = load i64, i64* %97, align 8, !tbaa !16
  %101 = add i64 %100, 1
  store i64 %101, i64* %97, align 8, !tbaa !16
  br label %102

; <label>:102:                                    ; preds = %99, %94
  %103 = getelementptr inbounds i8, i8* %50, i64 9
  %104 = load i8, i8* %103, align 1, !tbaa !21
  %105 = load i32, i32* %9, align 4, !tbaa !2
  %106 = zext i32 %105 to i64
  %107 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %107) #3
  switch i8 %104, label %147 [
    i8 17, label %108
    i8 6, label %113
  ]

; <label>:108:                                    ; preds = %102
  %109 = getelementptr inbounds i8, i8* %56, i64 8
  %110 = bitcast i8* %109 to %struct.udphdr*
  %111 = inttoptr i64 %106 to %struct.udphdr*
  %112 = icmp ugt %struct.udphdr* %110, %111
  br i1 %112, label %147, label %118

; <label>:113:                                    ; preds = %102
  %114 = getelementptr inbounds i8, i8* %56, i64 20
  %115 = bitcast i8* %114 to %struct.tcphdr*
  %116 = inttoptr i64 %106 to %struct.tcphdr*
  %117 = icmp ugt %struct.tcphdr* %115, %116
  br i1 %117, label %147, label %118

; <label>:118:                                    ; preds = %113, %108
  %119 = phi i32 [ 1, %108 ], [ 0, %113 ]
  %120 = getelementptr inbounds i8, i8* %56, i64 2
  %121 = bitcast i8* %120 to i16*
  %122 = load i16, i16* %121, align 2, !tbaa !7
  %123 = call i16 @llvm.bswap.i16(i16 %122) #3
  %124 = zext i16 %123 to i32
  store i32 %124, i32* %2, align 4, !tbaa !9
  %125 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @port_blacklist to i8*), i8* nonnull %107) #3
  %126 = icmp eq i8* %125, null
  br i1 %126, label %147, label %127

; <label>:127:                                    ; preds = %118
  %128 = bitcast i8* %125 to i32*
  %129 = load i32, i32* %128, align 4, !tbaa !9
  %130 = shl i32 1, %119
  %131 = and i32 %129, %130
  %132 = icmp eq i32 %131, 0
  br i1 %132, label %147, label %133

; <label>:133:                                    ; preds = %127
  %134 = icmp eq i32 %119, 0
  %135 = select i1 %134, %struct.bpf_map_def* @port_blacklist_drop_count_tcp, %struct.bpf_map_def* null
  %136 = icmp eq i32 %119, 1
  %137 = select i1 %136, %struct.bpf_map_def* @port_blacklist_drop_count_udp, %struct.bpf_map_def* %135
  %138 = icmp eq %struct.bpf_map_def* %137, null
  br i1 %138, label %147, label %139

; <label>:139:                                    ; preds = %133
  %140 = bitcast %struct.bpf_map_def* %137 to i8*
  %141 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* %140, i8* nonnull %107) #3
  %142 = bitcast i8* %141 to i32*
  %143 = icmp eq i8* %141, null
  br i1 %143, label %147, label %144

; <label>:144:                                    ; preds = %139
  %145 = load i32, i32* %142, align 4, !tbaa !9
  %146 = add i32 %145, 1
  store i32 %146, i32* %142, align 4, !tbaa !9
  br label %147

; <label>:147:                                    ; preds = %144, %139, %133, %127, %118, %113, %108, %102
  %148 = phi i32 [ 0, %108 ], [ 0, %113 ], [ 2, %102 ], [ 1, %139 ], [ 1, %133 ], [ 1, %144 ], [ 2, %127 ], [ 2, %118 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %107) #3
  br label %149

; <label>:149:                                    ; preds = %147, %83, %76, %48
  %150 = phi i32 [ %148, %147 ], [ 0, %48 ], [ 1, %76 ], [ 1, %83 ]
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %55) #3
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %54) #3
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %53) #3
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %52) #3
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %51) #3
  br label %151

; <label>:151:                                    ; preds = %149, %44
  %152 = phi i32 [ %150, %149 ], [ 2, %44 ]
  %153 = bitcast i32* %8 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %153)
  store i32 %152, i32* %8, align 4, !tbaa !9
  %154 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @verdict_cnt to i8*), i8* nonnull %153) #3
  %155 = bitcast i8* %154 to i64*
  %156 = icmp eq i8* %154, null
  br i1 %156, label %160, label %157

; <label>:157:                                    ; preds = %151
  %158 = load i64, i64* %155, align 8, !tbaa !16
  %159 = add i64 %158, 1
  store i64 %159, i64* %155, align 8, !tbaa !16
  br label %160

; <label>:160:                                    ; preds = %151, %157
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %153)
  br label %161

; <label>:161:                                    ; preds = %35, %25, %19, %1, %160
  %162 = phi i32 [ %152, %160 ], [ 2, %1 ], [ 2, %19 ], [ 2, %25 ], [ 2, %35 ]
  ret i32 %162
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
!20 = !{i32 537155}
!21 = !{!19, !5, i64 9}
