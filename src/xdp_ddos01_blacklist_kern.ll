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

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1

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
  %12 = alloca i64, align 8
  %13 = alloca i32, align 4
  %14 = alloca i64, align 8
  %15 = alloca %struct.log, align 4
  %16 = alloca %struct.log, align 4
  %17 = alloca %struct.log, align 4
  %18 = alloca i32, align 4
  %19 = alloca %struct.log, align 4
  %20 = alloca %struct.log, align 4
  %21 = alloca %struct.log, align 4
  %22 = bitcast i64* %12 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %22) #2
  store i64 1, i64* %12, align 8, !tbaa !6
  %23 = bitcast i32* %13 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %23) #2
  %24 = bitcast i64* %14 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %24) #2
  %25 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %26 = load i32, i32* %25, align 4, !tbaa !8
  %27 = zext i32 %26 to i64
  %28 = inttoptr i64 %27 to i8*
  %29 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0
  %30 = load i32, i32* %29, align 4, !tbaa !10
  %31 = zext i32 %30 to i64
  %32 = inttoptr i64 %31 to i8*
  %33 = inttoptr i64 %31 to %struct.ethhdr*
  %34 = getelementptr i8, i8* %32, i64 14
  %35 = icmp ugt i8* %34, %28
  br i1 %35, label %401, label %36

; <label>:36:                                     ; preds = %1
  %37 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 2
  %38 = load i16, i16* %37, align 1, !tbaa !11
  %39 = icmp eq i16 %38, 8
  br i1 %39, label %40, label %401

; <label>:40:                                     ; preds = %36
  %41 = getelementptr i8, i8* %32, i64 34
  %42 = icmp ugt i8* %41, %28
  br i1 %42, label %401, label %43

; <label>:43:                                     ; preds = %40
  %44 = getelementptr inbounds i8, i8* %32, i64 26
  %45 = bitcast i8* %44 to i32*
  %46 = load i32, i32* %45, align 4, !tbaa !14
  %47 = tail call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %46) #3, !srcloc !16
  store i32 %47, i32* %13, align 4, !tbaa !2
  %48 = getelementptr inbounds i8, i8* %32, i64 30
  %49 = bitcast i8* %48 to i32*
  %50 = load i32, i32* %49, align 4, !tbaa !17
  %51 = tail call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %50) #3, !srcloc !16
  %52 = bitcast %struct.log* %15 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %52) #2
  %53 = getelementptr inbounds %struct.log, %struct.log* %15, i64 0, i32 4, i64 0
  %54 = bitcast i8* %53 to i64*
  store i64 0, i64* %54, align 4
  %55 = getelementptr inbounds %struct.log, %struct.log* %15, i64 0, i32 0
  store i32 %47, i32* %55, align 4, !tbaa !18
  %56 = getelementptr inbounds %struct.log, %struct.log* %15, i64 0, i32 1
  store i32 0, i32* %56, align 4, !tbaa !20
  %57 = getelementptr inbounds %struct.log, %struct.log* %15, i64 0, i32 2
  store i32 0, i32* %57, align 4, !tbaa !21
  %58 = getelementptr inbounds %struct.log, %struct.log* %15, i64 0, i32 3
  store i32 %51, i32* %58, align 4, !tbaa !22
  %59 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 0
  %60 = load i8, i8* %59, align 1, !tbaa !23
  %61 = getelementptr inbounds %struct.log, %struct.log* %15, i64 0, i32 4, i64 0
  store i8 %60, i8* %61, align 4, !tbaa !23
  %62 = load i8, i8* %59, align 1, !tbaa !23
  %63 = getelementptr inbounds %struct.log, %struct.log* %15, i64 0, i32 4, i64 1
  store i8 %62, i8* %63, align 1, !tbaa !23
  %64 = load i8, i8* %59, align 1, !tbaa !23
  %65 = getelementptr inbounds %struct.log, %struct.log* %15, i64 0, i32 4, i64 2
  store i8 %64, i8* %65, align 2, !tbaa !23
  %66 = load i8, i8* %59, align 1, !tbaa !23
  %67 = getelementptr inbounds %struct.log, %struct.log* %15, i64 0, i32 4, i64 3
  store i8 %66, i8* %67, align 1, !tbaa !23
  %68 = load i8, i8* %59, align 1, !tbaa !23
  %69 = getelementptr inbounds %struct.log, %struct.log* %15, i64 0, i32 4, i64 4
  store i8 %68, i8* %69, align 4, !tbaa !23
  %70 = load i8, i8* %59, align 1, !tbaa !23
  %71 = getelementptr inbounds %struct.log, %struct.log* %15, i64 0, i32 4, i64 5
  store i8 %70, i8* %71, align 1, !tbaa !23
  %72 = tail call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %72, i64* %14, align 8, !tbaa !6
  %73 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %24, i8* nonnull %52, i64 0) #2
  %74 = sub nsw i64 %27, %31
  %75 = bitcast i32* %11 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %75)
  store i32 0, i32* %11, align 4, !tbaa !2
  %76 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @system_stats to i8*), i8* nonnull %75) #2
  %77 = bitcast i8* %76 to i64*
  %78 = icmp eq i8* %76, null
  br i1 %78, label %82, label %79

