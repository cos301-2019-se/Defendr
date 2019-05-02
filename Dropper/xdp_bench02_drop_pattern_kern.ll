; ModuleID = 'xdp_bench02_drop_pattern_kern.c'
source_filename = "xdp_bench02_drop_pattern_kern.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.iphdr = type { i8, i8, i16, i16, i16, i8, i8, i16, i32, i32 }

@rx_cnt = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 1, i32 0, i32 0, i32 0 }, section "maps", align 4
@xdp_pattern = global %struct.bpf_map_def { i32 2, i32 4, i32 8, i32 1, i32 0, i32 0, i32 0 }, section "maps", align 4
@touch_memory = global %struct.bpf_map_def { i32 2, i32 4, i32 8, i32 1, i32 0, i32 0, i32 0 }, section "maps", align 4
@verdict_cnt = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 4, i32 0, i32 0, i32 0 }, section "maps", align 4
@count = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 1, i32 0, i32 0, i32 0 }, section "maps", align 4
@blacklist = global %struct.bpf_map_def { i32 5, i32 4, i32 8, i32 100000, i32 1, i32 0, i32 0 }, section "maps", align 4
@xdp_action = global %struct.bpf_map_def { i32 2, i32 4, i32 8, i32 1, i32 0, i32 0, i32 0 }, section "maps", align 4
@_license = global [4 x i8] c"GPL\00", section "license", align 1
@llvm.used = appending global [9 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @blacklist to i8*), i8* bitcast (%struct.bpf_map_def* @count to i8*), i8* bitcast (%struct.bpf_map_def* @rx_cnt to i8*), i8* bitcast (%struct.bpf_map_def* @touch_memory to i8*), i8* bitcast (%struct.bpf_map_def* @verdict_cnt to i8*), i8* bitcast (%struct.bpf_map_def* @xdp_action to i8*), i8* bitcast (%struct.bpf_map_def* @xdp_pattern to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_prog to i8*)], section "llvm.metadata"

; Function Attrs: nounwind uwtable
define i32 @xdp_prog(%struct.xdp_md* nocapture readonly) #0 section "xdp_bench02" {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %7 = load i32, i32* %6, align 4, !tbaa !2
  %8 = zext i32 %7 to i64
  %9 = inttoptr i64 %8 to i8*
  %10 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0
  %11 = load i32, i32* %10, align 4, !tbaa !7
  %12 = zext i32 %11 to i64
  %13 = inttoptr i64 %12 to i8*
  %14 = bitcast i32* %5 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %14) #2
  store i32 0, i32* %5, align 4, !tbaa !8
  %15 = getelementptr i8, i8* %13, i64 14
  %16 = icmp ugt i8* %15, %9
  br i1 %16, label %128, label %17

; <label>:17:                                     ; preds = %1
  %18 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_pattern to i8*), i8* nonnull %14) #2
  %19 = icmp eq i8* %18, null
  br i1 %19, label %128, label %20

; <label>:20:                                     ; preds = %17
  %21 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @touch_memory to i8*), i8* nonnull %14) #2
  %22 = icmp eq i8* %21, null
  br i1 %22, label %71, label %23

; <label>:23:                                     ; preds = %20
  %24 = bitcast i8* %21 to i64*
  %25 = load i64, i64* %24, align 8, !tbaa !9
  %26 = icmp eq i64 %25, 1
  br i1 %26, label %27, label %71

; <label>:27:                                     ; preds = %23
  %28 = inttoptr i64 %12 to %struct.ethhdr*
  %29 = getelementptr %struct.ethhdr, %struct.ethhdr* %28, i64 0, i32 0, i64 14
  %30 = icmp ugt i8* %29, %9
  br i1 %30, label %128, label %31

; <label>:31:                                     ; preds = %27
  %32 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %28, i64 0, i32 2
  %33 = load i16, i16* %32, align 1, !tbaa !11
  %34 = trunc i16 %33 to i8
  %35 = icmp ult i8 %34, 6
  br i1 %35, label %128, label %36, !prof !14

; <label>:36:                                     ; preds = %31
  switch i16 %33, label %44 [
    i16 129, label %37
    i16 -22392, label %37
  ]

; <label>:37:                                     ; preds = %36, %36
  %38 = getelementptr %struct.ethhdr, %struct.ethhdr* %28, i64 0, i32 0, i64 18
  %39 = icmp ugt i8* %38, %9
  br i1 %39, label %128, label %40

; <label>:40:                                     ; preds = %37
  %41 = getelementptr %struct.ethhdr, %struct.ethhdr* %28, i64 0, i32 0, i64 16
  %42 = bitcast i8* %41 to i16*
  %43 = load i16, i16* %42, align 2, !tbaa !15
  br label %44

; <label>:44:                                     ; preds = %40, %36
  %45 = phi i16 [ %33, %36 ], [ %43, %40 ]
  %46 = phi i64 [ 14, %36 ], [ 18, %40 ]
  %47 = icmp eq i16 %45, 8
  br i1 %47, label %48, label %71

; <label>:48:                                     ; preds = %44
  %49 = load i32, i32* %6, align 4, !tbaa !2
  %50 = zext i32 %49 to i64
  %51 = load i32, i32* %10, align 4, !tbaa !7
  %52 = zext i32 %51 to i64
  %53 = inttoptr i64 %52 to i8*
  %54 = getelementptr i8, i8* %53, i64 %46
  %55 = bitcast i32* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %55) #2
  %56 = getelementptr inbounds i8, i8* %54, i64 20
  %57 = bitcast i8* %56 to %struct.iphdr*
  %58 = inttoptr i64 %50 to %struct.iphdr*
  %59 = icmp ugt %struct.iphdr* %57, %58
  br i1 %59, label %67, label %60

