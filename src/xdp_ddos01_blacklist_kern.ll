; ModuleID = 'xdp_ddos01_blacklist_kern.c'
source_filename = "xdp_ddos01_blacklist_kern.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.dest_info = type { i32, i32, i32, i64, i64, [6 x i8] }

@blacklist = global %struct.bpf_map_def { i32 5, i32 4, i32 8, i32 100000, i32 1, i32 0, i32 0 }, section "maps", align 4
@ip_watchlist = global %struct.bpf_map_def { i32 5, i32 4, i32 8, i32 100000, i32 1, i32 0, i32 0 }, section "maps", align 4
@enter_logs = global %struct.bpf_map_def { i32 5, i32 4, i32 8, i32 100000, i32 1, i32 0, i32 0 }, section "maps", align 4
@drop_logs = global %struct.bpf_map_def { i32 5, i32 4, i32 8, i32 100000, i32 1, i32 0, i32 0 }, section "maps", align 4
@pass_logs = global %struct.bpf_map_def { i32 5, i32 4, i32 8, i32 100000, i32 1, i32 0, i32 0 }, section "maps", align 4
@servers = global %struct.bpf_map_def { i32 1, i32 4, i32 40, i32 512, i32 0, i32 0, i32 0 }, section "maps", align 4
@services = global %struct.bpf_map_def { i32 1, i32 4, i32 24, i32 512, i32 0, i32 0, i32 0 }, section "maps", align 4
@destinations = global %struct.bpf_map_def { i32 1, i32 4, i32 4, i32 512, i32 0, i32 0, i32 0 }, section "maps", align 4
@verdict_cnt = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 4, i32 0, i32 0, i32 0 }, section "maps", align 4
@port_blacklist = global %struct.bpf_map_def { i32 6, i32 4, i32 4, i32 65536, i32 0, i32 0, i32 0 }, section "maps", align 4
@port_blacklist_drop_count_tcp = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 65536, i32 0, i32 0, i32 0 }, section "maps", align 4
@port_blacklist_drop_count_udp = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 65536, i32 0, i32 0, i32 0 }, section "maps", align 4
@_license = global [4 x i8] c"GPL\00", section "license", align 1
@llvm.used = appending global [14 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @blacklist to i8*), i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* bitcast (%struct.bpf_map_def* @drop_logs to i8*), i8* bitcast (%struct.bpf_map_def* @enter_logs to i8*), i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* bitcast (%struct.bpf_map_def* @pass_logs to i8*), i8* bitcast (%struct.bpf_map_def* @port_blacklist to i8*), i8* bitcast (%struct.bpf_map_def* @port_blacklist_drop_count_tcp to i8*), i8* bitcast (%struct.bpf_map_def* @port_blacklist_drop_count_udp to i8*), i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* bitcast (%struct.bpf_map_def* @services to i8*), i8* bitcast (%struct.bpf_map_def* @verdict_cnt to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_program to i8*)], section "llvm.metadata"

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
  %10 = alloca i64, align 8
  %11 = alloca i64, align 8
  %12 = alloca i64, align 8
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  %15 = bitcast i64* %9 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %15) #2
  store i64 1, i64* %9, align 8, !tbaa !2
  %16 = bitcast i64* %10 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %16) #2
  store i64 1, i64* %10, align 8, !tbaa !2
  %17 = bitcast i64* %11 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %17) #2
  store i64 1, i64* %11, align 8, !tbaa !2
  %18 = bitcast i64* %12 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %18) #2
  store i64 1, i64* %12, align 8, !tbaa !2
  %19 = bitcast i32* %13 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %19) #2
  %20 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %21 = load i32, i32* %20, align 4, !tbaa !6
  %22 = zext i32 %21 to i64
  %23 = inttoptr i64 %22 to i8*
  %24 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0
  %25 = load i32, i32* %24, align 4, !tbaa !9
  %26 = zext i32 %25 to i64
  %27 = inttoptr i64 %26 to i8*
  %28 = inttoptr i64 %26 to %struct.ethhdr*
  %29 = getelementptr i8, i8* %27, i64 14
  %30 = icmp ugt i8* %29, %23
  br i1 %30, label %539, label %31

; <label>:31:                                     ; preds = %1
  %32 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %28, i64 0, i32 2
  %33 = load i16, i16* %32, align 1, !tbaa !10
  %34 = icmp eq i16 %33, 8
  br i1 %34, label %35, label %539

; <label>:35:                                     ; preds = %31
  %36 = getelementptr i8, i8* %27, i64 34
  %37 = icmp ugt i8* %36, %23
  br i1 %37, label %539, label %38

