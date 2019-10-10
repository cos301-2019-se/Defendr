; ModuleID = 'defendr_xdp_kern.c'
source_filename = "defendr_xdp_kern.c"
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
@services = global %struct.bpf_map_def { i32 1, i32 4, i32 576, i32 512, i32 0, i32 0, i32 0 }, section "maps", align 4
@destinations = global %struct.bpf_map_def { i32 1, i32 4, i32 4, i32 512, i32 0, i32 0, i32 0 }, section "maps", align 4
@system_stats = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 5, i32 0, i32 0, i32 0 }, section "maps", align 4
@_license = global [4 x i8] c"GPL\00", section "license", align 1
@llvm.used = appending global [9 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @blacklist to i8*), i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* bitcast (%struct.bpf_map_def* @services to i8*), i8* bitcast (%struct.bpf_map_def* @system_stats to i8*), i8* bitcast (%struct.bpf_map_def* @whitelist to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_program to i8*)], section "llvm.metadata"

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
  %12 = alloca i32, align 4
  %13 = alloca i64, align 8
  %14 = alloca i32, align 4
  %15 = alloca i64, align 8
  %16 = alloca %struct.log, align 4
  %17 = alloca i32, align 4
  %18 = alloca %struct.log, align 4
  %19 = alloca %struct.log, align 4
  %20 = alloca %struct.log, align 4
  %21 = bitcast i64* %13 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %21) #2
  store i64 1, i64* %13, align 8, !tbaa !6
  %22 = bitcast i32* %14 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %22) #2
  %23 = bitcast i64* %15 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %23) #2
  %24 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %25 = load i32, i32* %24, align 4, !tbaa !8
  %26 = zext i32 %25 to i64
  %27 = inttoptr i64 %26 to i8*
  %28 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0
  %29 = load i32, i32* %28, align 4, !tbaa !10
  %30 = zext i32 %29 to i64
  %31 = inttoptr i64 %30 to i8*
  %32 = inttoptr i64 %30 to %struct.ethhdr*
  %33 = getelementptr i8, i8* %31, i64 14
  %34 = icmp ugt i8* %33, %27
  br i1 %34, label %376, label %35

; <label>:35:                                     ; preds = %1
  %36 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %32, i64 0, i32 2
  %37 = load i16, i16* %36, align 1, !tbaa !11
  %38 = icmp eq i16 %37, 8
  br i1 %38, label %39, label %376

; <label>:39:                                     ; preds = %35
  %40 = getelementptr i8, i8* %31, i64 34
  %41 = icmp ugt i8* %40, %27
  br i1 %41, label %376, label %42

; <label>:42:                                     ; preds = %39
  %43 = getelementptr inbounds i8, i8* %31, i64 26
  %44 = bitcast i8* %43 to i32*
  %45 = load i32, i32* %44, align 4, !tbaa !14
  %46 = tail call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %45) #3, !srcloc !16
  store i32 %46, i32* %14, align 4, !tbaa !2
  %47 = getelementptr inbounds i8, i8* %31, i64 30
  %48 = bitcast i8* %47 to i32*
  %49 = load i32, i32* %48, align 4, !tbaa !17
  %50 = tail call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %49) #3, !srcloc !16
  %51 = sub nsw i64 %26, %30
  %52 = bitcast i32* %12 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %52)
  store i32 0, i32* %12, align 4, !tbaa !2
  %53 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @system_stats to i8*), i8* nonnull %52) #2
  %54 = bitcast i8* %53 to i64*
  %55 = icmp eq i8* %53, null
  br i1 %55, label %59, label %56

; <label>:56:                                     ; preds = %42
  %57 = load i64, i64* %54, align 8, !tbaa !6
  %58 = add i64 %57, 1
  store i64 %58, i64* %54, align 8, !tbaa !6
  br label %59

; <label>:59:                                     ; preds = %42, %56
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %52)
  %60 = bitcast i32* %11 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %60)
  store i32 1, i32* %11, align 4, !tbaa !2
  %61 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @system_stats to i8*), i8* nonnull %60) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %60)
  %62 = and i64 %51, 65535
  %63 = bitcast i32* %10 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %63)
  store i32 2, i32* %10, align 4, !tbaa !2
  %64 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @system_stats to i8*), i8* nonnull %63) #2
  %65 = bitcast i8* %64 to i64*
  %66 = icmp eq i8* %64, null
  br i1 %66, label %70, label %67

