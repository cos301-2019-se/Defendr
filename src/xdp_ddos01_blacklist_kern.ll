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
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i64, align 8
  %10 = alloca i32, align 4
  %11 = alloca i64, align 8
  %12 = alloca %struct.log, align 4
  %13 = alloca %struct.log, align 4
  %14 = alloca %struct.log, align 4
  %15 = alloca i32, align 4
  %16 = alloca %struct.log, align 4
  %17 = alloca %struct.log, align 4
  %18 = alloca %struct.log, align 4
  %19 = bitcast i64* %9 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %19) #2
  store i64 1, i64* %9, align 8, !tbaa !2
  %20 = bitcast i32* %10 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %20) #2
  %21 = bitcast i64* %11 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %21) #2
  %22 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %23 = load i32, i32* %22, align 4, !tbaa !6
  %24 = zext i32 %23 to i64
  %25 = inttoptr i64 %24 to i8*
  %26 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0
  %27 = load i32, i32* %26, align 4, !tbaa !9
  %28 = zext i32 %27 to i64
  %29 = inttoptr i64 %28 to i8*
  %30 = inttoptr i64 %28 to %struct.ethhdr*
  %31 = getelementptr i8, i8* %29, i64 14
  %32 = icmp ugt i8* %31, %25
  br i1 %32, label %669, label %33

; <label>:33:                                     ; preds = %1
  %34 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %30, i64 0, i32 2
  %35 = load i16, i16* %34, align 1, !tbaa !10
  %36 = icmp eq i16 %35, 8
  br i1 %36, label %37, label %669

; <label>:37:                                     ; preds = %33
  %38 = getelementptr i8, i8* %29, i64 34
  %39 = icmp ugt i8* %38, %25
  br i1 %39, label %669, label %40

; <label>:40:                                     ; preds = %37
  %41 = getelementptr inbounds i8, i8* %29, i64 26
  %42 = bitcast i8* %41 to i32*
  %43 = load i32, i32* %42, align 4, !tbaa !13
  %44 = tail call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %43) #3, !srcloc !15
  store i32 %44, i32* %10, align 4, !tbaa !16
  %45 = getelementptr inbounds i8, i8* %29, i64 30
  %46 = bitcast i8* %45 to i32*
  %47 = load i32, i32* %46, align 4, !tbaa !17
  %48 = tail call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %47) #3, !srcloc !15
  %49 = bitcast %struct.log* %12 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %49) #2
  %50 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 4, i64 0
  %51 = bitcast i8* %50 to i64*
  store i64 0, i64* %51, align 4
  %52 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 0
  store i32 %44, i32* %52, align 4, !tbaa !18
  %53 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 1
  store i32 0, i32* %53, align 4, !tbaa !20
  %54 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 2
  store i32 0, i32* %54, align 4, !tbaa !21
  %55 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 3
  store i32 %48, i32* %55, align 4, !tbaa !22
  %56 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %30, i64 0, i32 0, i64 0
  %57 = load i8, i8* %56, align 1, !tbaa !23
  %58 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 4, i64 0
  store i8 %57, i8* %58, align 4, !tbaa !23
  %59 = load i8, i8* %56, align 1, !tbaa !23
  %60 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 4, i64 1
  store i8 %59, i8* %60, align 1, !tbaa !23
  %61 = load i8, i8* %56, align 1, !tbaa !23
  %62 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 4, i64 2
  store i8 %61, i8* %62, align 2, !tbaa !23
  %63 = load i8, i8* %56, align 1, !tbaa !23
  %64 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 4, i64 3
  store i8 %63, i8* %64, align 1, !tbaa !23
  %65 = load i8, i8* %56, align 1, !tbaa !23
  %66 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 4, i64 4
  store i8 %65, i8* %66, align 4, !tbaa !23
  %67 = load i8, i8* %56, align 1, !tbaa !23
  %68 = getelementptr inbounds %struct.log, %struct.log* %12, i64 0, i32 4, i64 5
  store i8 %67, i8* %68, align 1, !tbaa !23
  %69 = tail call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %69, i64* %11, align 8, !tbaa !2
  %70 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %21, i8* nonnull %49, i64 0) #2
  %71 = getelementptr inbounds i8, i8* %29, i64 23
  %72 = load i8, i8* %71, align 1, !tbaa !24
  %73 = icmp eq i8 %72, 6
  br i1 %73, label %97, label %74

; <label>:74:                                     ; preds = %40
  %75 = bitcast %struct.log* %13 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %75) #2
  %76 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 4, i64 0
  %77 = bitcast i8* %76 to i64*
  store i64 0, i64* %77, align 4
  %78 = load i32, i32* %10, align 4, !tbaa !16
  %79 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 0
  store i32 %78, i32* %79, align 4, !tbaa !18
  %80 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 1
  store i32 1, i32* %80, align 4, !tbaa !20
  %81 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 2
  store i32 4, i32* %81, align 4, !tbaa !21
  %82 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 3
  store i32 %48, i32* %82, align 4, !tbaa !22
  %83 = load i8, i8* %56, align 1, !tbaa !23
  %84 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 4, i64 0
  store i8 %83, i8* %84, align 4, !tbaa !23
  %85 = load i8, i8* %56, align 1, !tbaa !23
  %86 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 4, i64 1
  store i8 %85, i8* %86, align 1, !tbaa !23
  %87 = load i8, i8* %56, align 1, !tbaa !23
  %88 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 4, i64 2
  store i8 %87, i8* %88, align 2, !tbaa !23
  %89 = load i8, i8* %56, align 1, !tbaa !23
  %90 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 4, i64 3
  store i8 %89, i8* %90, align 1, !tbaa !23
  %91 = load i8, i8* %56, align 1, !tbaa !23
  %92 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 4, i64 4
  store i8 %91, i8* %92, align 4, !tbaa !23
  %93 = load i8, i8* %56, align 1, !tbaa !23
  %94 = getelementptr inbounds %struct.log, %struct.log* %13, i64 0, i32 4, i64 5
  store i8 %93, i8* %94, align 1, !tbaa !23
  %95 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %95, i64* %11, align 8, !tbaa !2
  %96 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %21, i8* nonnull %75, i64 0) #2
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %75) #2
  br label %667

