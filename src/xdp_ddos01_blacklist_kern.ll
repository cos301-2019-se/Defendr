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
@services = global %struct.bpf_map_def { i32 1, i32 4, i32 12, i32 512, i32 0, i32 0, i32 0 }, section "maps", align 4
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
  br i1 %35, label %476, label %36

; <label>:36:                                     ; preds = %1
  %37 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 2
  %38 = load i16, i16* %37, align 1, !tbaa !11
  %39 = icmp eq i16 %38, 8
  br i1 %39, label %40, label %476

; <label>:40:                                     ; preds = %36
  %41 = getelementptr i8, i8* %32, i64 34
  %42 = icmp ugt i8* %41, %28
  br i1 %42, label %476, label %43

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
  br i1 %95, label %474, label %96

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
  br label %474

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
  br label %474

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
  br i1 %193, label %444, label %194

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
  br i1 %240, label %244, label %241

; <label>:241:                                    ; preds = %194
  %242 = bitcast i8* %239 to i32*
  %243 = load i32, i32* %242, align 4, !tbaa !2
  store i32 %243, i32* %6, align 4, !tbaa !2
  br label %246

; <label>:244:                                    ; preds = %194
  %245 = load i32, i32* %6, align 4, !tbaa !2
  br label %246

; <label>:246:                                    ; preds = %244, %241
  %247 = phi i32 [ %245, %244 ], [ %243, %241 ]
  %248 = icmp eq i32 %247, 513
  br i1 %248, label %254, label %249

; <label>:249:                                    ; preds = %246
  %250 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %201) #2
  %251 = icmp eq i8* %250, null
  br i1 %251, label %254, label %252

; <label>:252:                                    ; preds = %249
  %253 = bitcast i8* %250 to %struct.dest_info*
  br label %353

; <label>:254:                                    ; preds = %249, %246
  store i32 %191, i32* %4, align 4, !tbaa !2
  %255 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @services to i8*), i8* nonnull %199) #2
  %256 = icmp eq i8* %255, null
  br i1 %256, label %353, label %257

; <label>:257:                                    ; preds = %254
  %258 = getelementptr inbounds i8, i8* %255, i64 8
  %259 = bitcast i8* %258 to i32*
  %260 = load i32, i32* %259, align 4, !tbaa !28
  %261 = zext i32 %260 to i64
  %262 = bitcast i8* %255 to i32*
  %263 = load i32, i32* %262, align 4, !tbaa !30
  %264 = add i32 %260, 1
  %265 = add i32 %264, %263
  %266 = add nuw nsw i64 %261, 10
  %267 = zext i32 %265 to i64
  %268 = icmp ugt i64 %266, %267
  %269 = select i1 %268, i32 %265, i32 %264
  store i32 %269, i32* %6, align 4, !tbaa !2
  %270 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %201) #2
  %271 = icmp eq i8* %270, null
  br i1 %271, label %272, label %280

; <label>:272:                                    ; preds = %257
  %273 = load i32, i32* %6, align 4, !tbaa !2
  %274 = add i32 %273, 1
  %275 = zext i32 %274 to i64
  %276 = icmp ugt i64 %266, %275
  %277 = select i1 %276, i32 %274, i32 %264
  store i32 %277, i32* %6, align 4, !tbaa !2
  %278 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %201) #2
  %279 = icmp eq i8* %278, null
  br i1 %279, label %286, label %280

; <label>:280:                                    ; preds = %342, %334, %326, %318, %310, %302, %294, %286, %272, %257
  %281 = phi i8* [ %270, %257 ], [ %278, %272 ], [ %292, %286 ], [ %300, %294 ], [ %308, %302 ], [ %316, %310 ], [ %324, %318 ], [ %332, %326 ], [ %340, %334 ], [ %348, %342 ]
  %282 = bitcast i8* %281 to %struct.dest_info*
  %283 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %200, i8* nonnull %201, i64 0) #2
  %284 = load i32, i32* %262, align 4, !tbaa !30
  %285 = add i32 %284, 1
  store i32 %285, i32* %262, align 4, !tbaa !30
  br label %353

; <label>:286:                                    ; preds = %272
  %287 = load i32, i32* %6, align 4, !tbaa !2
  %288 = add i32 %287, 1
  %289 = zext i32 %288 to i64
  %290 = icmp ugt i64 %266, %289
  %291 = select i1 %290, i32 %288, i32 %264
  store i32 %291, i32* %6, align 4, !tbaa !2
  %292 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %201) #2
  %293 = icmp eq i8* %292, null
  br i1 %293, label %294, label %280

