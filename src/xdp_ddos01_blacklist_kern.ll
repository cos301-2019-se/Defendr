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
@ip_logs = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 100000, i32 0, i32 0, i32 0 }, section "maps", align 4
@verdict_cnt = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 4, i32 0, i32 0, i32 0 }, section "maps", align 4
@port_blacklist = global %struct.bpf_map_def { i32 6, i32 4, i32 4, i32 65536, i32 0, i32 0, i32 0 }, section "maps", align 4
@port_blacklist_drop_count_tcp = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 65536, i32 0, i32 0, i32 0 }, section "maps", align 4
@port_blacklist_drop_count_udp = global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 65536, i32 0, i32 0, i32 0 }, section "maps", align 4
@_license = global [4 x i8] c"GPL\00", section "license", align 1
@llvm.used = appending global [9 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @blacklist to i8*), i8* bitcast (%struct.bpf_map_def* @ip_logs to i8*), i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* bitcast (%struct.bpf_map_def* @port_blacklist to i8*), i8* bitcast (%struct.bpf_map_def* @port_blacklist_drop_count_tcp to i8*), i8* bitcast (%struct.bpf_map_def* @port_blacklist_drop_count_udp to i8*), i8* bitcast (%struct.bpf_map_def* @verdict_cnt to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_program to i8*)], section "llvm.metadata"

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
  %5 = alloca i64, align 8
  %6 = alloca i32, align 4
  %7 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %8 = load i32, i32* %7, align 4, !tbaa !2
  %9 = zext i32 %8 to i64
  %10 = inttoptr i64 %9 to i8*
  %11 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0
  %12 = load i32, i32* %11, align 4, !tbaa !10
  %13 = zext i32 %12 to i64
  %14 = inttoptr i64 %13 to %struct.ethhdr*
  %15 = getelementptr %struct.ethhdr, %struct.ethhdr* %14, i64 0, i32 0, i64 14
  %16 = icmp ugt i8* %15, %10
  br i1 %16, label %137, label %17

; <label>:17:                                     ; preds = %1
  %18 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %14, i64 0, i32 2
  %19 = load i16, i16* %18, align 1, !tbaa !11
  %20 = trunc i16 %19 to i8
  %21 = icmp ult i8 %20, 6
  br i1 %21, label %137, label %22, !prof !13

; <label>:22:                                     ; preds = %17
  switch i16 %19, label %30 [
    i16 129, label %23
    i16 -22392, label %23
  ]

; <label>:23:                                     ; preds = %22, %22
  %24 = getelementptr %struct.ethhdr, %struct.ethhdr* %14, i64 0, i32 0, i64 18
  %25 = icmp ugt i8* %24, %10
  br i1 %25, label %137, label %26

; <label>:26:                                     ; preds = %23
  %27 = getelementptr %struct.ethhdr, %struct.ethhdr* %14, i64 0, i32 0, i64 16
  %28 = bitcast i8* %27 to i16*
  %29 = load i16, i16* %28, align 2, !tbaa !14
  br label %30

; <label>:30:                                     ; preds = %26, %22
  %31 = phi i64 [ 14, %22 ], [ 18, %26 ]
  %32 = phi i16 [ %19, %22 ], [ %29, %26 ]
  switch i16 %32, label %42 [
    i16 129, label %33
    i16 -22392, label %33
  ]

; <label>:33:                                     ; preds = %30, %30
  %34 = add nuw nsw i64 %31, 4
  %35 = getelementptr %struct.ethhdr, %struct.ethhdr* %14, i64 0, i32 0, i64 %34
  %36 = icmp ugt i8* %35, %10
  br i1 %36, label %137, label %37

; <label>:37:                                     ; preds = %33
  %38 = getelementptr %struct.ethhdr, %struct.ethhdr* %14, i64 0, i32 0, i64 %31
  %39 = getelementptr inbounds i8, i8* %38, i64 2
  %40 = bitcast i8* %39 to i16*
  %41 = load i16, i16* %40, align 2, !tbaa !14
  br label %42

