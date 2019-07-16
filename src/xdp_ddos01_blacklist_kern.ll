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
@pass_logs = global %struct.bpf_map_def { i32 5, i32 4, i32 4, i32 100000, i32 1, i32 0, i32 0 }, section "maps", align 4
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
  %12 = alloca i32, align 4
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
  %18 = bitcast i32* %12 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %18) #2
  %19 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %20 = load i32, i32* %19, align 4, !tbaa !6
  %21 = zext i32 %20 to i64
  %22 = inttoptr i64 %21 to i8*
  %23 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0
  %24 = load i32, i32* %23, align 4, !tbaa !9
  %25 = zext i32 %24 to i64
  %26 = inttoptr i64 %25 to i8*
  %27 = inttoptr i64 %25 to %struct.ethhdr*
  %28 = getelementptr i8, i8* %26, i64 14
  %29 = icmp ugt i8* %28, %22
  br i1 %29, label %540, label %30

; <label>:30:                                     ; preds = %1
  %31 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %27, i64 0, i32 2
  %32 = load i16, i16* %31, align 1, !tbaa !10
  %33 = icmp eq i16 %32, 8
  br i1 %33, label %34, label %540

; <label>:34:                                     ; preds = %30
  %35 = getelementptr i8, i8* %26, i64 34
  %36 = icmp ugt i8* %35, %22
  br i1 %36, label %540, label %37

; <label>:37:                                     ; preds = %34
  %38 = getelementptr inbounds i8, i8* %26, i64 23
  %39 = load i8, i8* %38, align 1, !tbaa !13
  %40 = icmp eq i8 %39, 6
  br i1 %40, label %41, label %540

; <label>:41:                                     ; preds = %37
  %42 = getelementptr i8, i8* %26, i64 54
  %43 = icmp ugt i8* %42, %22
  br i1 %43, label %540, label %44

; <label>:44:                                     ; preds = %41
  %45 = getelementptr inbounds i8, i8* %26, i64 26
  %46 = bitcast i8* %45 to i32*
  %47 = load i32, i32* %46, align 4, !tbaa !15
  %48 = tail call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %47) #3, !srcloc !16
  store i32 %48, i32* %12, align 4, !tbaa !17
  %49 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @enter_logs to i8*), i8* nonnull %18) #2
  %50 = bitcast i8* %49 to i64*
  %51 = icmp eq i8* %49, null
  br i1 %51, label %55, label %52

; <label>:52:                                     ; preds = %44
  %53 = load i64, i64* %50, align 8, !tbaa !2
  %54 = add i64 %53, 1
  store i64 %54, i64* %50, align 8, !tbaa !2
  br label %57

; <label>:55:                                     ; preds = %44
  %56 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @enter_logs to i8*), i8* nonnull %18, i8* nonnull %16, i64 1) #2
  br label %57

; <label>:57:                                     ; preds = %55, %52
  %58 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @blacklist to i8*), i8* nonnull %18) #2
  %59 = bitcast i8* %58 to i64*
  %60 = icmp eq i8* %58, null
  br i1 %60, label %72, label %61

; <label>:61:                                     ; preds = %57
  %62 = load i64, i64* %59, align 8, !tbaa !2
  %63 = add i64 %62, 1
  store i64 %63, i64* %59, align 8, !tbaa !2
  %64 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @drop_logs to i8*), i8* nonnull %18) #2
  %65 = bitcast i8* %64 to i64*
  %66 = icmp eq i8* %64, null
  br i1 %66, label %70, label %67

; <label>:67:                                     ; preds = %61
  %68 = load i64, i64* %65, align 8, !tbaa !2
  %69 = add i64 %68, 1
  store i64 %69, i64* %65, align 8, !tbaa !2
  br label %540

; <label>:70:                                     ; preds = %61
  %71 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @drop_logs to i8*), i8* nonnull %18, i8* nonnull %15, i64 1) #2
  br label %540

; <label>:72:                                     ; preds = %57
  %73 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* nonnull %18) #2
  %74 = bitcast i8* %73 to i64*
  %75 = icmp eq i8* %73, null
  br i1 %75, label %79, label %76

