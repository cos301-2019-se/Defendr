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
@services = global %struct.bpf_map_def { i32 1, i32 4, i32 24, i32 512, i32 0, i32 0, i32 0 }, section "maps", align 4
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
  br i1 %28, label %420, label %29

; <label>:29:                                     ; preds = %1
  %30 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 2
  %31 = load i16, i16* %30, align 1, !tbaa !10
  %32 = icmp eq i16 %31, 8
  br i1 %32, label %33, label %420

; <label>:33:                                     ; preds = %29
  %34 = getelementptr i8, i8* %25, i64 34
  %35 = icmp ugt i8* %34, %21
  br i1 %35, label %420, label %36

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
  br i1 %68, label %418, label %69

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
  br label %418

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
  br label %418

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
  br i1 %150, label %388, label %151

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
  %161 = xor i32 %160, -559038217
  %162 = shl i32 %160, 14
  %163 = lshr i32 %160, 18
  %164 = or i32 %163, %162
  %165 = sub i32 %161, %164
  %166 = xor i32 %165, %159
  %167 = shl i32 %165, 11
  %168 = lshr i32 %165, 21
  %169 = or i32 %168, %167
  %170 = sub i32 %166, %169
  %171 = xor i32 %170, %160
  %172 = shl i32 %170, 25
  %173 = lshr i32 %170, 7
  %174 = or i32 %173, %172
  %175 = sub i32 %171, %174
  %176 = xor i32 %175, %165
  %177 = shl i32 %175, 16
  %178 = lshr i32 %175, 16
  %179 = or i32 %178, %177
  %180 = sub i32 %176, %179
  %181 = xor i32 %180, %170
  %182 = shl i32 %180, 4
  %183 = lshr i32 %180, 28
  %184 = or i32 %183, %182
  %185 = sub i32 %181, %184
  %186 = xor i32 %185, %175
  %187 = shl i32 %185, 14
  %188 = lshr i32 %185, 18
  %189 = or i32 %188, %187
  %190 = sub i32 %186, %189
  %191 = xor i32 %190, %180
  %192 = lshr i32 %190, 8
  %193 = sub i32 %191, %192
  %194 = and i32 %193, 511
  store i32 %194, i32* %3, align 4, !tbaa !16
  %195 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %157) #2
  %196 = icmp eq i8* %195, null
  br i1 %196, label %200, label %197

; <label>:197:                                    ; preds = %151
  %198 = bitcast i8* %195 to i32*
  %199 = load i32, i32* %198, align 4, !tbaa !16
  store i32 %199, i32* %4, align 4, !tbaa !16
  br label %202

; <label>:200:                                    ; preds = %151
  %201 = load i32, i32* %4, align 4, !tbaa !16
  br label %202

; <label>:202:                                    ; preds = %200, %197
  %203 = phi i32 [ %201, %200 ], [ %199, %197 ]
  %204 = icmp eq i32 %203, 513
  br i1 %204, label %210, label %205

; <label>:205:                                    ; preds = %202
  %206 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %158) #2
  %207 = icmp eq i8* %206, null
  br i1 %207, label %210, label %208

; <label>:208:                                    ; preds = %205
  %209 = bitcast i8* %206 to %struct.dest_info*
  br label %313

; <label>:210:                                    ; preds = %205, %202
  store i32 %148, i32* %2, align 4, !tbaa !16
  %211 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @services to i8*), i8* nonnull %156) #2
  %212 = icmp eq i8* %211, null
  br i1 %212, label %313, label %213

; <label>:213:                                    ; preds = %210
  %214 = getelementptr inbounds i8, i8* %211, i64 16
  %215 = bitcast i8* %214 to i64*
  %216 = load i64, i64* %215, align 8, !tbaa !28
  %217 = bitcast i8* %211 to i64*
  %218 = load i64, i64* %217, align 8, !tbaa !30
  %219 = add i64 %218, 1
  %220 = and i64 %219, 4294967295
  %221 = urem i64 %220, %216
  %222 = add i64 %221, %216
  %223 = trunc i64 %222 to i32
  store i32 %223, i32* %4, align 4, !tbaa !16
  %224 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %158) #2
  %225 = icmp eq i8* %224, null
  br i1 %225, label %226, label %235