; <label>:42:                                     ; preds = %37, %30
  %43 = phi i64 [ %31, %30 ], [ %34, %37 ]
  %44 = phi i16 [ %32, %30 ], [ %41, %37 ]
  %45 = icmp eq i16 %44, 8
  br i1 %45, label %46, label %127

; <label>:46:                                     ; preds = %42
  %47 = inttoptr i64 %13 to i8*
  %48 = getelementptr i8, i8* %47, i64 %43
  %49 = bitcast i32* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %49) #3
  %50 = getelementptr inbounds i8, i8* %48, i64 20
  %51 = bitcast i8* %50 to %struct.iphdr*
  %52 = inttoptr i64 %9 to %struct.iphdr*
  %53 = icmp ugt %struct.iphdr* %51, %52
  br i1 %53, label %125, label %54

; <label>:54:                                     ; preds = %46
  %55 = getelementptr inbounds i8, i8* %48, i64 12
  %56 = bitcast i8* %55 to i32*
  %57 = load i32, i32* %56, align 4, !tbaa !16
  %58 = tail call i32 asm "bswapl $0", "=r,0,~{dirflag},~{fpsr},~{flags}"(i32 %57) #4, !srcloc !18
  store i32 %58, i32* %3, align 4, !tbaa !9
  %59 = bitcast i64* %4 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %59) #3
  store i64 0, i64* %4, align 8, !tbaa !19
  %60 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @blacklist to i8*), i8* nonnull %49) #3
  %61 = bitcast i8* %60 to i64*
  %62 = icmp eq i8* %60, null
  br i1 %62, label %66, label %63

; <label>:63:                                     ; preds = %54
  %64 = load i64, i64* %61, align 8, !tbaa !19
  %65 = add i64 %64, 1
  store i64 %65, i64* %61, align 8, !tbaa !19
  store i64 1, i64* %4, align 8, !tbaa !19
  br label %123

; <label>:66:                                     ; preds = %54
  %67 = bitcast i64* %5 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %67) #3
  store i64 0, i64* %5, align 8, !tbaa !19
  %68 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* nonnull %49, i8* nonnull %67, i64 0) #3
  %69 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @ip_watchlist to i8*), i8* nonnull %49) #3
  %70 = bitcast i8* %69 to i64*
  %71 = icmp eq i8* %69, null
  br i1 %71, label %75, label %72

; <label>:72:                                     ; preds = %66
  %73 = load i64, i64* %70, align 8, !tbaa !19
  %74 = add i64 %73, 1
  store i64 %74, i64* %70, align 8, !tbaa !19
  store i64 0, i64* %4, align 8, !tbaa !19
  br label %75

; <label>:75:                                     ; preds = %72, %66
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %67) #3
  %76 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @ip_logs to i8*), i8* nonnull %49, i8* nonnull %59, i64 0) #3
  %77 = getelementptr inbounds i8, i8* %48, i64 9
  %78 = load i8, i8* %77, align 1, !tbaa !21
  %79 = load i32, i32* %7, align 4, !tbaa !2
  %80 = zext i32 %79 to i64
  %81 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %81) #3
  switch i8 %78, label %121 [
    i8 17, label %82
    i8 6, label %87
  ]

; <label>:82:                                     ; preds = %75
  %83 = getelementptr inbounds i8, i8* %50, i64 8
  %84 = bitcast i8* %83 to %struct.udphdr*
  %85 = inttoptr i64 %80 to %struct.udphdr*
  %86 = icmp ugt %struct.udphdr* %84, %85
  br i1 %86, label %121, label %92

; <label>:87:                                     ; preds = %75
  %88 = getelementptr inbounds i8, i8* %50, i64 20
  %89 = bitcast i8* %88 to %struct.tcphdr*
  %90 = inttoptr i64 %80 to %struct.tcphdr*
  %91 = icmp ugt %struct.tcphdr* %89, %90
  br i1 %91, label %121, label %92

