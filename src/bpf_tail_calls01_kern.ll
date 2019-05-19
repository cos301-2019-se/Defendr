; ModuleID = 'bpf_tail_calls01_kern.c'
source_filename = "bpf_tail_calls01_kern.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }

@_license = global [4 x i8] c"GPL\00", section "license", align 1
@jmp_table1 = global %struct.bpf_map_def { i32 3, i32 4, i32 4, i32 100, i32 0, i32 0, i32 0 }, section "maps", align 4
@jmp_table2 = global %struct.bpf_map_def { i32 3, i32 4, i32 4, i32 1000, i32 0, i32 0, i32 0 }, section "maps", align 4
@jmp_table3 = global %struct.bpf_map_def { i32 3, i32 4, i32 4, i32 100, i32 0, i32 0, i32 0 }, section "maps", align 4
@xdp_prog.____fmt = private unnamed_addr constant [27 x i8] c"XDP: Killroy was here! %d\0A\00", align 16
@xdp_prog.____fmt.1 = private unnamed_addr constant [51 x i8] c"XDP: jmp_table empty, reached fall-through action\0A\00", align 16
@xdp_tail_call_1.____fmt = private unnamed_addr constant [29 x i8] c"XDP: tail call (xdp_1) id=1\0A\00", align 16
@xdp_tail_call_2.____fmt = private unnamed_addr constant [37 x i8] c"XDP: tail call (xdp_5) id=5 hash=%u\0A\00", align 16
@xdp_some_tail_call_3.____fmt = private unnamed_addr constant [40 x i8] c"XDP: tail call 'xdp_unrelated' hash=%u\0A\00", align 16
@llvm.used = appending global [8 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @jmp_table1 to i8*), i8* bitcast (%struct.bpf_map_def* @jmp_table2 to i8*), i8* bitcast (%struct.bpf_map_def* @jmp_table3 to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_prog to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_some_tail_call_3 to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_tail_call_1 to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_tail_call_2 to i8*)], section "llvm.metadata"

; Function Attrs: nounwind uwtable
define i32 @xdp_prog(%struct.xdp_md*) #0 section "xdp" {
  %2 = alloca [27 x i8], align 16
  %3 = alloca [51 x i8], align 16
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %5 = load i32, i32* %4, align 4, !tbaa !2
  %6 = zext i32 %5 to i64
  %7 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0
  %8 = load i32, i32* %7, align 4, !tbaa !7
  %9 = zext i32 %8 to i64
  %10 = inttoptr i64 %9 to %struct.ethhdr*
  %11 = getelementptr inbounds [27 x i8], [27 x i8]* %2, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 27, i8* nonnull %11) #2
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %11, i8* getelementptr inbounds ([27 x i8], [27 x i8]* @xdp_prog.____fmt, i64 0, i64 0), i64 27, i32 16, i1 false)
  %12 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %11, i32 27, i32 42) #2
  call void @llvm.lifetime.end.p0i8(i64 27, i8* nonnull %11) #2
  %13 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %10, i64 1
  %14 = inttoptr i64 %6 to %struct.ethhdr*
  %15 = icmp ugt %struct.ethhdr* %13, %14
  br i1 %15, label %20, label %16

; <label>:16:                                     ; preds = %1
  %17 = bitcast %struct.xdp_md* %0 to i8*
  call void inttoptr (i64 12 to void (i8*, i8*, i32)*)(i8* %17, i8* bitcast (%struct.bpf_map_def* @jmp_table1 to i8*), i32 1) #2
  %18 = getelementptr inbounds [51 x i8], [51 x i8]* %3, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 51, i8* nonnull %18) #2
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %18, i8* getelementptr inbounds ([51 x i8], [51 x i8]* @xdp_prog.____fmt.1, i64 0, i64 0), i64 51, i32 16, i1 false)
  %19 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %18, i32 51) #2
  call void @llvm.lifetime.end.p0i8(i64 51, i8* nonnull %18) #2
  br label %20

; <label>:20:                                     ; preds = %1, %16
  %21 = phi i32 [ 2, %16 ], [ 0, %1 ]
  ret i32 %21
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i32, i1) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1

; Function Attrs: nounwind uwtable
define i32 @xdp_tail_call_1(%struct.xdp_md*) #0 section "xdp_1" {
  %2 = alloca [29 x i8], align 16
  %3 = getelementptr inbounds [29 x i8], [29 x i8]* %2, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 29, i8* nonnull %3) #2
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %3, i8* getelementptr inbounds ([29 x i8], [29 x i8]* @xdp_tail_call_1.____fmt, i64 0, i64 0), i64 29, i32 16, i1 false)
  %4 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %3, i32 29) #2
  call void @llvm.lifetime.end.p0i8(i64 29, i8* nonnull %3) #2
  %5 = bitcast %struct.xdp_md* %0 to i8*
  call void inttoptr (i64 12 to void (i8*, i8*, i32)*)(i8* %5, i8* bitcast (%struct.bpf_map_def* @jmp_table1 to i8*), i32 5) #2
  ret i32 2
}

; Function Attrs: nounwind uwtable
define i32 @xdp_tail_call_2(%struct.xdp_md* nocapture readnone) #0 section "xdp_5" {
  %2 = alloca i32, align 4
  %3 = alloca [37 x i8], align 16
  %4 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %4)
  store volatile i32 0, i32* %2, align 4
  %5 = getelementptr inbounds [37 x i8], [37 x i8]* %3, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 37, i8* nonnull %5) #2
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %5, i8* getelementptr inbounds ([37 x i8], [37 x i8]* @xdp_tail_call_2.____fmt, i64 0, i64 0), i64 37, i32 16, i1 false)
  %6 = load volatile i32, i32* %2, align 4
  %7 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %5, i32 37, i32 %6) #2
  call void @llvm.lifetime.end.p0i8(i64 37, i8* nonnull %5) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %4)
  ret i32 2
}

; Function Attrs: nounwind uwtable
define i32 @xdp_some_tail_call_3(%struct.xdp_md*) #0 section "xdp_unrelated" {
  %2 = alloca i32, align 4
  %3 = alloca [40 x i8], align 16
  %4 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %4)
  store volatile i32 0, i32* %2, align 4
  %5 = getelementptr inbounds [40 x i8], [40 x i8]* %3, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 40, i8* nonnull %5) #2
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %5, i8* getelementptr inbounds ([40 x i8], [40 x i8]* @xdp_some_tail_call_3.____fmt, i64 0, i64 0), i64 40, i32 16, i1 false)
  %6 = load volatile i32, i32* %2, align 4
  %7 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %5, i32 40, i32 %6) #2
  call void @llvm.lifetime.end.p0i8(i64 40, i8* nonnull %5) #2
  %8 = bitcast %struct.xdp_md* %0 to i8*
  call void inttoptr (i64 12 to void (i8*, i8*, i32)*)(i8* %8, i8* bitcast (%struct.bpf_map_def* @jmp_table3 to i8*), i32 0) #2
  call void inttoptr (i64 12 to void (i8*, i8*, i32)*)(i8* %8, i8* bitcast (%struct.bpf_map_def* @jmp_table2 to i8*), i32 0) #2
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %4)
  ret i32 2
}

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
