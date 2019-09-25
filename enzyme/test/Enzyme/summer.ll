; RUN: opt < %s %loadEnzyme -enzyme -enzyme_preopt=false -inline -ipconstprop -deadargelim -mem2reg -instsimplify -adce -loop-deletion -correlated-propagation -simplifycfg -S | FileCheck %s

@.str = private unnamed_addr constant [25 x i8] c"xs[%d] = %f xp[%d] = %f\0A\00", align 1
@.str.1 = private unnamed_addr constant [7 x i8] c"n != 0\00", align 1
@.str.2 = private unnamed_addr constant [9 x i8] c"summer.c\00", align 1
@__PRETTY_FUNCTION__.summer = private unnamed_addr constant [40 x i8] c"double summer(double *restrict, size_t)\00", align 1
@.str.3 = private unnamed_addr constant [19 x i8] c"i print things %f\0A\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c"n != 1\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @derivative(double* noalias %x, double* noalias %xp, i64 %n) local_unnamed_addr #0 {
entry:
  %0 = tail call double (double (double*, i64)*, ...) @__enzyme_autodiff(double (double*, i64)* nonnull @summer, double* %x, double* %xp, i64 %n)
  ret void
}

; Function Attrs: noinline nounwind uwtable
define internal double @summer(double* noalias nocapture readonly %x, i64 %n) #0 {
entry:
  %cmp = icmp eq i64 %n, 0
  br i1 %cmp, label %cond.false, label %cond.end

cond.false:                                       ; preds = %entry
  tail call void @__assert_fail(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i64 0, i64 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.2, i64 0, i64 0), i32 11, i8* getelementptr inbounds ([40 x i8], [40 x i8]* @__PRETTY_FUNCTION__.summer, i64 0, i64 0)) #6
  unreachable

cond.end:                                         ; preds = %entry
  %call = tail call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.3, i64 0, i64 0), double 0.000000e+00)
  %cmp1 = icmp eq i64 %n, 1
  br i1 %cmp1, label %cond.false3, label %for.body.preheader

cond.false3:                                      ; preds = %cond.end
  tail call void @__assert_fail(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i64 0, i64 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.2, i64 0, i64 0), i32 13, i8* getelementptr inbounds ([40 x i8], [40 x i8]* @__PRETTY_FUNCTION__.summer, i64 0, i64 0)) #6
  unreachable

for.body.preheader:                               ; preds = %cond.end
  %0 = load double, double* %x, align 8, !tbaa !2
  br label %for.body.for.body_crit_edge

for.cond.cleanup:                                 ; preds = %for.body.for.body_crit_edge
  %sub = fsub fast double %0, %cond.i
  ret double %sub

for.body.for.body_crit_edge:                      ; preds = %for.body.for.body_crit_edge, %for.body.preheader
  %indvars.iv.next29 = phi i64 [ 1, %for.body.preheader ], [ %indvars.iv.next, %for.body.for.body_crit_edge ]
  %cond.i28 = phi double [ %0, %for.body.preheader ], [ %cond.i, %for.body.for.body_crit_edge ]
  %arrayidx9.phi.trans.insert = getelementptr inbounds double, double* %x, i64 %indvars.iv.next29
  %.pre = load double, double* %arrayidx9.phi.trans.insert, align 8, !tbaa !2
  %cmp.i = fcmp fast ogt double %cond.i28, %.pre
  %cond.i = select i1 %cmp.i, double %cond.i28, double %.pre
  %indvars.iv.next = add nuw i64 %indvars.iv.next29, 1
  %exitcond = icmp eq i64 %indvars.iv.next, %n
  br i1 %exitcond, label %for.cond.cleanup, label %for.body.for.body_crit_edge
}

; Function Attrs: nounwind
declare double @__enzyme_autodiff(double (double*, i64)*, ...) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #3

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #3

; Function Attrs: nounwind
declare dso_local i32 @printf(i8* nocapture readonly, ...) local_unnamed_addr #4

; Function Attrs: noreturn nounwind
declare dso_local void @__assert_fail(i8*, i8*, i32, i8*) local_unnamed_addr #5

