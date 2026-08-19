p1 <- ggplot(T01_COICOP1, aes(x=reorder(COICOP1, Part), y=Part)) +
  geom_col() +
  coord_flip() +
  labs(
    title="Structure des dépenses des ménages",
    subtitle="Répartition du montant annuel pondéré par fonction COICOP",
    x=NULL,
    y="Part des dépenses"
  ) +
  theme_minimal(base_size=12) +
  theme(panel.grid.major.y=element_blank())

p1



p2 <- ggplot(T02_Alimentation, aes(x=reorder(COICOP3, MontantMensuelMoyen), y=MontantMensuelMoyen)) +
  geom_col() +
  geom_text(
    aes(label=label_number(big.mark=" ", decimal.mark=",", suffix=" F CFP", accuracy=100)(MontantMensuelMoyen)),
    hjust=-0.1,
    size=3.3
  ) +
  coord_flip() +
  scale_y_continuous(
    labels=label_number(big.mark=" ", decimal.mark=","),
    expand=expansion(mult=c(0,0.25))
  ) +
  labs(
    title="Dépenses alimentaires mensuelles moyennes",
    subtitle="Montant moyen par ménage",
    x=NULL,
    y="F CFP par mois"
  ) +
  theme_minimal(base_size=12) +
  theme(panel.grid.major.y=element_blank())

p2



T03_TypeMenage <- DepenseMenage[
  !is.na(TypeMenageLib),
  .(
    DepenseMensuelle=weighted.mean(DepenseMensuelle, PonderationMenage, na.rm=TRUE),
    DepenseMensuelleUC=weighted.mean(DepenseMensuelleUCoxford, PonderationMenage, na.rm=TRUE)
  ),
  by=.(TypeMenageID, TypeMenageLib)
]

T03_long <- melt(
  T03_TypeMenage,
  id.vars=c("TypeMenageID","TypeMenageLib"),
  measure.vars=c("DepenseMensuelle","DepenseMensuelleUC"),
  variable.name="Indicateur",
  value.name="Montant"
)

T03_long[, Indicateur := fifelse(
  Indicateur=="DepenseMensuelle",
  "Dépense par ménage",
  "Dépense par unité de consommation"
)]


p3 <- ggplot(T03_long, aes(x=reorder(TypeMenageLib, Montant), y=Montant, fill=Indicateur)) +
  geom_col(position="dodge") +
  coord_flip() +
  scale_y_continuous(labels=label_number(big.mark=" ", decimal.mark=",", suffix=" F")) +
  labs(
    title="Dépenses mensuelles selon le type de ménage",
    subtitle="Dépense moyenne par ménage et par unité de consommation",
    x=NULL,
    y="F CFP par mois",
    fill=NULL
  ) +
  theme_minimal(base_size=12) +
  theme(
    panel.grid.major.y=element_blank(),
    legend.position="bottom"
  )

p3

T04_StructureNiveauVie <- DimDepense[
  QuintileRevenu %in% c("Q1","Q5") & !is.na(COICOP1),
  .(Montant=sum(MontantAnnuelPondere, na.rm=TRUE)),
  by=.(QuintileRevenu, COICOP1ID, COICOP1)
]

T04_StructureNiveauVie[, Part := Montant/sum(Montant), by=QuintileRevenu]

T04_StructureNiveauVie[, QuintileRevenu := factor(
  QuintileRevenu,
  levels=c("Q1","Q5"),
  labels=c("20 % les plus modestes","20 % les plus aisés")
)]

p4 <- ggplot(
  T04_StructureNiveauVie,
  aes(x=QuintileRevenu, y=Part, fill=COICOP1)
) +
  geom_col(position="fill", width=0.7) +
  scale_y_continuous(labels=percent_format(accuracy=1)) +
  labs(
    title="Structure des dépenses selon le niveau de vie",
    subtitle="Comparaison des 20 % de ménages les plus modestes et les plus aisés",
    x=NULL,
    y="Part des dépenses",
    fill="Fonction COICOP"
  ) +
  theme_minimal(base_size=12) +
  theme(
    panel.grid.major.x=element_blank(),
    legend.position="right"
  )

p4