; <label>:226:                                    ; preds = %213
  %227 = load i32, i32* %4, align 4, !tbaa !16
  %228 = add i32 %227, 1
  %229 = zext i32 %228 to i64
  %230 = urem i64 %229, %216
  %231 = add i64 %230, %216
  %232 = trunc i64 %231 to i32
  store i32 %232, i32* %4, align 4, !tbaa !16
  %233 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %158) #2
  %234 = icmp eq i8* %233, null
  br i1 %234, label %241, label %235

; <label>:235:                                    ; preds = %304, %295, %286, %277, %268, %259, %250, %241, %226, %213
  %236 = phi i8* [ %224, %213 ], [ %233, %226 ], [ %248, %241 ], [ %257, %250 ], [ %266, %259 ], [ %275, %268 ], [ %284, %277 ], [ %293, %286 ], [ %302, %295 ], [ %311, %304 ]
  %237 = bitcast i8* %236 to %struct.dest_info*
  %238 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %157, i8* nonnull %158, i64 0) #2
  %239 = load i32, i32* %4, align 4, !tbaa !16
  %240 = zext i32 %239 to i64
  store i64 %240, i64* %217, align 8, !tbaa !30
  br label %313

; <label>:241:                                    ; preds = %226
  %242 = load i32, i32* %4, align 4, !tbaa !16
  %243 = add i32 %242, 1
  %244 = zext i32 %243 to i64
  %245 = urem i64 %244, %216
  %246 = add i64 %245, %216
  %247 = trunc i64 %246 to i32
  store i32 %247, i32* %4, align 4, !tbaa !16
  %248 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %158) #2
  %249 = icmp eq i8* %248, null
  br i1 %249, label %250, label %235

; <label>:250:                                    ; preds = %241
  %251 = load i32, i32* %4, align 4, !tbaa !16
  %252 = add i32 %251, 1
  %253 = zext i32 %252 to i64
  %254 = urem i64 %253, %216
  %255 = add i64 %254, %216
  %256 = trunc i64 %255 to i32
  store i32 %256, i32* %4, align 4, !tbaa !16
  %257 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %158) #2
  %258 = icmp eq i8* %257, null
  br i1 %258, label %259, label %235

; <label>:259:                                    ; preds = %250
  %260 = load i32, i32* %4, align 4, !tbaa !16
  %261 = add i32 %260, 1
  %262 = zext i32 %261 to i64
  %263 = urem i64 %262, %216
  %264 = add i64 %263, %216
  %265 = trunc i64 %264 to i32
  store i32 %265, i32* %4, align 4, !tbaa !16
  %266 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %158) #2
  %267 = icmp eq i8* %266, null
  br i1 %267, label %268, label %235

; <label>:268:                                    ; preds = %259
  %269 = load i32, i32* %4, align 4, !tbaa !16
  %270 = add i32 %269, 1
  %271 = zext i32 %270 to i64
  %272 = urem i64 %271, %216
  %273 = add i64 %272, %216
  %274 = trunc i64 %273 to i32
  store i32 %274, i32* %4, align 4, !tbaa !16
  %275 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %158) #2
  %276 = icmp eq i8* %275, null
  br i1 %276, label %277, label %235

; <label>:277:                                    ; preds = %268
  %278 = load i32, i32* %4, align 4, !tbaa !16
  %279 = add i32 %278, 1
  %280 = zext i32 %279 to i64
  %281 = urem i64 %280, %216
  %282 = add i64 %281, %216
  %283 = trunc i64 %282 to i32
  store i32 %283, i32* %4, align 4, !tbaa !16
  %284 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %158) #2
  %285 = icmp eq i8* %284, null
  br i1 %285, label %286, label %235

; <label>:286:                                    ; preds = %277
  %287 = load i32, i32* %4, align 4, !tbaa !16
  %288 = add i32 %287, 1
  %289 = zext i32 %288 to i64
  %290 = urem i64 %289, %216
  %291 = add i64 %290, %216
  %292 = trunc i64 %291 to i32
  store i32 %292, i32* %4, align 4, !tbaa !16
  %293 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %158) #2
  %294 = icmp eq i8* %293, null
  br i1 %294, label %295, label %235

; <label>:295:                                    ; preds = %286
  %296 = load i32, i32* %4, align 4, !tbaa !16
  %297 = add i32 %296, 1
  %298 = zext i32 %297 to i64
  %299 = urem i64 %298, %216
  %300 = add i64 %299, %216
  %301 = trunc i64 %300 to i32
  store i32 %301, i32* %4, align 4, !tbaa !16
  %302 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %158) #2
  %303 = icmp eq i8* %302, null
  br i1 %303, label %304, label %235