; <label>:97:                                     ; preds = %40
  %98 = getelementptr i8, i8* %29, i64 54
  %99 = icmp ugt i8* %98, %25
  br i1 %99, label %667, label %100

; <label>:100:                                    ; preds = %97
  %101 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @blacklist to i8*), i8* nonnull %20) #2
  %102 = bitcast i8* %101 to i64*
  %103 = icmp eq i8* %101, null
  br i1 %103, label %134, label %104

; <label>:104:                                    ; preds = %100
  %105 = load i64, i64* %102, align 8, !tbaa !2
  %106 = add i64 %105, 1
  store i64 %106, i64* %102, align 8, !tbaa !2
  %107 = bitcast %struct.log* %14 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %107) #2
  %108 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 4, i64 0
  %109 = bitcast i8* %108 to i64*
  store i64 0, i64* %109, align 4
  %110 = load i32, i32* %10, align 4, !tbaa !16
  %111 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 0
  store i32 %110, i32* %111, align 4, !tbaa !18
  %112 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 1
  store i32 2, i32* %112, align 4, !tbaa !20
  %113 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 2
  store i32 1, i32* %113, align 4, !tbaa !21
  %114 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 3
  store i32 %48, i32* %114, align 4, !tbaa !22
  %115 = load i8, i8* %56, align 1, !tbaa !23
  %116 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 4, i64 0
  store i8 %115, i8* %116, align 4, !tbaa !23
  %117 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %30, i64 0, i32 0, i64 1
  %118 = load i8, i8* %117, align 1, !tbaa !23
  %119 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 4, i64 1
  store i8 %118, i8* %119, align 1, !tbaa !23
  %120 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %30, i64 0, i32 0, i64 2
  %121 = load i8, i8* %120, align 1, !tbaa !23
  %122 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 4, i64 2
  store i8 %121, i8* %122, align 2, !tbaa !23
  %123 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %30, i64 0, i32 0, i64 3
  %124 = load i8, i8* %123, align 1, !tbaa !23
  %125 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 4, i64 3
  store i8 %124, i8* %125, align 1, !tbaa !23
  %126 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %30, i64 0, i32 0, i64 4
  %127 = load i8, i8* %126, align 1, !tbaa !23
  %128 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 4, i64 4
  store i8 %127, i8* %128, align 4, !tbaa !23
  %129 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %30, i64 0, i32 0, i64 5
  %130 = load i8, i8* %129, align 1, !tbaa !23
  %131 = getelementptr inbounds %struct.log, %struct.log* %14, i64 0, i32 4, i64 5
  store i8 %130, i8* %131, align 1, !tbaa !23
  %132 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %132, i64* %11, align 8, !tbaa !2
  %133 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %21, i8* nonnull %107, i64 0) #2
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %107) #2
  br label %667

; <label>:134:                                    ; preds = %100
  %135 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* nonnull %20) #2
  %136 = bitcast i8* %135 to i64*
  %137 = icmp eq i8* %135, null
  br i1 %137, label %141, label %138

; <label>:138:                                    ; preds = %134
  %139 = load i64, i64* %136, align 8, !tbaa !2
  %140 = add i64 %139, 1
  store i64 %140, i64* %136, align 8, !tbaa !2
  br label %143

; <label>:141:                                    ; preds = %134
  %142 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* nonnull %20, i8* nonnull %19, i64 1) #2
  br label %143

; <label>:143:                                    ; preds = %141, %138
  %144 = load i32, i32* %42, align 4, !tbaa !13
  %145 = load i32, i32* %46, align 4, !tbaa !17
  %146 = bitcast i8* %38 to i16*
  %147 = load i16, i16* %146, align 4, !tbaa !25
  %148 = zext i16 %147 to i32
  %149 = getelementptr inbounds i8, i8* %29, i64 36
  %150 = bitcast i8* %149 to i16*
  %151 = load i16, i16* %150, align 2, !tbaa !27
  %152 = zext i16 %151 to i32
  %153 = shl nuw i32 %152, 16
  %154 = or i32 %153, %148
  %155 = bitcast i32* %15 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %155) #2
  %156 = call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %145) #3, !srcloc !15
  store i32 %156, i32* %15, align 4, !tbaa !16
  %157 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @services to i8*), i8* nonnull %155) #2
  %158 = icmp eq i8* %157, null
  br i1 %158, label %637, label %159