; <label>:38:                                     ; preds = %35
  %39 = getelementptr inbounds i8, i8* %27, i64 23
  %40 = load i8, i8* %39, align 1, !tbaa !13
  %41 = icmp eq i8 %40, 6
  br i1 %41, label %42, label %539

; <label>:42:                                     ; preds = %38
  %43 = getelementptr i8, i8* %27, i64 54
  %44 = icmp ugt i8* %43, %23
  br i1 %44, label %539, label %45

; <label>:45:                                     ; preds = %42
  %46 = getelementptr inbounds i8, i8* %27, i64 26
  %47 = bitcast i8* %46 to i32*
  %48 = load i32, i32* %47, align 4, !tbaa !15
  %49 = tail call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %48) #3, !srcloc !16
  store i32 %49, i32* %13, align 4, !tbaa !17
  %50 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @enter_logs to i8*), i8* nonnull %19) #2
  %51 = bitcast i8* %50 to i64*
  %52 = icmp eq i8* %50, null
  br i1 %52, label %56, label %53

; <label>:53:                                     ; preds = %45
  %54 = load i64, i64* %51, align 8, !tbaa !2
  %55 = add i64 %54, 1
  store i64 %55, i64* %51, align 8, !tbaa !2
  br label %58

; <label>:56:                                     ; preds = %45
  %57 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @enter_logs to i8*), i8* nonnull %19, i8* nonnull %16, i64 1) #2
  br label %58

; <label>:58:                                     ; preds = %56, %53
  %59 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @blacklist to i8*), i8* nonnull %19) #2
  %60 = bitcast i8* %59 to i64*
  %61 = icmp eq i8* %59, null
  br i1 %61, label %73, label %62

; <label>:62:                                     ; preds = %58
  %63 = load i64, i64* %60, align 8, !tbaa !2
  %64 = add i64 %63, 1
  store i64 %64, i64* %60, align 8, !tbaa !2
  %65 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @drop_logs to i8*), i8* nonnull %19) #2
  %66 = bitcast i8* %65 to i64*
  %67 = icmp eq i8* %65, null
  br i1 %67, label %71, label %68

; <label>:68:                                     ; preds = %62
  %69 = load i64, i64* %66, align 8, !tbaa !2
  %70 = add i64 %69, 1
  store i64 %70, i64* %66, align 8, !tbaa !2
  br label %539

; <label>:71:                                     ; preds = %62
  %72 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @drop_logs to i8*), i8* nonnull %19, i8* nonnull %15, i64 1) #2
  br label %539

; <label>:73:                                     ; preds = %58
  %74 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* nonnull %19) #2
  %75 = bitcast i8* %74 to i64*
  %76 = icmp eq i8* %74, null
  br i1 %76, label %80, label %77

; <label>:77:                                     ; preds = %73
  %78 = load i64, i64* %75, align 8, !tbaa !2
  %79 = add i64 %78, 1
  store i64 %79, i64* %75, align 8, !tbaa !2
  br label %82

; <label>:80:                                     ; preds = %73
  %81 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* nonnull %19, i8* nonnull %18, i64 1) #2
  br label %82

; <label>:82:                                     ; preds = %80, %77
  %83 = load i32, i32* %47, align 4, !tbaa !15
  %84 = getelementptr inbounds i8, i8* %27, i64 30
  %85 = bitcast i8* %84 to i32*
  %86 = load i32, i32* %85, align 4, !tbaa !18
  %87 = bitcast i8* %36 to i16*
  %88 = load i16, i16* %87, align 4, !tbaa !19
  %89 = zext i16 %88 to i32
  %90 = getelementptr inbounds i8, i8* %27, i64 36
  %91 = bitcast i8* %90 to i16*
  %92 = load i16, i16* %91, align 2, !tbaa !21
  %93 = zext i16 %92 to i32
  %94 = shl nuw i32 %93, 16
  %95 = or i32 %94, %89
  %96 = bitcast i32* %14 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %96) #2
  %97 = call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %86) #3, !srcloc !16
  store i32 %97, i32* %14, align 4, !tbaa !17
  %98 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @services to i8*), i8* nonnull %96) #2
  %99 = icmp eq i8* %98, null
  br i1 %99, label %538, label %100

; <label>:100:                                    ; preds = %82
  %101 = getelementptr inbounds i8, i8* %27, i64 46
  %102 = bitcast i8* %101 to i16*
  %103 = load i16, i16* %102, align 4
  %104 = and i16 %103, 512
  %105 = icmp eq i16 %104, 0
  br i1 %105, label %301, label %106

