; ModuleID = 'xdp_ddos01_blacklist_kern.c'
source_filename = "xdp_ddos01_blacklist_kern.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.iphdr = type { i8, i8, i16, i16, i16, i8, i8, i16, i32, i32 }

@blacklist = global %struct.bpf_map_def { i32 5, i32 4, i32 8, i32 100000, i32 1, i32 0, i32 0 }, section "maps", align 4
@ip_watchlist = global %struct.bpf_map_def { i32 5, i32 4, i32 8, i32 100000, i32 1, i32 0, i32 0 }, section "maps", align 4
@enter_logs = global %struct.bpf_map_def { i32 5, i32 4, i32 8, i32 100000, i32 1, i32 0, i32 0 }, section "maps", align 4
@drop_logs = global %struct.bpf_map_def { i32 5, i32 4, i32 8, i32 100000, i32 1, i32 0, i32 0 }, section "maps", align 4
@pass_logs = global %struct.bpf_map_def { i32 5, i32 4, i32 8, i32 100000, i32 1, i32 0, i32 0 }, section "maps", align 4
@servers = global %struct.bpf_map_def { i32 1, i32 4, i32 40, i32 512, i32 0, i32 0, i32 0 }, section "maps", align 4
@services = global %struct.bpf_map_def { i32 1, i32 4, i32 24, i32 512, i32 0, i32 0, i32 0 }, section "maps", align 4
@verdict_cnt = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 4, i32 0, i32 0, i32 0 }, section "maps", align 4
@port_blacklist = global %struct.bpf_map_def { i32 6, i32 4, i32 4, i32 65536, i32 0, i32 0, i32 0 }, section "maps", align 4
@port_blacklist_drop_count_tcp = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 65536, i32 0, i32 0, i32 0 }, section "maps", align 4
@port_blacklist_drop_count_udp = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 65536, i32 0, i32 0, i32 0 }, section "maps", align 4
@_license = global [4 x i8] c"GPL\00", section "license", align 1
@llvm.used = appending global [13 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @blacklist to i8*), i8* bitcast (%struct.bpf_map_def* @drop_logs to i8*), i8* bitcast (%struct.bpf_map_def* @enter_logs to i8*), i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* bitcast (%struct.bpf_map_def* @pass_logs to i8*), i8* bitcast (%struct.bpf_map_def* @port_blacklist to i8*), i8* bitcast (%struct.bpf_map_def* @port_blacklist_drop_count_tcp to i8*), i8* bitcast (%struct.bpf_map_def* @port_blacklist_drop_count_udp to i8*), i8* bitcast (%struct.bpf_map_def* @servers to i8*), i8* bitcast (%struct.bpf_map_def* @services to i8*), i8* bitcast (%struct.bpf_map_def* @verdict_cnt to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_program to i8*)], section "llvm.metadata"

; Function Attrs: nounwind uwtable
define i32 @xdp_program(%struct.xdp_md* nocapture readonly) #0 section "xdp_prog" {
  %2 = alloca i32, align 4
  %3 = alloca i64, align 8
  %4 = alloca i64, align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = alloca i32, align 4
  %8 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %9 = load i32, i32* %8, align 4, !tbaa !2
  %10 = zext i32 %9 to i64
  %11 = inttoptr i64 %10 to i8*
  %12 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0
  %13 = load i32, i32* %12, align 4, !tbaa !7
  %14 = zext i32 %13 to i64
  %15 = inttoptr i64 %14 to i8*
  %16 = getelementptr i8, i8* %15, i64 14
  %17 = icmp ugt i8* %16, %11
  br i1 %17, label %101, label %18

; <label>:18:                                     ; preds = %1
  %19 = inttoptr i64 %14 to %struct.ethhdr*
  %20 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %19, i64 0, i32 2
  %21 = load i16, i16* %20, align 1, !tbaa !8
  %22 = icmp eq i16 %21, 8
  br i1 %22, label %23, label %91

; <label>:23:                                     ; preds = %18
  %24 = bitcast i64* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %24) #2
  store i64 1, i64* %3, align 8, !tbaa !11
  %25 = bitcast i64* %4 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %25) #2
  store i64 1, i64* %4, align 8, !tbaa !11
  %26 = bitcast i64* %5 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %26) #2
  store i64 1, i64* %5, align 8, !tbaa !11
  %27 = bitcast i64* %6 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %27) #2
  store i64 1, i64* %6, align 8, !tbaa !11
  %28 = bitcast i32* %7 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %28) #2
  %29 = getelementptr inbounds i8, i8* %15, i64 34
  %30 = bitcast i8* %29 to %struct.iphdr*
  %31 = inttoptr i64 %10 to %struct.iphdr*
  %32 = icmp ugt %struct.iphdr* %30, %31
  br i1 %32, label %89, label %33

; <label>:33:                                     ; preds = %23
  %34 = load i8, i8* %16, align 4
  %35 = and i8 %34, 15
  %36 = icmp eq i8 %35, 5
  br i1 %36, label %37, label %89

; <label>:37:                                     ; preds = %33
  %38 = getelementptr inbounds i8, i8* %15, i64 20
  %39 = bitcast i8* %38 to i16*
  %40 = load i16, i16* %39, align 2, !tbaa !13
  %41 = and i16 %40, -193
  %42 = icmp eq i16 %41, 0
  br i1 %42, label %43, label %89