; <label>:159:                                    ; preds = %143
  %160 = getelementptr inbounds i8, i8* %29, i64 46
  %161 = bitcast i8* %160 to i16*
  %162 = load i16, i16* %161, align 4
  %163 = and i16 %162, 512
  %164 = icmp eq i16 %163, 0
  br i1 %164, label %360, label %165

; <label>:165:                                    ; preds = %159
  %166 = bitcast i32* %6 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %166) #2
  %167 = add i32 %144, -559038217
  %168 = add i32 %154, -559038217
  %169 = xor i32 %168, -559038217
  %170 = shl i32 %168, 14
  %171 = lshr i32 %168, 18
  %172 = or i32 %171, %170
  %173 = sub i32 %169, %172
  %174 = xor i32 %173, %167
  %175 = shl i32 %173, 11
  %176 = lshr i32 %173, 21
  %177 = or i32 %176, %175
  %178 = sub i32 %174, %177
  %179 = xor i32 %178, %168
  %180 = shl i32 %178, 25
  %181 = lshr i32 %178, 7
  %182 = or i32 %181, %180
  %183 = sub i32 %179, %182
  %184 = xor i32 %183, %173
  %185 = shl i32 %183, 16
  %186 = lshr i32 %183, 16
  %187 = or i32 %186, %185
  %188 = sub i32 %184, %187
  %189 = xor i32 %188, %178
  %190 = shl i32 %188, 4
  %191 = lshr i32 %188, 28
  %192 = or i32 %191, %190
  %193 = sub i32 %189, %192
  %194 = xor i32 %193, %183
  %195 = shl i32 %193, 14
  %196 = lshr i32 %193, 18
  %197 = or i32 %196, %195
  %198 = sub i32 %194, %197
  %199 = xor i32 %198, %188
  %200 = lshr i32 %198, 8
  %201 = sub i32 %199, %200
  %202 = and i32 %201, 511
  store i32 %202, i32* %6, align 4, !tbaa !16
  %203 = bitcast i32* %7 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %203) #2
  store i32 %156, i32* %7, align 4, !tbaa !16
  %204 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @services to i8*), i8* nonnull %203) #2
  %205 = bitcast i32* %8 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %205) #2
  store i32 513, i32* %8, align 4, !tbaa !16
  %206 = icmp eq i8* %204, null
  br i1 %206, label %359, label %207

; <label>:207:                                    ; preds = %165
  %208 = getelementptr inbounds i8, i8* %204, i64 16
  %209 = bitcast i8* %208 to i64*
  %210 = load i64, i64* %209, align 8, !tbaa !28
  %211 = bitcast i8* %204 to i64*
  %212 = load i64, i64* %211, align 8, !tbaa !30
  %213 = add i64 %212, 1
  %214 = and i64 %213, 4294967295
  %215 = urem i64 %214, %210
  %216 = add i64 %215, %210
  %217 = trunc i64 %216 to i32
  store i32 %217, i32* %8, align 4, !tbaa !16
  %218 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %205) #2
  %219 = icmp eq i8* %218, null
  br i1 %219, label %220, label %222

; <label>:220:                                    ; preds = %207
  %221 = load i32, i32* %8, align 4, !tbaa !16
  br label %226

; <label>:222:                                    ; preds = %207
  %223 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %166, i8* nonnull %205, i64 0) #2
  %224 = load i32, i32* %8, align 4, !tbaa !16
  %225 = zext i32 %224 to i64
  store i64 %225, i64* %211, align 8, !tbaa !30
  br label %226

; <label>:226:                                    ; preds = %222, %220
  %227 = phi i32 [ %221, %220 ], [ %224, %222 ]
  %228 = add i32 %227, 1
  %229 = zext i32 %228 to i64
  %230 = urem i64 %229, %210
  %231 = add i64 %230, %210
  %232 = trunc i64 %231 to i32
  store i32 %232, i32* %8, align 4, !tbaa !16
  %233 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %205) #2
  %234 = icmp eq i8* %233, null
  br i1 %234, label %235, label %237

; <label>:235:                                    ; preds = %226
  %236 = load i32, i32* %8, align 4, !tbaa !16
  br label %241

; <label>:237:                                    ; preds = %226
  %238 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %166, i8* nonnull %205, i64 0) #2
  %239 = load i32, i32* %8, align 4, !tbaa !16
  %240 = zext i32 %239 to i64
  store i64 %240, i64* %211, align 8, !tbaa !30
  br label %241

; <label>:241:                                    ; preds = %237, %235
  %242 = phi i32 [ %236, %235 ], [ %239, %237 ]
  %243 = add i32 %242, 1
  %244 = zext i32 %243 to i64
  %245 = urem i64 %244, %210
  %246 = add i64 %245, %210
  %247 = trunc i64 %246 to i32
  store i32 %247, i32* %8, align 4, !tbaa !16
  %248 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %205) #2
  %249 = icmp eq i8* %248, null
  br i1 %249, label %250, label %252

; <label>:250:                                    ; preds = %241
  %251 = load i32, i32* %8, align 4, !tbaa !16
  br label %256

; <label>:252:                                    ; preds = %241
  %253 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %166, i8* nonnull %205, i64 0) #2
  %254 = load i32, i32* %8, align 4, !tbaa !16
  %255 = zext i32 %254 to i64
  store i64 %255, i64* %211, align 8, !tbaa !30
  br label %256