; <label>:294:                                    ; preds = %286
  %295 = load i32, i32* %6, align 4, !tbaa !2
  %296 = add i32 %295, 1
  %297 = zext i32 %296 to i64
  %298 = icmp ugt i64 %266, %297
  %299 = select i1 %298, i32 %296, i32 %264
  store i32 %299, i32* %6, align 4, !tbaa !2
  %300 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %201) #2
  %301 = icmp eq i8* %300, null
  br i1 %301, label %302, label %280

; <label>:302:                                    ; preds = %294
  %303 = load i32, i32* %6, align 4, !tbaa !2
  %304 = add i32 %303, 1
  %305 = zext i32 %304 to i64
  %306 = icmp ugt i64 %266, %305
  %307 = select i1 %306, i32 %304, i32 %264
  store i32 %307, i32* %6, align 4, !tbaa !2
  %308 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %201) #2
  %309 = icmp eq i8* %308, null
  br i1 %309, label %310, label %280

; <label>:310:                                    ; preds = %302
  %311 = load i32, i32* %6, align 4, !tbaa !2
  %312 = add i32 %311, 1
  %313 = zext i32 %312 to i64
  %314 = icmp ugt i64 %266, %313
  %315 = select i1 %314, i32 %312, i32 %264
  store i32 %315, i32* %6, align 4, !tbaa !2
  %316 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %201) #2
  %317 = icmp eq i8* %316, null
  br i1 %317, label %318, label %280

; <label>:318:                                    ; preds = %310
  %319 = load i32, i32* %6, align 4, !tbaa !2
  %320 = add i32 %319, 1
  %321 = zext i32 %320 to i64
  %322 = icmp ugt i64 %266, %321
  %323 = select i1 %322, i32 %320, i32 %264
  store i32 %323, i32* %6, align 4, !tbaa !2
  %324 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %201) #2
  %325 = icmp eq i8* %324, null
  br i1 %325, label %326, label %280

; <label>:326:                                    ; preds = %318
  %327 = load i32, i32* %6, align 4, !tbaa !2
  %328 = add i32 %327, 1
  %329 = zext i32 %328 to i64
  %330 = icmp ugt i64 %266, %329
  %331 = select i1 %330, i32 %328, i32 %264
  store i32 %331, i32* %6, align 4, !tbaa !2
  %332 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %201) #2
  %333 = icmp eq i8* %332, null
  br i1 %333, label %334, label %280

; <label>:334:                                    ; preds = %326
  %335 = load i32, i32* %6, align 4, !tbaa !2
  %336 = add i32 %335, 1
  %337 = zext i32 %336 to i64
  %338 = icmp ugt i64 %266, %337
  %339 = select i1 %338, i32 %336, i32 %264
  store i32 %339, i32* %6, align 4, !tbaa !2
  %340 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %201) #2
  %341 = icmp eq i8* %340, null
  br i1 %341, label %342, label %280

; <label>:342:                                    ; preds = %334
  %343 = load i32, i32* %6, align 4, !tbaa !2
  %344 = add i32 %343, 1
  %345 = zext i32 %344 to i64
  %346 = icmp ugt i64 %266, %345
  %347 = select i1 %346, i32 %344, i32 %264
  store i32 %347, i32* %6, align 4, !tbaa !2
  %348 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %201) #2
  %349 = icmp eq i8* %348, null
  br i1 %349, label %350, label %280

; <label>:350:                                    ; preds = %342
  %351 = load i32, i32* %6, align 4, !tbaa !2
  %352 = add i32 %351, 1
  store i32 %352, i32* %6, align 4, !tbaa !2
  br label %353

; <label>:353:                                    ; preds = %252, %254, %280, %350
  %354 = phi %struct.dest_info* [ %253, %252 ], [ %282, %280 ], [ null, %254 ], [ null, %350 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %201) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %200) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %199) #2
  %355 = icmp eq %struct.dest_info* %354, null
  br i1 %355, label %356, label %400