; <label>:79:                                     ; preds = %43
  %80 = load i64, i64* %77, align 8, !tbaa !6
  %81 = add i64 %80, 1
  store i64 %81, i64* %77, align 8, !tbaa !6
  br label %82

; <label>:82:                                     ; preds = %43, %79
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %75)
  %83 = bitcast i32* %10 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %83)
  store i32 1, i32* %10, align 4, !tbaa !2
  %84 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @system_stats to i8*), i8* nonnull %83) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %83)
  %85 = and i64 %74, 65535
  %86 = bitcast i32* %9 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %86)
  store i32 2, i32* %9, align 4, !tbaa !2
  %87 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @system_stats to i8*), i8* nonnull %86) #2
  %88 = bitcast i8* %87 to i64*
  %89 = icmp eq i8* %87, null
  br i1 %89, label %93, label %90

; <label>:90:                                     ; preds = %82
  %91 = load i64, i64* %88, align 8, !tbaa !6
  %92 = add i64 %91, %85
  store i64 %92, i64* %88, align 8, !tbaa !6
  br label %93

; <label>:93:                                     ; preds = %82, %90
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %86)
  %94 = getelementptr i8, i8* %32, i64 54
  %95 = icmp ugt i8* %94, %28
  br i1 %95, label %399, label %96

; <label>:96:                                     ; preds = %93
  %97 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @blacklist to i8*), i8* nonnull %23) #2
  %98 = bitcast i8* %97 to i64*
  %99 = icmp eq i8* %97, null
  br i1 %99, label %146, label %100

; <label>:100:                                    ; preds = %96
  %101 = load i64, i64* %98, align 8, !tbaa !6
  %102 = add i64 %101, 1
  store i64 %102, i64* %98, align 8, !tbaa !6
  %103 = bitcast %struct.log* %16 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %103) #2
  %104 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 4, i64 0
  %105 = bitcast i8* %104 to i64*
  store i64 0, i64* %105, align 4
  %106 = load i32, i32* %13, align 4, !tbaa !2
  %107 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 0
  store i32 %106, i32* %107, align 4, !tbaa !18
  %108 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 1
  store i32 2, i32* %108, align 4, !tbaa !20
  %109 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 2
  store i32 1, i32* %109, align 4, !tbaa !21
  %110 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 3
  store i32 %51, i32* %110, align 4, !tbaa !22
  %111 = load i8, i8* %59, align 1, !tbaa !23
  %112 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 4, i64 0
  store i8 %111, i8* %112, align 4, !tbaa !23
  %113 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 1
  %114 = load i8, i8* %113, align 1, !tbaa !23
  %115 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 4, i64 1
  store i8 %114, i8* %115, align 1, !tbaa !23
  %116 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 2
  %117 = load i8, i8* %116, align 1, !tbaa !23
  %118 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 4, i64 2
  store i8 %117, i8* %118, align 2, !tbaa !23
  %119 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 3
  %120 = load i8, i8* %119, align 1, !tbaa !23
  %121 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 4, i64 3
  store i8 %120, i8* %121, align 1, !tbaa !23
  %122 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 4
  %123 = load i8, i8* %122, align 1, !tbaa !23
  %124 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 4, i64 4
  store i8 %123, i8* %124, align 4, !tbaa !23
  %125 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 5
  %126 = load i8, i8* %125, align 1, !tbaa !23
  %127 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 4, i64 5
  store i8 %126, i8* %127, align 1, !tbaa !23
  %128 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %128, i64* %14, align 8, !tbaa !6
  %129 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %24, i8* nonnull %103, i64 0) #2
  %130 = bitcast i32* %8 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %130)
  store i32 3, i32* %8, align 4, !tbaa !2
  %131 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @system_stats to i8*), i8* nonnull %130) #2
  %132 = bitcast i8* %131 to i64*
  %133 = icmp eq i8* %131, null
  br i1 %133, label %137, label %134