; <label>:67:                                     ; preds = %59
  %68 = load i64, i64* %65, align 8, !tbaa !6
  %69 = add i64 %68, %62
  store i64 %69, i64* %65, align 8, !tbaa !6
  br label %70

; <label>:70:                                     ; preds = %59, %67
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %63)
  %71 = getelementptr i8, i8* %31, i64 54
  %72 = icmp ugt i8* %71, %27
  br i1 %72, label %376, label %73

; <label>:73:                                     ; preds = %70
  %74 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @blacklist to i8*), i8* nonnull %22) #2
  %75 = bitcast i8* %74 to i64*
  %76 = icmp eq i8* %74, null
  br i1 %76, label %124, label %77

; <label>:77:                                     ; preds = %73
  %78 = load i64, i64* %75, align 8, !tbaa !6
  %79 = add i64 %78, 1
  store i64 %79, i64* %75, align 8, !tbaa !6
  %80 = bitcast %struct.log* %16 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %80) #2
  %81 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 4, i64 0
  %82 = bitcast i8* %81 to i64*
  store i64 0, i64* %82, align 4
  %83 = load i32, i32* %14, align 4, !tbaa !2
  %84 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 0
  store i32 %83, i32* %84, align 4, !tbaa !18
  %85 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 1
  store i32 2, i32* %85, align 4, !tbaa !20
  %86 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 2
  store i32 1, i32* %86, align 4, !tbaa !21
  %87 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 3
  store i32 %50, i32* %87, align 4, !tbaa !22
  %88 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %32, i64 0, i32 0, i64 0
  %89 = load i8, i8* %88, align 1, !tbaa !23
  %90 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 4, i64 0
  store i8 %89, i8* %90, align 4, !tbaa !23
  %91 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %32, i64 0, i32 0, i64 1
  %92 = load i8, i8* %91, align 1, !tbaa !23
  %93 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 4, i64 1
  store i8 %92, i8* %93, align 1, !tbaa !23
  %94 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %32, i64 0, i32 0, i64 2
  %95 = load i8, i8* %94, align 1, !tbaa !23
  %96 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 4, i64 2
  store i8 %95, i8* %96, align 2, !tbaa !23
  %97 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %32, i64 0, i32 0, i64 3
  %98 = load i8, i8* %97, align 1, !tbaa !23
  %99 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 4, i64 3
  store i8 %98, i8* %99, align 1, !tbaa !23
  %100 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %32, i64 0, i32 0, i64 4
  %101 = load i8, i8* %100, align 1, !tbaa !23
  %102 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 4, i64 4
  store i8 %101, i8* %102, align 4, !tbaa !23
  %103 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %32, i64 0, i32 0, i64 5
  %104 = load i8, i8* %103, align 1, !tbaa !23
  %105 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 4, i64 5
  store i8 %104, i8* %105, align 1, !tbaa !23
  %106 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %106, i64* %15, align 8, !tbaa !6
  %107 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %23, i8* nonnull %80, i64 0) #2
  %108 = bitcast i32* %9 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %108)
  store i32 3, i32* %9, align 4, !tbaa !2
  %109 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @system_stats to i8*), i8* nonnull %108) #2
  %110 = bitcast i8* %109 to i64*
  %111 = icmp eq i8* %109, null
  br i1 %111, label %115, label %112

; <label>:112:                                    ; preds = %77
  %113 = load i64, i64* %110, align 8, !tbaa !6
  %114 = add i64 %113, 1
  store i64 %114, i64* %110, align 8, !tbaa !6
  br label %115

; <label>:115:                                    ; preds = %77, %112
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %108)
  %116 = bitcast i32* %8 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %116)
  store i32 4, i32* %8, align 4, !tbaa !2
  %117 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @system_stats to i8*), i8* nonnull %116) #2
  %118 = bitcast i8* %117 to i64*
  %119 = icmp eq i8* %117, null
  br i1 %119, label %123, label %120

; <label>:120:                                    ; preds = %115
  %121 = load i64, i64* %118, align 8, !tbaa !6
  %122 = add i64 %121, %62
  store i64 %122, i64* %118, align 8, !tbaa !6
  br label %123

; <label>:123:                                    ; preds = %115, %120
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %116)
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %80) #2
  br label %376

; <label>:124:                                    ; preds = %73
  %125 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* nonnull %22) #2
  %126 = bitcast i8* %125 to i64*
  %127 = icmp eq i8* %125, null
  br i1 %127, label %131, label %128