; <label>:76:                                     ; preds = %72
  %77 = load i64, i64* %74, align 8, !tbaa !2
  %78 = add i64 %77, 1
  store i64 %78, i64* %74, align 8, !tbaa !2
  br label %81

; <label>:79:                                     ; preds = %72
  %80 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* nonnull %18, i8* nonnull %17, i64 1) #2
  br label %81

; <label>:81:                                     ; preds = %79, %76
  %82 = load i32, i32* %46, align 4, !tbaa !15
  %83 = getelementptr inbounds i8, i8* %26, i64 30
  %84 = bitcast i8* %83 to i32*
  %85 = load i32, i32* %84, align 4, !tbaa !18
  %86 = bitcast i8* %35 to i16*
  %87 = load i16, i16* %86, align 4, !tbaa !19
  %88 = zext i16 %87 to i32
  %89 = getelementptr inbounds i8, i8* %26, i64 36
  %90 = bitcast i8* %89 to i16*
  %91 = load i16, i16* %90, align 2, !tbaa !21
  %92 = zext i16 %91 to i32
  %93 = shl nuw i32 %92, 16
  %94 = or i32 %93, %88
  %95 = bitcast i32* %13 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %95) #2
  %96 = call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %85) #3, !srcloc !16
  store i32 %96, i32* %13, align 4, !tbaa !17
  %97 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @services to i8*), i8* nonnull %95) #2
  %98 = icmp eq i8* %97, null
  br i1 %98, label %539, label %99

; <label>:99:                                     ; preds = %81
  %100 = getelementptr inbounds i8, i8* %26, i64 46
  %101 = bitcast i8* %100 to i16*
  %102 = load i16, i16* %101, align 4
  %103 = and i16 %102, 512
  %104 = icmp eq i16 %103, 0
  br i1 %104, label %300, label %105

; <label>:105:                                    ; preds = %99
  %106 = bitcast i32* %6 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %106) #2
  %107 = add i32 %82, -559038217
  %108 = add i32 %94, -559038217
  %109 = xor i32 %108, -559038217
  %110 = shl i32 %108, 14
  %111 = lshr i32 %108, 18
  %112 = or i32 %111, %110
  %113 = sub i32 %109, %112
  %114 = xor i32 %113, %107
  %115 = shl i32 %113, 11
  %116 = lshr i32 %113, 21
  %117 = or i32 %116, %115
  %118 = sub i32 %114, %117
  %119 = xor i32 %118, %108
  %120 = shl i32 %118, 25
  %121 = lshr i32 %118, 7
  %122 = or i32 %121, %120
  %123 = sub i32 %119, %122
  %124 = xor i32 %123, %113
  %125 = shl i32 %123, 16
  %126 = lshr i32 %123, 16
  %127 = or i32 %126, %125
  %128 = sub i32 %124, %127
  %129 = xor i32 %128, %118
  %130 = shl i32 %128, 4
  %131 = lshr i32 %128, 28
  %132 = or i32 %131, %130
  %133 = sub i32 %129, %132
  %134 = xor i32 %133, %123
  %135 = shl i32 %133, 14
  %136 = lshr i32 %133, 18
  %137 = or i32 %136, %135
  %138 = sub i32 %134, %137
  %139 = xor i32 %138, %128
  %140 = lshr i32 %138, 8
  %141 = sub i32 %139, %140
  %142 = and i32 %141, 511
  store i32 %142, i32* %6, align 4, !tbaa !17
  %143 = bitcast i32* %7 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %143) #2
  store i32 %96, i32* %7, align 4, !tbaa !17
  %144 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @services to i8*), i8* nonnull %143) #2
  %145 = bitcast i32* %8 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %145) #2
  store i32 513, i32* %8, align 4, !tbaa !17
  %146 = icmp eq i8* %144, null
  br i1 %146, label %299, label %147

