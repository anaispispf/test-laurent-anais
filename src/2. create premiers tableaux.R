ResultatCOICOP1 <- DimDepense[,.(MontantAnnuelPondere = sum(MontantAnnuelPondere, na.rm=TRUE)),  by=.(COICOP1ID, COICOP1)]
ResultatCOICOP1[, Pourcentage := MontantAnnuelPondere / sum(MontantAnnuelPondere)]
ResultatCOICOP1[, `:=`(
  MontantAnnuelPondere=label_number(scale=1e-9, suffix=" Md F CFP", accuracy=0.1, big.mark=" ", decimal.mark=",")(MontantAnnuelPondere),
  Pourcentage=label_percent(accuracy=0.1, decimal.mark=",")(Pourcentage)
)]

setorder(ResultatCOICOP1, COICOP1ID)
ResultatCOICOP1