; <label>:128:                                    ; preds = %124
  %129 = load i64, i64* %126, align 8, !tbaa !6
  %130 = add i64 %129, 1
  store i64 %130, i64* %126, align 8, !tbaa !6
  br label %133

; <label>:131:                                    ; preds = %124
  %132 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* nonnull %22, i8* nonnull %21, i64 1) #2
  br label %133

; <label>:133:                                    ; preds = %131, %128
  %134 = bitcast i32* %17 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %134) #2
  %135 = load i32, i32* %48, align 4, !tbaa !17
  %136 = call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %135) #3, !srcloc !16
  store i32 %136, i32* %17, align 4, !tbaa !2
  %137 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @services to i8*), i8* nonnull %134) #2
  %138 = icmp eq i8* %137, null
  br i1 %138, label %374, label %139

; <label>:139:                                    ; preds = %133
  %140 = getelementptr inbounds i8, i8* %31, i64 23
  %141 = load i8, i8* %140, align 1, !tbaa !24
  %142 = icmp eq i8 %141, 6
  br i1 %142, label %167, label %143

; <label>:143:                                    ; preds = %139
  %144 = bitcast %struct.log* %18 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %144) #2
  %145 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 4, i64 0
  %146 = bitcast i8* %145 to i64*
  store i64 0, i64* %146, align 4
  %147 = load i32, i32* %14, align 4, !tbaa !2
  %148 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 0
  store i32 %147, i32* %148, align 4, !tbaa !18
  %149 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 1
  store i32 1, i32* %149, align 4, !tbaa !20
  %150 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 2
  store i32 4, i32* %150, align 4, !tbaa !21
  %151 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 3
  store i32 %50, i32* %151, align 4, !tbaa !22
  %152 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %32, i64 0, i32 0, i64 0
  %153 = load i8, i8* %152, align 1, !tbaa !23
  %154 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 4, i64 0
  store i8 %153, i8* %154, align 4, !tbaa !23
  %155 = load i8, i8* %152, align 1, !tbaa !23
  %156 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 4, i64 1
  store i8 %155, i8* %156, align 1, !tbaa !23
  %157 = load i8, i8* %152, align 1, !tbaa !23
  %158 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 4, i64 2
  store i8 %157, i8* %158, align 2, !tbaa !23
  %159 = load i8, i8* %152, align 1, !tbaa !23
  %160 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 4, i64 3
  store i8 %159, i8* %160, align 1, !tbaa !23
  %161 = load i8, i8* %152, align 1, !tbaa !23
  %162 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 4, i64 4
  store i8 %161, i8* %162, align 4, !tbaa !23
  %163 = load i8, i8* %152, align 1, !tbaa !23
  %164 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 4, i64 5
  store i8 %163, i8* %164, align 1, !tbaa !23
  %165 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %165, i64* %15, align 8, !tbaa !6
  %166 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %23, i8* nonnull %144, i64 0) #2
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %144) #2
  br label %374

; <label>:167:                                    ; preds = %139
  %168 = load i32, i32* %44, align 4, !tbaa !14
  %169 = load i32, i32* %48, align 4, !tbaa !17
  %170 = bitcast i8* %40 to i16*
  %171 = load i16, i16* %170, align 4, !tbaa !25
  %172 = zext i16 %171 to i32
  %173 = getelementptr inbounds i8, i8* %31, i64 36
  %174 = bitcast i8* %173 to i16*
  %175 = load i16, i16* %174, align 2, !tbaa !27
  %176 = zext i16 %175 to i32
  %177 = shl nuw i32 %176, 16
  %178 = or i32 %177, %172
  %179 = getelementptr inbounds i8, i8* %31, i64 46
  %180 = bitcast i8* %179 to i16*
  %181 = load i16, i16* %180, align 4
  %182 = and i16 %181, 512
  %183 = icmp eq i16 %182, 0
  br i1 %183, label %193, label %184

; <label>:184:                                    ; preds = %167
  %185 = bitcast i32* %7 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %185)
  store i32 1, i32* %7, align 4, !tbaa !2
  %186 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @system_stats to i8*), i8* nonnull %185) #2
  %187 = bitcast i8* %186 to i64*
  %188 = icmp eq i8* %186, null
  br i1 %188, label %192, label %189

; <label>:189:                                    ; preds = %184
  %190 = load i64, i64* %187, align 8, !tbaa !6
  %191 = add i64 %190, 1
  store i64 %191, i64* %187, align 8, !tbaa !6
  br label %192

; <label>:192:                                    ; preds = %184, %189
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %185)
  br label %193

