; ModuleID = 'xdp_ddos01_blacklist_kern.c'
source_filename = "xdp_ddos01_blacklist_kern.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.log = type { i32, i32, i32, i32, [6 x i8] }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.dest_info = type { i32, i32, i32, i64, i64, [6 x i8] }

@blacklist = global %struct.bpf_map_def { i32 5, i32 4, i32 8, i32 100000, i32 1, i32 0, i32 0 }, section "maps", align 4
@ip_watchlist = global %struct.bpf_map_def { i32 5, i32 4, i32 8, i32 100000, i32 1, i32 0, i32 0 }, section "maps", align 4
@logs = global %struct.bpf_map_def { i32 1, i32 8, i32 24, i32 100000, i32 1, i32 0, i32 0 }, section "maps", align 4
@servers = global %struct.bpf_map_def { i32 1, i32 4, i32 40, i32 512, i32 0, i32 0, i32 0 }, section "maps", align 4
@services = global %struct.bpf_map_def { i32 1, i32 4, i32 12, i32 512, i32 0, i32 0, i32 0 }, section "maps", align 4
@destinations = global %struct.bpf_map_def { i32 1, i32 4, i32 4, i32 512, i32 0, i32 0, i32 0 }, section "maps", align 4
@verdict_cnt = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 4, i32 0, i32 0, i32 0 }, section "maps", align 4
@port_blacklist = global %struct.bpf_map_def { i32 6, i32 4, i32 4, i32 65536, i32 0, i32 0, i32 0 }, section "maps", align 4
@port_blacklist_drop_count_tcp = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 65536, i32 0, i32 0, i32 0 }, section "maps", align 4
@port_blacklist_drop_count_udp = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 65536, i32 0, i32 0, i32 0 }, section "maps", align 4
@_license = global [4 x i8] c"GPL\00", section "license", align 1
@llvm.used = appending global [12 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @blacklist to i8*), i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* bitcast (%struct.bpf_map_def* @port_blacklist to i8*), i8* bitcast (%struct.bpf_map_def* @port_blacklist_drop_count_tcp to i8*), i8* bitcast (%struct.bpf_map_def* @port_blacklist_drop_count_udp to i8*), i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* bitcast (%struct.bpf_map_def* @services to i8*), i8* bitcast (%struct.bpf_map_def* @verdict_cnt to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_program to i8*)], section "llvm.metadata"

; Function Attrs: nounwind uwtable
define i32 @xdp_program(%struct.xdp_md* nocapture readonly) #0 section "xdp_prog" {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i64, align 8
  %6 = alloca i32, align 4
  %7 = alloca i64, align 8
  %8 = alloca %struct.log, align 4
  %9 = alloca %struct.log, align 4
  %10 = alloca %struct.log, align 4
  %11 = alloca i32, align 4
  %12 = alloca %struct.log, align 4
  %13 = alloca %struct.log, align 4
  %14 = alloca %struct.log, align 4
  %15 = bitcast i64* %5 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %15) #2
  store i64 1, i64* %5, align 8, !tbaa !2
  %16 = bitcast i32* %6 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %16) #2
  %17 = bitcast i64* %7 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %17) #2
  %18 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %19 = load i32, i32* %18, align 4, !tbaa !6
  %20 = zext i32 %19 to i64
  %21 = inttoptr i64 %20 to i8*
  %22 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0
  %23 = load i32, i32* %22, align 4, !tbaa !9
  %24 = zext i32 %23 to i64
  %25 = inttoptr i64 %24 to i8*
  %26 = inttoptr i64 %24 to %struct.ethhdr*
  %27 = getelementptr i8, i8* %25, i64 14
  %28 = icmp ugt i8* %27, %21
  br i1 %28, label %411, label %29

; <label>:29:                                     ; preds = %1
  %30 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 2
  %31 = load i16, i16* %30, align 1, !tbaa !10
  %32 = icmp eq i16 %31, 8
  br i1 %32, label %33, label %411