; <label>:106:                                    ; preds = %100
  %107 = bitcast i32* %6 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %107) #2
  %108 = add i32 %86, -559038217
  %109 = add i32 %95, -559038217
  %110 = xor i32 %109, -559038217
  %111 = shl i32 %109, 14
  %112 = lshr i32 %109, 18
  %113 = or i32 %112, %111
  %114 = sub i32 %110, %113
  %115 = xor i32 %114, %108
  %116 = shl i32 %114, 11
  %117 = lshr i32 %114, 21
  %118 = or i32 %117, %116
  %119 = sub i32 %115, %118
  %120 = xor i32 %119, %109
  %121 = shl i32 %119, 25
  %122 = lshr i32 %119, 7
  %123 = or i32 %122, %121
  %124 = sub i32 %120, %123
  %125 = xor i32 %124, %114
  %126 = shl i32 %124, 16
  %127 = lshr i32 %124, 16
  %128 = or i32 %127, %126
  %129 = sub i32 %125, %128
  %130 = xor i32 %129, %119
  %131 = shl i32 %129, 4
  %132 = lshr i32 %129, 28
  %133 = or i32 %132, %131
  %134 = sub i32 %130, %133
  %135 = xor i32 %134, %124
  %136 = shl i32 %134, 14
  %137 = lshr i32 %134, 18
  %138 = or i32 %137, %136
  %139 = sub i32 %135, %138
  %140 = xor i32 %139, %129
  %141 = lshr i32 %139, 8
  %142 = sub i32 %140, %141
  %143 = and i32 %142, 511
  store i32 %143, i32* %6, align 4, !tbaa !17
  %144 = bitcast i32* %7 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %144) #2
  store i32 %83, i32* %7, align 4, !tbaa !17
  %145 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @services to i8*), i8* nonnull %144) #2
  %146 = bitcast i32* %8 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %146) #2
  store i32 513, i32* %8, align 4, !tbaa !17
  %147 = icmp eq i8* %145, null
  br i1 %147, label %300, label %148

; <label>:148:                                    ; preds = %106
  %149 = getelementptr inbounds i8, i8* %145, i64 16
  %150 = bitcast i8* %149 to i64*
  %151 = load i64, i64* %150, align 8, !tbaa !22
  %152 = bitcast i8* %145 to i64*
  %153 = load i64, i64* %152, align 8, !tbaa !24
  %154 = add i64 %153, 1
  %155 = and i64 %154, 4294967295
  %156 = urem i64 %155, %151
  %157 = add i64 %156, %151
  %158 = trunc i64 %157 to i32
  store i32 %158, i32* %8, align 4, !tbaa !17
  %159 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %146) #2
  %160 = icmp eq i8* %159, null
  br i1 %160, label %161, label %163

; <label>:161:                                    ; preds = %148
  %162 = load i32, i32* %8, align 4, !tbaa !17
  br label %167

; <label>:163:                                    ; preds = %148
  %164 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %107, i8* nonnull %146, i64 0) #2
  %165 = load i32, i32* %8, align 4, !tbaa !17
  %166 = zext i32 %165 to i64
  store i64 %166, i64* %152, align 8, !tbaa !24
  br label %167

; <label>:167:                                    ; preds = %163, %161
  %168 = phi i32 [ %162, %161 ], [ %165, %163 ]
  %169 = add i32 %168, 1
  %170 = zext i32 %169 to i64
  %171 = urem i64 %170, %151
  %172 = add i64 %171, %151
  %173 = trunc i64 %172 to i32
  store i32 %173, i32* %8, align 4, !tbaa !17
  %174 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %146) #2
  %175 = icmp eq i8* %174, null
  br i1 %175, label %176, label %178

; <label>:176:                                    ; preds = %167
  %177 = load i32, i32* %8, align 4, !tbaa !17
  br label %182

; <label>:178:                                    ; preds = %167
  %179 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %107, i8* nonnull %146, i64 0) #2
  %180 = load i32, i32* %8, align 4, !tbaa !17
  %181 = zext i32 %180 to i64
  store i64 %181, i64* %152, align 8, !tbaa !24
  br label %182

; <label>:182:                                    ; preds = %178, %176
  %183 = phi i32 [ %177, %176 ], [ %180, %178 ]
  %184 = add i32 %183, 1
  %185 = zext i32 %184 to i64
  %186 = urem i64 %185, %151
  %187 = add i64 %186, %151
  %188 = trunc i64 %187 to i32
  store i32 %188, i32* %8, align 4, !tbaa !17
  %189 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %146) #2
  %190 = icmp eq i8* %189, null
  br i1 %190, label %191, label %193