; <label>:304:                                    ; preds = %295
  %305 = load i32, i32* %4, align 4, !tbaa !16
  %306 = add i32 %305, 1
  %307 = zext i32 %306 to i64
  %308 = urem i64 %307, %216
  %309 = add i64 %308, %216
  %310 = trunc i64 %309 to i32
  store i32 %310, i32* %4, align 4, !tbaa !16
  %311 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %158) #2
  %312 = icmp eq i8* %311, null
  br i1 %312, label %313, label %235

; <label>:313:                                    ; preds = %208, %210, %235, %304
  %314 = phi %struct.dest_info* [ %209, %208 ], [ %237, %235 ], [ null, %210 ], [ null, %304 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %158) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %157) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %156) #2
  %315 = icmp eq %struct.dest_info* %314, null
  br i1 %315, label %316, label %344

; <label>:316:                                    ; preds = %313
  %317 = bitcast %struct.log* %12 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %317) #2
  %318 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 4, i64 0
  %319 = bitcast i8* %318 to i64*
  store i64 0, i64* %319, align 4
  %320 = load i32, i32* %6, align 4, !tbaa !16
  %321 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 0
  store i32 %320, i32* %321, align 4, !tbaa !18
  %322 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 1
  store i32 2, i32* %322, align 4, !tbaa !20
  %323 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 2
  store i32 2, i32* %323, align 4, !tbaa !21
  %324 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 3
  store i32 %44, i32* %324, align 4, !tbaa !22
  %325 = load i8, i8* %52, align 1, !tbaa !23
  %326 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 4, i64 0
  store i8 %325, i8* %326, align 4, !tbaa !23
  %327 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 1
  %328 = load i8, i8* %327, align 1, !tbaa !23
  %329 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 4, i64 1
  store i8 %328, i8* %329, align 1, !tbaa !23
  %330 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 2
  %331 = load i8, i8* %330, align 1, !tbaa !23
  %332 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 4, i64 2
  store i8 %331, i8* %332, align 2, !tbaa !23
  %333 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 3
  %334 = load i8, i8* %333, align 1, !tbaa !23
  %335 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 4, i64 3
  store i8 %334, i8* %335, align 1, !tbaa !23
  %336 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 4
  %337 = load i8, i8* %336, align 1, !tbaa !23
  %338 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 4, i64 4
  store i8 %337, i8* %338, align 4, !tbaa !23
  %339 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 5
  %340 = load i8, i8* %339, align 1, !tbaa !23
  %341 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 4, i64 5
  store i8 %340, i8* %341, align 1, !tbaa !23
  %342 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %342, i64* %7, align 8, !tbaa !2
  %343 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %17, i8* nonnull %317, i64 0) #2
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %317) #2
  br label %416

; <label>:344:                                    ; preds = %313
  %345 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %314, i64 0, i32 5, i64 0
  %346 = load i8, i8* %345, align 8, !tbaa !23
  store i8 %346, i8* %52, align 1, !tbaa !23
  %347 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %314, i64 0, i32 5, i64 1
  %348 = load i8, i8* %347, align 1, !tbaa !23
  %349 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 1
  store i8 %348, i8* %349, align 1, !tbaa !23
  %350 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %314, i64 0, i32 5, i64 2
  %351 = load i8, i8* %350, align 2, !tbaa !23
  %352 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 2
  store i8 %351, i8* %352, align 1, !tbaa !23
  %353 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %314, i64 0, i32 5, i64 3
  %354 = load i8, i8* %353, align 1, !tbaa !23
  %355 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 3
  store i8 %354, i8* %355, align 1, !tbaa !23
  %356 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %314, i64 0, i32 5, i64 4
  %357 = load i8, i8* %356, align 4, !tbaa !23
  %358 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 4
  store i8 %357, i8* %358, align 1, !tbaa !23
  %359 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %314, i64 0, i32 5, i64 5
  %360 = load i8, i8* %359, align 1, !tbaa !23
  %361 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 5
  store i8 %360, i8* %361, align 1, !tbaa !23
  %362 = bitcast %struct.log* %13 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %362) #2
  call void @llvm.memset.p0i8.i64(i8* nonnull %362, i8 0, i64 24, i32 4, i1 false)
  %363 = load i32, i32* %6, align 4, !tbaa !16
  %364 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 0
  store i32 %363, i32* %364, align 4, !tbaa !18
  %365 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 1
  store i32 1, i32* %365, align 4, !tbaa !20
  %366 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 2
  store i32 0, i32* %366, align 4, !tbaa !21
  %367 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 3
  store i32 %44, i32* %367, align 4, !tbaa !22
  %368 = load i8, i8* %345, align 8, !tbaa !23
  %369 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 4, i64 0
  store i8 %368, i8* %369, align 4, !tbaa !23
  %370 = load i8, i8* %347, align 1, !tbaa !23
  %371 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 4, i64 1
  store i8 %370, i8* %371, align 1, !tbaa !23
  %372 = load i8, i8* %350, align 2, !tbaa !23
  %373 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 4, i64 2
  store i8 %372, i8* %373, align 2, !tbaa !23
  %374 = load i8, i8* %353, align 1, !tbaa !23
  %375 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 4, i64 3
  store i8 %374, i8* %375, align 1, !tbaa !23
  %376 = load i8, i8* %356, align 4, !tbaa !23
  %377 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 4, i64 4
  store i8 %376, i8* %377, align 4, !tbaa !23
  %378 = load i8, i8* %359, align 1, !tbaa !23
  %379 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 4, i64 5
  store i8 %378, i8* %379, align 1, !tbaa !23
  %380 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %380, i64* %7, align 8, !tbaa !2
  %381 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %17, i8* nonnull %362, i64 0) #2
  %382 = sub nsw i64 %20, %24
  %383 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %314, i64 0, i32 4
  %384 = atomicrmw add i64* %383, i64 1 seq_cst
  %385 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %314, i64 0, i32 3
  %386 = and i64 %382, 65535
  %387 = atomicrmw add i64* %385, i64 %386 seq_cst
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %362) #2
  br label %416