; <label>:33:                                     ; preds = %29
  %34 = getelementptr i8, i8* %25, i64 34
  %35 = icmp ugt i8* %34, %21
  br i1 %35, label %411, label %36

; <label>:36:                                     ; preds = %33
  %37 = getelementptr inbounds i8, i8* %25, i64 26
  %38 = bitcast i8* %37 to i32*
  %39 = load i32, i32* %38, align 4, !tbaa !13
  %40 = tail call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %39) #3, !srcloc !15
  store i32 %40, i32* %6, align 4, !tbaa !16
  %41 = getelementptr inbounds i8, i8* %25, i64 30
  %42 = bitcast i8* %41 to i32*
  %43 = load i32, i32* %42, align 4, !tbaa !17
  %44 = tail call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %43) #3, !srcloc !15
  %45 = bitcast %struct.log* %8 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %45) #2
  %46 = getelementptr inbounds %struct.log, %struct.log* %8, i64 0, i32 4, i64 0
  %47 = bitcast i8* %46 to i64*
  store i64 0, i64* %47, align 4
  %48 = getelementptr inbounds %struct.log, %struct.log* %8, i64 0, i32 0
  store i32 %40, i32* %48, align 4, !tbaa !18
  %49 = getelementptr inbounds %struct.log, %struct.log* %8, i64 0, i32 1
  store i32 0, i32* %49, align 4, !tbaa !20
  %50 = getelementptr inbounds %struct.log, %struct.log* %8, i64 0, i32 2
  store i32 0, i32* %50, align 4, !tbaa !21
  %51 = getelementptr inbounds %struct.log, %struct.log* %8, i64 0, i32 3
  store i32 %44, i32* %51, align 4, !tbaa !22
  %52 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 0
  %53 = load i8, i8* %52, align 1, !tbaa !23
  %54 = getelementptr inbounds %struct.log, %struct.log* %8, i64 0, i32 4, i64 0
  store i8 %53, i8* %54, align 4, !tbaa !23
  %55 = load i8, i8* %52, align 1, !tbaa !23
  %56 = getelementptr inbounds %struct.log, %struct.log* %8, i64 0, i32 4, i64 1
  store i8 %55, i8* %56, align 1, !tbaa !23
  %57 = load i8, i8* %52, align 1, !tbaa !23
  %58 = getelementptr inbounds %struct.log, %struct.log* %8, i64 0, i32 4, i64 2
  store i8 %57, i8* %58, align 2, !tbaa !23
  %59 = load i8, i8* %52, align 1, !tbaa !23
  %60 = getelementptr inbounds %struct.log, %struct.log* %8, i64 0, i32 4, i64 3
  store i8 %59, i8* %60, align 1, !tbaa !23
  %61 = load i8, i8* %52, align 1, !tbaa !23
  %62 = getelementptr inbounds %struct.log, %struct.log* %8, i64 0, i32 4, i64 4
  store i8 %61, i8* %62, align 4, !tbaa !23
  %63 = load i8, i8* %52, align 1, !tbaa !23
  %64 = getelementptr inbounds %struct.log, %struct.log* %8, i64 0, i32 4, i64 5
  store i8 %63, i8* %64, align 1, !tbaa !23
  %65 = tail call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %65, i64* %7, align 8, !tbaa !2
  %66 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %17, i8* nonnull %45, i64 0) #2
  %67 = getelementptr i8, i8* %25, i64 54
  %68 = icmp ugt i8* %67, %21
  br i1 %68, label %409, label %69

; <label>:69:                                     ; preds = %36
  %70 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @blacklist to i8*), i8* nonnull %16) #2
  %71 = bitcast i8* %70 to i64*
  %72 = icmp eq i8* %70, null
  br i1 %72, label %103, label %73

