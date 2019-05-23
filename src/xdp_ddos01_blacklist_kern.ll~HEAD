; ModuleID = 'xdp_ddos01_blacklist_kern.c'
source_filename = "xdp_ddos01_blacklist_kern.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.udphdr = type { i16, i16, i16, i16 }
%struct.tcphdr = type { i16, i16, i32, i32, i16, i16, i16, i16 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.iphdr = type { i8, i8, i16, i16, i16, i8, i8, i16, i32, i32 }

@blacklist = global %struct.bpf_map_def { i32 5, i32 4, i32 8, i32 100000, i32 1, i32 0, i32 0 }, section "maps", align 4
@ip_watchlist = global %struct.bpf_map_def { i32 5, i32 4, i32 8, i32 100000, i32 1, i32 0, i32 0 }, section "maps", align 4
@verdict_cnt = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 4, i32 0, i32 0, i32 0 }, section "maps", align 4
@port_blacklist = global %struct.bpf_map_def { i32 6, i32 4, i32 4, i32 65536, i32 0, i32 0, i32 0 }, section "maps", align 4
@port_blacklist_drop_count_tcp = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 65536, i32 0, i32 0, i32 0 }, section "maps", align 4
@port_blacklist_drop_count_udp = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 65536, i32 0, i32 0, i32 0 }, section "maps", align 4
@_license = global [4 x i8] c"GPL\00", section "license", align 1
@llvm.used = appending global [8 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @blacklist to i8*), i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* bitcast (%struct.bpf_map_def* @port_blacklist to i8*), i8* bitcast (%struct.bpf_map_def* @port_blacklist_drop_count_tcp to i8*), i8* bitcast (%struct.bpf_map_def* @port_blacklist_drop_count_udp to i8*), i8* bitcast (%struct.bpf_map_def* @verdict_cnt to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_program to i8*)], section "llvm.metadata"

; Function Attrs: nounwind uwtable
define i32 @parse_port(%struct.xdp_md* nocapture readonly, i8 zeroext, i8* readonly) local_unnamed_addr #0 {
  %4 = alloca i32, align 4
  %5 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %6 = load i32, i32* %5, align 4, !tbaa !2
  %7 = zext i32 %6 to i64
  %8 = bitcast i32* %4 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %8) #3
  switch i8 %1, label %48 [
    i8 17, label %9
    i8 6, label %14
  ]

; <label>:9:                                      ; preds = %3
  %10 = getelementptr inbounds i8, i8* %2, i64 8
  %11 = bitcast i8* %10 to %struct.udphdr*
  %12 = inttoptr i64 %7 to %struct.udphdr*
  %13 = icmp ugt %struct.udphdr* %11, %12
  br i1 %13, label %48, label %19

; <label>:14:                                     ; preds = %3
  %15 = getelementptr inbounds i8, i8* %2, i64 20
  %16 = bitcast i8* %15 to %struct.tcphdr*
  %17 = inttoptr i64 %7 to %struct.tcphdr*
  %18 = icmp ugt %struct.tcphdr* %16, %17
  br i1 %18, label %48, label %19

; <label>:19:                                     ; preds = %14, %9
  %20 = phi i32 [ 1, %9 ], [ 0, %14 ]
  %21 = getelementptr inbounds i8, i8* %2, i64 2
  %22 = bitcast i8* %21 to i16*
  %23 = load i16, i16* %22, align 2, !tbaa !7
  %24 = tail call i16 @llvm.bswap.i16(i16 %23) #3
  %25 = zext i16 %24 to i32
  store i32 %25, i32* %4, align 4, !tbaa !9
  %26 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @port_blacklist to i8*), i8* nonnull %8) #3
  %27 = icmp eq i8* %26, null
  br i1 %27, label %48, label %28

; <label>:28:                                     ; preds = %19
  %29 = bitcast i8* %26 to i32*
  %30 = load i32, i32* %29, align 4, !tbaa !9
  %31 = shl i32 1, %20
  %32 = and i32 %30, %31
  %33 = icmp eq i32 %32, 0
  br i1 %33, label %48, label %34