; <label>:256:                                    ; preds = %252, %250
  %257 = phi i32 [ %251, %250 ], [ %254, %252 ]
  %258 = add i32 %257, 1
  %259 = zext i32 %258 to i64
  %260 = urem i64 %259, %210
  %261 = add i64 %260, %210
  %262 = trunc i64 %261 to i32
  store i32 %262, i32* %8, align 4, !tbaa !16
  %263 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %205) #2
  %264 = icmp eq i8* %263, null
  br i1 %264, label %265, label %267

; <label>:265:                                    ; preds = %256
  %266 = load i32, i32* %8, align 4, !tbaa !16
  br label %271

; <label>:267:                                    ; preds = %256
  %268 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %166, i8* nonnull %205, i64 0) #2
  %269 = load i32, i32* %8, align 4, !tbaa !16
  %270 = zext i32 %269 to i64
  store i64 %270, i64* %211, align 8, !tbaa !30
  br label %271

; <label>:271:                                    ; preds = %267, %265
  %272 = phi i32 [ %266, %265 ], [ %269, %267 ]
  %273 = add i32 %272, 1
  %274 = zext i32 %273 to i64
  %275 = urem i64 %274, %210
  %276 = add i64 %275, %210
  %277 = trunc i64 %276 to i32
  store i32 %277, i32* %8, align 4, !tbaa !16
  %278 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %205) #2
  %279 = icmp eq i8* %278, null
  br i1 %279, label %280, label %282

; <label>:280:                                    ; preds = %271
  %281 = load i32, i32* %8, align 4, !tbaa !16
  br label %286

; <label>:282:                                    ; preds = %271
  %283 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %166, i8* nonnull %205, i64 0) #2
  %284 = load i32, i32* %8, align 4, !tbaa !16
  %285 = zext i32 %284 to i64
  store i64 %285, i64* %211, align 8, !tbaa !30
  br label %286

; <label>:286:                                    ; preds = %282, %280
  %287 = phi i32 [ %281, %280 ], [ %284, %282 ]
  %288 = add i32 %287, 1
  %289 = zext i32 %288 to i64
  %290 = urem i64 %289, %210
  %291 = add i64 %290, %210
  %292 = trunc i64 %291 to i32
  store i32 %292, i32* %8, align 4, !tbaa !16
  %293 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %205) #2
  %294 = icmp eq i8* %293, null
  br i1 %294, label %295, label %297

; <label>:295:                                    ; preds = %286
  %296 = load i32, i32* %8, align 4, !tbaa !16
  br label %301

; <label>:297:                                    ; preds = %286
  %298 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %166, i8* nonnull %205, i64 0) #2
  %299 = load i32, i32* %8, align 4, !tbaa !16
  %300 = zext i32 %299 to i64
  store i64 %300, i64* %211, align 8, !tbaa !30
  br label %301

; <label>:301:                                    ; preds = %297, %295
  %302 = phi i32 [ %296, %295 ], [ %299, %297 ]
  %303 = add i32 %302, 1
  %304 = zext i32 %303 to i64
  %305 = urem i64 %304, %210
  %306 = add i64 %305, %210
  %307 = trunc i64 %306 to i32
  store i32 %307, i32* %8, align 4, !tbaa !16
  %308 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %205) #2
  %309 = icmp eq i8* %308, null
  br i1 %309, label %310, label %312

; <label>:310:                                    ; preds = %301
  %311 = load i32, i32* %8, align 4, !tbaa !16
  br label %316

; <label>:312:                                    ; preds = %301
  %313 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %166, i8* nonnull %205, i64 0) #2
  %314 = load i32, i32* %8, align 4, !tbaa !16
  %315 = zext i32 %314 to i64
  store i64 %315, i64* %211, align 8, !tbaa !30
  br label %316

; <label>:316:                                    ; preds = %312, %310
  %317 = phi i32 [ %311, %310 ], [ %314, %312 ]
  %318 = add i32 %317, 1
  %319 = zext i32 %318 to i64
  %320 = urem i64 %319, %210
  %321 = add i64 %320, %210
  %322 = trunc i64 %321 to i32
  store i32 %322, i32* %8, align 4, !tbaa !16
  %323 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %205) #2
  %324 = icmp eq i8* %323, null
  br i1 %324, label %325, label %327

; <label>:325:                                    ; preds = %316
  %326 = load i32, i32* %8, align 4, !tbaa !16
  br label %331

; <label>:327:                                    ; preds = %316
  %328 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %166, i8* nonnull %205, i64 0) #2
  %329 = load i32, i32* %8, align 4, !tbaa !16
  %330 = zext i32 %329 to i64
  store i64 %330, i64* %211, align 8, !tbaa !30
  br label %331

; <label>:331:                                    ; preds = %327, %325
  %332 = phi i32 [ %326, %325 ], [ %329, %327 ]
  %333 = add i32 %332, 1
  %334 = zext i32 %333 to i64
  %335 = urem i64 %334, %210
  %336 = add i64 %335, %210
  %337 = trunc i64 %336 to i32
  store i32 %337, i32* %8, align 4, !tbaa !16
  %338 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %205) #2
  %339 = icmp eq i8* %338, null
  br i1 %339, label %340, label %342

; <label>:340:                                    ; preds = %331
  %341 = load i32, i32* %8, align 4, !tbaa !16
  br label %346