; <label>:193:                                    ; preds = %167, %192
  %194 = bitcast i32* %4 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %194) #2
  %195 = bitcast i32* %5 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %195) #2
  %196 = bitcast i32* %6 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %196) #2
  store i32 513, i32* %6, align 4, !tbaa !2
  %197 = add i32 %168, -559038217
  %198 = add i32 %178, -559038217
  %199 = add i32 %169, -559038217
  %200 = xor i32 %198, %199
  %201 = shl i32 %198, 14
  %202 = lshr i32 %198, 18
  %203 = or i32 %202, %201
  %204 = sub i32 %200, %203
  %205 = xor i32 %204, %197
  %206 = shl i32 %204, 11
  %207 = lshr i32 %204, 21
  %208 = or i32 %207, %206
  %209 = sub i32 %205, %208
  %210 = xor i32 %209, %198
  %211 = shl i32 %209, 25
  %212 = lshr i32 %209, 7
  %213 = or i32 %212, %211
  %214 = sub i32 %210, %213
  %215 = xor i32 %214, %204
  %216 = shl i32 %214, 16
  %217 = lshr i32 %214, 16
  %218 = or i32 %217, %216
  %219 = sub i32 %215, %218
  %220 = xor i32 %219, %209
  %221 = shl i32 %219, 4
  %222 = lshr i32 %219, 28
  %223 = or i32 %222, %221
  %224 = sub i32 %220, %223
  %225 = xor i32 %224, %214
  %226 = shl i32 %224, 14
  %227 = lshr i32 %224, 18
  %228 = or i32 %227, %226
  %229 = sub i32 %225, %228
  %230 = xor i32 %229, %219
  %231 = lshr i32 %229, 8
  %232 = sub i32 %230, %231
  %233 = and i32 %232, 511
  store i32 %233, i32* %5, align 4, !tbaa !2
  %234 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %195) #2
  %235 = bitcast i8* %234 to i32*
  %236 = call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %169) #3, !srcloc !16
  store i32 %236, i32* %4, align 4, !tbaa !2
  %237 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @services to i8*), i8* nonnull %194) #2
  %238 = icmp eq i8* %237, null
  br i1 %238, label %281, label %239

; <label>:239:                                    ; preds = %193
  %240 = icmp eq i8* %234, null
  br i1 %240, label %250, label %241

; <label>:241:                                    ; preds = %239
  %242 = load i32, i32* %235, align 4, !tbaa !2
  %243 = icmp ugt i32 %242, 9
  %244 = select i1 %243, i32 0, i32 %242
  store i32 %244, i32* %6, align 4
  %245 = getelementptr inbounds i8, i8* %237, i64 96
  %246 = bitcast i8* %245 to [10 x %struct.dest_info]*
  %247 = zext i32 %244 to i64
  %248 = getelementptr inbounds [10 x %struct.dest_info], [10 x %struct.dest_info]* %246, i64 0, i64 %247
  %249 = bitcast i8* %237 to i64*
  br label %275

; <label>:250:                                    ; preds = %239
  %251 = bitcast i8* %237 to i64*
  %252 = load i64, i64* %251, align 8, !tbaa !28
  %253 = add i64 %252, 1
  %254 = icmp ult i64 %253, 10
  %255 = select i1 %254, i64 %253, i64 0
  store i64 %255, i64* %251, align 8, !tbaa !28
  %256 = getelementptr inbounds i8, i8* %237, i64 16
  %257 = bitcast i8* %256 to [10 x i64]*
  %258 = getelementptr inbounds [10 x i64], [10 x i64]* %257, i64 0, i64 %255
  %259 = load i64, i64* %258, align 8, !tbaa !6
  %260 = icmp eq i64 %259, 0
  br i1 %260, label %265, label %261

; <label>:261:                                    ; preds = %250
  %262 = getelementptr inbounds i8, i8* %237, i64 96
  %263 = bitcast i8* %262 to [10 x %struct.dest_info]*
  %264 = getelementptr inbounds [10 x %struct.dest_info], [10 x %struct.dest_info]* %263, i64 0, i64 %255
  br label %272

; <label>:265:                                    ; preds = %250
  store i64 0, i64* %251, align 8, !tbaa !28
  %266 = bitcast i8* %256 to i64*
  %267 = load i64, i64* %266, align 8, !tbaa !6
  %268 = icmp eq i64 %267, 0
  br i1 %268, label %272, label %269