; <label>:60:                                     ; preds = %48
  %61 = getelementptr inbounds i8, i8* %54, i64 12
  %62 = bitcast i8* %61 to i32*
  %63 = load i32, i32* %62, align 4, !tbaa !17
  store i32 %63, i32* %3, align 4, !tbaa !8
  %64 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @blacklist to i8*), i8* nonnull %55) #2
  %65 = bitcast i8* %64 to i64*
  %66 = icmp eq i8* %64, null
  br i1 %66, label %67, label %68

; <label>:67:                                     ; preds = %48, %60
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %55) #2
  br label %71

; <label>:68:                                     ; preds = %60
  %69 = load i64, i64* %65, align 8, !tbaa !9
  %70 = add i64 %69, 1
  store i64 %70, i64* %65, align 8, !tbaa !9
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %55) #2
  br label %118

; <label>:71:                                     ; preds = %44, %67, %20, %23
  %72 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @rx_cnt to i8*), i8* nonnull %14) #2
  %73 = bitcast i8* %72 to i64*
  %74 = icmp eq i8* %72, null
  br i1 %74, label %78, label %75

; <label>:75:                                     ; preds = %71
  %76 = load i64, i64* %73, align 8, !tbaa !19
  %77 = add nsw i64 %76, 1
  store i64 %77, i64* %73, align 8, !tbaa !19
  br label %78

; <label>:78:                                     ; preds = %71, %75
  %79 = bitcast i8* %18 to i32*
  %80 = load i32, i32* %79, align 8, !tbaa !21
  %81 = icmp eq i32 %80, 1
  br i1 %81, label %82, label %108

; <label>:82:                                     ; preds = %78
  %83 = getelementptr inbounds i8, i8* %18, i64 4
  %84 = bitcast i8* %83 to i32*
  %85 = load i32, i32* %84, align 4, !tbaa !21
  %86 = zext i32 %85 to i64
  %87 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %87) #2
  store i32 0, i32* %2, align 4, !tbaa !8
  %88 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @count to i8*), i8* nonnull %87) #2
  %89 = bitcast i8* %88 to i64*
  %90 = icmp eq i8* %88, null
  br i1 %90, label %97, label %91

; <label>:91:                                     ; preds = %82
  %92 = load i64, i64* %89, align 8, !tbaa !9
  %93 = add i64 %92, 1
  %94 = shl nuw nsw i64 %86, 1
  %95 = icmp ult i64 %93, %94
  %96 = select i1 %95, i64 %93, i64 0
  store i64 %96, i64* %89, align 8, !tbaa !9
  br label %97

; <label>:97:                                     ; preds = %91, %82
  %98 = phi i64 [ 0, %82 ], [ %92, %91 ]
  %99 = icmp eq i32 %85, 0
  br i1 %99, label %106, label %100

; <label>:100:                                    ; preds = %97
  %101 = icmp ult i64 %98, %86
  br i1 %101, label %106, label %102

; <label>:102:                                    ; preds = %100
  %103 = shl nuw nsw i64 %86, 1
  %104 = icmp ult i64 %98, %103
  %105 = select i1 %104, i32 2, i32 3
  br label %106

; <label>:106:                                    ; preds = %97, %100, %102
  %107 = phi i32 [ 2, %97 ], [ 1, %100 ], [ %105, %102 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %87) #2
  br label %108

; <label>:108:                                    ; preds = %106, %78
  %109 = phi i32 [ %107, %106 ], [ 1, %78 ]
  %110 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_action to i8*), i8* nonnull %14) #2
  %111 = icmp eq i8* %110, null
  br i1 %111, label %118, label %112

; <label>:112:                                    ; preds = %108
  %113 = bitcast i8* %110 to i32*
  %114 = load i32, i32* %113, align 4, !tbaa !8
  %115 = add i32 %114, -1
  %116 = icmp ult i32 %115, 3
  %117 = select i1 %116, i32 %114, i32 %109
  br label %118

; <label>:118:                                    ; preds = %112, %108, %68
  %119 = phi i32 [ 1, %68 ], [ %109, %108 ], [ %117, %112 ]
  %120 = bitcast i32* %4 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %120)
  store i32 %119, i32* %4, align 4, !tbaa !8
  %121 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @verdict_cnt to i8*), i8* nonnull %120) #2
  %122 = bitcast i8* %121 to i64*
  %123 = icmp eq i8* %121, null
  br i1 %123, label %127, label %124

; <label>:124:                                    ; preds = %118
  %125 = load i64, i64* %122, align 8, !tbaa !9
  %126 = add i64 %125, 1
  store i64 %126, i64* %122, align 8, !tbaa !9
  br label %127

; <label>:127:                                    ; preds = %118, %124
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %120)
  br label %128

; <label>:128:                                    ; preds = %27, %31, %37, %17, %1, %127
  %129 = phi i32 [ %119, %127 ], [ 1, %1 ], [ 0, %17 ], [ 2, %37 ], [ 2, %31 ], [ 2, %27 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %14) #2
  ret i32 %129
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
!14 = !{!"branch_weights", i32 1, i32 2000}
!15 = !{!16, !13, i64 2}
!16 = !{!"vlan_hdr", !13, i64 0, !13, i64 2}
!17 = !{!18, !4, i64 12}
!18 = !{!"iphdr", !5, i64 0, !5, i64 0, !5, i64 1, !13, i64 2, !13, i64 4, !13, i64 6, !5, i64 8, !5, i64 9, !13, i64 10, !4, i64 12, !4, i64 16}
!19 = !{!20, !20, i64 0}
!20 = !{!"long", !5, i64 0}
!21 = !{!5, !5, i64 0}