; <label>:342:                                    ; preds = %331
  %343 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %166, i8* nonnull %205, i64 0) #2
  %344 = load i32, i32* %8, align 4, !tbaa !16
  %345 = zext i32 %344 to i64
  store i64 %345, i64* %211, align 8, !tbaa !30
  br label %346

; <label>:346:                                    ; preds = %342, %340
  %347 = phi i32 [ %341, %340 ], [ %344, %342 ]
  %348 = add i32 %347, 1
  %349 = zext i32 %348 to i64
  %350 = urem i64 %349, %210
  %351 = add i64 %350, %210
  %352 = trunc i64 %351 to i32
  store i32 %352, i32* %8, align 4, !tbaa !16
  %353 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %205) #2
  %354 = icmp eq i8* %353, null
  br i1 %354, label %359, label %355

; <label>:355:                                    ; preds = %346
  %356 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %166, i8* nonnull %205, i64 0) #2
  %357 = load i32, i32* %8, align 4, !tbaa !16
  %358 = zext i32 %357 to i64
  store i64 %358, i64* %211, align 8, !tbaa !30
  br label %359

; <label>:359:                                    ; preds = %165, %346, %355
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %205) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %203) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %166) #2
  br label %439

; <label>:360:                                    ; preds = %159
  %361 = and i16 %162, 256
  %362 = icmp eq i16 %361, 0
  br i1 %362, label %363, label %400

; <label>:363:                                    ; preds = %360
  %364 = add i32 %144, -559038217
  %365 = add i32 %154, -559038217
  %366 = xor i32 %365, -559038217
  %367 = shl i32 %365, 14
  %368 = lshr i32 %365, 18
  %369 = or i32 %368, %367
  %370 = sub i32 %366, %369
  %371 = xor i32 %370, %364
  %372 = shl i32 %370, 11
  %373 = lshr i32 %370, 21
  %374 = or i32 %373, %372
  %375 = sub i32 %371, %374
  %376 = xor i32 %375, %365
  %377 = shl i32 %375, 25
  %378 = lshr i32 %375, 7
  %379 = or i32 %378, %377
  %380 = sub i32 %376, %379
  %381 = xor i32 %380, %370
  %382 = shl i32 %380, 16
  %383 = lshr i32 %380, 16
  %384 = or i32 %383, %382
  %385 = sub i32 %381, %384
  %386 = xor i32 %385, %375
  %387 = shl i32 %385, 4
  %388 = lshr i32 %385, 28
  %389 = or i32 %388, %387
  %390 = sub i32 %386, %389
  %391 = xor i32 %390, %380
  %392 = shl i32 %390, 14
  %393 = lshr i32 %390, 18
  %394 = or i32 %393, %392
  %395 = sub i32 %391, %394
  %396 = xor i32 %395, %385
  %397 = lshr i32 %395, 8
  %398 = sub i32 %396, %397
  %399 = and i32 %398, 511
  br label %439

; <label>:400:                                    ; preds = %360
  %401 = bitcast i32* %5 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %401) #2
  %402 = add i32 %144, -559038217
  %403 = add i32 %154, -559038217
  %404 = xor i32 %403, -559038217
  %405 = shl i32 %403, 14
  %406 = lshr i32 %403, 18
  %407 = or i32 %406, %405
  %408 = sub i32 %404, %407
  %409 = xor i32 %408, %402
  %410 = shl i32 %408, 11
  %411 = lshr i32 %408, 21
  %412 = or i32 %411, %410
  %413 = sub i32 %409, %412
  %414 = xor i32 %413, %403
  %415 = shl i32 %413, 25
  %416 = lshr i32 %413, 7
  %417 = or i32 %416, %415
  %418 = sub i32 %414, %417
  %419 = xor i32 %418, %408
  %420 = shl i32 %418, 16
  %421 = lshr i32 %418, 16
  %422 = or i32 %421, %420
  %423 = sub i32 %419, %422
  %424 = xor i32 %423, %413
  %425 = shl i32 %423, 4
  %426 = lshr i32 %423, 28
  %427 = or i32 %426, %425
  %428 = sub i32 %424, %427
  %429 = xor i32 %428, %418
  %430 = shl i32 %428, 14
  %431 = lshr i32 %428, 18
  %432 = or i32 %431, %430
  %433 = sub i32 %429, %432
  %434 = xor i32 %433, %423
  %435 = lshr i32 %433, 8
  %436 = sub i32 %434, %435
  %437 = and i32 %436, 511
  store i32 %437, i32* %5, align 4, !tbaa !16
  %438 = call i32 inttoptr (i64 3 to i32 (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %401) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %401) #2
  br label %439

; <label>:439:                                    ; preds = %363, %400, %359
  %440 = phi i32 [ %399, %363 ], [ %437, %400 ], [ %202, %359 ]
  %441 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %441) #2
  %442 = bitcast i32* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %442) #2
  %443 = bitcast i32* %4 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %443) #2
  store i32 513, i32* %4, align 4, !tbaa !16
  store i32 0, i32* %2, align 4, !tbaa !16
  store i32 %440, i32* %3, align 4, !tbaa !16
  %444 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %442) #2
  %445 = icmp eq i8* %444, null
  br i1 %445, label %449, label %446

; <label>:446:                                    ; preds = %439
  %447 = bitcast i8* %444 to i32*
  %448 = load i32, i32* %447, align 4, !tbaa !16
  store i32 %448, i32* %4, align 4, !tbaa !16
  br label %451