; <label>:191:                                    ; preds = %182
  %192 = load i32, i32* %8, align 4, !tbaa !17
  br label %197

; <label>:193:                                    ; preds = %182
  %194 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %107, i8* nonnull %146, i64 0) #2
  %195 = load i32, i32* %8, align 4, !tbaa !17
  %196 = zext i32 %195 to i64
  store i64 %196, i64* %152, align 8, !tbaa !24
  br label %197

; <label>:197:                                    ; preds = %193, %191
  %198 = phi i32 [ %192, %191 ], [ %195, %193 ]
  %199 = add i32 %198, 1
  %200 = zext i32 %199 to i64
  %201 = urem i64 %200, %151
  %202 = add i64 %201, %151
  %203 = trunc i64 %202 to i32
  store i32 %203, i32* %8, align 4, !tbaa !17
  %204 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %146) #2
  %205 = icmp eq i8* %204, null
  br i1 %205, label %206, label %208

; <label>:206:                                    ; preds = %197
  %207 = load i32, i32* %8, align 4, !tbaa !17
  br label %212

; <label>:208:                                    ; preds = %197
  %209 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %107, i8* nonnull %146, i64 0) #2
  %210 = load i32, i32* %8, align 4, !tbaa !17
  %211 = zext i32 %210 to i64
  store i64 %211, i64* %152, align 8, !tbaa !24
  br label %212

; <label>:212:                                    ; preds = %208, %206
  %213 = phi i32 [ %207, %206 ], [ %210, %208 ]
  %214 = add i32 %213, 1
  %215 = zext i32 %214 to i64
  %216 = urem i64 %215, %151
  %217 = add i64 %216, %151
  %218 = trunc i64 %217 to i32
  store i32 %218, i32* %8, align 4, !tbaa !17
  %219 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %146) #2
  %220 = icmp eq i8* %219, null
  br i1 %220, label %221, label %223

; <label>:221:                                    ; preds = %212
  %222 = load i32, i32* %8, align 4, !tbaa !17
  br label %227

; <label>:223:                                    ; preds = %212
  %224 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %107, i8* nonnull %146, i64 0) #2
  %225 = load i32, i32* %8, align 4, !tbaa !17
  %226 = zext i32 %225 to i64
  store i64 %226, i64* %152, align 8, !tbaa !24
  br label %227

; <label>:227:                                    ; preds = %223, %221
  %228 = phi i32 [ %222, %221 ], [ %225, %223 ]
  %229 = add i32 %228, 1
  %230 = zext i32 %229 to i64
  %231 = urem i64 %230, %151
  %232 = add i64 %231, %151
  %233 = trunc i64 %232 to i32
  store i32 %233, i32* %8, align 4, !tbaa !17
  %234 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %146) #2
  %235 = icmp eq i8* %234, null
  br i1 %235, label %236, label %238

; <label>:236:                                    ; preds = %227
  %237 = load i32, i32* %8, align 4, !tbaa !17
  br label %242

; <label>:238:                                    ; preds = %227
  %239 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %107, i8* nonnull %146, i64 0) #2
  %240 = load i32, i32* %8, align 4, !tbaa !17
  %241 = zext i32 %240 to i64
  store i64 %241, i64* %152, align 8, !tbaa !24
  br label %242

; <label>:242:                                    ; preds = %238, %236
  %243 = phi i32 [ %237, %236 ], [ %240, %238 ]
  %244 = add i32 %243, 1
  %245 = zext i32 %244 to i64
  %246 = urem i64 %245, %151
  %247 = add i64 %246, %151
  %248 = trunc i64 %247 to i32
  store i32 %248, i32* %8, align 4, !tbaa !17
  %249 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %146) #2
  %250 = icmp eq i8* %249, null
  br i1 %250, label %251, label %253

; <label>:251:                                    ; preds = %242
  %252 = load i32, i32* %8, align 4, !tbaa !17
  br label %257

; <label>:253:                                    ; preds = %242
  %254 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %107, i8* nonnull %146, i64 0) #2
  %255 = load i32, i32* %8, align 4, !tbaa !17
  %256 = zext i32 %255 to i64
  store i64 %256, i64* %152, align 8, !tbaa !24
  br label %257