; <label>:73:                                     ; preds = %69
  %74 = load i64, i64* %71, align 8, !tbaa !2
  %75 = add i64 %74, 1
  store i64 %75, i64* %71, align 8, !tbaa !2
  %76 = bitcast %struct.log* %9 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %76) #2
  %77 = getelementptr inbounds %struct.log, %struct.log* %9, i64 0, i32 4, i64 0
  %78 = bitcast i8* %77 to i64*
  store i64 0, i64* %78, align 4
  %79 = load i32, i32* %6, align 4, !tbaa !16
  %80 = getelementptr inbounds %struct.log, %struct.log* %9, i64 0, i32 0
  store i32 %79, i32* %80, align 4, !tbaa !18
  %81 = getelementptr inbounds %struct.log, %struct.log* %9, i64 0, i32 1
  store i32 2, i32* %81, align 4, !tbaa !20
  %82 = getelementptr inbounds %struct.log, %struct.log* %9, i64 0, i32 2
  store i32 1, i32* %82, align 4, !tbaa !21
  %83 = getelementptr inbounds %struct.log, %struct.log* %9, i64 0, i32 3
  store i32 %44, i32* %83, align 4, !tbaa !22
  %84 = load i8, i8* %52, align 1, !tbaa !23
  %85 = getelementptr inbounds %struct.log, %struct.log* %9, i64 0, i32 4, i64 0
  store i8 %84, i8* %85, align 4, !tbaa !23
  %86 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 1
  %87 = load i8, i8* %86, align 1, !tbaa !23
  %88 = getelementptr inbounds %struct.log, %struct.log* %9, i64 0, i32 4, i64 1
  store i8 %87, i8* %88, align 1, !tbaa !23
  %89 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 2
  %90 = load i8, i8* %89, align 1, !tbaa !23
  %91 = getelementptr inbounds %struct.log, %struct.log* %9, i64 0, i32 4, i64 2
  store i8 %90, i8* %91, align 2, !tbaa !23
  %92 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 3
  %93 = load i8, i8* %92, align 1, !tbaa !23
  %94 = getelementptr inbounds %struct.log, %struct.log* %9, i64 0, i32 4, i64 3
  store i8 %93, i8* %94, align 1, !tbaa !23
  %95 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 4
  %96 = load i8, i8* %95, align 1, !tbaa !23
  %97 = getelementptr inbounds %struct.log, %struct.log* %9, i64 0, i32 4, i64 4
  store i8 %96, i8* %97, align 4, !tbaa !23
  %98 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 5
  %99 = load i8, i8* %98, align 1, !tbaa !23
  %100 = getelementptr inbounds %struct.log, %struct.log* %9, i64 0, i32 4, i64 5
  store i8 %99, i8* %100, align 1, !tbaa !23
  %101 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %101, i64* %7, align 8, !tbaa !2
  %102 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %17, i8* nonnull %76, i64 0) #2
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %76) #2
  br label %409

; <label>:103:                                    ; preds = %69
  %104 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* nonnull %16) #2
  %105 = bitcast i8* %104 to i64*
  %106 = icmp eq i8* %104, null
  br i1 %106, label %110, label %107

; <label>:107:                                    ; preds = %103
  %108 = load i64, i64* %105, align 8, !tbaa !2
  %109 = add i64 %108, 1
  store i64 %109, i64* %105, align 8, !tbaa !2
  br label %112

; <label>:110:                                    ; preds = %103
  %111 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* nonnull %16, i8* nonnull %15, i64 1) #2
  br label %112

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

; <label>:139:                                    ; preds = %112
  %140 = load i32, i32* %38, align 4, !tbaa !13
  %141 = load i32, i32* %42, align 4, !tbaa !17
  %142 = bitcast i8* %34 to i16*
  %143 = load i16, i16* %142, align 4, !tbaa !25
  %144 = getelementptr inbounds i8, i8* %25, i64 36
  %145 = bitcast i8* %144 to i16*
  %146 = load i16, i16* %145, align 2, !tbaa !27
  %147 = bitcast i32* %11 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %147) #2
  %148 = call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %141) #3, !srcloc !15
  store i32 %148, i32* %11, align 4, !tbaa !16
  %149 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @services to i8*), i8* nonnull %147) #2
  %150 = icmp eq i8* %149, null
  br i1 %150, label %379, label %151

