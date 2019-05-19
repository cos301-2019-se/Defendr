; ModuleID = 'xdp_redirect_err_kern.c'
source_filename = "xdp_redirect_err_kern.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }

@tx_port = global %struct.bpf_map_def { i32 14, i32 4, i32 4, i32 100, i32 0, i32 0, i32 0 }, section "maps", align 4
@rxcnt = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 1, i32 0, i32 0, i32 0 }, section "maps", align 4
@_license = global [4 x i8] c"GPL\00", section "license", align 1
@llvm.used = appending global [6 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @rxcnt to i8*), i8* bitcast (%struct.bpf_map_def* @tx_port to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_prog_redirect_map_rr to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_redirect_dummy_prog to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_redirect_map_prog to i8*)], section "llvm.metadata"

; Function Attrs: nounwind uwtable
define i32 @xdp_redirect_map_prog(%struct.xdp_md* nocapture readonly) #0 section "xdp_redirect_map" {
  %2 = alloca i32, align 4
  %3 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %4 = load i32, i32* %3, align 4, !tbaa !3
  %5 = zext i32 %4 to i64
  %6 = inttoptr i64 %5 to i8*
  %7 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0
  %8 = load i32, i32* %7, align 4, !tbaa !8
  %9 = zext i32 %8 to i64
  %10 = inttoptr i64 %9 to i8*
  %11 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %11) #3
  store i32 0, i32* %2, align 4, !tbaa !9
  %12 = getelementptr i8, i8* %10, i64 14
  %13 = icmp ugt i8* %12, %6
  br i1 %13, label %39, label %14

; <label>:14:                                     ; preds = %1
  %15 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @rxcnt to i8*), i8* nonnull %11) #3
  %16 = bitcast i8* %15 to i64*
  %17 = icmp eq i8* %15, null
  br i1 %17, label %21, label %18

; <label>:18:                                     ; preds = %14
  %19 = load i64, i64* %16, align 8, !tbaa !10
  %20 = add nsw i64 %19, 1
  store i64 %20, i64* %16, align 8, !tbaa !10
  br label %21

; <label>:21:                                     ; preds = %14, %18
  %22 = inttoptr i64 %9 to i16*
  %23 = load i16, i16* %22, align 2, !tbaa !12
  %24 = getelementptr inbounds i8, i8* %10, i64 2
  %25 = bitcast i8* %24 to i16*
  %26 = load i16, i16* %25, align 2, !tbaa !12
  %27 = getelementptr inbounds i8, i8* %10, i64 4
  %28 = bitcast i8* %27 to i16*
  %29 = load i16, i16* %28, align 2, !tbaa !12
  %30 = getelementptr inbounds i8, i8* %10, i64 6
  %31 = bitcast i8* %30 to i16*
  %32 = load i16, i16* %31, align 2, !tbaa !12
  store i16 %32, i16* %22, align 2, !tbaa !12
  %33 = getelementptr inbounds i8, i8* %10, i64 8
  %34 = bitcast i8* %33 to i16*
  %35 = load i16, i16* %34, align 2, !tbaa !12
  store i16 %35, i16* %25, align 2, !tbaa !12
  %36 = getelementptr inbounds i8, i8* %10, i64 10
  %37 = bitcast i8* %36 to i16*
  %38 = load i16, i16* %37, align 2, !tbaa !12
  store i16 %38, i16* %28, align 2, !tbaa !12
  store i16 %23, i16* %31, align 2, !tbaa !12
  store i16 %26, i16* %34, align 2, !tbaa !12
  store i16 %29, i16* %37, align 2, !tbaa !12
  br label %39

; <label>:39:                                     ; preds = %1, %21
  %40 = phi i32 [ 4, %21 ], [ 1, %1 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %11) #3
  ret i32 %40
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1

; Function Attrs: norecurse nounwind readnone uwtable
define i32 @xdp_redirect_dummy_prog(%struct.xdp_md* nocapture readnone) #2 section "xdp_redirect_dummy" {
  ret i32 2
}

; Function Attrs: nounwind uwtable
define i32 @xdp_prog_redirect_map_rr(%struct.xdp_md* nocapture readnone) #0 section "xdp_redirect_map_rr" {
  %2 = alloca i32, align 4
  %3 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #3
  store i32 0, i32* %2, align 4, !tbaa !9
  %4 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @rxcnt to i8*), i8* nonnull %3) #3
  %5 = bitcast i8* %4 to i64*
  %6 = icmp eq i8* %4, null
  br i1 %6, label %13, label %7

; <label>:7:                                      ; preds = %1
  %8 = load i64, i64* %5, align 8, !tbaa !10
  %9 = add nsw i64 %8, 1
  store i64 %9, i64* %5, align 8, !tbaa !10
  %10 = srem i64 %9, 2
  %11 = trunc i64 %10 to i32
  %12 = icmp sgt i32 %11, 9
  br i1 %12, label %16, label %13

; <label>:13:                                     ; preds = %1, %7
  %14 = phi i32 [ %11, %7 ], [ 0, %1 ]
  %15 = call i32 inttoptr (i64 51 to i32 (i8*, i32, i32)*)(i8* bitcast (%struct.bpf_map_def* @tx_port to i8*), i32 %14, i32 0) #3
  br label %16

; <label>:16:                                     ; preds = %7, %13
  %17 = phi i32 [ %15, %13 ], [ 0, %7 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #3
  ret i32 %17
}

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { norecurse nounwind readnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }

!llvm.named.register.rsp = !{!0}
!llvm.module.flags = !{!1}
!llvm.ident = !{!2}

!0 = !{!"rsp"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
!3 = !{!4, !5, i64 4}
!4 = !{!"xdp_md", !5, i64 0, !5, i64 4, !5, i64 8, !5, i64 12, !5, i64 16}
!5 = !{!"int", !6, i64 0}
!6 = !{!"omnipotent char", !7, i64 0}
!7 = !{!"Simple C/C++ TBAA"}
!8 = !{!4, !5, i64 0}
!9 = !{!5, !5, i64 0}
!10 = !{!11, !11, i64 0}
!11 = !{!"long", !6, i64 0}
!12 = !{!13, !13, i64 0}
!13 = !{!"short", !6, i64 0}