; <label>:147:                                    ; preds = %105
  %148 = getelementptr inbounds i8, i8* %144, i64 16
  %149 = bitcast i8* %148 to i64*
  %150 = load i64, i64* %149, align 8, !tbaa !22
  %151 = bitcast i8* %144 to i64*
  %152 = load i64, i64* %151, align 8, !tbaa !24
  %153 = add i64 %152, 1
  %154 = and i64 %153, 4294967295
  %155 = urem i64 %154, %150
  %156 = add i64 %155, %150
  %157 = trunc i64 %156 to i32
  store i32 %157, i32* %8, align 4, !tbaa !17
  %158 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %145) #2
  %159 = icmp eq i8* %158, null
  br i1 %159, label %160, label %162

; <label>:160:                                    ; preds = %147
  %161 = load i32, i32* %8, align 4, !tbaa !17
  br label %166

; <label>:162:                                    ; preds = %147
  %163 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %106, i8* nonnull %145, i64 0) #2
  %164 = load i32, i32* %8, align 4, !tbaa !17
  %165 = zext i32 %164 to i64
  store i64 %165, i64* %151, align 8, !tbaa !24
  br label %166

; <label>:166:                                    ; preds = %162, %160
  %167 = phi i32 [ %161, %160 ], [ %164, %162 ]
  %168 = add i32 %167, 1
  %169 = zext i32 %168 to i64
  %170 = urem i64 %169, %150
  %171 = add i64 %170, %150
  %172 = trunc i64 %171 to i32
  store i32 %172, i32* %8, align 4, !tbaa !17
  %173 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %145) #2
  %174 = icmp eq i8* %173, null
  br i1 %174, label %175, label %177

; <label>:175:                                    ; preds = %166
  %176 = load i32, i32* %8, align 4, !tbaa !17
  br label %181

; <label>:177:                                    ; preds = %166
  %178 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %106, i8* nonnull %145, i64 0) #2
  %179 = load i32, i32* %8, align 4, !tbaa !17
  %180 = zext i32 %179 to i64
  store i64 %180, i64* %151, align 8, !tbaa !24
  br label %181

; <label>:181:                                    ; preds = %177, %175
  %182 = phi i32 [ %176, %175 ], [ %179, %177 ]
  %183 = add i32 %182, 1
  %184 = zext i32 %183 to i64
  %185 = urem i64 %184, %150
  %186 = add i64 %185, %150
  %187 = trunc i64 %186 to i32
  store i32 %187, i32* %8, align 4, !tbaa !17
  %188 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %145) #2
  %189 = icmp eq i8* %188, null
  br i1 %189, label %190, label %192

; <label>:190:                                    ; preds = %181
  %191 = load i32, i32* %8, align 4, !tbaa !17
  br label %196

; <label>:192:                                    ; preds = %181
  %193 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %106, i8* nonnull %145, i64 0) #2
  %194 = load i32, i32* %8, align 4, !tbaa !17
  %195 = zext i32 %194 to i64
  store i64 %195, i64* %151, align 8, !tbaa !24
  br label %196

; <label>:196:                                    ; preds = %192, %190
  %197 = phi i32 [ %191, %190 ], [ %194, %192 ]
  %198 = add i32 %197, 1
  %199 = zext i32 %198 to i64
  %200 = urem i64 %199, %150
  %201 = add i64 %200, %150
  %202 = trunc i64 %201 to i32
  store i32 %202, i32* %8, align 4, !tbaa !17
  %203 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %145) #2
  %204 = icmp eq i8* %203, null
  br i1 %204, label %205, label %207

; <label>:205:                                    ; preds = %196
  %206 = load i32, i32* %8, align 4, !tbaa !17
  br label %211

; <label>:207:                                    ; preds = %196
  %208 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %106, i8* nonnull %145, i64 0) #2
  %209 = load i32, i32* %8, align 4, !tbaa !17
  %210 = zext i32 %209 to i64
  store i64 %210, i64* %151, align 8, !tbaa !24
  br label %211

; <label>:211:                                    ; preds = %207, %205
  %212 = phi i32 [ %206, %205 ], [ %209, %207 ]
  %213 = add i32 %212, 1
  %214 = zext i32 %213 to i64
  %215 = urem i64 %214, %150
  %216 = add i64 %215, %150
  %217 = trunc i64 %216 to i32
  store i32 %217, i32* %8, align 4, !tbaa !17
  %218 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %145) #2
  %219 = icmp eq i8* %218, null
  br i1 %219, label %220, label %222

