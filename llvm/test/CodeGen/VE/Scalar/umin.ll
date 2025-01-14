; RUN: llc < %s -mtriple=ve | FileCheck %s

;;; Test ‘llvm.umin.*’ intrinsic
;;;
;;; Syntax:
;;;   This is an overloaded intrinsic. You can use @llvm.umin on any
;;;   integer bit width or any vector of integer elements.
;;;
;;; declare i32 @llvm.umin.i32(i32 %a, i32 %b)
;;; declare <4 x i32> @llvm.umin.v4i32(<4 x i32> %a, <4 x i32> %b)
;;;
;;; Overview:
;;;   Return the smaller of %a and %b comparing the values as unsigned
;;;   integers. Vector intrinsics operate on a per-element basis. The
;;;   smaller element of %a and %b at a given index is returned for
;;;   that index.
;;;
;;; Arguments:
;;;   The arguments (%a and %b) may be of any integer type or a vector
;;;   with integer element type. The argument types must match each
;;;   other, and the return type must match the argument type.
;;;
;;; Note:
;;;   We test only i1/u8/u16/u32/u64/u128.

; Function Attrs: mustprogress nofree nosync nounwind readnone willreturn
define zeroext i1 @func_umin_var_i1(i1 noundef zeroext %0, i1 noundef zeroext %1) {
; CHECK-LABEL: func_umin_var_i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mins.w.sx %s0, %s0, %s1
; CHECK-NEXT:    adds.w.zx %s0, %s0, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  %3 = tail call i1 @llvm.umin.i1(i1 %0, i1 %1)
  ret i1 %3
}

; Function Attrs: mustprogress nofree nosync nounwind readnone willreturn
define zeroext i8 @func_umin_var_u8(i8 noundef zeroext %0, i8 noundef zeroext %1) {
; CHECK-LABEL: func_umin_var_u8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mins.w.sx %s0, %s0, %s1
; CHECK-NEXT:    adds.w.zx %s0, %s0, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  %3 = tail call i8 @llvm.umin.i8(i8 %0, i8 %1)
  ret i8 %3
}

; Function Attrs: mustprogress nofree nosync nounwind readnone willreturn
define zeroext i16 @func_umin_var_u16(i16 noundef zeroext %0, i16 noundef zeroext %1) {
; CHECK-LABEL: func_umin_var_u16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mins.w.sx %s0, %s0, %s1
; CHECK-NEXT:    adds.w.zx %s0, %s0, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  %3 = tail call i16 @llvm.umin.i16(i16 %0, i16 %1)
  ret i16 %3
}

; Function Attrs: mustprogress nofree nosync nounwind readnone willreturn
define zeroext i32 @func_umin_var_u32(i32 noundef zeroext %0, i32 noundef zeroext %1) {
; CHECK-LABEL: func_umin_var_u32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    cmpu.w %s2, %s0, %s1
; CHECK-NEXT:    cmov.w.lt %s1, %s0, %s2
; CHECK-NEXT:    adds.w.zx %s0, %s1, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  %3 = tail call i32 @llvm.umin.i32(i32 %0, i32 %1)
  ret i32 %3
}

; Function Attrs: mustprogress nofree nosync nounwind readnone willreturn
define i64 @func_umin_var_u64(i64 noundef %0, i64 noundef %1) {
; CHECK-LABEL: func_umin_var_u64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    cmpu.l %s2, %s0, %s1
; CHECK-NEXT:    cmov.l.lt %s1, %s0, %s2
; CHECK-NEXT:    or %s0, 0, %s1
; CHECK-NEXT:    b.l.t (, %s10)
  %3 = tail call i64 @llvm.umin.i64(i64 %0, i64 %1)
  ret i64 %3
}