; <label>:257:                                    ; preds = %253, %251
  %258 = phi i32 [ %252, %251 ], [ %255, %253 ]
  %259 = add i32 %258, 1
  %260 = zext i32 %259 to i64
  %261 = urem i64 %260, %151
  %262 = add i64 %261, %151
  %263 = trunc i64 %262 to i32
  store i32 %263, i32* %8, align 4, !tbaa !17
  %264 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %146) #2
  %265 = icmp eq i8* %264, null
  br i1 %265, label %266, label %268

; <label>:266:                                    ; preds = %257
  %267 = load i32, i32* %8, align 4, !tbaa !17
  br label %272

; <label>:268:                                    ; preds = %257
  %269 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %107, i8* nonnull %146, i64 0) #2
  %270 = load i32, i32* %8, align 4, !tbaa !17
  %271 = zext i32 %270 to i64
  store i64 %271, i64* %152, align 8, !tbaa !24
  br label %272

; <label>:272:                                    ; preds = %268, %266
  %273 = phi i32 [ %267, %266 ], [ %270, %268 ]
  %274 = add i32 %273, 1
  %275 = zext i32 %274 to i64
  %276 = urem i64 %275, %151
  %277 = add i64 %276, %151
  %278 = trunc i64 %277 to i32
  store i32 %278, i32* %8, align 4, !tbaa !17
  %279 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %146) #2
  %280 = icmp eq i8* %279, null
  br i1 %280, label %281, label %283

; <label>:281:                                    ; preds = %272
  %282 = load i32, i32* %8, align 4, !tbaa !17
  br label %287

; <label>:283:                                    ; preds = %272
  %284 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %107, i8* nonnull %146, i64 0) #2
  %285 = load i32, i32* %8, align 4, !tbaa !17
  %286 = zext i32 %285 to i64
  store i64 %286, i64* %152, align 8, !tbaa !24
  br label %287

; <label>:287:                                    ; preds = %283, %281
  %288 = phi i32 [ %282, %281 ], [ %285, %283 ]
  %289 = add i32 %288, 1
  %290 = zext i32 %289 to i64
  %291 = urem i64 %290, %151
  %292 = add i64 %291, %151
  %293 = trunc i64 %292 to i32
  store i32 %293, i32* %8, align 4, !tbaa !17
  %294 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %146) #2
  %295 = icmp eq i8* %294, null
  br i1 %295, label %300, label %296

; <label>:296:                                    ; preds = %287
  %297 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %107, i8* nonnull %146, i64 0) #2
  %298 = load i32, i32* %8, align 4, !tbaa !17
  %299 = zext i32 %298 to i64
  store i64 %299, i64* %152, align 8, !tbaa !24
  br label %300

; <label>:300:                                    ; preds = %106, %287, %296
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %146) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %144) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %107) #2
  br label %380

; <label>:301:                                    ; preds = %100
  %302 = and i16 %103, 256
  %303 = icmp eq i16 %302, 0
  br i1 %303, label %304, label %341

; <label>:304:                                    ; preds = %301
  %305 = add i32 %86, -559038217
  %306 = add i32 %95, -559038217
  %307 = xor i32 %306, -559038217
  %308 = shl i32 %306, 14
  %309 = lshr i32 %306, 18
  %310 = or i32 %309, %308
  %311 = sub i32 %307, %310
  %312 = xor i32 %311, %305
  %313 = shl i32 %311, 11
  %314 = lshr i32 %311, 21
  %315 = or i32 %314, %313
  %316 = sub i32 %312, %315
  %317 = xor i32 %316, %306
  %318 = shl i32 %316, 25
  %319 = lshr i32 %316, 7
  %320 = or i32 %319, %318
  %321 = sub i32 %317, %320
  %322 = xor i32 %321, %311
  %323 = shl i32 %321, 16
  %324 = lshr i32 %321, 16
  %325 = or i32 %324, %323
  %326 = sub i32 %322, %325
  %327 = xor i32 %326, %316
  %328 = shl i32 %326, 4
  %329 = lshr i32 %326, 28
  %330 = or i32 %329, %328
  %331 = sub i32 %327, %330
  %332 = xor i32 %331, %321
  %333 = shl i32 %331, 14
  %334 = lshr i32 %331, 18
  %335 = or i32 %334, %333
  %336 = sub i32 %332, %335
  %337 = xor i32 %336, %326
  %338 = lshr i32 %336, 8
  %339 = sub i32 %337, %338
  %340 = and i32 %339, 511
  br label %380