; <label>:269:                                    ; preds = %265
  %270 = getelementptr inbounds i8, i8* %237, i64 96
  %271 = bitcast i8* %270 to %struct.dest_info*
  br label %272

; <label>:272:                                    ; preds = %269, %265, %261
  %273 = phi %struct.dest_info* [ %264, %261 ], [ %271, %269 ], [ null, %265 ]
  %274 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @services to i8*), i8* nonnull %194, i8* nonnull %237, i64 0) #2
  br label %275

; <label>:275:                                    ; preds = %272, %241
  %276 = phi i64* [ %251, %272 ], [ %249, %241 ]
  %277 = phi %struct.dest_info* [ %273, %272 ], [ %248, %241 ]
  %278 = load i64, i64* %276, align 8, !tbaa !28
  %279 = trunc i64 %278 to i32
  store i32 %279, i32* %6, align 4, !tbaa !2
  %280 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %195, i8* nonnull %196, i64 0) #2
  br label %281

; <label>:281:                                    ; preds = %193, %275
  %282 = phi %struct.dest_info* [ %277, %275 ], [ null, %193 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %196) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %195) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %194) #2
  %283 = icmp eq %struct.dest_info* %282, null
  br i1 %283, label %284, label %329

; <label>:284:                                    ; preds = %281
  %285 = bitcast %struct.log* %19 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %285) #2
  %286 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 4, i64 0
  %287 = bitcast i8* %286 to i64*
  store i64 0, i64* %287, align 4
  %288 = load i32, i32* %14, align 4, !tbaa !2
  %289 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 0
  store i32 %288, i32* %289, align 4, !tbaa !18
  %290 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 1
  store i32 2, i32* %290, align 4, !tbaa !20
  %291 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 2
  store i32 2, i32* %291, align 4, !tbaa !21
  %292 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 3
  store i32 %50, i32* %292, align 4, !tbaa !22
  %293 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %32, i64 0, i32 0, i64 0
  %294 = load i8, i8* %293, align 1, !tbaa !23
  %295 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 4, i64 0
  store i8 %294, i8* %295, align 4, !tbaa !23
  %296 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %32, i64 0, i32 0, i64 1
  %297 = load i8, i8* %296, align 1, !tbaa !23
  %298 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 4, i64 1
  store i8 %297, i8* %298, align 1, !tbaa !23
  %299 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %32, i64 0, i32 0, i64 2
  %300 = load i8, i8* %299, align 1, !tbaa !23
  %301 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 4, i64 2
  store i8 %300, i8* %301, align 2, !tbaa !23
  %302 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %32, i64 0, i32 0, i64 3
  %303 = load i8, i8* %302, align 1, !tbaa !23
  %304 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 4, i64 3
  store i8 %303, i8* %304, align 1, !tbaa !23
  %305 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %32, i64 0, i32 0, i64 4
  %306 = load i8, i8* %305, align 1, !tbaa !23
  %307 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 4, i64 4
  store i8 %306, i8* %307, align 4, !tbaa !23
  %308 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %32, i64 0, i32 0, i64 5
  %309 = load i8, i8* %308, align 1, !tbaa !23
  %310 = getelementptr inbounds %struct.log, %struct.log* %19, i64 0, i32 4, i64 5
  store i8 %309, i8* %310, align 1, !tbaa !23
  %311 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %311, i64* %15, align 8, !tbaa !6
  %312 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %23, i8* nonnull %285, i64 0) #2
  %313 = bitcast i32* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %313)
  store i32 3, i32* %3, align 4, !tbaa !2
  %314 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @system_stats to i8*), i8* nonnull %313) #2
  %315 = bitcast i8* %314 to i64*
  %316 = icmp eq i8* %314, null
  br i1 %316, label %320, label %317

; <label>:317:                                    ; preds = %284
  %318 = load i64, i64* %315, align 8, !tbaa !6
  %319 = add i64 %318, 1
  store i64 %319, i64* %315, align 8, !tbaa !6
  br label %320

; <label>:320:                                    ; preds = %284, %317
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %313)
  %321 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %321)
  store i32 4, i32* %2, align 4, !tbaa !2
  %322 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @system_stats to i8*), i8* nonnull %321) #2
  %323 = bitcast i8* %322 to i64*
  %324 = icmp eq i8* %322, null
  br i1 %324, label %328, label %325

; <label>:325:                                    ; preds = %320
  %326 = load i64, i64* %323, align 8, !tbaa !6
  %327 = add i64 %326, %62
  store i64 %327, i64* %323, align 8, !tbaa !6
  br label %328

