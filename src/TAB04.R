DimDepense[, ClasseRevenu2015 := fcase(
  RevenuMensuel < 150000, "Moins de 150 000 F CFP",
  RevenuMensuel > 600000, "Plus de 600 000 F CFP",
  default=NA_character_
)]

T04_Seuils2015 <- DimDepense[
  !is.na(ClasseRevenu2015) & !is.na(COICOP1),
  .(Montant=sum(MontantAnnuelPondere, na.rm=TRUE)),
  by=.(ClasseRevenu2015, COICOP1ID, COICOP1)
]

T04_Seuils2015[, Part := Montant/sum(Montant), by=ClasseRevenu2015]
T04_Seuils2015[, Pourcentage := fmt_pct(Part)]