; <label>:341:                                    ; preds = %301
  %342 = bitcast i32* %5 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %342) #2
  %343 = add i32 %86, -559038217
  %344 = add i32 %95, -559038217
  %345 = xor i32 %344, -559038217
  %346 = shl i32 %344, 14
  %347 = lshr i32 %344, 18
  %348 = or i32 %347, %346
  %349 = sub i32 %345, %348
  %350 = xor i32 %349, %343
  %351 = shl i32 %349, 11
  %352 = lshr i32 %349, 21
  %353 = or i32 %352, %351
  %354 = sub i32 %350, %353
  %355 = xor i32 %354, %344
  %356 = shl i32 %354, 25
  %357 = lshr i32 %354, 7
  %358 = or i32 %357, %356
  %359 = sub i32 %355, %358
  %360 = xor i32 %359, %349
  %361 = shl i32 %359, 16
  %362 = lshr i32 %359, 16
  %363 = or i32 %362, %361
  %364 = sub i32 %360, %363
  %365 = xor i32 %364, %354
  %366 = shl i32 %364, 4
  %367 = lshr i32 %364, 28
  %368 = or i32 %367, %366
  %369 = sub i32 %365, %368
  %370 = xor i32 %369, %359
  %371 = shl i32 %369, 14
  %372 = lshr i32 %369, 18
  %373 = or i32 %372, %371
  %374 = sub i32 %370, %373
  %375 = xor i32 %374, %364
  %376 = lshr i32 %374, 8
  %377 = sub i32 %375, %376
  %378 = and i32 %377, 511
  store i32 %378, i32* %5, align 4, !tbaa !17
  %379 = call i32 inttoptr (i64 3 to i32 (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %342) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %342) #2
  br label %380

; <label>:380:                                    ; preds = %304, %341, %300
  %381 = phi i32 [ %340, %304 ], [ %378, %341 ], [ %143, %300 ]
  %382 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %382) #2
  %383 = bitcast i32* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %383) #2
  %384 = bitcast i32* %4 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %384) #2
  store i32 513, i32* %4, align 4, !tbaa !17
  store i32 0, i32* %2, align 4, !tbaa !17
  store i32 %381, i32* %3, align 4, !tbaa !17
  %385 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %383) #2
  %386 = icmp eq i8* %385, null
  br i1 %386, label %390, label %387

; <label>:387:                                    ; preds = %380
  %388 = bitcast i8* %385 to i32*
  %389 = load i32, i32* %388, align 4, !tbaa !17
  store i32 %389, i32* %4, align 4, !tbaa !17
  br label %392

; <label>:390:                                    ; preds = %380
  %391 = load i32, i32* %4, align 4, !tbaa !17
  br label %392

; <label>:392:                                    ; preds = %390, %387
  %393 = phi i32 [ %391, %390 ], [ %389, %387 ]
  %394 = icmp eq i32 %393, 513
  br i1 %394, label %400, label %395

; <label>:395:                                    ; preds = %392
  %396 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %384) #2
  %397 = icmp eq i8* %396, null
  br i1 %397, label %400, label %398

; <label>:398:                                    ; preds = %395
  %399 = bitcast i8* %396 to %struct.dest_info*
  br label %504

; <label>:400:                                    ; preds = %395, %392
  %401 = call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %83) #3, !srcloc !16
  store i32 %401, i32* %2, align 4, !tbaa !17
  %402 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @services to i8*), i8* nonnull %382) #2
  %403 = icmp eq i8* %402, null
  br i1 %403, label %504, label %404

; <label>:404:                                    ; preds = %400
  %405 = getelementptr inbounds i8, i8* %402, i64 16
  %406 = bitcast i8* %405 to i64*
  %407 = load i64, i64* %406, align 8, !tbaa !22
  %408 = bitcast i8* %402 to i64*
  %409 = load i64, i64* %408, align 8, !tbaa !24
  %410 = add i64 %409, 1
  %411 = and i64 %410, 4294967295
  %412 = urem i64 %411, %407
  %413 = add i64 %412, %407
  %414 = trunc i64 %413 to i32
  store i32 %414, i32* %4, align 4, !tbaa !17
  %415 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %384) #2
  %416 = icmp eq i8* %415, null
  br i1 %416, label %417, label %426

; <label>:417:                                    ; preds = %404
  %418 = load i32, i32* %4, align 4, !tbaa !17
  %419 = add i32 %418, 1
  %420 = zext i32 %419 to i64
  %421 = urem i64 %420, %407
  %422 = add i64 %421, %407
  %423 = trunc i64 %422 to i32
  store i32 %423, i32* %4, align 4, !tbaa !17
  %424 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %384) #2
  %425 = icmp eq i8* %424, null
  br i1 %425, label %432, label %426

