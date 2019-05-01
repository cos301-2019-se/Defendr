; ModuleID = 'xdp_monitor_kern.c'
source_filename = "xdp_monitor_kern.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_redirect_ctx = type { i16, i8, i8, i32, i32, i32, i32, i32, i32, i32, i32 }

@redirect_err_cnt = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 2, i32 0, i32 0, i32 0 }, section "maps", align 4
@llvm.used = appending global [5 x i8*] [i8* bitcast (%struct.bpf_map_def* @redirect_err_cnt to i8*), i8* bitcast (i32 (%struct.xdp_redirect_ctx*)* @trace_xdp_redirect to i8*), i8* bitcast (i32 (%struct.xdp_redirect_ctx*)* @trace_xdp_redirect_err to i8*), i8* bitcast (i32 (%struct.xdp_redirect_ctx*)* @trace_xdp_redirect_map to i8*), i8* bitcast (i32 (%struct.xdp_redirect_ctx*)* @trace_xdp_redirect_map_err to i8*)], section "llvm.metadata"

; Function Attrs: nounwind uwtable
define i32 @trace_xdp_redirect_err(%struct.xdp_redirect_ctx* nocapture readonly) #0 section "tracepoint/xdp/xdp_redirect_err" {
  %2 = alloca i32, align 4
  %3 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #2
  %4 = getelementptr inbounds %struct.xdp_redirect_ctx, %struct.xdp_redirect_ctx* %0, i64 0, i32 7
  %5 = load i32, i32* %4, align 4, !tbaa !2
  %6 = icmp ne i32 %5, 0
  %7 = zext i1 %6 to i32
  store i32 %7, i32* %2, align 4
  %8 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @redirect_err_cnt to i8*), i8* nonnull %3) #2
  %9 = bitcast i8* %8 to i64*
  %10 = icmp eq i8* %8, null
  br i1 %10, label %14, label %11

; <label>:11:                                     ; preds = %1
  %12 = load i64, i64* %9, align 8, !tbaa !8
  %13 = add i64 %12, 1
  store i64 %13, i64* %9, align 8, !tbaa !8
  br label %14

; <label>:14:                                     ; preds = %1, %11
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #2
  ret i32 0
}

; Function Attrs: nounwind uwtable
define i32 @trace_xdp_redirect_map_err(%struct.xdp_redirect_ctx* nocapture readonly) #0 section "tracepoint/xdp/xdp_redirect_map_err" {
  %2 = alloca i32, align 4
  %3 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #2
  %4 = getelementptr inbounds %struct.xdp_redirect_ctx, %struct.xdp_redirect_ctx* %0, i64 0, i32 7
  %5 = load i32, i32* %4, align 4, !tbaa !2
  %6 = icmp ne i32 %5, 0
  %7 = zext i1 %6 to i32
  store i32 %7, i32* %2, align 4
  %8 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @redirect_err_cnt to i8*), i8* nonnull %3) #2
  %9 = bitcast i8* %8 to i64*
  %10 = icmp eq i8* %8, null
  br i1 %10, label %14, label %11

; <label>:11:                                     ; preds = %1
  %12 = load i64, i64* %9, align 8, !tbaa !8
  %13 = add i64 %12, 1
  store i64 %13, i64* %9, align 8, !tbaa !8
  br label %14

; <label>:14:                                     ; preds = %1, %11
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #2
  ret i32 0
}

; Function Attrs: nounwind uwtable
define i32 @trace_xdp_redirect(%struct.xdp_redirect_ctx* nocapture readonly) #0 section "tracepoint/xdp/xdp_redirect" {
  %2 = alloca i32, align 4
  %3 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #2
  %4 = getelementptr inbounds %struct.xdp_redirect_ctx, %struct.xdp_redirect_ctx* %0, i64 0, i32 7
  %5 = load i32, i32* %4, align 4, !tbaa !2
  %6 = icmp ne i32 %5, 0
  %7 = zext i1 %6 to i32
  store i32 %7, i32* %2, align 4
  %8 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @redirect_err_cnt to i8*), i8* nonnull %3) #2
  %9 = bitcast i8* %8 to i64*
  %10 = icmp eq i8* %8, null
  br i1 %10, label %14, label %11

; <label>:11:                                     ; preds = %1
  %12 = load i64, i64* %9, align 8, !tbaa !8
  %13 = add i64 %12, 1
  store i64 %13, i64* %9, align 8, !tbaa !8
  br label %14

; <label>:14:                                     ; preds = %1, %11
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #2
  ret i32 0
}

; Function Attrs: nounwind uwtable
define i32 @trace_xdp_redirect_map(%struct.xdp_redirect_ctx* nocapture readonly) #0 section "tracepoint/xdp/xdp_redirect_map" {
  %2 = alloca i32, align 4
  %3 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #2
  %4 = getelementptr inbounds %struct.xdp_redirect_ctx, %struct.xdp_redirect_ctx* %0, i64 0, i32 7
  %5 = load i32, i32* %4, align 4, !tbaa !2
  %6 = icmp ne i32 %5, 0
  %7 = zext i1 %6 to i32
  store i32 %7, i32* %2, align 4
  %8 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @redirect_err_cnt to i8*), i8* nonnull %3) #2
  %9 = bitcast i8* %8 to i64*
  %10 = icmp eq i8* %8, null
  br i1 %10, label %14, label %11

; <label>:11:                                     ; preds = %1
  %12 = load i64, i64* %9, align 8, !tbaa !8
  %13 = add i64 %12, 1
  store i64 %13, i64* %9, align 8, !tbaa !8
  br label %14

; <label>:14:                                     ; preds = %1, %11
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #2
  ret i32 0
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
!2 = !{!3, !7, i64 20}
!3 = !{!"xdp_redirect_ctx", !4, i64 0, !5, i64 2, !5, i64 3, !7, i64 4, !7, i64 8, !7, i64 12, !7, i64 16, !7, i64 20, !7, i64 24, !7, i64 28, !7, i64 32}
!4 = !{!"short", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = !{!"int", !5, i64 0}
!8 = !{!9, !9, i64 0}
!9 = !{!"long long", !5, i64 0}
