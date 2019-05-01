; ModuleID = 'tc_bench01_redirect_kern.c'
source_filename = "tc_bench01_redirect_kern.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.bpf_elf_map = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.__sk_buff = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, [5 x i32], i32, i32, i32, i32, i32, i32, i32, i32, [4 x i32], [4 x i32], i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }

@egress_ifindex = global %struct.bpf_elf_map { i32 2, i32 4, i32 4, i32 1, i32 0, i32 0, i32 2 }, section "maps", align 4
@_license = global [4 x i8] c"GPL\00", section "license", align 1
@llvm.used = appending global [3 x i8*] [i8* bitcast (i32 (%struct.__sk_buff*)* @_ingress_redirect to i8*), i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_elf_map* @egress_ifindex to i8*)], section "llvm.metadata"

; Function Attrs: nounwind uwtable
define i32 @_ingress_redirect(%struct.__sk_buff* nocapture readonly) #0 section "ingress_redirect" {
  %2 = alloca i32, align 4
  %3 = getelementptr inbounds %struct.__sk_buff, %struct.__sk_buff* %0, i64 0, i32 15
  %4 = load i32, i32* %3, align 4, !tbaa !2
  %5 = zext i32 %4 to i64
  %6 = inttoptr i64 %5 to i8*
  %7 = getelementptr inbounds %struct.__sk_buff, %struct.__sk_buff* %0, i64 0, i32 16
  %8 = load i32, i32* %7, align 4, !tbaa !7
  %9 = zext i32 %8 to i64
  %10 = inttoptr i64 %9 to i8*
  %11 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %11) #2
  store i32 0, i32* %2, align 4, !tbaa !8
  %12 = getelementptr i8, i8* %6, i64 14
  %13 = icmp ugt i8* %12, %10
  br i1 %13, label %50, label %14

; <label>:14:                                     ; preds = %1
  %15 = inttoptr i64 %5 to %struct.ethhdr*
  %16 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %15, i64 0, i32 2
  %17 = load i16, i16* %16, align 1, !tbaa !9
  %18 = icmp eq i16 %17, 1544
  br i1 %18, label %50, label %19

; <label>:19:                                     ; preds = %14
  %20 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_elf_map* @egress_ifindex to i8*), i8* nonnull %11) #2
  %21 = icmp eq i8* %20, null
  br i1 %21, label %50, label %22

; <label>:22:                                     ; preds = %19
  %23 = bitcast i8* %20 to i32*
  %24 = load i32, i32* %23, align 4, !tbaa !8
  switch i32 %24, label %26 [
    i32 0, label %50
    i32 42, label %25
  ]

; <label>:25:                                     ; preds = %22
  br label %50

; <label>:26:                                     ; preds = %22
  %27 = getelementptr inbounds %struct.__sk_buff, %struct.__sk_buff* %0, i64 0, i32 9
  %28 = load i32, i32* %27, align 4, !tbaa !12
  %29 = icmp eq i32 %24, %28
  br i1 %29, label %30, label %48

; <label>:30:                                     ; preds = %26
  %31 = inttoptr i64 %5 to i16*
  %32 = load i16, i16* %31, align 2, !tbaa !13
  %33 = getelementptr inbounds i8, i8* %6, i64 2
  %34 = bitcast i8* %33 to i16*
  %35 = load i16, i16* %34, align 2, !tbaa !13
  %36 = getelementptr inbounds i8, i8* %6, i64 4
  %37 = bitcast i8* %36 to i16*
  %38 = load i16, i16* %37, align 2, !tbaa !13
  %39 = getelementptr inbounds i8, i8* %6, i64 6
  %40 = bitcast i8* %39 to i16*
  %41 = load i16, i16* %40, align 2, !tbaa !13
  store i16 %41, i16* %31, align 2, !tbaa !13
  %42 = getelementptr inbounds i8, i8* %6, i64 8
  %43 = bitcast i8* %42 to i16*
  %44 = load i16, i16* %43, align 2, !tbaa !13
  store i16 %44, i16* %34, align 2, !tbaa !13
  %45 = getelementptr inbounds i8, i8* %6, i64 10
  %46 = bitcast i8* %45 to i16*
  %47 = load i16, i16* %46, align 2, !tbaa !13
  store i16 %47, i16* %37, align 2, !tbaa !13
  store i16 %32, i16* %40, align 2, !tbaa !13
  store i16 %35, i16* %43, align 2, !tbaa !13
  store i16 %38, i16* %46, align 2, !tbaa !13
  br label %48

; <label>:48:                                     ; preds = %30, %26
  %49 = call i32 inttoptr (i64 23 to i32 (i32, i32)*)(i32 %24, i32 0) #2
  br label %50

; <label>:50:                                     ; preds = %22, %19, %14, %1, %48, %25
  %51 = phi i32 [ 2, %25 ], [ %49, %48 ], [ 0, %1 ], [ 0, %14 ], [ 0, %19 ], [ %24, %22 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %11) #2
  ret i32 %51
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
!2 = !{!3, !4, i64 76}
!3 = !{!"__sk_buff", !4, i64 0, !4, i64 4, !4, i64 8, !4, i64 12, !4, i64 16, !4, i64 20, !4, i64 24, !4, i64 28, !4, i64 32, !4, i64 36, !4, i64 40, !4, i64 44, !5, i64 48, !4, i64 68, !4, i64 72, !4, i64 76, !4, i64 80, !4, i64 84, !4, i64 88, !4, i64 92, !4, i64 96, !5, i64 100, !5, i64 116, !4, i64 132, !4, i64 136, !4, i64 140}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = !{!3, !4, i64 80}
!8 = !{!4, !4, i64 0}
!9 = !{!10, !11, i64 12}
!10 = !{!"ethhdr", !5, i64 0, !5, i64 6, !11, i64 12}
!11 = !{!"short", !5, i64 0}
!12 = !{!3, !4, i64 36}
!13 = !{!11, !11, i64 0}