; <label>:92:                                     ; preds = %87, %82
  %93 = phi i32 [ 1, %82 ], [ 0, %87 ]
  %94 = getelementptr inbounds i8, i8* %50, i64 2
  %95 = bitcast i8* %94 to i16*
  %96 = load i16, i16* %95, align 2, !tbaa !7
  %97 = call i16 @llvm.bswap.i16(i16 %96) #3
  %98 = zext i16 %97 to i32
  store i32 %98, i32* %2, align 4, !tbaa !9
  %99 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @port_blacklist to i8*), i8* nonnull %81) #3
  %100 = icmp eq i8* %99, null
  br i1 %100, label %121, label %101

; <label>:101:                                    ; preds = %92
  %102 = bitcast i8* %99 to i32*
  %103 = load i32, i32* %102, align 4, !tbaa !9
  %104 = shl i32 1, %93
  %105 = and i32 %103, %104
  %106 = icmp eq i32 %105, 0
  br i1 %106, label %121, label %107

; <label>:107:                                    ; preds = %101
  %108 = icmp eq i32 %93, 0
  %109 = select i1 %108, %struct.bpf_map_def* @port_blacklist_drop_count_tcp, %struct.bpf_map_def* null
  %110 = icmp eq i32 %93, 1
  %111 = select i1 %110, %struct.bpf_map_def* @port_blacklist_drop_count_udp, %struct.bpf_map_def* %109
  %112 = icmp eq %struct.bpf_map_def* %111, null
  br i1 %112, label %121, label %113

; <label>:113:                                    ; preds = %107
  %114 = bitcast %struct.bpf_map_def* %111 to i8*
  %115 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* %114, i8* nonnull %81) #3
  %116 = bitcast i8* %115 to i32*
  %117 = icmp eq i8* %115, null
  br i1 %117, label %121, label %118

; <label>:118:                                    ; preds = %113
  %119 = load i32, i32* %116, align 4, !tbaa !9
  %120 = add i32 %119, 1
  store i32 %120, i32* %116, align 4, !tbaa !9
  br label %121

; <label>:121:                                    ; preds = %118, %113, %107, %101, %92, %87, %82, %75
  %122 = phi i32 [ 0, %82 ], [ 0, %87 ], [ 2, %75 ], [ 1, %113 ], [ 1, %107 ], [ 1, %118 ], [ 2, %101 ], [ 2, %92 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %81) #3
  br label %123

; <label>:123:                                    ; preds = %121, %63
  %124 = phi i32 [ 1, %63 ], [ %122, %121 ]
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %59) #3
  br label %125

; <label>:125:                                    ; preds = %123, %46
  %126 = phi i32 [ %124, %123 ], [ 0, %46 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %49) #3
  br label %127

; <label>:127:                                    ; preds = %125, %42
  %128 = phi i32 [ %126, %125 ], [ 2, %42 ]
  %129 = bitcast i32* %6 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %129)
  store i32 %128, i32* %6, align 4, !tbaa !9
  %130 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @verdict_cnt to i8*), i8* nonnull %129) #3
  %131 = bitcast i8* %130 to i64*
  %132 = icmp eq i8* %130, null
  br i1 %132, label %136, label %133

; <label>:133:                                    ; preds = %127
  %134 = load i64, i64* %131, align 8, !tbaa !19
  %135 = add i64 %134, 1
  store i64 %135, i64* %131, align 8, !tbaa !19
  br label %136

; <label>:136:                                    ; preds = %127, %133
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %129)
  br label %137

; <label>:137:                                    ; preds = %33, %23, %17, %1, %136
  %138 = phi i32 [ %128, %136 ], [ 2, %1 ], [ 2, %17 ], [ 2, %23 ], [ 2, %33 ]
  ret i32 %138
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
!18 = !{i32 536248}
!19 = !{!20, !20, i64 0}
!20 = !{!"long long", !5, i64 0}
!21 = !{!17, !5, i64 9}
