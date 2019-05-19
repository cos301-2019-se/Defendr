; ModuleID = 'xdp_ttl_kern.c'
source_filename = "xdp_ttl_kern.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.iphdr = type { i8, i8, i16, i16, i16, i8, i8, i16, i32, i32 }

@ttl_map = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 256, i32 0, i32 0, i32 0 }, section "maps", align 4
@ip2hc_map = global %struct.bpf_map_def { i32 6, i32 4, i32 1, i32 100000, i32 0, i32 0, i32 0 }, section "maps", align 4
@_license = global [4 x i8] c"GPL\00", section "license", align 1
@llvm.used = appending global [4 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @ip2hc_map to i8*), i8* bitcast (%struct.bpf_map_def* @ttl_map to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_ttl_program to i8*)], section "llvm.metadata"

; Function Attrs: nounwind uwtable
define i32 @xdp_ttl_program(%struct.xdp_md* nocapture readonly) #0 section "xdp_ttl" {
  %2 = alloca i32, align 4
  %3 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %4 = load i32, i32* %3, align 4, !tbaa !2
  %5 = zext i32 %4 to i64
  %6 = inttoptr i64 %5 to i8*
  %7 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0
  %8 = load i32, i32* %7, align 4, !tbaa !7
  %9 = zext i32 %8 to i64
  %10 = inttoptr i64 %9 to %struct.ethhdr*
  %11 = getelementptr %struct.ethhdr, %struct.ethhdr* %10, i64 0, i32 0, i64 14
  %12 = icmp ugt i8* %11, %6
  br i1 %12, label %50, label %13

; <label>:13:                                     ; preds = %1
  %14 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %10, i64 0, i32 2
  %15 = load i16, i16* %14, align 1, !tbaa !8
  %16 = trunc i16 %15 to i8
  %17 = icmp ult i8 %16, 6
  br i1 %17, label %50, label %18, !prof !11

; <label>:18:                                     ; preds = %13
  switch i16 %15, label %26 [
    i16 129, label %19
    i16 -22392, label %19
  ]

; <label>:19:                                     ; preds = %18, %18
  %20 = getelementptr %struct.ethhdr, %struct.ethhdr* %10, i64 0, i32 0, i64 18
  %21 = icmp ugt i8* %20, %6
  br i1 %21, label %50, label %22

; <label>:22:                                     ; preds = %19
  %23 = getelementptr %struct.ethhdr, %struct.ethhdr* %10, i64 0, i32 0, i64 16
  %24 = bitcast i8* %23 to i16*
  %25 = load i16, i16* %24, align 2, !tbaa !12
  br label %26

; <label>:26:                                     ; preds = %22, %18
  %27 = phi i16 [ %15, %18 ], [ %25, %22 ]
  %28 = phi i64 [ 14, %18 ], [ 18, %22 ]
  %29 = icmp eq i16 %27, 8
  br i1 %29, label %30, label %50

; <label>:30:                                     ; preds = %26
  %31 = inttoptr i64 %9 to i8*
  %32 = getelementptr i8, i8* %31, i64 %28
  %33 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %33) #2
  %34 = getelementptr inbounds i8, i8* %32, i64 20
  %35 = bitcast i8* %34 to %struct.iphdr*
  %36 = inttoptr i64 %5 to %struct.iphdr*
  %37 = icmp ugt %struct.iphdr* %35, %36
  br i1 %37, label %48, label %38

; <label>:38:                                     ; preds = %30
  %39 = getelementptr inbounds i8, i8* %32, i64 8
  %40 = load i8, i8* %39, align 4, !tbaa !14
  %41 = zext i8 %40 to i32
  store i32 %41, i32* %2, align 4, !tbaa !16
  %42 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @ttl_map to i8*), i8* nonnull %33) #2
  %43 = bitcast i8* %42 to i64*
  %44 = icmp eq i8* %42, null
  br i1 %44, label %48, label %45

; <label>:45:                                     ; preds = %38
  %46 = load i64, i64* %43, align 8, !tbaa !17
  %47 = add i64 %46, 1
  store i64 %47, i64* %43, align 8, !tbaa !17
  br label %48

; <label>:48:                                     ; preds = %45, %38, %30
  %49 = phi i32 [ 0, %30 ], [ 2, %38 ], [ 2, %45 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %33) #2
  br label %50

; <label>:50:                                     ; preds = %19, %13, %1, %48, %26
  %51 = phi i32 [ %49, %48 ], [ 2, %26 ], [ 2, %1 ], [ 2, %13 ], [ 2, %19 ]
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
!2 = !{!3, !4, i64 4}
!3 = !{!"xdp_md", !4, i64 0, !4, i64 4, !4, i64 8, !4, i64 12, !4, i64 16}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = !{!3, !4, i64 0}
!8 = !{!9, !10, i64 12}
!9 = !{!"ethhdr", !5, i64 0, !5, i64 6, !10, i64 12}
!10 = !{!"short", !5, i64 0}
!11 = !{!"branch_weights", i32 1, i32 2000}
!12 = !{!13, !10, i64 2}
!13 = !{!"vlan_hdr", !10, i64 0, !10, i64 2}
!14 = !{!15, !5, i64 8}
!15 = !{!"iphdr", !5, i64 0, !5, i64 0, !5, i64 1, !10, i64 2, !10, i64 4, !10, i64 6, !5, i64 8, !5, i64 9, !10, i64 10, !4, i64 12, !4, i64 16}
!16 = !{!4, !4, i64 0}
!17 = !{!18, !18, i64 0}
!18 = !{!"long long", !5, i64 0}