; <label>:426:                                    ; preds = %495, %486, %477, %468, %459, %450, %441, %432, %417, %404
  %427 = phi i8* [ %415, %404 ], [ %424, %417 ], [ %439, %432 ], [ %448, %441 ], [ %457, %450 ], [ %466, %459 ], [ %475, %468 ], [ %484, %477 ], [ %493, %486 ], [ %502, %495 ]
  %428 = bitcast i8* %427 to %struct.dest_info*
  %429 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %383, i8* nonnull %384, i64 0) #2
  %430 = load i32, i32* %4, align 4, !tbaa !17
  %431 = zext i32 %430 to i64
  store i64 %431, i64* %408, align 8, !tbaa !24
  br label %504

; <label>:432:                                    ; preds = %417
  %433 = load i32, i32* %4, align 4, !tbaa !17
  %434 = add i32 %433, 1
  %435 = zext i32 %434 to i64
  %436 = urem i64 %435, %407
  %437 = add i64 %436, %407
  %438 = trunc i64 %437 to i32
  store i32 %438, i32* %4, align 4, !tbaa !17
  %439 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %384) #2
  %440 = icmp eq i8* %439, null
  br i1 %440, label %441, label %426

; <label>:441:                                    ; preds = %432
  %442 = load i32, i32* %4, align 4, !tbaa !17
  %443 = add i32 %442, 1
  %444 = zext i32 %443 to i64
  %445 = urem i64 %444, %407
  %446 = add i64 %445, %407
  %447 = trunc i64 %446 to i32
  store i32 %447, i32* %4, align 4, !tbaa !17
  %448 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %384) #2
  %449 = icmp eq i8* %448, null
  br i1 %449, label %450, label %426

; <label>:450:                                    ; preds = %441
  %451 = load i32, i32* %4, align 4, !tbaa !17
  %452 = add i32 %451, 1
  %453 = zext i32 %452 to i64
  %454 = urem i64 %453, %407
  %455 = add i64 %454, %407
  %456 = trunc i64 %455 to i32
  store i32 %456, i32* %4, align 4, !tbaa !17
  %457 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %384) #2
  %458 = icmp eq i8* %457, null
  br i1 %458, label %459, label %426

; <label>:459:                                    ; preds = %450
  %460 = load i32, i32* %4, align 4, !tbaa !17
  %461 = add i32 %460, 1
  %462 = zext i32 %461 to i64
  %463 = urem i64 %462, %407
  %464 = add i64 %463, %407
  %465 = trunc i64 %464 to i32
  store i32 %465, i32* %4, align 4, !tbaa !17
  %466 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %384) #2
  %467 = icmp eq i8* %466, null
  br i1 %467, label %468, label %426

; <label>:468:                                    ; preds = %459
  %469 = load i32, i32* %4, align 4, !tbaa !17
  %470 = add i32 %469, 1
  %471 = zext i32 %470 to i64
  %472 = urem i64 %471, %407
  %473 = add i64 %472, %407
  %474 = trunc i64 %473 to i32
  store i32 %474, i32* %4, align 4, !tbaa !17
  %475 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %384) #2
  %476 = icmp eq i8* %475, null
  br i1 %476, label %477, label %426

; <label>:477:                                    ; preds = %468
  %478 = load i32, i32* %4, align 4, !tbaa !17
  %479 = add i32 %478, 1
  %480 = zext i32 %479 to i64
  %481 = urem i64 %480, %407
  %482 = add i64 %481, %407
  %483 = trunc i64 %482 to i32
  store i32 %483, i32* %4, align 4, !tbaa !17
  %484 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %384) #2
  %485 = icmp eq i8* %484, null
  br i1 %485, label %486, label %426

; <label>:486:                                    ; preds = %477
  %487 = load i32, i32* %4, align 4, !tbaa !17
  %488 = add i32 %487, 1
  %489 = zext i32 %488 to i64
  %490 = urem i64 %489, %407
  %491 = add i64 %490, %407
  %492 = trunc i64 %491 to i32
  store i32 %492, i32* %4, align 4, !tbaa !17
  %493 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %384) #2
  %494 = icmp eq i8* %493, null
  br i1 %494, label %495, label %426

; <label>:495:                                    ; preds = %486
  %496 = load i32, i32* %4, align 4, !tbaa !17
  %497 = add i32 %496, 1
  %498 = zext i32 %497 to i64
  %499 = urem i64 %498, %407
  %500 = add i64 %499, %407
  %501 = trunc i64 %500 to i32
  store i32 %501, i32* %4, align 4, !tbaa !17
  %502 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %384) #2
  %503 = icmp eq i8* %502, null
  br i1 %503, label %504, label %426