; <label>:151:                                    ; preds = %139
  %152 = zext i16 %143 to i32
  %153 = zext i16 %146 to i32
  %154 = shl nuw i32 %153, 16
  %155 = or i32 %154, %152
  %156 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %156) #2
  %157 = bitcast i32* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %157) #2
  %158 = bitcast i32* %4 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %158) #2
  store i32 513, i32* %4, align 4, !tbaa !16
  store i32 0, i32* %2, align 4, !tbaa !16
  %159 = add i32 %140, -559038217
  %160 = add i32 %155, -559038217
  %161 = add i32 %141, -559038217
  %162 = xor i32 %160, %161
  %163 = shl i32 %160, 14
  %164 = lshr i32 %160, 18
  %165 = or i32 %164, %163
  %166 = sub i32 %162, %165
  %167 = xor i32 %166, %159
  %168 = shl i32 %166, 11
  %169 = lshr i32 %166, 21
  %170 = or i32 %169, %168
  %171 = sub i32 %167, %170
  %172 = xor i32 %171, %160
  %173 = shl i32 %171, 25
  %174 = lshr i32 %171, 7
  %175 = or i32 %174, %173
  %176 = sub i32 %172, %175
  %177 = xor i32 %176, %166
  %178 = shl i32 %176, 16
  %179 = lshr i32 %176, 16
  %180 = or i32 %179, %178
  %181 = sub i32 %177, %180
  %182 = xor i32 %181, %171
  %183 = shl i32 %181, 4
  %184 = lshr i32 %181, 28
  %185 = or i32 %184, %183
  %186 = sub i32 %182, %185
  %187 = xor i32 %186, %176
  %188 = shl i32 %186, 14
  %189 = lshr i32 %186, 18
  %190 = or i32 %189, %188
  %191 = sub i32 %187, %190
  %192 = xor i32 %191, %181
  %193 = lshr i32 %191, 8
  %194 = sub i32 %192, %193
  %195 = and i32 %194, 511
  store i32 %195, i32* %3, align 4, !tbaa !16
  %196 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %157) #2
  %197 = icmp eq i8* %196, null
  br i1 %197, label %201, label %198

; <label>:198:                                    ; preds = %151
  %199 = bitcast i8* %196 to i32*
  %200 = load i32, i32* %199, align 4, !tbaa !16
  store i32 %200, i32* %4, align 4, !tbaa !16
  br label %203

; <label>:201:                                    ; preds = %151
  %202 = load i32, i32* %4, align 4, !tbaa !16
  br label %203

; <label>:203:                                    ; preds = %201, %198
  %204 = phi i32 [ %202, %201 ], [ %200, %198 ]
  %205 = icmp eq i32 %204, 513
  br i1 %205, label %211, label %206

; <label>:206:                                    ; preds = %203
  %207 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %158) #2
  %208 = icmp eq i8* %207, null
  br i1 %208, label %211, label %209

; <label>:209:                                    ; preds = %206
  %210 = bitcast i8* %207 to %struct.dest_info*
  br label %310

; <label>:211:                                    ; preds = %206, %203
  store i32 %148, i32* %2, align 4, !tbaa !16
  %212 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @services to i8*), i8* nonnull %156) #2
  %213 = icmp eq i8* %212, null
  br i1 %213, label %310, label %214