attributes #0 = { noinline nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="true" "no-jump-tables"="false" "no-nans-fp-math"="true" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="true" "use-soft-float"="false" }
attributes #1 = { nounwind }
attributes #2 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="true" "no-jump-tables"="false" "no-nans-fp-math"="true" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="true" "use-soft-float"="false" }
attributes #3 = { argmemonly nounwind }
attributes #4 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="true" "no-nans-fp-math"="true" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="true" "use-soft-float"="false" }
attributes #5 = { noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="true" "no-nans-fp-math"="true" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="true" "use-soft-float"="false" }
attributes #6 = { noreturn nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 7.1.0 "}
!2 = !{!3, !3, i64 0}
!3 = !{!"double", !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}


; CHECK: define internal {{(dso_local )?}}void @diffesummer(double* noalias nocapture readonly %x, double* %"x'", i64 %n) #0 {
; CHECK-NEXT: entry:
; CHECK-NEXT:   %cmp = icmp eq i64 %n, 0
; CHECK-NEXT:   br i1 %cmp, label %cond.false, label %cond.end

; CHECK: cond.false:                                       ; preds = %entry
; CHECK-NEXT:   tail call void @__assert_fail(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.1, i64 0, i64 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.2, i64 0, i64 0), i32 11, i8* getelementptr inbounds ([40 x i8], [40 x i8]* @__PRETTY_FUNCTION__.summer, i64 0, i64 0))
; CHECK-NEXT:   unreachable

; CHECK: cond.end:                                         ; preds = %entry
; CHECK-NEXT:   %call = tail call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.3, i64 0, i64 0), double 0.000000e+00)
; CHECK-NEXT:   %cmp1 = icmp eq i64 %n, 1
; CHECK-NEXT:   br i1 %cmp1, label %cond.false3, label %for.body.preheader

; CHECK: cond.false3:                                      ; preds = %cond.end
; CHECK-NEXT:   tail call void @__assert_fail(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i64 0, i64 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.2, i64 0, i64 0), i32 13, i8* getelementptr inbounds ([40 x i8], [40 x i8]* @__PRETTY_FUNCTION__.summer, i64 0, i64 0))
; CHECK-NEXT:   unreachable

; CHECK: for.body.preheader:                               ; preds = %cond.end
; CHECK-NEXT:   %0 = load double, double* %x, align 8, !tbaa !2
; CHECK-NEXT:   %[[nm2:.+]] = add i64 %n, -2
; CHECK-NEXT:   %[[msize:.+]] = add nuw i64 %[[nm2]], 1
; CHECK-NEXT:   %malloccall = tail call noalias nonnull i8* @malloc(i64 %[[msize]])
; CHECK-NEXT:   %cmp.i_malloccache = bitcast i8* %malloccall to i1*
; CHECK-NEXT:   br label %for.body.for.body_crit_edge

; CHECK: for.body.for.body_crit_edge:                      ; preds = %for.body.for.body_crit_edge, %for.body.preheader
; CHECK-NEXT:   %indvar = phi i64 [ %indvar.next, %for.body.for.body_crit_edge ], [ 0, %for.body.preheader ]
; CHECK-NEXT:   %cond.i28 = phi double [ %0, %for.body.preheader ], [ %cond.i, %for.body.for.body_crit_edge ]
; CHECK-NEXT:   %[[idxadd:.+]] = add i64 %indvar, 1
; CHECK-NEXT:   %arrayidx9.phi.trans.insert = getelementptr inbounds double, double* %x, i64 %[[idxadd]]
; CHECK-NEXT:   %.pre = load double, double* %arrayidx9.phi.trans.insert, align 8, !tbaa !2
; CHECK-NEXT:   %cmp.i = fcmp fast ogt double %cond.i28, %.pre
; CHECK-NEXT:   %[[gepz:.+]] = getelementptr i1, i1* %cmp.i_malloccache, i64 %indvar
; CHECK-NEXT:   store i1 %cmp.i, i1* %[[gepz]]
; CHECK-NEXT:   %cond.i = select i1 %cmp.i, double %cond.i28, double %.pre
; CHECK-NEXT:   %indvars.iv.next = add nuw i64 %[[idxadd]], 1
; CHECK-NEXT:   %[[pcond:.+]] = icmp eq i64 %indvars.iv.next, %n
; CHECK-NEXT:   %indvar.next = add i64 %indvar, 1
; CHECK-NEXT:   br i1 %[[pcond]], label %invertfor.cond.cleanup, label %for.body.for.body_crit_edge