; <label>:504:                                    ; preds = %398, %400, %426, %495
  %505 = phi %struct.dest_info* [ %399, %398 ], [ %428, %426 ], [ null, %400 ], [ null, %495 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %384) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %383) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %382) #2
  %506 = icmp eq %struct.dest_info* %505, null
  br i1 %506, label %507, label %509

; <label>:507:                                    ; preds = %504
  %508 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @drop_logs to i8*), i8* nonnull %19, i8* nonnull %15, i64 1) #2
  br label %536

; <label>:509:                                    ; preds = %504
  %510 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %505, i64 0, i32 5, i64 0
  %511 = load i8, i8* %510, align 8, !tbaa !25
  %512 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %28, i64 0, i32 0, i64 0
  store i8 %511, i8* %512, align 1, !tbaa !25
  %513 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %505, i64 0, i32 5, i64 1
  %514 = load i8, i8* %513, align 1, !tbaa !25
  %515 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %28, i64 0, i32 0, i64 1
  store i8 %514, i8* %515, align 1, !tbaa !25
  %516 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %505, i64 0, i32 5, i64 2
  %517 = load i8, i8* %516, align 2, !tbaa !25
  %518 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %28, i64 0, i32 0, i64 2
  store i8 %517, i8* %518, align 1, !tbaa !25
  %519 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %505, i64 0, i32 5, i64 3
  %520 = load i8, i8* %519, align 1, !tbaa !25
  %521 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %28, i64 0, i32 0, i64 3
  store i8 %520, i8* %521, align 1, !tbaa !25
  %522 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %505, i64 0, i32 5, i64 4
  %523 = load i8, i8* %522, align 4, !tbaa !25
  %524 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %28, i64 0, i32 0, i64 4
  store i8 %523, i8* %524, align 1, !tbaa !25
  %525 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %505, i64 0, i32 5, i64 5
  %526 = load i8, i8* %525, align 1, !tbaa !25
  %527 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %28, i64 0, i32 0, i64 5
  store i8 %526, i8* %527, align 1, !tbaa !25
  %528 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @pass_logs to i8*), i8* nonnull %19) #2
  %529 = bitcast i8* %528 to i64*
  %530 = icmp eq i8* %528, null
  br i1 %530, label %534, label %531

; <label>:531:                                    ; preds = %509
  %532 = load i64, i64* %529, align 8, !tbaa !2
  %533 = add i64 %532, 1
  store i64 %533, i64* %529, align 8, !tbaa !2
  br label %536

; <label>:534:                                    ; preds = %509
  %535 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @pass_logs to i8*), i8* nonnull %19, i8* nonnull %17, i64 1) #2
  br label %536

; <label>:536:                                    ; preds = %507, %534, %531
  %537 = phi i32 [ 3, %531 ], [ 3, %534 ], [ 1, %507 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %96) #2
  br label %539

; <label>:538:                                    ; preds = %82
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %96) #2
  br label %539

; <label>:539:                                    ; preds = %538, %536, %35, %38, %68, %71, %42, %31, %1
  %540 = phi i32 [ 1, %1 ], [ 2, %31 ], [ 1, %35 ], [ 2, %38 ], [ 1, %42 ], [ 1, %71 ], [ 1, %68 ], [ 2, %538 ], [ %537, %536 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %19) #2
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %18) #2
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %17) #2
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %16) #2
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %15) #2
  ret i32 %540
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

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
!13 = !{!14, !4, i64 9}
!14 = !{!"iphdr", !4, i64 0, !4, i64 0, !4, i64 1, !12, i64 2, !12, i64 4, !12, i64 6, !4, i64 8, !4, i64 9, !12, i64 10, !8, i64 12, !8, i64 16}
!15 = !{!14, !8, i64 12}
!16 = !{i32 549211}
!17 = !{!8, !8, i64 0}
!18 = !{!14, !8, i64 16}
!19 = !{!20, !12, i64 0}
!20 = !{!"tcphdr", !12, i64 0, !12, i64 2, !8, i64 4, !8, i64 8, !12, i64 12, !12, i64 12, !12, i64 13, !12, i64 13, !12, i64 13, !12, i64 13, !12, i64 13, !12, i64 13, !12, i64 13, !12, i64 13, !12, i64 14, !12, i64 16, !12, i64 18}
!21 = !{!20, !12, i64 2}
!22 = !{!23, !3, i64 16}
!23 = !{!"service", !3, i64 0, !3, i64 8, !3, i64 16}
!24 = !{!23, !3, i64 0}
!25 = !{!4, !4, i64 0}