; <label>:220:                                    ; preds = %211
  %221 = load i32, i32* %8, align 4, !tbaa !17
  br label %226

; <label>:222:                                    ; preds = %211
  %223 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %106, i8* nonnull %145, i64 0) #2
  %224 = load i32, i32* %8, align 4, !tbaa !17
  %225 = zext i32 %224 to i64
  store i64 %225, i64* %151, align 8, !tbaa !24
  br label %226

; <label>:226:                                    ; preds = %222, %220
  %227 = phi i32 [ %221, %220 ], [ %224, %222 ]
  %228 = add i32 %227, 1
  %229 = zext i32 %228 to i64
  %230 = urem i64 %229, %150
  %231 = add i64 %230, %150
  %232 = trunc i64 %231 to i32
  store i32 %232, i32* %8, align 4, !tbaa !17
  %233 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %145) #2
  %234 = icmp eq i8* %233, null
  br i1 %234, label %235, label %237

; <label>:235:                                    ; preds = %226
  %236 = load i32, i32* %8, align 4, !tbaa !17
  br label %241

; <label>:237:                                    ; preds = %226
  %238 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %106, i8* nonnull %145, i64 0) #2
  %239 = load i32, i32* %8, align 4, !tbaa !17
  %240 = zext i32 %239 to i64
  store i64 %240, i64* %151, align 8, !tbaa !24
  br label %241

; <label>:241:                                    ; preds = %237, %235
  %242 = phi i32 [ %236, %235 ], [ %239, %237 ]
  %243 = add i32 %242, 1
  %244 = zext i32 %243 to i64
  %245 = urem i64 %244, %150
  %246 = add i64 %245, %150
  %247 = trunc i64 %246 to i32
  store i32 %247, i32* %8, align 4, !tbaa !17
  %248 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %145) #2
  %249 = icmp eq i8* %248, null
  br i1 %249, label %250, label %252

; <label>:250:                                    ; preds = %241
  %251 = load i32, i32* %8, align 4, !tbaa !17
  br label %256

; <label>:252:                                    ; preds = %241
  %253 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %106, i8* nonnull %145, i64 0) #2
  %254 = load i32, i32* %8, align 4, !tbaa !17
  %255 = zext i32 %254 to i64
  store i64 %255, i64* %151, align 8, !tbaa !24
  br label %256

; <label>:256:                                    ; preds = %252, %250
  %257 = phi i32 [ %251, %250 ], [ %254, %252 ]
  %258 = add i32 %257, 1
  %259 = zext i32 %258 to i64
  %260 = urem i64 %259, %150
  %261 = add i64 %260, %150
  %262 = trunc i64 %261 to i32
  store i32 %262, i32* %8, align 4, !tbaa !17
  %263 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %145) #2
  %264 = icmp eq i8* %263, null
  br i1 %264, label %265, label %267

; <label>:265:                                    ; preds = %256
  %266 = load i32, i32* %8, align 4, !tbaa !17
  br label %271

; <label>:267:                                    ; preds = %256
  %268 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %106, i8* nonnull %145, i64 0) #2
  %269 = load i32, i32* %8, align 4, !tbaa !17
  %270 = zext i32 %269 to i64
  store i64 %270, i64* %151, align 8, !tbaa !24
  br label %271

; <label>:271:                                    ; preds = %267, %265
  %272 = phi i32 [ %266, %265 ], [ %269, %267 ]
  %273 = add i32 %272, 1
  %274 = zext i32 %273 to i64
  %275 = urem i64 %274, %150
  %276 = add i64 %275, %150
  %277 = trunc i64 %276 to i32
  store i32 %277, i32* %8, align 4, !tbaa !17
  %278 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %145) #2
  %279 = icmp eq i8* %278, null
  br i1 %279, label %280, label %282

; <label>:280:                                    ; preds = %271
  %281 = load i32, i32* %8, align 4, !tbaa !17
  br label %286

; <label>:282:                                    ; preds = %271
  %283 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %106, i8* nonnull %145, i64 0) #2
  %284 = load i32, i32* %8, align 4, !tbaa !17
  %285 = zext i32 %284 to i64
  store i64 %285, i64* %151, align 8, !tbaa !24
  br label %286