; <label>:134:                                    ; preds = %100
  %135 = load i64, i64* %132, align 8, !tbaa !6
  %136 = add i64 %135, 1
  store i64 %136, i64* %132, align 8, !tbaa !6
  br label %137

; <label>:137:                                    ; preds = %100, %134
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %130)
  %138 = bitcast i32* %7 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %138)
  store i32 4, i32* %7, align 4, !tbaa !2
  %139 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @system_stats to i8*), i8* nonnull %138) #2
  %140 = bitcast i8* %139 to i64*
  %141 = icmp eq i8* %139, null
  br i1 %141, label %145, label %142

; <label>:142:                                    ; preds = %137
  %143 = load i64, i64* %140, align 8, !tbaa !6
  %144 = add i64 %143, %85
  store i64 %144, i64* %140, align 8, !tbaa !6
  br label %145

; <label>:145:                                    ; preds = %137, %142
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %138)
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %103) #2
  br label %399

; <label>:146:                                    ; preds = %96
  %147 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* nonnull %23) #2
  %148 = bitcast i8* %147 to i64*
  %149 = icmp eq i8* %147, null
  br i1 %149, label %153, label %150

; <label>:150:                                    ; preds = %146
  %151 = load i64, i64* %148, align 8, !tbaa !6
  %152 = add i64 %151, 1
  store i64 %152, i64* %148, align 8, !tbaa !6
  br label %155

; <label>:153:                                    ; preds = %146
  %154 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* nonnull %23, i8* nonnull %22, i64 1) #2
  br label %155

; <label>:155:                                    ; preds = %153, %150
  %156 = getelementptr inbounds i8, i8* %32, i64 23
  %157 = load i8, i8* %156, align 1, !tbaa !24
  %158 = icmp eq i8 %157, 6
  br i1 %158, label %182, label %159

; <label>:159:                                    ; preds = %155
  %160 = bitcast %struct.log* %17 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %160) #2
  %161 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 4, i64 0
  %162 = bitcast i8* %161 to i64*
  store i64 0, i64* %162, align 4
  %163 = load i32, i32* %13, align 4, !tbaa !2
  %164 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 0
  store i32 %163, i32* %164, align 4, !tbaa !18
  %165 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 1
  store i32 1, i32* %165, align 4, !tbaa !20
  %166 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 2
  store i32 4, i32* %166, align 4, !tbaa !21
  %167 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 3
  store i32 %51, i32* %167, align 4, !tbaa !22
  %168 = load i8, i8* %59, align 1, !tbaa !23
  %169 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 4, i64 0
  store i8 %168, i8* %169, align 4, !tbaa !23
  %170 = load i8, i8* %59, align 1, !tbaa !23
  %171 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 4, i64 1
  store i8 %170, i8* %171, align 1, !tbaa !23
  %172 = load i8, i8* %59, align 1, !tbaa !23
  %173 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 4, i64 2
  store i8 %172, i8* %173, align 2, !tbaa !23
  %174 = load i8, i8* %59, align 1, !tbaa !23
  %175 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 4, i64 3
  store i8 %174, i8* %175, align 1, !tbaa !23
  %176 = load i8, i8* %59, align 1, !tbaa !23
  %177 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 4, i64 4
  store i8 %176, i8* %177, align 4, !tbaa !23
  %178 = load i8, i8* %59, align 1, !tbaa !23
  %179 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 4, i64 5
  store i8 %178, i8* %179, align 1, !tbaa !23
  %180 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %180, i64* %14, align 8, !tbaa !6
  %181 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %24, i8* nonnull %160, i64 0) #2
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %160) #2
  br label %399

