T02_Alimentation <- DimDepense[
  substr(COICOP_04,1,2) == "01",
  .(MontantAnnuel=sum(MontantAnnuel, na.rm=TRUE)),
  by=.(MenageID, COICOP3ID, COICOP3)
]

T02_Alimentation <- merge(
  T02_Alimentation,
  DimMenage[, .(MenageID, PonderationMenage)],
  by="MenageID",
  all.x=TRUE
)

T02_Alimentation <- T02_Alimentation[
  ,
  .(MontantMensuelMoyen=weighted.mean(MontantAnnuel/12, PonderationMenage, na.rm=TRUE)),
  by=.(COICOP3ID, COICOP3)
]

T02_Alimentation[, MontantMensuel := fmt_fcfp(MontantMensuelMoyen)]
setorder(T02_Alimentation, -MontantMensuelMoyen)