; <label>:214:                                    ; preds = %211
  %215 = getelementptr inbounds i8, i8* %212, i64 8
  %216 = bitcast i8* %215 to i32*
  %217 = load i32, i32* %216, align 4, !tbaa !28
  %218 = zext i32 %217 to i64
  %219 = bitcast i8* %212 to i32*
  %220 = load i32, i32* %219, align 4, !tbaa !30
  %221 = add i32 %217, 1
  %222 = add i32 %221, %220
  %223 = add nuw nsw i64 %218, 10
  %224 = zext i32 %222 to i64
  %225 = icmp ugt i64 %223, %224
  %226 = select i1 %225, i32 %222, i32 %221
  store i32 %226, i32* %4, align 4, !tbaa !16
  %227 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %158) #2
  %228 = icmp eq i8* %227, null
  br i1 %228, label %229, label %237

; <label>:229:                                    ; preds = %214
  %230 = load i32, i32* %4, align 4, !tbaa !16
  %231 = add i32 %230, 1
  %232 = zext i32 %231 to i64
  %233 = icmp ugt i64 %223, %232
  %234 = select i1 %233, i32 %231, i32 %221
  store i32 %234, i32* %4, align 4, !tbaa !16
  %235 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %158) #2
  %236 = icmp eq i8* %235, null
  br i1 %236, label %243, label %237

; <label>:237:                                    ; preds = %299, %291, %283, %275, %267, %259, %251, %243, %229, %214
  %238 = phi i8* [ %227, %214 ], [ %235, %229 ], [ %249, %243 ], [ %257, %251 ], [ %265, %259 ], [ %273, %267 ], [ %281, %275 ], [ %289, %283 ], [ %297, %291 ], [ %305, %299 ]
  %239 = bitcast i8* %238 to %struct.dest_info*
  %240 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %157, i8* nonnull %158, i64 0) #2
  %241 = load i32, i32* %219, align 4, !tbaa !30
  %242 = add i32 %241, 1
  store i32 %242, i32* %219, align 4, !tbaa !30
  br label %310

; <label>:243:                                    ; preds = %229
  %244 = load i32, i32* %4, align 4, !tbaa !16
  %245 = add i32 %244, 1
  %246 = zext i32 %245 to i64
  %247 = icmp ugt i64 %223, %246
  %248 = select i1 %247, i32 %245, i32 %221
  store i32 %248, i32* %4, align 4, !tbaa !16
  %249 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %158) #2
  %250 = icmp eq i8* %249, null
  br i1 %250, label %251, label %237

; <label>:251:                                    ; preds = %243
  %252 = load i32, i32* %4, align 4, !tbaa !16
  %253 = add i32 %252, 1
  %254 = zext i32 %253 to i64
  %255 = icmp ugt i64 %223, %254
  %256 = select i1 %255, i32 %253, i32 %221
  store i32 %256, i32* %4, align 4, !tbaa !16
  %257 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %158) #2
  %258 = icmp eq i8* %257, null
  br i1 %258, label %259, label %237

; <label>:259:                                    ; preds = %251
  %260 = load i32, i32* %4, align 4, !tbaa !16
  %261 = add i32 %260, 1
  %262 = zext i32 %261 to i64
  %263 = icmp ugt i64 %223, %262
  %264 = select i1 %263, i32 %261, i32 %221
  store i32 %264, i32* %4, align 4, !tbaa !16
  %265 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %158) #2
  %266 = icmp eq i8* %265, null
  br i1 %266, label %267, label %237

; <label>:267:                                    ; preds = %259
  %268 = load i32, i32* %4, align 4, !tbaa !16
  %269 = add i32 %268, 1
  %270 = zext i32 %269 to i64
  %271 = icmp ugt i64 %223, %270
  %272 = select i1 %271, i32 %269, i32 %221
  store i32 %272, i32* %4, align 4, !tbaa !16
  %273 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %158) #2
  %274 = icmp eq i8* %273, null
  br i1 %274, label %275, label %237

; <label>:275:                                    ; preds = %267
  %276 = load i32, i32* %4, align 4, !tbaa !16
  %277 = add i32 %276, 1
  %278 = zext i32 %277 to i64
  %279 = icmp ugt i64 %223, %278
  %280 = select i1 %279, i32 %277, i32 %221
  store i32 %280, i32* %4, align 4, !tbaa !16
  %281 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %158) #2
  %282 = icmp eq i8* %281, null
  br i1 %282, label %283, label %237