; <label>:388:                                    ; preds = %139
  %389 = bitcast %struct.log* %14 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %389) #2
  %390 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 4, i64 0
  %391 = bitcast i8* %390 to i64*
  store i64 0, i64* %391, align 4
  %392 = load i32, i32* %6, align 4, !tbaa !16
  %393 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 0
  store i32 %392, i32* %393, align 4, !tbaa !18
  %394 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 1
  store i32 1, i32* %394, align 4, !tbaa !20
  %395 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 2
  store i32 0, i32* %395, align 4, !tbaa !21
  %396 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 3
  store i32 %44, i32* %396, align 4, !tbaa !22
  %397 = load i8, i8* %52, align 1, !tbaa !23
  %398 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 4, i64 0
  store i8 %397, i8* %398, align 4, !tbaa !23
  %399 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 1
  %400 = load i8, i8* %399, align 1, !tbaa !23
  %401 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 4, i64 1
  store i8 %400, i8* %401, align 1, !tbaa !23
  %402 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 2
  %403 = load i8, i8* %402, align 1, !tbaa !23
  %404 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 4, i64 2
  store i8 %403, i8* %404, align 2, !tbaa !23
  %405 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 3
  %406 = load i8, i8* %405, align 1, !tbaa !23
  %407 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 4, i64 3
  store i8 %406, i8* %407, align 1, !tbaa !23
  %408 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 4
  %409 = load i8, i8* %408, align 1, !tbaa !23
  %410 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 4, i64 4
  store i8 %409, i8* %410, align 4, !tbaa !23
  %411 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %26, i64 0, i32 0, i64 5
  %412 = load i8, i8* %411, align 1, !tbaa !23
  %413 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 4, i64 5
  store i8 %412, i8* %413, align 1, !tbaa !23
  %414 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %414, i64* %7, align 8, !tbaa !2
  %415 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %17, i8* nonnull %389, i64 0) #2
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %389) #2
  br label %416

; <label>:416:                                    ; preds = %388, %344, %316
  %417 = phi i32 [ 1, %316 ], [ 3, %344 ], [ 2, %388 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %147) #2
  br label %418

; <label>:418:                                    ; preds = %36, %416, %116, %73
  %419 = phi i32 [ 1, %73 ], [ 2, %116 ], [ %417, %416 ], [ 1, %36 ]
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %45) #2
  br label %420

; <label>:420:                                    ; preds = %418, %33, %29, %1
  %421 = phi i32 [ 1, %1 ], [ 2, %29 ], [ %419, %418 ], [ 1, %33 ]
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %17) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %16) #2
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %15) #2
  ret i32 %421
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
!15 = !{i32 551948}
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
!28 = !{!29, !3, i64 16}
!29 = !{!"service", !3, i64 0, !3, i64 8, !3, i64 16}
!30 = !{!29, !3, i64 0}