; <label>:182:                                    ; preds = %155
  %183 = load i32, i32* %45, align 4, !tbaa !14
  %184 = load i32, i32* %49, align 4, !tbaa !17
  %185 = bitcast i8* %41 to i16*
  %186 = load i16, i16* %185, align 4, !tbaa !25
  %187 = getelementptr inbounds i8, i8* %32, i64 36
  %188 = bitcast i8* %187 to i16*
  %189 = load i16, i16* %188, align 2, !tbaa !27
  %190 = bitcast i32* %18 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %190) #2
  %191 = call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %184) #3, !srcloc !16
  store i32 %191, i32* %18, align 4, !tbaa !2
  %192 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @services to i8*), i8* nonnull %190) #2
  %193 = icmp eq i8* %192, null
  br i1 %193, label %369, label %194

; <label>:194:                                    ; preds = %182
  %195 = zext i16 %186 to i32
  %196 = zext i16 %189 to i32
  %197 = shl nuw i32 %196, 16
  %198 = or i32 %197, %195
  %199 = bitcast i32* %4 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %199) #2
  %200 = bitcast i32* %5 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %200) #2
  %201 = bitcast i32* %6 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %201) #2
  store i32 513, i32* %6, align 4, !tbaa !2
  store i32 0, i32* %4, align 4, !tbaa !2
  %202 = add i32 %183, -559038217
  %203 = add i32 %198, -559038217
  %204 = add i32 %184, -559038217
  %205 = xor i32 %203, %204
  %206 = shl i32 %203, 14
  %207 = lshr i32 %203, 18
  %208 = or i32 %207, %206
  %209 = sub i32 %205, %208
  %210 = xor i32 %209, %202
  %211 = shl i32 %209, 11
  %212 = lshr i32 %209, 21
  %213 = or i32 %212, %211
  %214 = sub i32 %210, %213
  %215 = xor i32 %214, %203
  %216 = shl i32 %214, 25
  %217 = lshr i32 %214, 7
  %218 = or i32 %217, %216
  %219 = sub i32 %215, %218
  %220 = xor i32 %219, %209
  %221 = shl i32 %219, 16
  %222 = lshr i32 %219, 16
  %223 = or i32 %222, %221
  %224 = sub i32 %220, %223
  %225 = xor i32 %224, %214
  %226 = shl i32 %224, 4
  %227 = lshr i32 %224, 28
  %228 = or i32 %227, %226
  %229 = sub i32 %225, %228
  %230 = xor i32 %229, %219
  %231 = shl i32 %229, 14
  %232 = lshr i32 %229, 18
  %233 = or i32 %232, %231
  %234 = sub i32 %230, %233
  %235 = xor i32 %234, %224
  %236 = lshr i32 %234, 8
  %237 = sub i32 %235, %236
  %238 = and i32 %237, 511
  store i32 %238, i32* %5, align 4, !tbaa !2
  %239 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %200) #2
  %240 = icmp eq i8* %239, null
  br i1 %240, label %249, label %241

; <label>:241:                                    ; preds = %194
  %242 = bitcast i8* %239 to i32*
  %243 = load i32, i32* %242, align 4, !tbaa !2
  store i32 %243, i32* %6, align 4, !tbaa !2
  %244 = icmp eq i32 %243, 513
  br i1 %244, label %249, label %245