; <label>:449:                                    ; preds = %439
  %450 = load i32, i32* %4, align 4, !tbaa !16
  br label %451

; <label>:451:                                    ; preds = %449, %446
  %452 = phi i32 [ %450, %449 ], [ %448, %446 ]
  %453 = icmp eq i32 %452, 513
  br i1 %453, label %459, label %454

; <label>:454:                                    ; preds = %451
  %455 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %443) #2
  %456 = icmp eq i8* %455, null
  br i1 %456, label %459, label %457

; <label>:457:                                    ; preds = %454
  %458 = bitcast i8* %455 to %struct.dest_info*
  br label %562

; <label>:459:                                    ; preds = %454, %451
  store i32 %156, i32* %2, align 4, !tbaa !16
  %460 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @services to i8*), i8* nonnull %441) #2
  %461 = icmp eq i8* %460, null
  br i1 %461, label %562, label %462

; <label>:462:                                    ; preds = %459
  %463 = getelementptr inbounds i8, i8* %460, i64 16
  %464 = bitcast i8* %463 to i64*
  %465 = load i64, i64* %464, align 8, !tbaa !28
  %466 = bitcast i8* %460 to i64*
  %467 = load i64, i64* %466, align 8, !tbaa !30
  %468 = add i64 %467, 1
  %469 = and i64 %468, 4294967295
  %470 = urem i64 %469, %465
  %471 = add i64 %470, %465
  %472 = trunc i64 %471 to i32
  store i32 %472, i32* %4, align 4, !tbaa !16
  %473 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %443) #2
  %474 = icmp eq i8* %473, null
  br i1 %474, label %475, label %484

; <label>:475:                                    ; preds = %462
  %476 = load i32, i32* %4, align 4, !tbaa !16
  %477 = add i32 %476, 1
  %478 = zext i32 %477 to i64
  %479 = urem i64 %478, %465
  %480 = add i64 %479, %465
  %481 = trunc i64 %480 to i32
  store i32 %481, i32* %4, align 4, !tbaa !16
  %482 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %443) #2
  %483 = icmp eq i8* %482, null
  br i1 %483, label %490, label %484

; <label>:484:                                    ; preds = %553, %544, %535, %526, %517, %508, %499, %490, %475, %462
  %485 = phi i8* [ %473, %462 ], [ %482, %475 ], [ %497, %490 ], [ %506, %499 ], [ %515, %508 ], [ %524, %517 ], [ %533, %526 ], [ %542, %535 ], [ %551, %544 ], [ %560, %553 ]
  %486 = bitcast i8* %485 to %struct.dest_info*
  %487 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %442, i8* nonnull %443, i64 0) #2
  %488 = load i32, i32* %4, align 4, !tbaa !16
  %489 = zext i32 %488 to i64
  store i64 %489, i64* %466, align 8, !tbaa !30
  br label %562

; <label>:490:                                    ; preds = %475
  %491 = load i32, i32* %4, align 4, !tbaa !16
  %492 = add i32 %491, 1
  %493 = zext i32 %492 to i64
  %494 = urem i64 %493, %465
  %495 = add i64 %494, %465
  %496 = trunc i64 %495 to i32
  store i32 %496, i32* %4, align 4, !tbaa !16
  %497 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %443) #2
  %498 = icmp eq i8* %497, null
  br i1 %498, label %499, label %484

; <label>:499:                                    ; preds = %490
  %500 = load i32, i32* %4, align 4, !tbaa !16
  %501 = add i32 %500, 1
  %502 = zext i32 %501 to i64
  %503 = urem i64 %502, %465
  %504 = add i64 %503, %465
  %505 = trunc i64 %504 to i32
  store i32 %505, i32* %4, align 4, !tbaa !16
  %506 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %443) #2
  %507 = icmp eq i8* %506, null
  br i1 %507, label %508, label %484

; <label>:508:                                    ; preds = %499
  %509 = load i32, i32* %4, align 4, !tbaa !16
  %510 = add i32 %509, 1
  %511 = zext i32 %510 to i64
  %512 = urem i64 %511, %465
  %513 = add i64 %512, %465
  %514 = trunc i64 %513 to i32
  store i32 %514, i32* %4, align 4, !tbaa !16
  %515 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %443) #2
  %516 = icmp eq i8* %515, null
  br i1 %516, label %517, label %484

; <label>:517:                                    ; preds = %508
  %518 = load i32, i32* %4, align 4, !tbaa !16
  %519 = add i32 %518, 1
  %520 = zext i32 %519 to i64
  %521 = urem i64 %520, %465
  %522 = add i64 %521, %465
  %523 = trunc i64 %522 to i32
  store i32 %523, i32* %4, align 4, !tbaa !16
  %524 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %443) #2
  %525 = icmp eq i8* %524, null
  br i1 %525, label %526, label %484

; <label>:526:                                    ; preds = %517
  %527 = load i32, i32* %4, align 4, !tbaa !16
  %528 = add i32 %527, 1
  %529 = zext i32 %528 to i64
  %530 = urem i64 %529, %465
  %531 = add i64 %530, %465
  %532 = trunc i64 %531 to i32
  store i32 %532, i32* %4, align 4, !tbaa !16
  %533 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %443) #2
  %534 = icmp eq i8* %533, null
  br i1 %534, label %535, label %484