; <label>:286:                                    ; preds = %282, %280
  %287 = phi i32 [ %281, %280 ], [ %284, %282 ]
  %288 = add i32 %287, 1
  %289 = zext i32 %288 to i64
  %290 = urem i64 %289, %150
  %291 = add i64 %290, %150
  %292 = trunc i64 %291 to i32
  store i32 %292, i32* %8, align 4, !tbaa !17
  %293 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %145) #2
  %294 = icmp eq i8* %293, null
  br i1 %294, label %299, label %295

; <label>:295:                                    ; preds = %286
  %296 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %106, i8* nonnull %145, i64 0) #2
  %297 = load i32, i32* %8, align 4, !tbaa !17
  %298 = zext i32 %297 to i64
  store i64 %298, i64* %151, align 8, !tbaa !24
  br label %299

; <label>:299:                                    ; preds = %105, %286, %295
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %145) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %143) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %106) #2
  br label %379

; <label>:300:                                    ; preds = %99
  %301 = and i16 %102, 256
  %302 = icmp eq i16 %301, 0
  br i1 %302, label %303, label %340

; <label>:303:                                    ; preds = %300
  %304 = add i32 %82, -559038217
  %305 = add i32 %94, -559038217
  %306 = xor i32 %305, -559038217
  %307 = shl i32 %305, 14
  %308 = lshr i32 %305, 18
  %309 = or i32 %308, %307
  %310 = sub i32 %306, %309
  %311 = xor i32 %310, %304
  %312 = shl i32 %310, 11
  %313 = lshr i32 %310, 21
  %314 = or i32 %313, %312
  %315 = sub i32 %311, %314
  %316 = xor i32 %315, %305
  %317 = shl i32 %315, 25
  %318 = lshr i32 %315, 7
  %319 = or i32 %318, %317
  %320 = sub i32 %316, %319
  %321 = xor i32 %320, %310
  %322 = shl i32 %320, 16
  %323 = lshr i32 %320, 16
  %324 = or i32 %323, %322
  %325 = sub i32 %321, %324
  %326 = xor i32 %325, %315
  %327 = shl i32 %325, 4
  %328 = lshr i32 %325, 28
  %329 = or i32 %328, %327
  %330 = sub i32 %326, %329
  %331 = xor i32 %330, %320
  %332 = shl i32 %330, 14
  %333 = lshr i32 %330, 18
  %334 = or i32 %333, %332
  %335 = sub i32 %331, %334
  %336 = xor i32 %335, %325
  %337 = lshr i32 %335, 8
  %338 = sub i32 %336, %337
  %339 = and i32 %338, 511
  br label %379

; <label>:340:                                    ; preds = %300
  %341 = bitcast i32* %5 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %341) #2
  %342 = add i32 %82, -559038217
  %343 = add i32 %94, -559038217
  %344 = xor i32 %343, -559038217
  %345 = shl i32 %343, 14
  %346 = lshr i32 %343, 18
  %347 = or i32 %346, %345
  %348 = sub i32 %344, %347
  %349 = xor i32 %348, %342
  %350 = shl i32 %348, 11
  %351 = lshr i32 %348, 21
  %352 = or i32 %351, %350
  %353 = sub i32 %349, %352
  %354 = xor i32 %353, %343
  %355 = shl i32 %353, 25
  %356 = lshr i32 %353, 7
  %357 = or i32 %356, %355
  %358 = sub i32 %354, %357
  %359 = xor i32 %358, %348
  %360 = shl i32 %358, 16
  %361 = lshr i32 %358, 16
  %362 = or i32 %361, %360
  %363 = sub i32 %359, %362
  %364 = xor i32 %363, %353
  %365 = shl i32 %363, 4
  %366 = lshr i32 %363, 28
  %367 = or i32 %366, %365
  %368 = sub i32 %364, %367
  %369 = xor i32 %368, %358
  %370 = shl i32 %368, 14
  %371 = lshr i32 %368, 18
  %372 = or i32 %371, %370
  %373 = sub i32 %369, %372
  %374 = xor i32 %373, %363
  %375 = lshr i32 %373, 8
  %376 = sub i32 %374, %375
  %377 = and i32 %376, 511
  store i32 %377, i32* %5, align 4, !tbaa !17
  %378 = call i32 inttoptr (i64 3 to i32 (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %341) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %341) #2
  br label %379

