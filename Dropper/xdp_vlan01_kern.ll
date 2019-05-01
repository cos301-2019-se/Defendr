; ModuleID = 'xdp_vlan01_kern.c'
source_filename = "xdp_vlan01_kern.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.__sk_buff = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, [5 x i32], i32, i32, i32, i32, i32, i32, i32, i32, [4 x i32], [4 x i32], i32, i32, i32 }

@_license = global [4 x i8] c"GPL\00", section "license", align 1
@llvm.used = appending global [6 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.__sk_buff*)* @_tc_progA to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_prognum0 to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_prognum1 to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_prognum2 to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_prognum3 to i8*)], section "llvm.metadata"

; Function Attrs: nounwind readonly uwtable
define i32 @xdp_prognum0(%struct.xdp_md* nocapture readonly) #0 section "xdp_drop_vlan_4011" {
  %2 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %3 = load i32, i32* %2, align 4, !tbaa !2
  %4 = zext i32 %3 to i64
  %5 = inttoptr i64 %4 to i8*
  %6 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0
  %7 = load i32, i32* %6, align 4, !tbaa !7
  %8 = zext i32 %7 to i64
  %9 = inttoptr i64 %8 to %struct.ethhdr*
  %10 = getelementptr %struct.ethhdr, %struct.ethhdr* %9, i64 0, i32 0, i64 14
  %11 = getelementptr %struct.ethhdr, %struct.ethhdr* %9, i64 0, i32 0, i64 22
  %12 = icmp ugt i8* %11, %5
  br i1 %12, label %22, label %13

; <label>:13:                                     ; preds = %1
  %14 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %9, i64 0, i32 2
  %15 = load i16, i16* %14, align 1, !tbaa !8
  switch i16 %15, label %22 [
    i16 129, label %16
    i16 -22392, label %16
  ]

; <label>:16:                                     ; preds = %13, %13
  %17 = bitcast i8* %10 to i16*
  %18 = load i16, i16* %17, align 2, !tbaa !11
  %19 = and i16 %18, -241
  %20 = icmp eq i16 %19, -21745
  %21 = select i1 %20, i32 0, i32 2
  br label %22

; <label>:22:                                     ; preds = %13, %16, %1
  %23 = phi i32 [ 0, %1 ], [ 2, %13 ], [ %21, %16 ]
  ret i32 %23
}

; Function Attrs: nounwind uwtable
define i32 @xdp_prognum1(%struct.xdp_md* nocapture readonly) #1 section "xdp_vlan_change" {
  %2 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %3 = load i32, i32* %2, align 4, !tbaa !2
  %4 = zext i32 %3 to i64
  %5 = inttoptr i64 %4 to i8*
  %6 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0
  %7 = load i32, i32* %6, align 4, !tbaa !7
  %8 = zext i32 %7 to i64
  %9 = inttoptr i64 %8 to i8*
  %10 = inttoptr i64 %8 to %struct.ethhdr*
  %11 = getelementptr %struct.ethhdr, %struct.ethhdr* %10, i64 0, i32 0, i64 14
  %12 = getelementptr %struct.ethhdr, %struct.ethhdr* %10, i64 0, i32 0, i64 22
  %13 = icmp ugt i8* %12, %5
  br i1 %13, label %29, label %14

; <label>:14:                                     ; preds = %1
  %15 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %10, i64 0, i32 2
  %16 = load i16, i16* %15, align 1, !tbaa !8
  switch i16 %16, label %29 [
    i16 129, label %17
    i16 -22392, label %17
  ]

; <label>:17:                                     ; preds = %14, %14
  %18 = bitcast i8* %11 to i16*
  %19 = load i16, i16* %18, align 2, !tbaa !11
  %20 = and i16 %19, -241
  %21 = icmp eq i16 %20, -21745
  br i1 %21, label %22, label %29

; <label>:22:                                     ; preds = %17
  %23 = getelementptr i8, i8* %9, i64 14
  %24 = bitcast i8* %23 to i16*
  %25 = load i16, i16* %24, align 2, !tbaa !11
  %26 = shl i16 %25, 8
  %27 = and i16 %26, -4096
  %28 = tail call i16 @llvm.bswap.i16(i16 %27) #4
  store i16 %28, i16* %24, align 2, !tbaa !11
  br label %29

; <label>:29:                                     ; preds = %14, %1, %17, %22
  %30 = phi i32 [ 2, %22 ], [ 2, %17 ], [ 0, %1 ], [ 2, %14 ]
  ret i32 %30
}

; Function Attrs: nounwind uwtable
define i32 @xdp_prognum2(%struct.xdp_md*) #1 section "xdp_vlan_remove_outer" {
  %2 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %3 = load i32, i32* %2, align 4, !tbaa !2
  %4 = zext i32 %3 to i64
  %5 = inttoptr i64 %4 to i8*
  %6 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0
  %7 = load i32, i32* %6, align 4, !tbaa !7
  %8 = zext i32 %7 to i64
  %9 = inttoptr i64 %8 to i8*
  %10 = inttoptr i64 %8 to %struct.ethhdr*
  %11 = getelementptr %struct.ethhdr, %struct.ethhdr* %10, i64 0, i32 0, i64 22
  %12 = icmp ugt i8* %11, %5
  br i1 %12, label %20, label %13