; <label>:34:                                     ; preds = %28
  %35 = icmp eq i32 %20, 0
  %36 = select i1 %35, %struct.bpf_map_def* @port_blacklist_drop_count_tcp, %struct.bpf_map_def* null
  %37 = icmp eq i32 %20, 1
  %38 = select i1 %37, %struct.bpf_map_def* @port_blacklist_drop_count_udp, %struct.bpf_map_def* %36
  %39 = icmp eq %struct.bpf_map_def* %38, null
  br i1 %39, label %48, label %40

; <label>:40:                                     ; preds = %34
  %41 = bitcast %struct.bpf_map_def* %38 to i8*
  %42 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* %41, i8* nonnull %8) #3
  %43 = bitcast i8* %42 to i32*
  %44 = icmp eq i8* %42, null
  br i1 %44, label %48, label %45

; <label>:45:                                     ; preds = %40
  %46 = load i32, i32* %43, align 4, !tbaa !9
  %47 = add i32 %46, 1
  store i32 %47, i32* %43, align 4, !tbaa !9
  br label %48

; <label>:48:                                     ; preds = %19, %28, %45, %34, %40, %3, %14, %9
  %49 = phi i32 [ 0, %9 ], [ 0, %14 ], [ 2, %3 ], [ 1, %40 ], [ 1, %34 ], [ 1, %45 ], [ 2, %28 ], [ 2, %19 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %8) #3
  ret i32 %49
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1

; Function Attrs: nounwind uwtable
define i32 @xdp_program(%struct.xdp_md* nocapture readonly) #0 section "xdp_prog" {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i64, align 8
  %5 = alloca i32, align 4
  %6 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %7 = load i32, i32* %6, align 4, !tbaa !2
  %8 = zext i32 %7 to i64
  %9 = inttoptr i64 %8 to i8*
  %10 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0
  %11 = load i32, i32* %10, align 4, !tbaa !10
  %12 = zext i32 %11 to i64
  %13 = inttoptr i64 %12 to %struct.ethhdr*
  %14 = getelementptr %struct.ethhdr, %struct.ethhdr* %13, i64 0, i32 0, i64 14
  %15 = icmp ugt i8* %14, %9
  br i1 %15, label %132, label %16

; <label>:16:                                     ; preds = %1
  %17 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %13, i64 0, i32 2
  %18 = load i16, i16* %17, align 1, !tbaa !11
  %19 = trunc i16 %18 to i8
  %20 = icmp ult i8 %19, 6
  br i1 %20, label %132, label %21, !prof !13

; <label>:21:                                     ; preds = %16
  switch i16 %18, label %29 [
    i16 129, label %22
    i16 -22392, label %22
  ]

; <label>:22:                                     ; preds = %21, %21
  %23 = getelementptr %struct.ethhdr, %struct.ethhdr* %13, i64 0, i32 0, i64 18
  %24 = icmp ugt i8* %23, %9
  br i1 %24, label %132, label %25

; <label>:25:                                     ; preds = %22
  %26 = getelementptr %struct.ethhdr, %struct.ethhdr* %13, i64 0, i32 0, i64 16
  %27 = bitcast i8* %26 to i16*
  %28 = load i16, i16* %27, align 2, !tbaa !14
  br label %29

; <label>:29:                                     ; preds = %25, %21
  %30 = phi i64 [ 14, %21 ], [ 18, %25 ]
  %31 = phi i16 [ %18, %21 ], [ %28, %25 ]
  switch i16 %31, label %41 [
    i16 129, label %32
    i16 -22392, label %32
  ]

; <label>:32:                                     ; preds = %29, %29
  %33 = add nuw nsw i64 %30, 4
  %34 = getelementptr %struct.ethhdr, %struct.ethhdr* %13, i64 0, i32 0, i64 %33
  %35 = icmp ugt i8* %34, %9
  br i1 %35, label %132, label %36

; <label>:36:                                     ; preds = %32
  %37 = getelementptr %struct.ethhdr, %struct.ethhdr* %13, i64 0, i32 0, i64 %30
  %38 = getelementptr inbounds i8, i8* %37, i64 2
  %39 = bitcast i8* %38 to i16*
  %40 = load i16, i16* %39, align 2, !tbaa !14
  br label %41