; <label>:379:                                    ; preds = %303, %340, %299
  %380 = phi i32 [ %339, %303 ], [ %377, %340 ], [ %142, %299 ]
  %381 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %381) #2
  %382 = bitcast i32* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %382) #2
  %383 = bitcast i32* %4 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %383) #2
  store i32 513, i32* %4, align 4, !tbaa !17
  store i32 0, i32* %2, align 4, !tbaa !17
  store i32 %380, i32* %3, align 4, !tbaa !17
  %384 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %382) #2
  %385 = icmp eq i8* %384, null
  br i1 %385, label %389, label %386

; <label>:386:                                    ; preds = %379
  %387 = bitcast i8* %384 to i32*
  %388 = load i32, i32* %387, align 4, !tbaa !17
  store i32 %388, i32* %4, align 4, !tbaa !17
  br label %391

; <label>:389:                                    ; preds = %379
  %390 = load i32, i32* %4, align 4, !tbaa !17
  br label %391

; <label>:391:                                    ; preds = %389, %386
  %392 = phi i32 [ %390, %389 ], [ %388, %386 ]
  %393 = icmp eq i32 %392, 513
  br i1 %393, label %399, label %394

; <label>:394:                                    ; preds = %391
  %395 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %383) #2
  %396 = icmp eq i8* %395, null
  br i1 %396, label %399, label %397

; <label>:397:                                    ; preds = %394
  %398 = bitcast i8* %395 to %struct.dest_info*
  br label %502

; <label>:399:                                    ; preds = %394, %391
  store i32 %96, i32* %2, align 4, !tbaa !17
  %400 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @services to i8*), i8* nonnull %381) #2
  %401 = icmp eq i8* %400, null
  br i1 %401, label %502, label %402

; <label>:402:                                    ; preds = %399
  %403 = getelementptr inbounds i8, i8* %400, i64 16
  %404 = bitcast i8* %403 to i64*
  %405 = load i64, i64* %404, align 8, !tbaa !22
  %406 = bitcast i8* %400 to i64*
  %407 = load i64, i64* %406, align 8, !tbaa !24
  %408 = add i64 %407, 1
  %409 = and i64 %408, 4294967295
  %410 = urem i64 %409, %405
  %411 = add i64 %410, %405
  %412 = trunc i64 %411 to i32
  store i32 %412, i32* %4, align 4, !tbaa !17
  %413 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %383) #2
  %414 = icmp eq i8* %413, null
  br i1 %414, label %415, label %424

; <label>:415:                                    ; preds = %402
  %416 = load i32, i32* %4, align 4, !tbaa !17
  %417 = add i32 %416, 1
  %418 = zext i32 %417 to i64
  %419 = urem i64 %418, %405
  %420 = add i64 %419, %405
  %421 = trunc i64 %420 to i32
  store i32 %421, i32* %4, align 4, !tbaa !17
  %422 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %383) #2
  %423 = icmp eq i8* %422, null
  br i1 %423, label %430, label %424

; <label>:424:                                    ; preds = %493, %484, %475, %466, %457, %448, %439, %430, %415, %402
  %425 = phi i8* [ %413, %402 ], [ %422, %415 ], [ %437, %430 ], [ %446, %439 ], [ %455, %448 ], [ %464, %457 ], [ %473, %466 ], [ %482, %475 ], [ %491, %484 ], [ %500, %493 ]
  %426 = bitcast i8* %425 to %struct.dest_info*
  %427 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @destinations to i8*), i8* nonnull %382, i8* nonnull %383, i64 0) #2
  %428 = load i32, i32* %4, align 4, !tbaa !17
  %429 = zext i32 %428 to i64
  store i64 %429, i64* %406, align 8, !tbaa !24
  br label %502