; <label>:245:                                    ; preds = %241
  %246 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %201) #2
  %247 = bitcast i8* %246 to %struct.dest_info*
  %248 = icmp eq i8* %246, null
  br i1 %248, label %249, label %278

; <label>:249:                                    ; preds = %245, %241, %194
  %250 = phi %struct.dest_info* [ %247, %245 ], [ null, %241 ], [ null, %194 ]
  store i32 %191, i32* %4, align 4, !tbaa !2
  %251 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @services to i8*), i8* nonnull %199) #2
  %252 = icmp eq i8* %251, null
  br i1 %252, label %278, label %253

; <label>:253:                                    ; preds = %249
  %254 = bitcast i8* %251 to i64*
  %255 = load i64, i64* %254, align 8, !tbaa !28
  %256 = add i64 %255, 1
  %257 = icmp ult i64 %256, 10
  %258 = select i1 %257, i64 %256, i64 0
  store i64 %258, i64* %254, align 8, !tbaa !28
  %259 = getelementptr inbounds i8, i8* %251, i64 16
  %260 = bitcast i8* %259 to [10 x i64]*
  %261 = getelementptr inbounds [10 x i64], [10 x i64]* %260, i64 0, i64 %258
  %262 = load i64, i64* %261, align 8, !tbaa !6
  %263 = icmp eq i64 %262, 0
  br i1 %263, label %268, label %264

; <label>:264:                                    ; preds = %253
  %265 = getelementptr inbounds i8, i8* %251, i64 96
  %266 = bitcast i8* %265 to [10 x %struct.dest_info]*
  %267 = getelementptr inbounds [10 x %struct.dest_info], [10 x %struct.dest_info]* %266, i64 0, i64 %258
  br label %275

; <label>:268:                                    ; preds = %253
  store i64 0, i64* %254, align 8, !tbaa !28
  %269 = bitcast i8* %259 to i64*
  %270 = load i64, i64* %269, align 8, !tbaa !6
  %271 = icmp eq i64 %270, 0
  br i1 %271, label %275, label %272

; <label>:272:                                    ; preds = %268
  %273 = getelementptr inbounds i8, i8* %251, i64 96
  %274 = bitcast i8* %273 to %struct.dest_info*
  br label %275

; <label>:275:                                    ; preds = %272, %268, %264
  %276 = phi %struct.dest_info* [ %267, %264 ], [ %274, %272 ], [ null, %268 ]
  %277 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @services to i8*), i8* nonnull %199, i8* nonnull %251, i64 0) #2
  br label %278

; <label>:278:                                    ; preds = %245, %249, %275
  %279 = phi %struct.dest_info* [ %247, %245 ], [ %276, %275 ], [ %250, %249 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %201) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %200) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %199) #2
  %280 = icmp eq %struct.dest_info* %279, null
  br i1 %280, label %281, label %325

; <label>:281:                                    ; preds = %278
  %282 = bitcast %struct.log* %19 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %282) #2
  %283 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 4, i64 0
  %284 = bitcast i8* %283 to i64*
  store i64 0, i64* %284, align 4
  %285 = load i32, i32* %13, align 4, !tbaa !2
  %286 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 0
  store i32 %285, i32* %286, align 4, !tbaa !18
  %287 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 1
  store i32 2, i32* %287, align 4, !tbaa !20
  %288 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 2
  store i32 2, i32* %288, align 4, !tbaa !21
  %289 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 3
  store i32 %51, i32* %289, align 4, !tbaa !22
  %290 = load i8, i8* %59, align 1, !tbaa !23
  %291 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 4, i64 0
  store i8 %290, i8* %291, align 4, !tbaa !23
  %292 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 1
  %293 = load i8, i8* %292, align 1, !tbaa !23
  %294 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 4, i64 1
  store i8 %293, i8* %294, align 1, !tbaa !23
  %295 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 2
  %296 = load i8, i8* %295, align 1, !tbaa !23
  %297 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 4, i64 2
  store i8 %296, i8* %297, align 2, !tbaa !23
  %298 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 3
  %299 = load i8, i8* %298, align 1, !tbaa !23
  %300 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 4, i64 3
  store i8 %299, i8* %300, align 1, !tbaa !23
  %301 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 4
  %302 = load i8, i8* %301, align 1, !tbaa !23
  %303 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 4, i64 4
  store i8 %302, i8* %303, align 4, !tbaa !23
  %304 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 5
  %305 = load i8, i8* %304, align 1, !tbaa !23
  %306 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 4, i64 5
  store i8 %305, i8* %306, align 1, !tbaa !23
  %307 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %307, i64* %14, align 8, !tbaa !6
  %308 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %24, i8* nonnull %282, i64 0) #2
  %309 = bitcast i32* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %309)
  store i32 3, i32* %3, align 4, !tbaa !2
  %310 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @system_stats to i8*), i8* nonnull %309) #2
  %311 = bitcast i8* %310 to i64*
  %312 = icmp eq i8* %310, null
  br i1 %312, label %316, label %313

