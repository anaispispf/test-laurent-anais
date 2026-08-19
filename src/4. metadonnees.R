METADATA <- data.table(
  nom = c(
    "tab1",
    "tab2",
    "repartition_profession",
    "repartition_sexe"
  ),
  type = c(
    "Table",
    "Table",
    "Graphique",
    "Graphique"
  ),
  fichier = c(
    "output/tab1.csv",
    "output/tab2.csv",
    "output/repartition_profession.png",
    "output/repartition_sexe.png"
  ),
  description = c(
    "Effectifs par profession",
    "Effectifs par profession",
    "Répartition des personnes par profession",
    "Répartition des personnes par sexe"
  ),
  script_source = c(
    "src/2. analyse data.R",
    "main.R",
    "src/3. ggplot.R",
    "src/3. ggplot.R"
  )
)

fwrite(METADATA, "output/metadonnees.csv")