; CHECK: invertfor.body.preheader:                         ; preds = %invertfor.body.for.body_crit_edge
; CHECK-NEXT:   tail call void @free(i8* nonnull %malloccall)
; CHECK-NEXT:   %[[lastload:.+]] = load double, double* %"x'"
; CHECK-NEXT:   %[[output:.+]] = fadd fast double %[[lastload]], %[[decarry:.+]]
; CHECK-NEXT:   store double %[[output]], double* %"x'"
; CHECK-NEXT:   %[[printer:.+]] = tail call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.3, i64 0, i64 0), double 0.000000e+00)
; CHECK-NEXT:   ret

; CHECK: invertfor.cond.cleanup:                           ; preds = %for.body.for.body_crit_edge
; CHECK-NEXT:   %[[nm210:.+]] = add i64 %n, -2
; CHECK-NEXT:   br label %invertfor.body.for.body_crit_edge

; CHECK: invertfor.body.for.body_crit_edge:                ; preds = %invertfor.body.for.body_crit_edge, %invertfor.cond.cleanup
; CHECK-NEXT:   %"cond.i'de.0" = phi double [ -1.000000e+00, %invertfor.cond.cleanup ], [ %diffecond.i28, %invertfor.body.for.body_crit_edge ]
; CHECK-NEXT:   %"'de.0" = phi double [ 1.000000e+00, %invertfor.cond.cleanup ], [ %[[decarry]], %invertfor.body.for.body_crit_edge ]
; CHECK-NEXT:   %"indvar'phi" = phi i64 [ %[[nm210]], %invertfor.cond.cleanup ], [ %[[subd:.+]], %invertfor.body.for.body_crit_edge ]
; CHECK-NEXT:   %[[subd]] = sub i64 %"indvar'phi", 1
; CHECK-NEXT:   %[[gep1:.+]] = getelementptr i1, i1* %cmp.i_malloccache, i64 %"indvar'phi"
; CHECK-NEXT:   %[[reload:.+]] = load i1, i1* %[[gep1]]
; CHECK-NEXT:   %diffecond.i28 = select i1 %[[reload]], double %"cond.i'de.0", double 0.000000e+00
; CHECK-NEXT:   %diffe.pre = select i1 %[[reload]], double 0.000000e+00, double %"cond.i'de.0"
; CHECK-NEXT:   %[[idx2:.+]] = add i64 %"indvar'phi", 1
; CHECK-NEXT:   %"arrayidx9.phi.trans.insert'ipg" = getelementptr double, double* %"x'", i64 %[[idx2]]
; CHECK-NEXT:   %[[loaded:.+]] = load double, double* %"arrayidx9.phi.trans.insert'ipg"
; CHECK-NEXT:   %[[tostore:.+]] = fadd fast double %[[loaded]], %diffe.pre
; CHECK-NEXT:   store double %[[tostore]], double* %"arrayidx9.phi.trans.insert'ipg"
; CHECK-NEXT:   %[[lcond:.+]] = icmp ne i64 %"indvar'phi", 0
; CHECK-NEXT:   %[[unusedselect:.+]] = select i1 %[[lcond]], double %diffecond.i28, double 0.000000e+00
; CHECK-NEXT:   %[[sel2:.+]] = select i1 %[[lcond]], double 0.000000e+00, double %diffecond.i28
; CHECK-NEXT:   %[[decarry]] = fadd fast double %"'de.0", %[[sel2]]
; CHECK-NEXT:   br i1 %[[lcond]], label %invertfor.body.for.body_crit_edge, label %invertfor.body.preheader
; CHECK-NEXT: }