; <label>:43:                                     ; preds = %37
  %44 = getelementptr inbounds i8, i8* %15, i64 26
  %45 = bitcast i8* %44 to i32*
  %46 = load i32, i32* %45, align 4, !tbaa !15
  %47 = tail call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %46) #3, !srcloc !16
  store i32 %47, i32* %7, align 4, !tbaa !17
  %48 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @enter_logs to i8*), i8* nonnull %28) #2
  %49 = bitcast i8* %48 to i64*
  %50 = icmp eq i8* %48, null
  br i1 %50, label %54, label %51

; <label>:51:                                     ; preds = %43
  %52 = load i64, i64* %49, align 8, !tbaa !11
  %53 = add i64 %52, 1
  store i64 %53, i64* %49, align 8, !tbaa !11
  br label %56

; <label>:54:                                     ; preds = %43
  %55 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @enter_logs to i8*), i8* nonnull %28, i8* nonnull %25, i64 1) #2
  br label %56

; <label>:56:                                     ; preds = %54, %51
  %57 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @blacklist to i8*), i8* nonnull %28) #2
  %58 = bitcast i8* %57 to i64*
  %59 = icmp eq i8* %57, null
  br i1 %59, label %71, label %60

; <label>:60:                                     ; preds = %56
  %61 = load i64, i64* %58, align 8, !tbaa !11
  %62 = add i64 %61, 1
  store i64 %62, i64* %58, align 8, !tbaa !11
  %63 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @drop_logs to i8*), i8* nonnull %28) #2
  %64 = bitcast i8* %63 to i64*
  %65 = icmp eq i8* %63, null
  br i1 %65, label %69, label %66

; <label>:66:                                     ; preds = %60
  %67 = load i64, i64* %64, align 8, !tbaa !11
  %68 = add i64 %67, 1
  store i64 %68, i64* %64, align 8, !tbaa !11
  br label %89

; <label>:69:                                     ; preds = %60
  %70 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @drop_logs to i8*), i8* nonnull %28, i8* nonnull %24, i64 1) #2
  br label %89

; <label>:71:                                     ; preds = %56
  %72 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* nonnull %28) #2
  %73 = bitcast i8* %72 to i64*
  %74 = icmp eq i8* %72, null
  br i1 %74, label %78, label %75

; <label>:75:                                     ; preds = %71
  %76 = load i64, i64* %73, align 8, !tbaa !11
  %77 = add i64 %76, 1
  store i64 %77, i64* %73, align 8, !tbaa !11
  br label %80

; <label>:78:                                     ; preds = %71
  %79 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* nonnull %28, i8* nonnull %27, i64 1) #2
  br label %80

; <label>:80:                                     ; preds = %78, %75
  %81 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @pass_logs to i8*), i8* nonnull %28) #2
  %82 = bitcast i8* %81 to i64*
  %83 = icmp eq i8* %81, null
  br i1 %83, label %87, label %84

; <label>:84:                                     ; preds = %80
  %85 = load i64, i64* %82, align 8, !tbaa !11
  %86 = add i64 %85, 1
  store i64 %86, i64* %82, align 8, !tbaa !11
  br label %89

; <label>:87:                                     ; preds = %80
  %88 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @pass_logs to i8*), i8* nonnull %28, i8* nonnull %26, i64 1) #2
  br label %89

; <label>:89:                                     ; preds = %23, %33, %37, %66, %69, %84, %87
  %90 = phi i32 [ 1, %23 ], [ 1, %33 ], [ 1, %37 ], [ 1, %69 ], [ 1, %66 ], [ 2, %84 ], [ 2, %87 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %28) #2
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %27) #2
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %26) #2
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %25) #2
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %24) #2
  br label %91

; <label>:91:                                     ; preds = %18, %89
  %92 = phi i32 [ %90, %89 ], [ 2, %18 ]
  %93 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %93)
  store i32 %92, i32* %2, align 4, !tbaa !17
  %94 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @verdict_cnt to i8*), i8* nonnull %93) #2
  %95 = bitcast i8* %94 to i64*
  %96 = icmp eq i8* %94, null
  br i1 %96, label %100, label %97

; <label>:97:                                     ; preds = %91
  %98 = load i64, i64* %95, align 8, !tbaa !11
  %99 = add i64 %98, 1
  store i64 %99, i64* %95, align 8, !tbaa !11
  br label %100

; <label>:100:                                    ; preds = %91, %97
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %93)
  br label %101

; <label>:101:                                    ; preds = %1, %100
  %102 = phi i32 [ %92, %100 ], [ 1, %1 ]
  ret i32 %102
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
!2 = !{!3, !4, i64 4}
!3 = !{!"xdp_md", !4, i64 0, !4, i64 4, !4, i64 8, !4, i64 12, !4, i64 16}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = !{!3, !4, i64 0}
!8 = !{!9, !10, i64 12}
!9 = !{!"ethhdr", !5, i64 0, !5, i64 6, !10, i64 12}
!10 = !{!"short", !5, i64 0}
!11 = !{!12, !12, i64 0}
!12 = !{!"long long", !5, i64 0}
!13 = !{!14, !10, i64 6}
!14 = !{!"iphdr", !5, i64 0, !5, i64 0, !5, i64 1, !10, i64 2, !10, i64 4, !10, i64 6, !5, i64 8, !5, i64 9, !10, i64 10, !4, i64 12, !4, i64 16}
!15 = !{!14, !4, i64 12}
!16 = !{i32 546043}
!17 = !{!4, !4, i64 0}
