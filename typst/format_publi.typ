#let format_publi(
  metadata,
  metafigures,
  body) = {
    
    // META VARIABLES ----------------------------------
    let titre = metadata.titre
    let mois  = metadata.mois
    let ispf  = metadata.ispf
    let abstract = metadata.abstract
    let collection = metadata.collection
    let numeropubli = metadata.numeropubli
    let auteur = metadata.auteur
    let redacteur = metadata.redacteur
    let directeur = metadata.directeur
    let editeur = metadata.editeur
    let depotlegal = metadata.depotlegal
    let copyrightannee = metadata.copyrightannee
    let ISSN = metadata.ISSN
    let lientelechargement = metadata.lientelechargement
    let logo = move(dy: -3pt, image("LOGO_ISPF.png", height: 22pt))

    // FIGURES ----------------------------------
    let getmetafigures(name) = metafigures.find(row => row.nomimage == name)

    // DOCUMENT AND TEXT DEFAULTS ----------------------------------
    set document(title: [#titre])
    show title: set text(size: 22pt, weight: 300, fill: rgb("#009FA5"))
    set text(font: "Roboto", size: 8.5pt, weight: 300)
    set par(justify: true, first-line-indent: 0.8em) 
    show strong: it => text(weight: 700, it.body)

    // PAGE SETUP ----------------------------------
    set page(
    paper: "a4",
    margin: (top: 1.5cm, left: 1cm, right: 1cm, bottom: 1.6cm),
    columns: 2,
    footer-descent: 6pt,
    footer: context {
      let p = counter(page).get().first()
      place(top, line(length: 100%, stroke: 0.2pt))
      pad(top: if p == 1 { 12pt } else { 7pt }, bottom: 12pt)[
        #if calc.even(p) {
          grid(
            columns: (1fr, 1fr),
            align(horizon + left)[
              #set text(7pt)
              *#p* #h(5pt) | #h(5pt) #editeur],
            align(right)[#logo]
          )
        } else {
          grid(
            columns: (1fr, 1fr),
            align(horizon + left)[
              #if p == 1 { set text(7pt); ispf } else { logo }],
            align(horizon + right)[
              #set text(7pt)
              #document.title #h(5pt) | #h(5pt)
              #mois #h(5pt) | #h(5pt)
              #if p == 1 {
                text(weight: "bold")[#counter(page).display("1 - 1", both: true)]
              } else {
                text(weight: "bold")[#p]
              }
            ]
          )
        }
      ]
    }
  )

    // HEADER FIRST PAGE ----------------------------------
    place(top, float: true, scope: "parent", clearance: 3em)[
      #box(width: 100%)[
        #figure(image("fv-pc.png", width: 100%))
        #place(top + left, dy: -4pt, dx: -1pt)[
          #text(font: "Roboto", size: 29pt, weight: 700, fill: rgb("#009FA5"))[#collection]]
        #place(top + center, dy: 30pt, dx: -17pt)[
          #text(font: "Roboto", size: 24pt, weight: 300, fill: rgb("#009FA5"))[de la Polynésie française]]
        #place(top + left, dy: 65pt, dx: 1.5pt)[
          #text(font: "Roboto", size: 20pt, weight: 300, fill: luma(255))[N° #numeropubli]]
        ]
        #title()
        #set text(font: "Roboto", size: 10pt, weight: 700, overhang: false)
        #par(justify: true, first-line-indent: 0em)[#abstract]
        #line(length: 100%, stroke: 1.5pt + rgb("#009FA5"))
      ]

      // HEADING AND FIGURE STYLING ----------------------------------
      set par(first-line-indent: (amount: 0.8em, all: true,))
      show heading: set text(size: 10pt, weight: 700, fill: rgb("#009FA5"), ligatures: true,)
      show heading: set block(below: 1.5em, above: 1.5em)
      counter(figure.where(kind: image)).update(0)  
      show figure.caption: set text(size: 7pt)
      show figure.caption: it => context [
       *#it.supplement~#it.counter.display()#it.separator*#it.body]
      show figure: set block(below: 1em, above: 2em)

      // BODY INSERT ----------------------------------
      body

      // DOCUMENT INFOS ----------------------------------
      block(fill: rgb("#CCECED"), inset: 8pt, breakable: false, width: 100%, above: 2em, below: 4em)[
        #set text(font: "Roboto", size: 7pt, hyphenate: false)
        #grid(
          columns: (38%, 62%),
          row-gutter: 4pt,
          [*Editeur*],                     [#editeur],
          [*Collection*],                  [#collection],
          [*Numéro*],                      [#numeropubli],
          [*Auteur de la publication*],    [#auteur],
          [*Rédactrice en chef*],          [#redacteur],
          [*Directeur de la publication*], [#directeur],
          [*Dépôt légal*],                 [#depotlegal],
          [*Informations*],                [Immeuble Uupa - 1#super[er] étage #linebreak()
                                            15 rue Edouard Ahnne #linebreak()
                                            BP 395 - 98713 Papeete Tahiti #linebreak()
                                            Polynésie française],
          [*Téléphone*],                   [+689 40 47 34 34],
          [*Courriel*],                    [ispf\@ispf.pf],
          [*Copyright*],                   [\u{00A9} ISPF, Papeete #copyrightannee #linebreak()
                                            La reproduction est autorisée, sauf à des fins commerciales,
                                            si la source est mentionnée],
          [*ISSN*],                        [#ISSN],
        )
      ]
      figure(image("frisefin-pc.png"))
    }

#let make-createfigure(numeropubli, metafigures) = (name) => {
  let m = metafigures.find(row => row.nomimage == name)
  let is_table = m.type == "tab"
  figure(
    caption: figure.caption(position: top)[#m.caption],
    kind: if is_table { table } else { image },
    supplement: if is_table { [Table] } else { [Figure] },
    block()[
      #v(6pt)
      #image(numeropubli + " " + m.nomimage + ".pdf")
      #v(-2pt)
      #align(right)[#text(6.5pt)[Source : #m.sources]]
      #v(6pt)
    ]
  )
}