; <label>:430:                                    ; preds = %415
  %431 = load i32, i32* %4, align 4, !tbaa !17
  %432 = add i32 %431, 1
  %433 = zext i32 %432 to i64
  %434 = urem i64 %433, %405
  %435 = add i64 %434, %405
  %436 = trunc i64 %435 to i32
  store i32 %436, i32* %4, align 4, !tbaa !17
  %437 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %383) #2
  %438 = icmp eq i8* %437, null
  br i1 %438, label %439, label %424

; <label>:439:                                    ; preds = %430
  %440 = load i32, i32* %4, align 4, !tbaa !17
  %441 = add i32 %440, 1
  %442 = zext i32 %441 to i64
  %443 = urem i64 %442, %405
  %444 = add i64 %443, %405
  %445 = trunc i64 %444 to i32
  store i32 %445, i32* %4, align 4, !tbaa !17
  %446 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %383) #2
  %447 = icmp eq i8* %446, null
  br i1 %447, label %448, label %424

; <label>:448:                                    ; preds = %439
  %449 = load i32, i32* %4, align 4, !tbaa !17
  %450 = add i32 %449, 1
  %451 = zext i32 %450 to i64
  %452 = urem i64 %451, %405
  %453 = add i64 %452, %405
  %454 = trunc i64 %453 to i32
  store i32 %454, i32* %4, align 4, !tbaa !17
  %455 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %383) #2
  %456 = icmp eq i8* %455, null
  br i1 %456, label %457, label %424

; <label>:457:                                    ; preds = %448
  %458 = load i32, i32* %4, align 4, !tbaa !17
  %459 = add i32 %458, 1
  %460 = zext i32 %459 to i64
  %461 = urem i64 %460, %405
  %462 = add i64 %461, %405
  %463 = trunc i64 %462 to i32
  store i32 %463, i32* %4, align 4, !tbaa !17
  %464 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %383) #2
  %465 = icmp eq i8* %464, null
  br i1 %465, label %466, label %424

; <label>:466:                                    ; preds = %457
  %467 = load i32, i32* %4, align 4, !tbaa !17
  %468 = add i32 %467, 1
  %469 = zext i32 %468 to i64
  %470 = urem i64 %469, %405
  %471 = add i64 %470, %405
  %472 = trunc i64 %471 to i32
  store i32 %472, i32* %4, align 4, !tbaa !17
  %473 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %383) #2
  %474 = icmp eq i8* %473, null
  br i1 %474, label %475, label %424

; <label>:475:                                    ; preds = %466
  %476 = load i32, i32* %4, align 4, !tbaa !17
  %477 = add i32 %476, 1
  %478 = zext i32 %477 to i64
  %479 = urem i64 %478, %405
  %480 = add i64 %479, %405
  %481 = trunc i64 %480 to i32
  store i32 %481, i32* %4, align 4, !tbaa !17
  %482 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %383) #2
  %483 = icmp eq i8* %482, null
  br i1 %483, label %484, label %424

; <label>:484:                                    ; preds = %475
  %485 = load i32, i32* %4, align 4, !tbaa !17
  %486 = add i32 %485, 1
  %487 = zext i32 %486 to i64
  %488 = urem i64 %487, %405
  %489 = add i64 %488, %405
  %490 = trunc i64 %489 to i32
  store i32 %490, i32* %4, align 4, !tbaa !17
  %491 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %383) #2
  %492 = icmp eq i8* %491, null
  br i1 %492, label %493, label %424

; <label>:493:                                    ; preds = %484
  %494 = load i32, i32* %4, align 4, !tbaa !17
  %495 = add i32 %494, 1
  %496 = zext i32 %495 to i64
  %497 = urem i64 %496, %405
  %498 = add i64 %497, %405
  %499 = trunc i64 %498 to i32
  store i32 %499, i32* %4, align 4, !tbaa !17
  %500 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* nonnull %383) #2
  %501 = icmp eq i8* %500, null
  br i1 %501, label %502, label %424

; <label>:502:                                    ; preds = %397, %399, %424, %493
  %503 = phi %struct.dest_info* [ %398, %397 ], [ %426, %424 ], [ null, %399 ], [ null, %493 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %383) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %382) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %381) #2
  %504 = icmp eq %struct.dest_info* %503, null
  br i1 %504, label %505, label %507