; <label>:356:                                    ; preds = %353
  %357 = bitcast %struct.log* %19 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %357) #2
  %358 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 4, i64 0
  %359 = bitcast i8* %358 to i64*
  store i64 0, i64* %359, align 4
  %360 = load i32, i32* %13, align 4, !tbaa !2
  %361 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 0
  store i32 %360, i32* %361, align 4, !tbaa !18
  %362 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 1
  store i32 2, i32* %362, align 4, !tbaa !20
  %363 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 2
  store i32 2, i32* %363, align 4, !tbaa !21
  %364 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 3
  store i32 %51, i32* %364, align 4, !tbaa !22
  %365 = load i8, i8* %59, align 1, !tbaa !23
  %366 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 4, i64 0
  store i8 %365, i8* %366, align 4, !tbaa !23
  %367 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 1
  %368 = load i8, i8* %367, align 1, !tbaa !23
  %369 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 4, i64 1
  store i8 %368, i8* %369, align 1, !tbaa !23
  %370 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 2
  %371 = load i8, i8* %370, align 1, !tbaa !23
  %372 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 4, i64 2
  store i8 %371, i8* %372, align 2, !tbaa !23
  %373 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 3
  %374 = load i8, i8* %373, align 1, !tbaa !23
  %375 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 4, i64 3
  store i8 %374, i8* %375, align 1, !tbaa !23
  %376 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 4
  %377 = load i8, i8* %376, align 1, !tbaa !23
  %378 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 4, i64 4
  store i8 %377, i8* %378, align 4, !tbaa !23
  %379 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 5
  %380 = load i8, i8* %379, align 1, !tbaa !23
  %381 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 4, i64 5
  store i8 %380, i8* %381, align 1, !tbaa !23
  %382 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %382, i64* %14, align 8, !tbaa !6
  %383 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %24, i8* nonnull %357, i64 0) #2
  %384 = bitcast i32* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %384)
  store i32 3, i32* %3, align 4, !tbaa !2
  %385 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @system_stats to i8*), i8* nonnull %384) #2
  %386 = bitcast i8* %385 to i64*
  %387 = icmp eq i8* %385, null
  br i1 %387, label %391, label %388

; <label>:388:                                    ; preds = %356
  %389 = load i64, i64* %386, align 8, !tbaa !6
  %390 = add i64 %389, 1
  store i64 %390, i64* %386, align 8, !tbaa !6
  br label %391

; <label>:391:                                    ; preds = %356, %388
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %384)
  %392 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %392)
  store i32 4, i32* %2, align 4, !tbaa !2
  %393 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @system_stats to i8*), i8* nonnull %392) #2
  %394 = bitcast i8* %393 to i64*
  %395 = icmp eq i8* %393, null
  br i1 %395, label %399, label %396

; <label>:396:                                    ; preds = %391
  %397 = load i64, i64* %394, align 8, !tbaa !6
  %398 = add i64 %397, %85
  store i64 %398, i64* %394, align 8, !tbaa !6
  br label %399

; <label>:399:                                    ; preds = %391, %396
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %392)
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %357) #2
  br label %472

; <label>:400:                                    ; preds = %353
  %401 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %354, i64 0, i32 6, i64 0
  %402 = load i8, i8* %401, align 8, !tbaa !23
  store i8 %402, i8* %59, align 1, !tbaa !23
  %403 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %354, i64 0, i32 6, i64 1
  %404 = load i8, i8* %403, align 1, !tbaa !23
  %405 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 1
  store i8 %404, i8* %405, align 1, !tbaa !23
  %406 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %354, i64 0, i32 6, i64 2
  %407 = load i8, i8* %406, align 2, !tbaa !23
  %408 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 2
  store i8 %407, i8* %408, align 1, !tbaa !23
  %409 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %354, i64 0, i32 6, i64 3
  %410 = load i8, i8* %409, align 1, !tbaa !23
  %411 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 3
  store i8 %410, i8* %411, align 1, !tbaa !23
  %412 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %354, i64 0, i32 6, i64 4
  %413 = load i8, i8* %412, align 4, !tbaa !23
  %414 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 4
  store i8 %413, i8* %414, align 1, !tbaa !23
  %415 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %354, i64 0, i32 6, i64 5
  %416 = load i8, i8* %415, align 1, !tbaa !23
  %417 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 5
  store i8 %416, i8* %417, align 1, !tbaa !23
  %418 = bitcast %struct.log* %20 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %418) #2
  call void @llvm.memset.p0i8.i64(i8* nonnull %418, i8 0, i64 24, i32 4, i1 false)
  %419 = load i32, i32* %13, align 4, !tbaa !2
  %420 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 0
  store i32 %419, i32* %420, align 4, !tbaa !18
  %421 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 1
  store i32 1, i32* %421, align 4, !tbaa !20
  %422 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 2
  store i32 0, i32* %422, align 4, !tbaa !21
  %423 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 3
  store i32 %51, i32* %423, align 4, !tbaa !22
  %424 = load i8, i8* %401, align 8, !tbaa !23
  %425 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 4, i64 0
  store i8 %424, i8* %425, align 4, !tbaa !23
  %426 = load i8, i8* %403, align 1, !tbaa !23
  %427 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 4, i64 1
  store i8 %426, i8* %427, align 1, !tbaa !23
  %428 = load i8, i8* %406, align 2, !tbaa !23
  %429 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 4, i64 2
  store i8 %428, i8* %429, align 2, !tbaa !23
  %430 = load i8, i8* %409, align 1, !tbaa !23
  %431 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 4, i64 3
  store i8 %430, i8* %431, align 1, !tbaa !23
  %432 = load i8, i8* %412, align 4, !tbaa !23
  %433 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 4, i64 4
  store i8 %432, i8* %433, align 4, !tbaa !23
  %434 = load i8, i8* %415, align 1, !tbaa !23
  %435 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 4, i64 5
  store i8 %434, i8* %435, align 1, !tbaa !23
  %436 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %436, i64* %14, align 8, !tbaa !6
  %437 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %24, i8* nonnull %418, i64 0) #2
  %438 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %354, i64 0, i32 4
  %439 = atomicrmw add i64* %438, i64 1 seq_cst
  %440 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %354, i64 0, i32 3
  %441 = atomicrmw add i64* %440, i64 %85 seq_cst
  %442 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %354, i64 0, i32 5
  %443 = atomicrmw add i64* %442, i64 0 seq_cst
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %418) #2
  br label %472

