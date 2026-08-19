T03_TypeMenage <- DepenseMenage[
  !is.na(TypeMenageLib),
  .(
    NbMenages=sum(PonderationMenage, na.rm=TRUE),
    DepenseMensuelle=weighted.mean(DepenseMensuelle, PonderationMenage, na.rm=TRUE),
    DepenseMensuelleUC=weighted.mean(DepenseMensuelleUCoxford, PonderationMenage, na.rm=TRUE)
  ),
  by=.(TypeMenageID, TypeMenageLib)
]

T03_TypeMenage[, PartMenages := NbMenages/sum(NbMenages)]

T03_TypeMenage[, `:=`(
  Part=fmt_pct(PartMenages),
  DepenseMenage=fmt_fcfp(DepenseMensuelle),
  DepenseUC=fmt_fcfp(DepenseMensuelleUC)
)]