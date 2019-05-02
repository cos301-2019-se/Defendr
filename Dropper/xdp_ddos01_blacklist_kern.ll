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
@verdict_cnt = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 4, i32 0, i32 0, i32 0 }, section "maps", align 4
@port_blacklist = global %struct.bpf_map_def { i32 6, i32 4, i32 4, i32 65536, i32 0, i32 0, i32 0 }, section "maps", align 4
@port_blacklist_drop_count_tcp = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 65536, i32 0, i32 0, i32 0 }, section "maps", align 4
@port_blacklist_drop_count_udp = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 65536, i32 0, i32 0, i32 0 }, section "maps", align 4
@_license = global [4 x i8] c"GPL\00", section "license", align 1
@llvm.used = appending global [7 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @blacklist to i8*), i8* bitcast (%struct.bpf_map_def* @port_blacklist to i8*), i8* bitcast (%struct.bpf_map_def* @port_blacklist_drop_count_tcp to i8*), i8* bitcast (%struct.bpf_map_def* @port_blacklist_drop_count_udp to i8*), i8* bitcast (%struct.bpf_map_def* @verdict_cnt to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_program to i8*)], section "llvm.metadata"

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
  %4 = alloca i32, align 4
  %5 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %6 = load i32, i32* %5, align 4, !tbaa !2
  %7 = zext i32 %6 to i64
  %8 = inttoptr i64 %7 to i8*
  %9 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0
  %10 = load i32, i32* %9, align 4, !tbaa !10
  %11 = zext i32 %10 to i64
  %12 = inttoptr i64 %11 to %struct.ethhdr*
  %13 = getelementptr %struct.ethhdr, %struct.ethhdr* %12, i64 0, i32 0, i64 14
  %14 = icmp ugt i8* %13, %8
  br i1 %14, label %122, label %15

; <label>:15:                                     ; preds = %1
  %16 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %12, i64 0, i32 2
  %17 = load i16, i16* %16, align 1, !tbaa !11
  %18 = trunc i16 %17 to i8
  %19 = icmp ult i8 %18, 6
  br i1 %19, label %122, label %20, !prof !13

; <label>:20:                                     ; preds = %15
  switch i16 %17, label %28 [
    i16 129, label %21
    i16 -22392, label %21
  ]

; <label>:21:                                     ; preds = %20, %20
  %22 = getelementptr %struct.ethhdr, %struct.ethhdr* %12, i64 0, i32 0, i64 18
  %23 = icmp ugt i8* %22, %8
  br i1 %23, label %122, label %24

; <label>:24:                                     ; preds = %21
  %25 = getelementptr %struct.ethhdr, %struct.ethhdr* %12, i64 0, i32 0, i64 16
  %26 = bitcast i8* %25 to i16*
  %27 = load i16, i16* %26, align 2, !tbaa !14
  br label %28

; <label>:28:                                     ; preds = %24, %20
  %29 = phi i64 [ 14, %20 ], [ 18, %24 ]
  %30 = phi i16 [ %17, %20 ], [ %27, %24 ]
  switch i16 %30, label %40 [
    i16 129, label %31
    i16 -22392, label %31
  ]

; <label>:31:                                     ; preds = %28, %28
  %32 = add nuw nsw i64 %29, 4
  %33 = getelementptr %struct.ethhdr, %struct.ethhdr* %12, i64 0, i32 0, i64 %32
  %34 = icmp ugt i8* %33, %8
  br i1 %34, label %122, label %35

; <label>:35:                                     ; preds = %31
  %36 = getelementptr %struct.ethhdr, %struct.ethhdr* %12, i64 0, i32 0, i64 %29
  %37 = getelementptr inbounds i8, i8* %36, i64 2
  %38 = bitcast i8* %37 to i16*
  %39 = load i16, i16* %38, align 2, !tbaa !14
  br label %40

; <label>:40:                                     ; preds = %35, %28
  %41 = phi i64 [ %29, %28 ], [ %32, %35 ]
  %42 = phi i16 [ %30, %28 ], [ %39, %35 ]
  %43 = icmp eq i16 %42, 8
  br i1 %43, label %44, label %112

; <label>:44:                                     ; preds = %40
  %45 = inttoptr i64 %11 to i8*
  %46 = getelementptr i8, i8* %45, i64 %41
  %47 = bitcast i32* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %47) #3
  %48 = getelementptr inbounds i8, i8* %46, i64 20
  %49 = bitcast i8* %48 to %struct.iphdr*
  %50 = inttoptr i64 %7 to %struct.iphdr*
  %51 = icmp ugt %struct.iphdr* %49, %50
  br i1 %51, label %110, label %52

; <label>:52:                                     ; preds = %44
  %53 = getelementptr inbounds i8, i8* %46, i64 12
  %54 = bitcast i8* %53 to i32*
  %55 = load i32, i32* %54, align 4, !tbaa !16
  %56 = tail call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %55) #4, !srcloc !18
  store i32 %56, i32* %3, align 4, !tbaa !9
  %57 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @blacklist to i8*), i8* nonnull %47) #3
  %58 = bitcast i8* %57 to i64*
  %59 = icmp eq i8* %57, null
  br i1 %59, label %63, label %60

