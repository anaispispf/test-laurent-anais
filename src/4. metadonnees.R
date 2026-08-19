METADATA <- data.table(
  paire = c(1, 1, 2, 2),
  nom = c(
    "tab1",
    "repartition_sexe",
    "tab2",
    "repartition_profession"
  ),
  type = c(
    "Table",
    "Graphique",
    "Table",
    "Graphique"
  ),
  fichier = c(
    "output/tab1.csv",
    "output/repartition_sexe.png",
    "output/tab2.csv",
    "output/repartition_profession.png"
  ),
  description = c(
    "Effectifs par sexe",
    "Répartition des personnes par sexe",
    "Effectifs par profession",
    "Répartition des personnes par profession"
  ),
  script_source = c(
    "src/2. analyse data.R",
    "src/3. ggplot.R",
    "src/2. analyse data.R",
    "src/3. ggplot.R"
  )
)

fwrite(METADATA, "output/metadonnees.csv")