; <label>:283:                                    ; preds = %275
  %284 = load i32, i32* %4, align 4, !tbaa !16
  %285 = add i32 %284, 1
  %286 = zext i32 %285 to i64
  %287 = icmp ugt i64 %223, %286
  %288 = select i1 %287, i32 %285, i32 %221
  store i32 %288, i32* %4, align 4, !tbaa !16
  %289 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %158) #2
  %290 = icmp eq i8* %289, null
  br i1 %290, label %291, label %237

; <label>:291:                                    ; preds = %283
  %292 = load i32, i32* %4, align 4, !tbaa !16
  %293 = add i32 %292, 1
  %294 = zext i32 %293 to i64
  %295 = icmp ugt i64 %223, %294
  %296 = select i1 %295, i32 %293, i32 %221
  store i32 %296, i32* %4, align 4, !tbaa !16
  %297 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %158) #2
  %298 = icmp eq i8* %297, null
  br i1 %298, label %299, label %237

; <label>:299:                                    ; preds = %291
  %300 = load i32, i32* %4, align 4, !tbaa !16
  %301 = add i32 %300, 1
  %302 = zext i32 %301 to i64
  %303 = icmp ugt i64 %223, %302
  %304 = select i1 %303, i32 %301, i32 %221
  store i32 %304, i32* %4, align 4, !tbaa !16
  %305 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %158) #2
  %306 = icmp eq i8* %305, null
  br i1 %306, label %307, label %237

; <label>:307:                                    ; preds = %299
  %308 = load i32, i32* %4, align 4, !tbaa !16
  %309 = add i32 %308, 1
  store i32 %309, i32* %4, align 4, !tbaa !16
  br label %310

; <label>:310:                                    ; preds = %209, %211, %237, %307
  %311 = phi %struct.dest_info* [ %210, %209 ], [ %239, %237 ], [ null, %211 ], [ null, %307 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %158) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %157) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %156) #2
  %312 = icmp eq %struct.dest_info* %311, null
  br i1 %312, label %313, label %341

; <label>:313:                                    ; preds = %310
  %314 = bitcast %struct.log* %12 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %314) #2
  %315 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 4, i64 0
  %316 = bitcast i8* %315 to i64*
  store i64 0, i64* %316, align 4
  %317 = load i32, i32* %6, align 4, !tbaa !16
  %318 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 0
  store i32 %317, i32* %318, align 4, !tbaa !18
  %319 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 1
  store i32 2, i32* %319, align 4, !tbaa !20
  %320 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 2
  store i32 2, i32* %320, align 4, !tbaa !21
  %321 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 3
  store i32 %44, i32* %321, align 4, !tbaa !22
  %322 = load i8, i8* %52, align 1, !tbaa !23
  %323 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 4, i64 0
  store i8 %322, i8* %323, align 4, !tbaa !23
  %324 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 1
  %325 = load i8, i8* %324, align 1, !tbaa !23
  %326 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 4, i64 1
  store i8 %325, i8* %326, align 1, !tbaa !23
  %327 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 2
  %328 = load i8, i8* %327, align 1, !tbaa !23
  %329 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 4, i64 2
  store i8 %328, i8* %329, align 2, !tbaa !23
  %330 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 3
  %331 = load i8, i8* %330, align 1, !tbaa !23
  %332 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 4, i64 3
  store i8 %331, i8* %332, align 1, !tbaa !23
  %333 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 4
  %334 = load i8, i8* %333, align 1, !tbaa !23
  %335 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 4, i64 4
  store i8 %334, i8* %335, align 4, !tbaa !23
  %336 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 5
  %337 = load i8, i8* %336, align 1, !tbaa !23
  %338 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 4, i64 5
  store i8 %337, i8* %338, align 1, !tbaa !23
  %339 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %339, i64* %7, align 8, !tbaa !2
  %340 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %17, i8* nonnull %314, i64 0) #2
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %314) #2
  br label %407

