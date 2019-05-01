; ModuleID = 'xdp_prog_kern.c'
source_filename = "xdp_prog_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.hdr_cursor = type { i8* }

@xdp_stats_map = global %struct.bpf_map_def { i32 6, i32 4, i32 16, i32 5, i32 0, i32 0 }, section "maps", align 4, !dbg !0
@_license = global [4 x i8] c"GPL\00", section "license", align 1, !dbg !17
@llvm.used = appending global [3 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_parser_func to i8*), i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define i32 @xdp_parser_func(%struct.xdp_md* nocapture readonly) #0 section "xdp_packet_parser" !dbg !43 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !58, metadata !DIExpression()), !dbg !83
  %3 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !84
  %4 = load i32, i32* %3, align 4, !dbg !84, !tbaa !85
  %5 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !90
  %6 = load i32, i32* %5, align 4, !dbg !90, !tbaa !91
  call void @llvm.dbg.value(metadata i32 2, metadata !77, metadata !DIExpression()), !dbg !92
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !61, metadata !DIExpression()), !dbg !93
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !78, metadata !DIExpression()), !dbg !94
  call void @llvm.dbg.value(metadata i32 2, metadata !77, metadata !DIExpression()), !dbg !92
  %7 = bitcast i32* %2 to i8*, !dbg !95
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %7), !dbg !95
  call void @llvm.dbg.value(metadata i32 2, metadata !101, metadata !DIExpression()) #3, !dbg !95
  store i32 2, i32* %2, align 4, !tbaa !115
  %8 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* nonnull %7) #3, !dbg !116
  call void @llvm.dbg.value(metadata i8* %8, metadata !104, metadata !DIExpression()) #3, !dbg !117
  %9 = icmp eq i8* %8, null, !dbg !118
  br i1 %9, label %22, label %10, !dbg !120

; <label>:10:                                     ; preds = %1
  %11 = zext i32 %6 to i64, !dbg !121
  %12 = zext i32 %4 to i64, !dbg !122
  %13 = sub nsw i64 %12, %11, !dbg !123
  call void @llvm.dbg.value(metadata i64 %13, metadata !113, metadata !DIExpression()) #3, !dbg !124
  %14 = bitcast i8* %8 to i64*, !dbg !125
  %15 = load i64, i64* %14, align 8, !dbg !126, !tbaa !127
  %16 = add i64 %15, 1, !dbg !126
  store i64 %16, i64* %14, align 8, !dbg !126, !tbaa !127
  %17 = getelementptr inbounds i8, i8* %8, i64 8, !dbg !130
  %18 = bitcast i8* %17 to i64*, !dbg !130
  %19 = load i64, i64* %18, align 8, !dbg !131, !tbaa !132
  %20 = add i64 %13, %19, !dbg !131
  store i64 %20, i64* %18, align 8, !dbg !131, !tbaa !132
  %21 = load i32, i32* %2, align 4, !dbg !133, !tbaa !115
  call void @llvm.dbg.value(metadata i32 %21, metadata !101, metadata !DIExpression()) #3, !dbg !95
  br label %22

