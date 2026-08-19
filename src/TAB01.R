T01_COICOP1 <- DimDepense[
  !is.na(COICOP1),
  .(MontantAnnuelPondere=sum(MontantAnnuelPondere, na.rm=TRUE)),
  by=.(COICOP1ID, COICOP1)
]

T01_COICOP1[, Pourcentage := MontantAnnuelPondere/sum(MontantAnnuelPondere)]
setorder(T01_COICOP1, COICOP1ID)

T01_COICOP1[, `:=`(
  Montant=fmt_milliards(MontantAnnuelPondere),
  Part=fmt_pct(Pourcentage)
)]