; <label>:313:                                    ; preds = %281
  %314 = load i64, i64* %311, align 8, !tbaa !6
  %315 = add i64 %314, 1
  store i64 %315, i64* %311, align 8, !tbaa !6
  br label %316

; <label>:316:                                    ; preds = %281, %313
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %309)
  %317 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %317)
  store i32 4, i32* %2, align 4, !tbaa !2
  %318 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @system_stats to i8*), i8* nonnull %317) #2
  %319 = bitcast i8* %318 to i64*
  %320 = icmp eq i8* %318, null
  br i1 %320, label %324, label %321

; <label>:321:                                    ; preds = %316
  %322 = load i64, i64* %319, align 8, !tbaa !6
  %323 = add i64 %322, %85
  store i64 %323, i64* %319, align 8, !tbaa !6
  br label %324

; <label>:324:                                    ; preds = %316, %321
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %317)
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %282) #2
  br label %397

; <label>:325:                                    ; preds = %278
  %326 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %279, i64 0, i32 6, i64 0
  %327 = load i8, i8* %326, align 8, !tbaa !23
  store i8 %327, i8* %59, align 1, !tbaa !23
  %328 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %279, i64 0, i32 6, i64 1
  %329 = load i8, i8* %328, align 1, !tbaa !23
  %330 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 1
  store i8 %329, i8* %330, align 1, !tbaa !23
  %331 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %279, i64 0, i32 6, i64 2
  %332 = load i8, i8* %331, align 2, !tbaa !23
  %333 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 2
  store i8 %332, i8* %333, align 1, !tbaa !23
  %334 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %279, i64 0, i32 6, i64 3
  %335 = load i8, i8* %334, align 1, !tbaa !23
  %336 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 3
  store i8 %335, i8* %336, align 1, !tbaa !23
  %337 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %279, i64 0, i32 6, i64 4
  %338 = load i8, i8* %337, align 4, !tbaa !23
  %339 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 4
  store i8 %338, i8* %339, align 1, !tbaa !23
  %340 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %279, i64 0, i32 6, i64 5
  %341 = load i8, i8* %340, align 1, !tbaa !23
  %342 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 5
  store i8 %341, i8* %342, align 1, !tbaa !23
  %343 = bitcast %struct.log* %20 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %343) #2
  call void @llvm.memset.p0i8.i64(i8* nonnull %343, i8 0, i64 24, i32 4, i1 false)
  %344 = load i32, i32* %13, align 4, !tbaa !2
  %345 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 0
  store i32 %344, i32* %345, align 4, !tbaa !18
  %346 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 1
  store i32 1, i32* %346, align 4, !tbaa !20
  %347 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 2
  store i32 0, i32* %347, align 4, !tbaa !21
  %348 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 3
  store i32 %51, i32* %348, align 4, !tbaa !22
  %349 = load i8, i8* %326, align 8, !tbaa !23
  %350 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 4, i64 0
  store i8 %349, i8* %350, align 4, !tbaa !23
  %351 = load i8, i8* %328, align 1, !tbaa !23
  %352 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 4, i64 1
  store i8 %351, i8* %352, align 1, !tbaa !23
  %353 = load i8, i8* %331, align 2, !tbaa !23
  %354 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 4, i64 2
  store i8 %353, i8* %354, align 2, !tbaa !23
  %355 = load i8, i8* %334, align 1, !tbaa !23
  %356 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 4, i64 3
  store i8 %355, i8* %356, align 1, !tbaa !23
  %357 = load i8, i8* %337, align 4, !tbaa !23
  %358 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 4, i64 4
  store i8 %357, i8* %358, align 4, !tbaa !23
  %359 = load i8, i8* %340, align 1, !tbaa !23
  %360 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 4, i64 5
  store i8 %359, i8* %360, align 1, !tbaa !23
  %361 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %361, i64* %14, align 8, !tbaa !6
  %362 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %24, i8* nonnull %343, i64 0) #2
  %363 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %279, i64 0, i32 4
  %364 = atomicrmw add i64* %363, i64 1 seq_cst
  %365 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %279, i64 0, i32 3
  %366 = atomicrmw add i64* %365, i64 %85 seq_cst
  %367 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %279, i64 0, i32 5
  %368 = atomicrmw add i64* %367, i64 0 seq_cst
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %343) #2
  br label %397