; <label>:535:                                    ; preds = %526
  %536 = load i32, i32* %4, align 4, !tbaa !16
  %537 = add i32 %536, 1
  %538 = zext i32 %537 to i64
  %539 = urem i64 %538, %465
  %540 = add i64 %539, %465
  %541 = trunc i64 %540 to i32
  store i32 %541, i32* %4, align 4, !tbaa !16
  %542 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %443) #2
  %543 = icmp eq i8* %542, null
  br i1 %543, label %544, label %484

; <label>:544:                                    ; preds = %535
  %545 = load i32, i32* %4, align 4, !tbaa !16
  %546 = add i32 %545, 1
  %547 = zext i32 %546 to i64
  %548 = urem i64 %547, %465
  %549 = add i64 %548, %465
  %550 = trunc i64 %549 to i32
  store i32 %550, i32* %4, align 4, !tbaa !16
  %551 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %443) #2
  %552 = icmp eq i8* %551, null
  br i1 %552, label %553, label %484

; <label>:553:                                    ; preds = %544
  %554 = load i32, i32* %4, align 4, !tbaa !16
  %555 = add i32 %554, 1
  %556 = zext i32 %555 to i64
  %557 = urem i64 %556, %465
  %558 = add i64 %557, %465
  %559 = trunc i64 %558 to i32
  store i32 %559, i32* %4, align 4, !tbaa !16
  %560 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %443) #2
  %561 = icmp eq i8* %560, null
  br i1 %561, label %562, label %484

; <label>:562:                                    ; preds = %457, %459, %484, %553
  %563 = phi %struct.dest_info* [ %458, %457 ], [ %486, %484 ], [ null, %459 ], [ null, %553 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %443) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %442) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %441) #2
  %564 = icmp eq %struct.dest_info* %563, null
  br i1 %564, label %565, label %593

; <label>:565:                                    ; preds = %562
  %566 = bitcast %struct.log* %16 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %566) #2
  %567 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 4, i64 0
  %568 = bitcast i8* %567 to i64*
  store i64 0, i64* %568, align 4
  %569 = load i32, i32* %10, align 4, !tbaa !16
  %570 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 0
  store i32 %569, i32* %570, align 4, !tbaa !18
  %571 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 1
  store i32 2, i32* %571, align 4, !tbaa !20
  %572 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 2
  store i32 2, i32* %572, align 4, !tbaa !21
  %573 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 3
  store i32 %48, i32* %573, align 4, !tbaa !22
  %574 = load i8, i8* %56, align 1, !tbaa !23
  %575 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 4, i64 0
  store i8 %574, i8* %575, align 4, !tbaa !23
  %576 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %30, i64 0, i32 0, i64 1
  %577 = load i8, i8* %576, align 1, !tbaa !23
  %578 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 4, i64 1
  store i8 %577, i8* %578, align 1, !tbaa !23
  %579 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %30, i64 0, i32 0, i64 2
  %580 = load i8, i8* %579, align 1, !tbaa !23
  %581 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 4, i64 2
  store i8 %580, i8* %581, align 2, !tbaa !23
  %582 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %30, i64 0, i32 0, i64 3
  %583 = load i8, i8* %582, align 1, !tbaa !23
  %584 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 4, i64 3
  store i8 %583, i8* %584, align 1, !tbaa !23
  %585 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %30, i64 0, i32 0, i64 4
  %586 = load i8, i8* %585, align 1, !tbaa !23
  %587 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 4, i64 4
  store i8 %586, i8* %587, align 4, !tbaa !23
  %588 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %30, i64 0, i32 0, i64 5
  %589 = load i8, i8* %588, align 1, !tbaa !23
  %590 = getelementptr inbounds %struct.log, %struct.log* %16, i64 0, i32 4, i64 5
  store i8 %589, i8* %590, align 1, !tbaa !23
  %591 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %591, i64* %11, align 8, !tbaa !2
  %592 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %21, i8* nonnull %566, i64 0) #2
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %566) #2
  br label %665

