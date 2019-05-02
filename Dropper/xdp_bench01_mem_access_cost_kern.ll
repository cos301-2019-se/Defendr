; ModuleID = 'xdp_bench01_mem_access_cost_kern.c'
source_filename = "xdp_bench01_mem_access_cost_kern.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }

@rx_cnt = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 1, i32 0, i32 0, i32 0 }, section "maps", align 4
@xdp_action = global %struct.bpf_map_def { i32 2, i32 4, i32 8, i32 1, i32 0, i32 0, i32 0 }, section "maps", align 4
@touch_memory = global %struct.bpf_map_def { i32 2, i32 4, i32 8, i32 1, i32 0, i32 0, i32 0 }, section "maps", align 4
@_license = global [4 x i8] c"GPL\00", section "license", align 1
@__version = global i32 1, section "version", align 4
@llvm.used = appending global [6 x i8*] [i8* bitcast (i32* @__version to i8*), i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @rx_cnt to i8*), i8* bitcast (%struct.bpf_map_def* @touch_memory to i8*), i8* bitcast (%struct.bpf_map_def* @xdp_action to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_prog to i8*)], section "llvm.metadata"

; Function Attrs: nounwind uwtable
define i32 @xdp_prog(%struct.xdp_md* nocapture readonly) #0 section "xdp_bench01" {
  %2 = alloca i16, align 2
  %3 = alloca i32, align 4
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %5 = load i32, i32* %4, align 4, !tbaa !2
  %6 = zext i32 %5 to i64
  %7 = inttoptr i64 %6 to i8*
  %8 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0
  %9 = load i32, i32* %8, align 4, !tbaa !7
  %10 = zext i32 %9 to i64
  %11 = inttoptr i64 %10 to i8*
  %12 = bitcast i16* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 2, i8* nonnull %12)
  %13 = bitcast i32* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %13) #2
  store i32 0, i32* %3, align 4, !tbaa !8
  %14 = getelementptr i8, i8* %11, i64 14
  %15 = icmp ugt i8* %14, %7
  br i1 %15, label %70, label %16

; <label>:16:                                     ; preds = %1
  %17 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_action to i8*), i8* nonnull %13) #2
  %18 = bitcast i8* %17 to i32*
  %19 = icmp eq i8* %17, null
  br i1 %19, label %70, label %20

; <label>:20:                                     ; preds = %16
  %21 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @touch_memory to i8*), i8* nonnull %13) #2
  %22 = icmp eq i8* %21, null
  br i1 %22, label %61, label %23

; <label>:23:                                     ; preds = %20
  %24 = bitcast i8* %21 to i64*
  %25 = load i64, i64* %24, align 8, !tbaa !9
  %26 = icmp eq i64 %25, 0
  br i1 %26, label %61, label %27

; <label>:27:                                     ; preds = %23
  %28 = and i64 %25, 1
  %29 = icmp eq i64 %28, 0
  br i1 %29, label %37, label %30

; <label>:30:                                     ; preds = %27
  %31 = inttoptr i64 %10 to %struct.ethhdr*
  %32 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %31, i64 0, i32 2
  %33 = load i16, i16* %32, align 1, !tbaa !11
  store volatile i16 %33, i16* %2, align 2
  %34 = load volatile i16, i16* %2, align 2
  %35 = trunc i16 %34 to i8
  %36 = icmp ugt i8 %35, 5
  br i1 %36, label %37, label %70

; <label>:37:                                     ; preds = %27, %30
  %38 = load i32, i32* %18, align 4, !tbaa !8
  %39 = icmp ne i32 %38, 3
  %40 = and i64 %25, 2
  %41 = icmp eq i64 %40, 0
  %42 = and i1 %41, %39
  br i1 %42, label %61, label %43

; <label>:43:                                     ; preds = %37
  %44 = inttoptr i64 %10 to i16*
  %45 = load i16, i16* %44, align 2, !tbaa !14
  %46 = getelementptr inbounds i8, i8* %11, i64 2
  %47 = bitcast i8* %46 to i16*
  %48 = load i16, i16* %47, align 2, !tbaa !14
  %49 = getelementptr inbounds i8, i8* %11, i64 4
  %50 = bitcast i8* %49 to i16*
  %51 = load i16, i16* %50, align 2, !tbaa !14
  %52 = getelementptr inbounds i8, i8* %11, i64 6
  %53 = bitcast i8* %52 to i16*
  %54 = load i16, i16* %53, align 2, !tbaa !14
  store i16 %54, i16* %44, align 2, !tbaa !14
  %55 = getelementptr inbounds i8, i8* %11, i64 8
  %56 = bitcast i8* %55 to i16*
  %57 = load i16, i16* %56, align 2, !tbaa !14
  store i16 %57, i16* %47, align 2, !tbaa !14
  %58 = getelementptr inbounds i8, i8* %11, i64 10
  %59 = bitcast i8* %58 to i16*
  %60 = load i16, i16* %59, align 2, !tbaa !14
  store i16 %60, i16* %50, align 2, !tbaa !14
  store i16 %45, i16* %53, align 2, !tbaa !14
  store i16 %48, i16* %56, align 2, !tbaa !14
  store i16 %51, i16* %59, align 2, !tbaa !14
  br label %61

; <label>:61:                                     ; preds = %37, %23, %20, %43
  %62 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @rx_cnt to i8*), i8* nonnull %13) #2
  %63 = bitcast i8* %62 to i64*
  %64 = icmp eq i8* %62, null
  br i1 %64, label %68, label %65

; <label>:65:                                     ; preds = %61
  %66 = load i64, i64* %63, align 8, !tbaa !15
  %67 = add nsw i64 %66, 1
  store i64 %67, i64* %63, align 8, !tbaa !15
  br label %68

; <label>:68:                                     ; preds = %61, %65
  %69 = load i32, i32* %18, align 4, !tbaa !8
  br label %70

; <label>:70:                                     ; preds = %16, %1, %30, %68
  %71 = phi i32 [ %69, %68 ], [ 1, %30 ], [ 1, %1 ], [ 1, %16 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %13) #2
  call void @llvm.lifetime.end.p0i8(i64 2, i8* nonnull %12)
  ret i32 %71
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
!8 = !{!4, !4, i64 0}
!9 = !{!10, !10, i64 0}
!10 = !{!"long long", !5, i64 0}
!11 = !{!12, !13, i64 12}
!12 = !{!"ethhdr", !5, i64 0, !5, i64 6, !13, i64 12}
!13 = !{!"short", !5, i64 0}
!14 = !{!13, !13, i64 0}
!15 = !{!16, !16, i64 0}
!16 = !{!"long", !5, i64 0}