; <label>:369:                                    ; preds = %182
  %370 = bitcast %struct.log* %21 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %370) #2
  %371 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 4, i64 0
  %372 = bitcast i8* %371 to i64*
  store i64 0, i64* %372, align 4
  %373 = load i32, i32* %13, align 4, !tbaa !2
  %374 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 0
  store i32 %373, i32* %374, align 4, !tbaa !18
  %375 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 1
  store i32 1, i32* %375, align 4, !tbaa !20
  %376 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 2
  store i32 0, i32* %376, align 4, !tbaa !21
  %377 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 3
  store i32 %51, i32* %377, align 4, !tbaa !22
  %378 = load i8, i8* %59, align 1, !tbaa !23
  %379 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 4, i64 0
  store i8 %378, i8* %379, align 4, !tbaa !23
  %380 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 1
  %381 = load i8, i8* %380, align 1, !tbaa !23
  %382 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 4, i64 1
  store i8 %381, i8* %382, align 1, !tbaa !23
  %383 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 2
  %384 = load i8, i8* %383, align 1, !tbaa !23
  %385 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 4, i64 2
  store i8 %384, i8* %385, align 2, !tbaa !23
  %386 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 3
  %387 = load i8, i8* %386, align 1, !tbaa !23
  %388 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 4, i64 3
  store i8 %387, i8* %388, align 1, !tbaa !23
  %389 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 4
  %390 = load i8, i8* %389, align 1, !tbaa !23
  %391 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 4, i64 4
  store i8 %390, i8* %391, align 4, !tbaa !23
  %392 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 5
  %393 = load i8, i8* %392, align 1, !tbaa !23
  %394 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 4, i64 5
  store i8 %393, i8* %394, align 1, !tbaa !23
  %395 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %395, i64* %14, align 8, !tbaa !6
  %396 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %24, i8* nonnull %370, i64 0) #2
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %370) #2
  br label %397

; <label>:397:                                    ; preds = %369, %325, %324
  %398 = phi i32 [ 1, %324 ], [ 3, %325 ], [ 2, %369 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %190) #2
  br label %399

; <label>:399:                                    ; preds = %93, %397, %159, %145
  %400 = phi i32 [ 1, %145 ], [ 2, %159 ], [ %398, %397 ], [ 1, %93 ]
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %52) #2
  br label %401

; <label>:401:                                    ; preds = %399, %40, %36, %1
  %402 = phi i32 [ 2, %1 ], [ 2, %36 ], [ %400, %399 ], [ 2, %40 ]
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %24) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %23) #2
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %22) #2
  ret i32 %402
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i32, i1) #1

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
!16 = !{i32 557340}
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