; <label>:13:                                     ; preds = %1
  %14 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %10, i64 0, i32 2
  %15 = load i16, i16* %14, align 1, !tbaa !8
  switch i16 %15, label %20 [
    i16 129, label %16
    i16 -22392, label %16
  ]

; <label>:16:                                     ; preds = %13, %13
  %17 = getelementptr inbounds i8, i8* %9, i64 4
  tail call void @llvm.memmove.p0i8.p0i8.i64(i8* nonnull %17, i8* %9, i64 12, i32 1, i1 false)
  %18 = bitcast %struct.xdp_md* %0 to i8*
  %19 = tail call i32 inttoptr (i64 44 to i32 (i8*, i32)*)(i8* %18, i32 4) #4
  br label %20

; <label>:20:                                     ; preds = %13, %1, %16
  %21 = phi i32 [ 2, %16 ], [ 0, %1 ], [ 2, %13 ]
  ret i32 %21
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memmove.p0i8.p0i8.i64(i8* nocapture, i8* nocapture readonly, i64, i32, i1) #2

; Function Attrs: nounwind uwtable
define i32 @xdp_prognum3(%struct.xdp_md*) #1 section "xdp_vlan_remove_outer2" {
  %2 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %3 = load i32, i32* %2, align 4, !tbaa !2
  %4 = zext i32 %3 to i64
  %5 = inttoptr i64 %4 to i8*
  %6 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0
  %7 = load i32, i32* %6, align 4, !tbaa !7
  %8 = zext i32 %7 to i64
  %9 = inttoptr i64 %8 to i8*
  %10 = inttoptr i64 %8 to %struct.ethhdr*
  %11 = getelementptr %struct.ethhdr, %struct.ethhdr* %10, i64 0, i32 0, i64 22
  %12 = icmp ugt i8* %11, %5
  br i1 %12, label %29, label %13

; <label>:13:                                     ; preds = %1
  %14 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %10, i64 0, i32 2
  %15 = load i16, i16* %14, align 1, !tbaa !8
  switch i16 %15, label %29 [
    i16 129, label %16
    i16 -22392, label %16
  ]

; <label>:16:                                     ; preds = %13, %13
  %17 = inttoptr i64 %8 to i32*
  %18 = getelementptr inbounds i8, i8* %9, i64 8
  %19 = bitcast i8* %18 to i32*
  %20 = load i32, i32* %19, align 4, !tbaa !13
  %21 = getelementptr inbounds i8, i8* %9, i64 12
  %22 = bitcast i8* %21 to i32*
  store i32 %20, i32* %22, align 4, !tbaa !13
  %23 = getelementptr inbounds i8, i8* %9, i64 4
  %24 = bitcast i8* %23 to i32*
  %25 = load i32, i32* %24, align 4, !tbaa !13
  store i32 %25, i32* %19, align 4, !tbaa !13
  %26 = load i32, i32* %17, align 4, !tbaa !13
  store i32 %26, i32* %24, align 4, !tbaa !13
  %27 = bitcast %struct.xdp_md* %0 to i8*
  %28 = tail call i32 inttoptr (i64 44 to i32 (i8*, i32)*)(i8* %27, i32 4) #4
  br label %29

; <label>:29:                                     ; preds = %13, %1, %16
  %30 = phi i32 [ 2, %16 ], [ 0, %1 ], [ 2, %13 ]
  ret i32 %30
}

; Function Attrs: nounwind uwtable
define i32 @_tc_progA(%struct.__sk_buff*) #1 section "tc_vlan_push" {
  %2 = bitcast %struct.__sk_buff* %0 to i8*
  %3 = tail call i32 inttoptr (i64 18 to i32 (i8*, i16, i16)*)(i8* %2, i16 zeroext 129, i16 zeroext 4011) #4
  ret i32 0
}

; Function Attrs: nounwind readnone speculatable
declare i16 @llvm.bswap.i16(i16) #3

attributes #0 = { nounwind readonly uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { argmemonly nounwind }
attributes #3 = { nounwind readnone speculatable }
attributes #4 = { nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
!2 = !{!3, !4, i64 4}
!3 = !{!"xdp_md", !4, i64 0, !4, i64 4, !4, i64 8, !4, i64 12, !4, i64 16}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = !{!3, !4, i64 0}
!8 = !{!9, !10, i64 12}
!9 = !{!"ethhdr", !5, i64 0, !5, i64 6, !10, i64 12}
!10 = !{!"short", !5, i64 0}
!11 = !{!12, !10, i64 0}
!12 = !{!"_vlan_hdr", !10, i64 0, !10, i64 2}
!13 = !{!4, !4, i64 0}