; Function Attrs: mustprogress nofree nosync nounwind readnone willreturn
define i128 @func_umin_var_u128(i128 noundef %0, i128 noundef %1) {
; CHECK-LABEL: func_umin_var_u128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    cmpu.l %s5, %s1, %s3
; CHECK-NEXT:    or %s4, 0, %s2
; CHECK-NEXT:    cmov.l.lt %s4, %s0, %s5
; CHECK-NEXT:    cmpu.l %s6, %s0, %s2
; CHECK-NEXT:    cmov.l.lt %s2, %s0, %s6
; CHECK-NEXT:    cmps.l %s0, %s1, %s3
; CHECK-NEXT:    cmov.l.eq %s4, %s2, %s0
; CHECK-NEXT:    cmov.l.lt %s3, %s1, %s5
; CHECK-NEXT:    or %s0, 0, %s4
; CHECK-NEXT:    or %s1, 0, %s3
; CHECK-NEXT:    b.l.t (, %s10)
  %3 = tail call i128 @llvm.umin.i128(i128 %0, i128 %1)
  ret i128 %3
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind readnone willreturn
define zeroext i1 @func_umin_fore_zero_i1(i1 noundef zeroext %0) {
; CHECK-LABEL: func_umin_fore_zero_i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    or %s0, 0, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  ret i1 false
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind readnone willreturn
define zeroext i8 @func_umin_fore_zero_u8(i8 noundef zeroext %0) {
; CHECK-LABEL: func_umin_fore_zero_u8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    or %s0, 0, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  ret i8 0
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind readnone willreturn
define zeroext i16 @func_umin_fore_zero_u16(i16 noundef zeroext %0) {
; CHECK-LABEL: func_umin_fore_zero_u16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    or %s0, 0, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  ret i16 0
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind readnone willreturn
define zeroext i32 @func_umin_fore_zero_u32(i32 noundef zeroext %0) {
; CHECK-LABEL: func_umin_fore_zero_u32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    or %s0, 0, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  ret i32 0
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind readnone willreturn
define i64 @func_umin_fore_zero_u64(i64 noundef %0) {
; CHECK-LABEL: func_umin_fore_zero_u64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    or %s0, 0, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  ret i64 0
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind readnone willreturn
define i128 @func_umin_fore_zero_u128(i128 noundef %0) {
; CHECK-LABEL: func_umin_fore_zero_u128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    or %s0, 0, (0)1
; CHECK-NEXT:    or %s1, 0, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  ret i128 0
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind readnone willreturn
define zeroext i1 @func_umin_back_zero_i1(i1 noundef zeroext %0) {
; CHECK-LABEL: func_umin_back_zero_i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    or %s0, 0, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  ret i1 false
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind readnone willreturn
define zeroext i8 @func_umin_back_zero_u8(i8 noundef zeroext %0) {
; CHECK-LABEL: func_umin_back_zero_u8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    or %s0, 0, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  ret i8 0
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind readnone willreturn
define zeroext i16 @func_umin_back_zero_u16(i16 noundef zeroext %0) {
; CHECK-LABEL: func_umin_back_zero_u16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    or %s0, 0, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  ret i16 0
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind readnone willreturn
define zeroext i32 @func_umin_back_zero_u32(i32 noundef zeroext %0) {
; CHECK-LABEL: func_umin_back_zero_u32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    or %s0, 0, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  ret i32 0
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind readnone willreturn
define i64 @func_umin_back_zero_u64(i64 noundef %0) {
; CHECK-LABEL: func_umin_back_zero_u64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    or %s0, 0, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  ret i64 0
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind readnone willreturn
define i128 @func_umin_back_zero_u128(i128 noundef %0) {
; CHECK-LABEL: func_umin_back_zero_u128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    or %s0, 0, (0)1
; CHECK-NEXT:    or %s1, 0, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  ret i128 0
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind readnone willreturn
define zeroext i1 @func_umin_fore_const_i1(i1 noundef returned zeroext %0) {
; CHECK-LABEL: func_umin_fore_const_i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    b.l.t (, %s10)
  ret i1 %0
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind readnone willreturn
define zeroext i8 @func_umin_fore_const_u8(i8 noundef returned zeroext %0) {
; CHECK-LABEL: func_umin_fore_const_u8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    b.l.t (, %s10)
  ret i8 %0
}

; Function Attrs: mustprogress nofree nosync nounwind readnone willreturn
define zeroext i16 @func_umin_fore_const_u16(i16 noundef zeroext %0) {
; CHECK-LABEL: func_umin_fore_const_u16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mins.w.sx %s0, %s0, (56)0
; CHECK-NEXT:    adds.w.zx %s0, %s0, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  %2 = tail call i16 @llvm.umin.i16(i16 %0, i16 255)
  ret i16 %2
}

; Function Attrs: mustprogress nofree nosync nounwind readnone willreturn
define zeroext i32 @func_umin_fore_const_u32(i32 noundef zeroext %0) {
; CHECK-LABEL: func_umin_fore_const_u32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s1, 255
; CHECK-NEXT:    cmpu.w %s2, %s0, %s1
; CHECK-NEXT:    cmov.w.lt %s1, %s0, %s2
; CHECK-NEXT:    adds.w.zx %s0, %s1, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  %2 = tail call i32 @llvm.umin.i32(i32 %0, i32 255)
  ret i32 %2
}

; Function Attrs: mustprogress nofree nosync nounwind readnone willreturn
define i64 @func_umin_fore_const_u64(i64 noundef %0) {
; CHECK-LABEL: func_umin_fore_const_u64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s1, 255
; CHECK-NEXT:    cmpu.l %s2, %s0, (56)0
; CHECK-NEXT:    cmov.l.lt %s1, %s0, %s2
; CHECK-NEXT:    or %s0, 0, %s1
; CHECK-NEXT:    b.l.t (, %s10)
  %2 = tail call i64 @llvm.umin.i64(i64 %0, i64 255)
  ret i64 %2
}

; Function Attrs: mustprogress nofree nosync nounwind readnone willreturn
define i128 @func_umin_fore_const_u128(i128 noundef %0) {
; CHECK-LABEL: func_umin_fore_const_u128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s2, 255
; CHECK-NEXT:    cmpu.l %s3, %s0, (56)0
; CHECK-NEXT:    lea %s4, 255
; CHECK-NEXT:    cmov.l.lt %s4, %s0, %s3
; CHECK-NEXT:    cmps.l %s0, %s1, (0)1
; CHECK-NEXT:    cmov.l.eq %s2, %s4, %s0
; CHECK-NEXT:    or %s1, 0, (0)1
; CHECK-NEXT:    or %s0, 0, %s2
; CHECK-NEXT:    b.l.t (, %s10)
  %2 = tail call i128 @llvm.umin.i128(i128 %0, i128 255)
  ret i128 %2
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind readnone willreturn
define zeroext i1 @func_umin_back_const_i1(i1 noundef returned zeroext %0) {
; CHECK-LABEL: func_umin_back_const_i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    b.l.t (, %s10)
  ret i1 %0
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind readnone willreturn
define zeroext i8 @func_umin_back_const_u8(i8 noundef returned zeroext %0) {
; CHECK-LABEL: func_umin_back_const_u8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    b.l.t (, %s10)
  ret i8 %0
}

; Function Attrs: mustprogress nofree nosync nounwind readnone willreturn
define zeroext i16 @func_umin_back_const_u16(i16 noundef zeroext %0) {
; CHECK-LABEL: func_umin_back_const_u16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mins.w.sx %s0, %s0, (56)0
; CHECK-NEXT:    adds.w.zx %s0, %s0, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  %2 = tail call i16 @llvm.umin.i16(i16 %0, i16 255)
  ret i16 %2
}

; Function Attrs: mustprogress nofree nosync nounwind readnone willreturn
define zeroext i32 @func_umin_back_const_u32(i32 noundef zeroext %0) {
; CHECK-LABEL: func_umin_back_const_u32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s1, 255
; CHECK-NEXT:    cmpu.w %s2, %s0, %s1
; CHECK-NEXT:    cmov.w.lt %s1, %s0, %s2
; CHECK-NEXT:    adds.w.zx %s0, %s1, (0)1
; CHECK-NEXT:    b.l.t (, %s10)
  %2 = tail call i32 @llvm.umin.i32(i32 %0, i32 255)
  ret i32 %2
}

; Function Attrs: mustprogress nofree nosync nounwind readnone willreturn
define i64 @func_umin_back_const_u64(i64 noundef %0) {
; CHECK-LABEL: func_umin_back_const_u64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s1, 255
; CHECK-NEXT:    cmpu.l %s2, %s0, (56)0
; CHECK-NEXT:    cmov.l.lt %s1, %s0, %s2
; CHECK-NEXT:    or %s0, 0, %s1
; CHECK-NEXT:    b.l.t (, %s10)
  %2 = tail call i64 @llvm.umin.i64(i64 %0, i64 255)
  ret i64 %2
}

; Function Attrs: mustprogress nofree nosync nounwind readnone willreturn
define i128 @func_umin_back_const_u128(i128 noundef %0) {
; CHECK-LABEL: func_umin_back_const_u128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lea %s2, 255
; CHECK-NEXT:    cmpu.l %s3, %s0, (56)0
; CHECK-NEXT:    lea %s4, 255
; CHECK-NEXT:    cmov.l.lt %s4, %s0, %s3
; CHECK-NEXT:    cmps.l %s0, %s1, (0)1
; CHECK-NEXT:    cmov.l.eq %s2, %s4, %s0
; CHECK-NEXT:    or %s1, 0, (0)1
; CHECK-NEXT:    or %s0, 0, %s2
; CHECK-NEXT:    b.l.t (, %s10)
  %2 = tail call i128 @llvm.umin.i128(i128 %0, i128 255)
  ret i128 %2
}

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i32 @llvm.umin.i32(i32, i32)

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i1 @llvm.umin.i1(i1, i1)

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i8 @llvm.umin.i8(i8, i8)

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i16 @llvm.umin.i16(i16, i16)

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i64 @llvm.umin.i64(i64, i64)

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i128 @llvm.umin.i128(i128, i128)