; <label>:444:                                    ; preds = %182
  %445 = bitcast %struct.log* %21 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %445) #2
  %446 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 4, i64 0
  %447 = bitcast i8* %446 to i64*
  store i64 0, i64* %447, align 4
  %448 = load i32, i32* %13, align 4, !tbaa !2
  %449 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 0
  store i32 %448, i32* %449, align 4, !tbaa !18
  %450 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 1
  store i32 1, i32* %450, align 4, !tbaa !20
  %451 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 2
  store i32 0, i32* %451, align 4, !tbaa !21
  %452 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 3
  store i32 %51, i32* %452, align 4, !tbaa !22
  %453 = load i8, i8* %59, align 1, !tbaa !23
  %454 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 4, i64 0
  store i8 %453, i8* %454, align 4, !tbaa !23
  %455 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 1
  %456 = load i8, i8* %455, align 1, !tbaa !23
  %457 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 4, i64 1
  store i8 %456, i8* %457, align 1, !tbaa !23
  %458 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 2
  %459 = load i8, i8* %458, align 1, !tbaa !23
  %460 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 4, i64 2
  store i8 %459, i8* %460, align 2, !tbaa !23
  %461 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 3
  %462 = load i8, i8* %461, align 1, !tbaa !23
  %463 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 4, i64 3
  store i8 %462, i8* %463, align 1, !tbaa !23
  %464 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 4
  %465 = load i8, i8* %464, align 1, !tbaa !23
  %466 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 4, i64 4
  store i8 %465, i8* %466, align 4, !tbaa !23
  %467 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %33, i64 0, i32 0, i64 5
  %468 = load i8, i8* %467, align 1, !tbaa !23
  %469 = getelementptr inbounds %struct.log, %struct.log* %21, i64 0, i32 4, i64 5
  store i8 %468, i8* %469, align 1, !tbaa !23
  %470 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %470, i64* %14, align 8, !tbaa !6
  %471 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %24, i8* nonnull %445, i64 0) #2
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %445) #2
  br label %472

; <label>:472:                                    ; preds = %444, %400, %399
  %473 = phi i32 [ 1, %399 ], [ 3, %400 ], [ 2, %444 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %190) #2
  br label %474

; <label>:474:                                    ; preds = %93, %472, %159, %145
  %475 = phi i32 [ 1, %145 ], [ 2, %159 ], [ %473, %472 ], [ 1, %93 ]
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %52) #2
  br label %476

; <label>:476:                                    ; preds = %474, %40, %36, %1
  %477 = phi i32 [ 2, %1 ], [ 2, %36 ], [ %475, %474 ], [ 2, %40 ]
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %24) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %23) #2
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %22) #2
  ret i32 %477
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
!16 = !{i32 556434}
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
!28 = !{!29, !3, i64 8}
!29 = !{!"service", !3, i64 0, !3, i64 4, !3, i64 8}
!30 = !{!29, !3, i64 0}