; <label>:60:                                     ; preds = %52
  %61 = load i64, i64* %58, align 8, !tbaa !19
  %62 = add i64 %61, 1
  store i64 %62, i64* %58, align 8, !tbaa !19
  br label %110

; <label>:63:                                     ; preds = %52
  %64 = getelementptr inbounds i8, i8* %46, i64 9
  %65 = load i8, i8* %64, align 1, !tbaa !21
  %66 = load i32, i32* %5, align 4, !tbaa !2
  %67 = zext i32 %66 to i64
  %68 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %68) #3
  switch i8 %65, label %108 [
    i8 17, label %69
    i8 6, label %74
  ]

; <label>:69:                                     ; preds = %63
  %70 = getelementptr inbounds i8, i8* %48, i64 8
  %71 = bitcast i8* %70 to %struct.udphdr*
  %72 = inttoptr i64 %67 to %struct.udphdr*
  %73 = icmp ugt %struct.udphdr* %71, %72
  br i1 %73, label %108, label %79

; <label>:74:                                     ; preds = %63
  %75 = getelementptr inbounds i8, i8* %48, i64 20
  %76 = bitcast i8* %75 to %struct.tcphdr*
  %77 = inttoptr i64 %67 to %struct.tcphdr*
  %78 = icmp ugt %struct.tcphdr* %76, %77
  br i1 %78, label %108, label %79

; <label>:79:                                     ; preds = %74, %69
  %80 = phi i32 [ 1, %69 ], [ 0, %74 ]
  %81 = getelementptr inbounds i8, i8* %48, i64 2
  %82 = bitcast i8* %81 to i16*
  %83 = load i16, i16* %82, align 2, !tbaa !7
  %84 = call i16 @llvm.bswap.i16(i16 %83) #3
  %85 = zext i16 %84 to i32
  store i32 %85, i32* %2, align 4, !tbaa !9
  %86 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @port_blacklist to i8*), i8* nonnull %68) #3
  %87 = icmp eq i8* %86, null
  br i1 %87, label %108, label %88

; <label>:88:                                     ; preds = %79
  %89 = bitcast i8* %86 to i32*
  %90 = load i32, i32* %89, align 4, !tbaa !9
  %91 = shl i32 1, %80
  %92 = and i32 %90, %91
  %93 = icmp eq i32 %92, 0
  br i1 %93, label %108, label %94

; <label>:94:                                     ; preds = %88
  %95 = icmp eq i32 %80, 0
  %96 = select i1 %95, %struct.bpf_map_def* @port_blacklist_drop_count_tcp, %struct.bpf_map_def* null
  %97 = icmp eq i32 %80, 1
  %98 = select i1 %97, %struct.bpf_map_def* @port_blacklist_drop_count_udp, %struct.bpf_map_def* %96
  %99 = icmp eq %struct.bpf_map_def* %98, null
  br i1 %99, label %108, label %100

; <label>:100:                                    ; preds = %94
  %101 = bitcast %struct.bpf_map_def* %98 to i8*
  %102 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* %101, i8* nonnull %68) #3
  %103 = bitcast i8* %102 to i32*
  %104 = icmp eq i8* %102, null
  br i1 %104, label %108, label %105

; <label>:105:                                    ; preds = %100
  %106 = load i32, i32* %103, align 4, !tbaa !9
  %107 = add i32 %106, 1
  store i32 %107, i32* %103, align 4, !tbaa !9
  br label %108

; <label>:108:                                    ; preds = %105, %100, %94, %88, %79, %74, %69, %63
  %109 = phi i32 [ 0, %69 ], [ 0, %74 ], [ 2, %63 ], [ 1, %100 ], [ 1, %94 ], [ 1, %105 ], [ 2, %88 ], [ 2, %79 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %68) #3
  br label %110

; <label>:110:                                    ; preds = %108, %60, %44
  %111 = phi i32 [ 1, %60 ], [ %109, %108 ], [ 0, %44 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %47) #3
  br label %112

; <label>:112:                                    ; preds = %110, %40
  %113 = phi i32 [ %111, %110 ], [ 2, %40 ]
  %114 = bitcast i32* %4 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %114)
  store i32 %113, i32* %4, align 4, !tbaa !9
  %115 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @verdict_cnt to i8*), i8* nonnull %114) #3
  %116 = bitcast i8* %115 to i64*
  %117 = icmp eq i8* %115, null
  br i1 %117, label %121, label %118

; <label>:118:                                    ; preds = %112
  %119 = load i64, i64* %116, align 8, !tbaa !19
  %120 = add i64 %119, 1
  store i64 %120, i64* %116, align 8, !tbaa !19
  br label %121

; <label>:121:                                    ; preds = %112, %118
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %114)
  br label %122

; <label>:122:                                    ; preds = %31, %21, %15, %1, %121
  %123 = phi i32 [ %113, %121 ], [ 2, %1 ], [ 2, %15 ], [ 2, %21 ], [ 2, %31 ]
  ret i32 %123
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
!18 = !{i32 532646}
!19 = !{!20, !20, i64 0}
!20 = !{!"long long", !5, i64 0}
!21 = !{!17, !5, i64 9}