; <label>:341:                                    ; preds = %310
  %342 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %311, i64 0, i32 5, i64 0
  %343 = load i8, i8* %342, align 8, !tbaa !23
  store i8 %343, i8* %52, align 1, !tbaa !23
  %344 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %311, i64 0, i32 5, i64 1
  %345 = load i8, i8* %344, align 1, !tbaa !23
  %346 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 1
  store i8 %345, i8* %346, align 1, !tbaa !23
  %347 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %311, i64 0, i32 5, i64 2
  %348 = load i8, i8* %347, align 2, !tbaa !23
  %349 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 2
  store i8 %348, i8* %349, align 1, !tbaa !23
  %350 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %311, i64 0, i32 5, i64 3
  %351 = load i8, i8* %350, align 1, !tbaa !23
  %352 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 3
  store i8 %351, i8* %352, align 1, !tbaa !23
  %353 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %311, i64 0, i32 5, i64 4
  %354 = load i8, i8* %353, align 4, !tbaa !23
  %355 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 4
  store i8 %354, i8* %355, align 1, !tbaa !23
  %356 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %311, i64 0, i32 5, i64 5
  %357 = load i8, i8* %356, align 1, !tbaa !23
  %358 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 5
  store i8 %357, i8* %358, align 1, !tbaa !23
  %359 = bitcast %struct.log* %13 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %359) #2
  call void @llvm.memset.p0i8.i64(i8* nonnull %359, i8 0, i64 24, i32 4, i1 false)
  %360 = load i32, i32* %6, align 4, !tbaa !16
  %361 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 0
  store i32 %360, i32* %361, align 4, !tbaa !18
  %362 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 1
  store i32 1, i32* %362, align 4, !tbaa !20
  %363 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 2
  store i32 0, i32* %363, align 4, !tbaa !21
  %364 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 3
  store i32 %44, i32* %364, align 4, !tbaa !22
  %365 = load i8, i8* %342, align 8, !tbaa !23
  %366 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 4, i64 0
  store i8 %365, i8* %366, align 4, !tbaa !23
  %367 = load i8, i8* %344, align 1, !tbaa !23
  %368 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 4, i64 1
  store i8 %367, i8* %368, align 1, !tbaa !23
  %369 = load i8, i8* %347, align 2, !tbaa !23
  %370 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 4, i64 2
  store i8 %369, i8* %370, align 2, !tbaa !23
  %371 = load i8, i8* %350, align 1, !tbaa !23
  %372 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 4, i64 3
  store i8 %371, i8* %372, align 1, !tbaa !23
  %373 = load i8, i8* %353, align 4, !tbaa !23
  %374 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 4, i64 4
  store i8 %373, i8* %374, align 4, !tbaa !23
  %375 = load i8, i8* %356, align 1, !tbaa !23
  %376 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 4, i64 5
  store i8 %375, i8* %376, align 1, !tbaa !23
  %377 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %377, i64* %7, align 8, !tbaa !2
  %378 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %17, i8* nonnull %359, i64 0) #2
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %359) #2
  br label %407