; <label>:328:                                    ; preds = %320, %325
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %321)
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %285) #2
  br label %374

; <label>:329:                                    ; preds = %281
  %330 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %282, i64 0, i32 6, i64 0
  %331 = load i8, i8* %330, align 8, !tbaa !23
  %332 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %32, i64 0, i32 0, i64 0
  store i8 %331, i8* %332, align 1, !tbaa !23
  %333 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %282, i64 0, i32 6, i64 1
  %334 = load i8, i8* %333, align 1, !tbaa !23
  %335 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %32, i64 0, i32 0, i64 1
  store i8 %334, i8* %335, align 1, !tbaa !23
  %336 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %282, i64 0, i32 6, i64 2
  %337 = load i8, i8* %336, align 2, !tbaa !23
  %338 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %32, i64 0, i32 0, i64 2
  store i8 %337, i8* %338, align 1, !tbaa !23
  %339 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %282, i64 0, i32 6, i64 3
  %340 = load i8, i8* %339, align 1, !tbaa !23
  %341 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %32, i64 0, i32 0, i64 3
  store i8 %340, i8* %341, align 1, !tbaa !23
  %342 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %282, i64 0, i32 6, i64 4
  %343 = load i8, i8* %342, align 4, !tbaa !23
  %344 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %32, i64 0, i32 0, i64 4
  store i8 %343, i8* %344, align 1, !tbaa !23
  %345 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %282, i64 0, i32 6, i64 5
  %346 = load i8, i8* %345, align 1, !tbaa !23
  %347 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %32, i64 0, i32 0, i64 5
  store i8 %346, i8* %347, align 1, !tbaa !23
  %348 = bitcast %struct.log* %20 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %348) #2
  call void @llvm.memset.p0i8.i64(i8* nonnull %348, i8 0, i64 24, i32 4, i1 false)
  %349 = load i32, i32* %14, align 4, !tbaa !2
  %350 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 0
  store i32 %349, i32* %350, align 4, !tbaa !18
  %351 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 1
  store i32 1, i32* %351, align 4, !tbaa !20
  %352 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 2
  store i32 0, i32* %352, align 4, !tbaa !21
  %353 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 3
  store i32 %50, i32* %353, align 4, !tbaa !22
  %354 = load i8, i8* %330, align 8, !tbaa !23
  %355 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 4, i64 0
  store i8 %354, i8* %355, align 4, !tbaa !23
  %356 = load i8, i8* %333, align 1, !tbaa !23
  %357 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 4, i64 1
  store i8 %356, i8* %357, align 1, !tbaa !23
  %358 = load i8, i8* %336, align 2, !tbaa !23
  %359 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 4, i64 2
  store i8 %358, i8* %359, align 2, !tbaa !23
  %360 = load i8, i8* %339, align 1, !tbaa !23
  %361 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 4, i64 3
  store i8 %360, i8* %361, align 1, !tbaa !23
  %362 = load i8, i8* %342, align 4, !tbaa !23
  %363 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 4, i64 4
  store i8 %362, i8* %363, align 4, !tbaa !23
  %364 = load i8, i8* %345, align 1, !tbaa !23
  %365 = getelementptr inbounds %struct.log, %struct.log* %20, i64 0, i32 4, i64 5
  store i8 %364, i8* %365, align 1, !tbaa !23
  %366 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %366, i64* %15, align 8, !tbaa !6
  %367 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %23, i8* nonnull %348, i64 0) #2
  %368 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %282, i64 0, i32 4
  %369 = atomicrmw add i64* %368, i64 1 seq_cst
  %370 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %282, i64 0, i32 3
  %371 = atomicrmw add i64* %370, i64 %62 seq_cst
  %372 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %282, i64 0, i32 5
  %373 = atomicrmw add i64* %372, i64 0 seq_cst
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %348) #2
  br label %374

; <label>:374:                                    ; preds = %133, %329, %328, %143
  %375 = phi i32 [ 2, %143 ], [ 1, %328 ], [ 3, %329 ], [ 2, %133 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %134) #2
  br label %376

; <label>:376:                                    ; preds = %39, %70, %374, %123, %35, %1
  %377 = phi i32 [ 2, %1 ], [ 2, %35 ], [ 2, %39 ], [ 1, %123 ], [ %375, %374 ], [ 1, %70 ]
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %23) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %22) #2
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %21) #2
  ret i32 %377
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
!16 = !{i32 550238}
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