; <label>:593:                                    ; preds = %562
  %594 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %563, i64 0, i32 5, i64 0
  %595 = load i8, i8* %594, align 8, !tbaa !23
  store i8 %595, i8* %56, align 1, !tbaa !23
  %596 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %563, i64 0, i32 5, i64 1
  %597 = load i8, i8* %596, align 1, !tbaa !23
  %598 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %30, i64 0, i32 0, i64 1
  store i8 %597, i8* %598, align 1, !tbaa !23
  %599 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %563, i64 0, i32 5, i64 2
  %600 = load i8, i8* %599, align 2, !tbaa !23
  %601 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %30, i64 0, i32 0, i64 2
  store i8 %600, i8* %601, align 1, !tbaa !23
  %602 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %563, i64 0, i32 5, i64 3
  %603 = load i8, i8* %602, align 1, !tbaa !23
  %604 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %30, i64 0, i32 0, i64 3
  store i8 %603, i8* %604, align 1, !tbaa !23
  %605 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %563, i64 0, i32 5, i64 4
  %606 = load i8, i8* %605, align 4, !tbaa !23
  %607 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %30, i64 0, i32 0, i64 4
  store i8 %606, i8* %607, align 1, !tbaa !23
  %608 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %563, i64 0, i32 5, i64 5
  %609 = load i8, i8* %608, align 1, !tbaa !23
  %610 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %30, i64 0, i32 0, i64 5
  store i8 %609, i8* %610, align 1, !tbaa !23
  %611 = bitcast %struct.log* %17 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %611) #2
  call void @llvm.memset.p0i8.i64(i8* nonnull %611, i8 0, i64 24, i32 4, i1 false)
  %612 = load i32, i32* %10, align 4, !tbaa !16
  %613 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 0
  store i32 %612, i32* %613, align 4, !tbaa !18
  %614 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 1
  store i32 1, i32* %614, align 4, !tbaa !20
  %615 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 2
  store i32 0, i32* %615, align 4, !tbaa !21
  %616 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 3
  store i32 %48, i32* %616, align 4, !tbaa !22
  %617 = load i8, i8* %594, align 8, !tbaa !23
  %618 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 4, i64 0
  store i8 %617, i8* %618, align 4, !tbaa !23
  %619 = load i8, i8* %596, align 1, !tbaa !23
  %620 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 4, i64 1
  store i8 %619, i8* %620, align 1, !tbaa !23
  %621 = load i8, i8* %599, align 2, !tbaa !23
  %622 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 4, i64 2
  store i8 %621, i8* %622, align 2, !tbaa !23
  %623 = load i8, i8* %602, align 1, !tbaa !23
  %624 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 4, i64 3
  store i8 %623, i8* %624, align 1, !tbaa !23
  %625 = load i8, i8* %605, align 4, !tbaa !23
  %626 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 4, i64 4
  store i8 %625, i8* %626, align 4, !tbaa !23
  %627 = load i8, i8* %608, align 1, !tbaa !23
  %628 = getelementptr inbounds %struct.log, %struct.log* %17, i64 0, i32 4, i64 5
  store i8 %627, i8* %628, align 1, !tbaa !23
  %629 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %629, i64* %11, align 8, !tbaa !2
  %630 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %21, i8* nonnull %611, i64 0) #2
  %631 = sub nsw i64 %24, %28
  %632 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %563, i64 0, i32 4
  %633 = atomicrmw add i64* %632, i64 1 seq_cst
  %634 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %563, i64 0, i32 3
  %635 = and i64 %631, 65535
  %636 = atomicrmw add i64* %634, i64 %635 seq_cst
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %611) #2
  br label %665

; <label>:637:                                    ; preds = %143
  %638 = bitcast %struct.log* %18 to i8*
  call void @llvm.lifetime.start.p0i8(i64 24, i8* nonnull %638) #2
  %639 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 4, i64 0
  %640 = bitcast i8* %639 to i64*
  store i64 0, i64* %640, align 4
  %641 = load i32, i32* %10, align 4, !tbaa !16
  %642 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 0
  store i32 %641, i32* %642, align 4, !tbaa !18
  %643 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 1
  store i32 1, i32* %643, align 4, !tbaa !20
  %644 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 2
  store i32 0, i32* %644, align 4, !tbaa !21
  %645 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 3
  store i32 %48, i32* %645, align 4, !tbaa !22
  %646 = load i8, i8* %56, align 1, !tbaa !23
  %647 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 4, i64 0
  store i8 %646, i8* %647, align 4, !tbaa !23
  %648 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %30, i64 0, i32 0, i64 1
  %649 = load i8, i8* %648, align 1, !tbaa !23
  %650 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 4, i64 1
  store i8 %649, i8* %650, align 1, !tbaa !23
  %651 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %30, i64 0, i32 0, i64 2
  %652 = load i8, i8* %651, align 1, !tbaa !23
  %653 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 4, i64 2
  store i8 %652, i8* %653, align 2, !tbaa !23
  %654 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %30, i64 0, i32 0, i64 3
  %655 = load i8, i8* %654, align 1, !tbaa !23
  %656 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 4, i64 3
  store i8 %655, i8* %656, align 1, !tbaa !23
  %657 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %30, i64 0, i32 0, i64 4
  %658 = load i8, i8* %657, align 1, !tbaa !23
  %659 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 4, i64 4
  store i8 %658, i8* %659, align 4, !tbaa !23
  %660 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %30, i64 0, i32 0, i64 5
  %661 = load i8, i8* %660, align 1, !tbaa !23
  %662 = getelementptr inbounds %struct.log, %struct.log* %18, i64 0, i32 4, i64 5
  store i8 %661, i8* %662, align 1, !tbaa !23
  %663 = call i64 inttoptr (i64 5 to i64 ()*)() #2
  store i64 %663, i64* %11, align 8, !tbaa !2
  %664 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @logs to i8*), i8* nonnull %21, i8* nonnull %638, i64 0) #2
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %638) #2
  br label %665

; <label>:665:                                    ; preds = %637, %593, %565
  %666 = phi i32 [ 1, %565 ], [ 3, %593 ], [ 2, %637 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %155) #2
  br label %667

; <label>:667:                                    ; preds = %104, %665, %97, %74
  %668 = phi i32 [ 2, %74 ], [ 1, %104 ], [ %666, %665 ], [ 1, %97 ]
  call void @llvm.lifetime.end.p0i8(i64 24, i8* nonnull %49) #2
  br label %669

; <label>:669:                                    ; preds = %667, %37, %33, %1
  %670 = phi i32 [ 1, %1 ], [ 2, %33 ], [ %668, %667 ], [ 1, %37 ]
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %21) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %20) #2
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %19) #2
  ret i32 %670
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
!15 = !{i32 555282}
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