; <label>:41:                                     ; preds = %36, %29
  %42 = phi i64 [ %30, %29 ], [ %33, %36 ]
  %43 = phi i16 [ %31, %29 ], [ %40, %36 ]
  %44 = icmp eq i16 %43, 8
  br i1 %44, label %45, label %122

; <label>:45:                                     ; preds = %41
  %46 = inttoptr i64 %12 to i8*
  %47 = getelementptr i8, i8* %46, i64 %42
  %48 = bitcast i32* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %48) #3
  %49 = getelementptr inbounds i8, i8* %47, i64 20
  %50 = bitcast i8* %49 to %struct.iphdr*
  %51 = inttoptr i64 %8 to %struct.iphdr*
  %52 = icmp ugt %struct.iphdr* %50, %51
  br i1 %52, label %120, label %53

; <label>:53:                                     ; preds = %45
  %54 = getelementptr inbounds i8, i8* %47, i64 12
  %55 = bitcast i8* %54 to i32*
  %56 = load i32, i32* %55, align 4, !tbaa !16
  %57 = tail call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %56) #4, !srcloc !18
  store i32 %57, i32* %3, align 4, !tbaa !9
  %58 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @blacklist to i8*), i8* nonnull %48) #3
  %59 = bitcast i8* %58 to i64*
  %60 = icmp eq i8* %58, null
  br i1 %60, label %64, label %61

; <label>:61:                                     ; preds = %53
  %62 = load i64, i64* %59, align 8, !tbaa !19
  %63 = add i64 %62, 1
  store i64 %63, i64* %59, align 8, !tbaa !19
  br label %120

; <label>:64:                                     ; preds = %53
  %65 = bitcast i64* %4 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %65) #3
  store i64 0, i64* %4, align 8, !tbaa !19
  %66 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* nonnull %48, i8* nonnull %65, i64 0) #3
  %67 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* nonnull %48) #3
  %68 = bitcast i8* %67 to i64*
  %69 = icmp eq i8* %67, null
  br i1 %69, label %73, label %70

; <label>:70:                                     ; preds = %64
  %71 = load i64, i64* %68, align 8, !tbaa !19
  %72 = add i64 %71, 1
  store i64 %72, i64* %68, align 8, !tbaa !19
  br label %73

; <label>:73:                                     ; preds = %70, %64
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %65) #3
  %74 = getelementptr inbounds i8, i8* %47, i64 9
  %75 = load i8, i8* %74, align 1, !tbaa !21
  %76 = load i32, i32* %6, align 4, !tbaa !2
  %77 = zext i32 %76 to i64
  %78 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %78) #3
  switch i8 %75, label %118 [
    i8 17, label %79
    i8 6, label %84
  ]

; <label>:79:                                     ; preds = %73
  %80 = getelementptr inbounds i8, i8* %49, i64 8
  %81 = bitcast i8* %80 to %struct.udphdr*
  %82 = inttoptr i64 %77 to %struct.udphdr*
  %83 = icmp ugt %struct.udphdr* %81, %82
  br i1 %83, label %118, label %89

; <label>:84:                                     ; preds = %73
  %85 = getelementptr inbounds i8, i8* %49, i64 20
  %86 = bitcast i8* %85 to %struct.tcphdr*
  %87 = inttoptr i64 %77 to %struct.tcphdr*
  %88 = icmp ugt %struct.tcphdr* %86, %87
  br i1 %88, label %118, label %89

; <label>:89:                                     ; preds = %84, %79
  %90 = phi i32 [ 1, %79 ], [ 0, %84 ]
  %91 = getelementptr inbounds i8, i8* %49, i64 2
  %92 = bitcast i8* %91 to i16*
  %93 = load i16, i16* %92, align 2, !tbaa !7
  %94 = call i16 @llvm.bswap.i16(i16 %93) #3
  %95 = zext i16 %94 to i32
  store i32 %95, i32* %2, align 4, !tbaa !9
  %96 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @port_blacklist to i8*), i8* nonnull %78) #3
  %97 = icmp eq i8* %96, null
  br i1 %97, label %118, label %98

; <label>:98:                                     ; preds = %89
  %99 = bitcast i8* %96 to i32*
  %100 = load i32, i32* %99, align 4, !tbaa !9
  %101 = shl i32 1, %90
  %102 = and i32 %100, %101
  %103 = icmp eq i32 %102, 0
  br i1 %103, label %118, label %104

