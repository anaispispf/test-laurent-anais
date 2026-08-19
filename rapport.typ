#set page(paper: "a4", margin: (x: 2.5cm, y: 2.5cm), numbering: "1")
#set text(font: "New Computer Modern", size: 11pt, lang: "fr")
#set par(justify: true, leading: 0.65em)
#set heading(numbering: "1.1")

#align(center)[
  #text(size: 18pt, weight: "bold")[Répartition d'une population simulée par sexe et par profession]

  #v(0.6em)
  #text(size: 12pt)[Laurent Pellet]
  #v(0.15em)
  #text(size: 10pt, style: "italic")[laurent\@pellet.pf]
  #v(0.4em)
  #text(size: 10pt)[#datetime.today().display("[day] [month repr:long] [year]")]
]

#v(1.5em)

#align(center)[
  #block(width: 85%)[
    #text(weight: "bold")[Résumé] #linebreak()
    Ce rapport présente une analyse descriptive d'une population simulée, caractérisée par son âge, son sexe et sa profession. Les effectifs sont résumés sous forme de tableaux et de graphiques de répartition, générés à partir d'un pipeline `data.table` / `ggplot2`.
  ]
]

#v(1.5em)

= Introduction

Ce document est un export au format Typst du rapport produit par le pipeline R du projet. Les données sont générées par `src/1. generateData.R`, analysées par `src/2. analyse data.R`, puis visualisées par `src/3. ggplot.R`. La table de métadonnées (`output/metadonnees.csv`), produite par `src/4. metadonnees.R`, recense l'ensemble des tableaux et graphiques disponibles et pilote la mise en page ci-dessous.

= Données et méthodes

Le jeu de données comprend un identifiant, un âge, un sexe et une profession pour chaque individu. Deux répartitions sont étudiées : la répartition par sexe (tableau 1 / figure 1) et la répartition par profession (tableau 2 / figure 2).

= Résultats

#let meta = csv("output/metadonnees.csv", row-type: dictionary)

#for p in (1, 2) [
  == Répartition #p

  #for ligne in meta.filter(l => int(l.paire) == p) [
    === #ligne.description

    #if ligne.type == "Table" [
      #let data = csv(ligne.fichier)
      #figure(
        table(
          columns: data.at(0).len(),
          table.header(..data.at(0)),
          ..data.slice(1).flatten()
        ),
        caption: [#ligne.description],
      )
    ] else [
      #figure(
        image(ligne.fichier, width: 70%),
        caption: [#ligne.description],
      )
    ]
  ]
]

= Conclusion

Ce document illustre comment la table de métadonnées du projet peut piloter, sans nom codé en dur, à la fois le rapport R Markdown (`rapport.Rmd`) et cet export Typst. Toute table ou graphique ajouté dans `src/4. metadonnees.R` apparaît automatiquement dans les deux formats après régénération des sorties (`output/`).