; <label>:22:                                     ; preds = %1, %10
  %23 = phi i32 [ %21, %10 ], [ 0, %1 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %7), !dbg !134
  ret i32 %23, !dbg !135
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { nounwind readnone speculatable }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!39, !40, !41}
!llvm.ident = !{!42}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xdp_stats_map", scope: !2, file: !29, line: 16, type: !30, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 6.0.1 (tags/RELEASE_601/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !13, globals: !16)
!3 = !DIFile(filename: "xdp_prog_kern.c", directory: "/home/darknites/Documents/Dropper/src")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2629, size: 32, elements: !7)
!6 = !DIFile(filename: "/usr/include/linux/bpf.h", directory: "/home/darknites/Documents/Dropper/src")
!7 = !{!8, !9, !10, !11, !12}
!8 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!9 = !DIEnumerator(name: "XDP_DROP", value: 1)
!10 = !DIEnumerator(name: "XDP_PASS", value: 2)
!11 = !DIEnumerator(name: "XDP_TX", value: 3)
!12 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!13 = !{!14, !15}
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!15 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!16 = !{!0, !17, !23}
!17 = !DIGlobalVariableExpression(var: !18, expr: !DIExpression())
!18 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 85, type: !19, isLocal: false, isDefinition: true)
!19 = !DICompositeType(tag: DW_TAG_array_type, baseType: !20, size: 32, elements: !21)
!20 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!21 = !{!22}
!22 = !DISubrange(count: 4)
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !25, line: 13, type: !26, isLocal: true, isDefinition: true)
!25 = !DIFile(filename: "../headers/bpf_helpers.h", directory: "/home/darknites/Documents/Dropper/src")
!26 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !27, size: 64)
!27 = !DISubroutineType(types: !28)
!28 = !{!14, !14, !14}
!29 = !DIFile(filename: "./../common/xdp_stats_kern.h", directory: "/home/darknites/Documents/Dropper/src")
!30 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !25, line: 82, size: 192, elements: !31)
!31 = !{!32, !34, !35, !36, !37, !38}
!32 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !30, file: !25, line: 83, baseType: !33, size: 32)
!33 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !30, file: !25, line: 84, baseType: !33, size: 32, offset: 32)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !30, file: !25, line: 85, baseType: !33, size: 32, offset: 64)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !30, file: !25, line: 86, baseType: !33, size: 32, offset: 96)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !30, file: !25, line: 87, baseType: !33, size: 32, offset: 128)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "inner_map_idx", scope: !30, file: !25, line: 88, baseType: !33, size: 32, offset: 160)
!39 = !{i32 2, !"Dwarf Version", i32 4}
!40 = !{i32 2, !"Debug Info Version", i32 3}
!41 = !{i32 1, !"wchar_size", i32 4}
!42 = !{!"clang version 6.0.1 (tags/RELEASE_601/final)"}
!43 = distinct !DISubprogram(name: "xdp_parser_func", scope: !3, file: !3, line: 63, type: !44, isLocal: false, isDefinition: true, scopeLine: 64, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !57)
!44 = !DISubroutineType(types: !45)
!45 = !{!46, !47}
!46 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!47 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !48, size: 64)
!48 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2640, size: 160, elements: !49)
!49 = !{!50, !53, !54, !55, !56}
!50 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !48, file: !6, line: 2641, baseType: !51, size: 32)
!51 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !52, line: 27, baseType: !33)
!52 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "/home/darknites/Documents/Dropper/src")
!53 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !48, file: !6, line: 2642, baseType: !51, size: 32, offset: 32)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !48, file: !6, line: 2643, baseType: !51, size: 32, offset: 64)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !48, file: !6, line: 2645, baseType: !51, size: 32, offset: 96)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !48, file: !6, line: 2646, baseType: !51, size: 32, offset: 128)
!57 = !{!58, !59, !60, !61, !77, !78, !82}
!58 = !DILocalVariable(name: "ctx", arg: 1, scope: !43, file: !3, line: 63, type: !47)
!59 = !DILocalVariable(name: "data_end", scope: !43, file: !3, line: 65, type: !14)
!60 = !DILocalVariable(name: "data", scope: !43, file: !3, line: 66, type: !14)
!61 = !DILocalVariable(name: "eth", scope: !43, file: !3, line: 67, type: !62)
!62 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !63, size: 64)
!63 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !64, line: 161, size: 112, elements: !65)
!64 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "/home/darknites/Documents/Dropper/src")
!65 = !{!66, !71, !72}
!66 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !63, file: !64, line: 162, baseType: !67, size: 48)
!67 = !DICompositeType(tag: DW_TAG_array_type, baseType: !68, size: 48, elements: !69)
!68 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!69 = !{!70}
!70 = !DISubrange(count: 6)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !63, file: !64, line: 163, baseType: !67, size: 48, offset: 48)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !63, file: !64, line: 164, baseType: !73, size: 16, offset: 96)
!73 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !74, line: 25, baseType: !75)
!74 = !DIFile(filename: "/usr/include/linux/types.h", directory: "/home/darknites/Documents/Dropper/src")
!75 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !52, line: 24, baseType: !76)
!76 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!77 = !DILocalVariable(name: "action", scope: !43, file: !3, line: 69, type: !51)
!78 = !DILocalVariable(name: "nh", scope: !43, file: !3, line: 71, type: !79)
!79 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "hdr_cursor", file: !3, line: 16, size: 64, elements: !80)
!80 = !{!81}
!81 = !DIDerivedType(tag: DW_TAG_member, name: "pos", scope: !79, file: !3, line: 17, baseType: !14, size: 64)
!82 = !DILocalVariable(name: "nh_type", scope: !43, file: !3, line: 72, type: !46)
!83 = !DILocation(line: 63, column: 37, scope: !43)
!84 = !DILocation(line: 65, column: 38, scope: !43)
!85 = !{!86, !87, i64 4}
!86 = !{!"xdp_md", !87, i64 0, !87, i64 4, !87, i64 8, !87, i64 12, !87, i64 16}
!87 = !{!"int", !88, i64 0}
!88 = !{!"omnipotent char", !89, i64 0}
!89 = !{!"Simple C/C++ TBAA"}
!90 = !DILocation(line: 66, column: 34, scope: !43)
!91 = !{!86, !87, i64 0}
!92 = !DILocation(line: 69, column: 8, scope: !43)
!93 = !DILocation(line: 67, column: 17, scope: !43)
!94 = !DILocation(line: 71, column: 20, scope: !43)
!95 = !DILocation(line: 24, column: 57, scope: !96, inlinedAt: !114)
!96 = distinct !DISubprogram(name: "xdp_stats_record_action", scope: !29, file: !29, line: 24, type: !97, isLocal: true, isDefinition: true, scopeLine: 25, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !99)
!97 = !DISubroutineType(types: !98)
!98 = !{!51, !47, !51}
!99 = !{!100, !101, !102, !103, !104, !113}
!100 = !DILocalVariable(name: "ctx", arg: 1, scope: !96, file: !29, line: 24, type: !47)
!101 = !DILocalVariable(name: "action", arg: 2, scope: !96, file: !29, line: 24, type: !51)
!102 = !DILocalVariable(name: "data_end", scope: !96, file: !29, line: 26, type: !14)
!103 = !DILocalVariable(name: "data", scope: !96, file: !29, line: 27, type: !14)
!104 = !DILocalVariable(name: "rec", scope: !96, file: !29, line: 33, type: !105)
!105 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !106, size: 64)
!106 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "datarec", file: !107, line: 10, size: 128, elements: !108)
!107 = !DIFile(filename: "./../common/xdp_stats_kern_user.h", directory: "/home/darknites/Documents/Dropper/src")
!108 = !{!109, !112}
!109 = !DIDerivedType(tag: DW_TAG_member, name: "rx_packets", scope: !106, file: !107, line: 11, baseType: !110, size: 64)
!110 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !52, line: 31, baseType: !111)
!111 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!112 = !DIDerivedType(tag: DW_TAG_member, name: "rx_bytes", scope: !106, file: !107, line: 12, baseType: !110, size: 64, offset: 64)
!113 = !DILocalVariable(name: "bytes", scope: !96, file: !29, line: 38, type: !110)
!114 = distinct !DILocation(line: 82, column: 9, scope: !43)
!115 = !{!87, !87, i64 0}
!116 = !DILocation(line: 33, column: 24, scope: !96, inlinedAt: !114)
!117 = !DILocation(line: 33, column: 18, scope: !96, inlinedAt: !114)
!118 = !DILocation(line: 34, column: 7, scope: !119, inlinedAt: !114)
!119 = distinct !DILexicalBlock(scope: !96, file: !29, line: 34, column: 6)
!120 = !DILocation(line: 34, column: 6, scope: !96, inlinedAt: !114)
!121 = !DILocation(line: 66, column: 23, scope: !43)
!122 = !DILocation(line: 65, column: 27, scope: !43)
!123 = !DILocation(line: 38, column: 25, scope: !96, inlinedAt: !114)
!124 = !DILocation(line: 38, column: 8, scope: !96, inlinedAt: !114)
!125 = !DILocation(line: 44, column: 7, scope: !96, inlinedAt: !114)
!126 = !DILocation(line: 44, column: 17, scope: !96, inlinedAt: !114)
!127 = !{!128, !129, i64 0}
!128 = !{!"datarec", !129, i64 0, !129, i64 8}
!129 = !{!"long long", !88, i64 0}
!130 = !DILocation(line: 45, column: 7, scope: !96, inlinedAt: !114)
!131 = !DILocation(line: 45, column: 16, scope: !96, inlinedAt: !114)
!132 = !{!128, !129, i64 8}
!133 = !DILocation(line: 47, column: 9, scope: !96, inlinedAt: !114)
!134 = !DILocation(line: 48, column: 1, scope: !96, inlinedAt: !114)
!135 = !DILocation(line: 82, column: 2, scope: !43)