; <label>:104:                                    ; preds = %98
  %105 = icmp eq i32 %90, 0
  %106 = select i1 %105, %struct.bpf_map_def* @port_blacklist_drop_count_tcp, %struct.bpf_map_def* null
  %107 = icmp eq i32 %90, 1
  %108 = select i1 %107, %struct.bpf_map_def* @port_blacklist_drop_count_udp, %struct.bpf_map_def* %106
  %109 = icmp eq %struct.bpf_map_def* %108, null
  br i1 %109, label %118, label %110

; <label>:110:                                    ; preds = %104
  %111 = bitcast %struct.bpf_map_def* %108 to i8*
  %112 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* %111, i8* nonnull %78) #3
  %113 = bitcast i8* %112 to i32*
  %114 = icmp eq i8* %112, null
  br i1 %114, label %118, label %115

; <label>:115:                                    ; preds = %110
  %116 = load i32, i32* %113, align 4, !tbaa !9
  %117 = add i32 %116, 1
  store i32 %117, i32* %113, align 4, !tbaa !9
  br label %118

; <label>:118:                                    ; preds = %115, %110, %104, %98, %89, %84, %79, %73
  %119 = phi i32 [ 0, %79 ], [ 0, %84 ], [ 2, %73 ], [ 1, %110 ], [ 1, %104 ], [ 1, %115 ], [ 2, %98 ], [ 2, %89 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %78) #3
  br label %120

; <label>:120:                                    ; preds = %118, %61, %45
  %121 = phi i32 [ 1, %61 ], [ %119, %118 ], [ 0, %45 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %48) #3
  br label %122

; <label>:122:                                    ; preds = %120, %41
  %123 = phi i32 [ %121, %120 ], [ 2, %41 ]
  %124 = bitcast i32* %5 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %124)
  store i32 %123, i32* %5, align 4, !tbaa !9
  %125 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @verdict_cnt to i8*), i8* nonnull %124) #3
  %126 = bitcast i8* %125 to i64*
  %127 = icmp eq i8* %125, null
  br i1 %127, label %131, label %128

; <label>:128:                                    ; preds = %122
  %129 = load i64, i64* %126, align 8, !tbaa !19
  %130 = add i64 %129, 1
  store i64 %130, i64* %126, align 8, !tbaa !19
  br label %131

; <label>:131:                                    ; preds = %122, %128
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %124)
  br label %132

; <label>:132:                                    ; preds = %32, %22, %16, %1, %131
  %133 = phi i32 [ %123, %131 ], [ 2, %1 ], [ 2, %16 ], [ 2, %22 ], [ 2, %32 ]
  ret i32 %133
}

; Function Attrs: nounwind readnone speculatable
declare i16 @llvm.bswap.i16(i16) #2

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { nounwind readnone speculatable }
attributes #3 = { nounwind }
attributes #4 = { nounwind readnone }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
!2 = !{!3, !4, i64 4}
!3 = !{!"xdp_md", !4, i64 0, !4, i64 4, !4, i64 8, !4, i64 12, !4, i64 16}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = !{!8, !8, i64 0}
!8 = !{!"short", !5, i64 0}
!9 = !{!4, !4, i64 0}
!10 = !{!3, !4, i64 0}
!11 = !{!12, !8, i64 12}
!12 = !{!"ethhdr", !5, i64 0, !5, i64 6, !8, i64 12}
!13 = !{!"branch_weights", i32 1, i32 2000}
!14 = !{!15, !8, i64 2}
!15 = !{!"vlan_hdr", !8, i64 0, !8, i64 2}
!16 = !{!17, !4, i64 12}
!17 = !{!"iphdr", !5, i64 0, !5, i64 0, !5, i64 1, !8, i64 2, !8, i64 4, !8, i64 6, !5, i64 8, !5, i64 9, !8, i64 10, !4, i64 12, !4, i64 16}
!18 = !{i32 535793}
!19 = !{!20, !20, i64 0}
!20 = !{!"long long", !5, i64 0}
!21 = !{!17, !5, i64 9}