; <label>:505:                                    ; preds = %502
  %506 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @drop_logs to i8*), i8* nonnull %18, i8* nonnull %15, i64 1) #2
  br label %537

; <label>:507:                                    ; preds = %502
  %508 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %503, i64 0, i32 5, i64 0
  %509 = load i8, i8* %508, align 8, !tbaa !25
  %510 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %27, i64 0, i32 0, i64 0
  store i8 %509, i8* %510, align 1, !tbaa !25
  %511 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %503, i64 0, i32 5, i64 1
  %512 = load i8, i8* %511, align 1, !tbaa !25
  %513 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %27, i64 0, i32 0, i64 1
  store i8 %512, i8* %513, align 1, !tbaa !25
  %514 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %503, i64 0, i32 5, i64 2
  %515 = load i8, i8* %514, align 2, !tbaa !25
  %516 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %27, i64 0, i32 0, i64 2
  store i8 %515, i8* %516, align 1, !tbaa !25
  %517 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %503, i64 0, i32 5, i64 3
  %518 = load i8, i8* %517, align 1, !tbaa !25
  %519 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %27, i64 0, i32 0, i64 3
  store i8 %518, i8* %519, align 1, !tbaa !25
  %520 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %503, i64 0, i32 5, i64 4
  %521 = load i8, i8* %520, align 4, !tbaa !25
  %522 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %27, i64 0, i32 0, i64 4
  store i8 %521, i8* %522, align 1, !tbaa !25
  %523 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %503, i64 0, i32 5, i64 5
  %524 = load i8, i8* %523, align 1, !tbaa !25
  %525 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %27, i64 0, i32 0, i64 5
  store i8 %524, i8* %525, align 1, !tbaa !25
  %526 = bitcast i32* %14 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %526) #2
  %527 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %503, i64 0, i32 1
  %528 = load i32, i32* %527, align 4, !tbaa !26
  %529 = call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %528) #3, !srcloc !16
  store i32 %529, i32* %14, align 4, !tbaa !17
  %530 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @pass_logs to i8*), i8* nonnull %18, i8* nonnull %526, i64 0) #2
  %531 = sub nsw i64 %21, %25
  %532 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %503, i64 0, i32 4
  %533 = atomicrmw add i64* %532, i64 1 seq_cst
  %534 = getelementptr inbounds %struct.dest_info, %struct.dest_info* %503, i64 0, i32 3
  %535 = and i64 %531, 65535
  %536 = atomicrmw add i64* %534, i64 %535 seq_cst
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %526) #2
  br label %537

; <label>:537:                                    ; preds = %505, %507
  %538 = phi i32 [ 3, %507 ], [ 1, %505 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %95) #2
  br label %540

; <label>:539:                                    ; preds = %81
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %95) #2
  br label %540

; <label>:540:                                    ; preds = %539, %537, %34, %37, %67, %70, %41, %30, %1
  %541 = phi i32 [ 1, %1 ], [ 2, %30 ], [ 1, %34 ], [ 2, %37 ], [ 1, %41 ], [ 1, %70 ], [ 1, %67 ], [ 2, %539 ], [ %538, %537 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %18) #2
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %17) #2
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %16) #2
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %15) #2
  ret i32 %541
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
!16 = !{i32 548553}
!17 = !{!8, !8, i64 0}
!18 = !{!14, !8, i64 16}
!19 = !{!20, !12, i64 0}
!20 = !{!"tcphdr", !12, i64 0, !12, i64 2, !8, i64 4, !8, i64 8, !12, i64 12, !12, i64 12, !12, i64 13, !12, i64 13, !12, i64 13, !12, i64 13, !12, i64 13, !12, i64 13, !12, i64 13, !12, i64 13, !12, i64 14, !12, i64 16, !12, i64 18}
!21 = !{!20, !12, i64 2}
!22 = !{!23, !3, i64 16}
!23 = !{!"service", !3, i64 0, !3, i64 8, !3, i64 16}
!24 = !{!23, !3, i64 0}
!25 = !{!4, !4, i64 0}
!26 = !{!27, !8, i64 4}
!27 = !{!"dest_info", !8, i64 0, !8, i64 4, !8, i64 8, !3, i64 16, !3, i64 24, !4, i64 32}