; <label>:379:                                    ; preds = %139
  %380 = bitcast %struct.log* %14 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %380) #2
  %381 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 4, i64 0
  %382 = bitcast i8* %381 to i64*
  store i64 0, i64* %382, align 4
  %383 = load i32, i32* %6, align 4, !tbaa !16
  %384 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 0
  store i32 %383, i32* %384, align 4, !tbaa !18
  %385 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 1
  store i32 1, i32* %385, align 4, !tbaa !20
  %386 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 2
  store i32 0, i32* %386, align 4, !tbaa !21
  %387 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 3
  store i32 %44, i32* %387, align 4, !tbaa !22
  %388 = load i8, i8* %52, align 1, !tbaa !23
  %389 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 4, i64 0
  store i8 %388, i8* %389, align 4, !tbaa !23
  %390 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 1
  %391 = load i8, i8* %390, align 1, !tbaa !23
  %392 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 4, i64 1
  store i8 %391, i8* %392, align 1, !tbaa !23
  %393 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 2
  %394 = load i8, i8* %393, align 1, !tbaa !23
  %395 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 4, i64 2
  store i8 %394, i8* %395, align 2, !tbaa !23
  %396 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 3
  %397 = load i8, i8* %396, align 1, !tbaa !23
  %398 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 4, i64 3
  store i8 %397, i8* %398, align 1, !tbaa !23
  %399 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 4
  %400 = load i8, i8* %399, align 1, !tbaa !23
  %401 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 4, i64 4
  store i8 %400, i8* %401, align 4, !tbaa !23
  %402 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 5
  %403 = load i8, i8* %402, align 1, !tbaa !23
  %404 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 4, i64 5
  store i8 %403, i8* %404, align 1, !tbaa !23
  %405 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %405, i64* %7, align 8, !tbaa !2
  %406 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %17, i8* nonnull %380, i64 0) #2
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %380) #2
  br label %407

; <label>:407:                                    ; preds = %379, %341, %313
  %408 = phi i32 [ 1, %313 ], [ 3, %341 ], [ 2, %379 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %147) #2
  br label %409

; <label>:409:                                    ; preds = %36, %407, %116, %73
  %410 = phi i32 [ 1, %73 ], [ 2, %116 ], [ %408, %407 ], [ 1, %36 ]
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %45) #2
  br label %411

; <label>:411:                                    ; preds = %409, %33, %29, %1
  %412 = phi i32 [ 2, %1 ], [ 2, %29 ], [ %410, %409 ], [ 2, %33 ]
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %17) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %16) #2
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %15) #2
  ret i32 %412
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

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
!3 = !{!"long long", !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
!6 = !{!7, !8, i64 4}
!7 = !{!"xdp_md", !8, i64 0, !8, i64 4, !8, i64 8, !8, i64 12, !8, i64 16}
!8 = !{!"int", !4, i64 0}
!9 = !{!7, !8, i64 0}
!10 = !{!11, !12, i64 12}
!11 = !{!"ethhdr", !4, i64 0, !4, i64 6, !12, i64 12}
!12 = !{!"short", !4, i64 0}
!13 = !{!14, !8, i64 12}
!14 = !{!"iphdr", !4, i64 0, !4, i64 0, !4, i64 1, !12, i64 2, !12, i64 4, !12, i64 6, !4, i64 8, !4, i64 9, !12, i64 10, !8, i64 12, !8, i64 16}
!15 = !{i32 555411}
!16 = !{!8, !8, i64 0}
!17 = !{!14, !8, i64 16}
!18 = !{!19, !8, i64 0}
!19 = !{!"log", !8, i64 0, !8, i64 4, !8, i64 8, !8, i64 12, !4, i64 16}
!20 = !{!19, !8, i64 4}
!21 = !{!19, !8, i64 8}
!22 = !{!19, !8, i64 12}
!23 = !{!4, !4, i64 0}
!24 = !{!14, !4, i64 9}
!25 = !{!26, !12, i64 0}
!26 = !{!"tcphdr", !12, i64 0, !12, i64 2, !8, i64 4, !8, i64 8, !12, i64 12, !12, i64 12, !12, i64 13, !12, i64 13, !12, i64 13, !12, i64 13, !12, i64 13, !12, i64 13, !12, i64 13, !12, i64 13, !12, i64 14, !12, i64 16, !12, i64 18}
!27 = !{!26, !12, i64 2}
!28 = !{!29, !8, i64 8}
!29 = !{!"service", !8, i64 0, !8, i64 4, !8, i64 8}
!30 = !{!29, !8, i64 0}
