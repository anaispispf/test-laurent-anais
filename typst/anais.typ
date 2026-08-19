#import "format_publi.typ": format_publi, make-createfigure

#let metapubli = yaml("publi_meta.yaml")
#let metafigures = csv("figures_meta.csv", row-type: dictionary)
#let createfigure = make-createfigure(metapubli.numeropubli, metafigures)

#show: format_publi.with(metapubli, metafigures)

= Estsdfdsfsdimation du nombre de visiteurs en Polynésie française

En février 2026, la Polynésie française a accueilli 24 154 visiteurs, parmi lesquels 21 454 touristes et 2 700 excursionnistes venus à bord de deux navires. En cumul depuis janvier, la Polynésie françaisefdsfsdfdsdsfsdfs a accueilli 351 289 visiteurs, dont 281 227 touristes et 70 062 excursionnistes, à bord de 32 navires.


= Fréquentation touristique

#createfigure("graphe1")


Note de lecture : En décembre 2025, le nombre de touristes en cumul sur les douze derniers mois s'élève à 281 227.

#colbreak()

#createfigure("graphe2")

En décembre 2025, 21 454 touristes ont débarqué à l'aéroport de Tahiti-Faa'a, soit une baisse de −3,3 % sur un an. Cette baisse concerne essentiellement les touristes en hébergement terrestre marchand (−10,9 %) et non marchand (−3,2 %), puisque la fréquentation en hébergement flottant progresse (+28,5 %). Le recul des effectifs concerne les clientèles originaires d'Amérique du Nord (−2,5 %), de France hexagonale (−4,8 %) et du Pacifique (−8,8 %). Seule la clientèle résidant en Europe (hors France) est plus nombreuse (+11,7 %) qu'il y a un an.

Ce recul des principaux marchés touristiques se retrouve dans les effectifs en hébergement terrestre marchand (61,5 % des touristes totaux), dont la baisse contribue pour −7,2 points à l'évolution globale. Sur l'année 2025, ce type de tourisme progresse de 8,2 % (+14 900 personnes) et contribue pour 5,6 points à l'évolution annuelle (+6,6 %).

Deuxième composante du tourisme polynésien, les touristes en hébergement flottant (20,9 % de la clientèle du mois) sont plus nombreux par rapport à l'année précédente, portés par une offre en cabine plus importante et un rebond des clientèles d'Amérique du Nord (+41,7 %), de France hexagonale (+19,7 %) et du Pacifique (+34,6 %) sur ce segment. Sur l'année 2025, les effectifs en hébergement flottant progressent de +3,5 %.

Les touristes en hébergement non marchand, qui représentent 17,6 % des effectifs du mois, se contractent de 3,2 % par rapport à décembre 2024, principalement en raison de la baisse de fréquentation des marchés de France hexagonale (−5,9 %) et d'Amérique du Nord (−1,6 %). En cumul sur l'année, ce segment progresse de 2,5 % à (29 780) touristes affinitaires.

Si la fréquentation touristique est en recul ce mois, la durée moyenne des séjours touristiques reste stable à 16,3 jours. Le nombre de nuitées touristiques baisse ainsi de −3,6 % sur un an (349 123 nuitées ce mois). En cumul depuis janvier, la Polynésie française a accueilli 281 227 touristes (+6,6 % par rapport à 2024), qui ont cumulé 4 650 744 nuitées touristiques (+7,9 %).

#pagebreak()



= Définitionss

#set par(justify: true, first-line-indent: 0em)

*Croisière transpacifique* : Un séjour sur un navire transitant dans les eaux polynésiennes avec un port d'entrée et de sortie différent et sans aucun hébergement terrestre. Les visiteurs utilisant cette forme d'hébergement flottant sont comptabilisés comme des excursionnistes.

*Excursionnistes* : Visiteurs dont le séjour ne comporte aucune nuitée dans un hébergement terrestre ni dans une croisière intrapolynésienne. Cela comprend les passagers logés à bord des navires en transit et en croisière transpacifique. Ils peuvent visiter le pays pendant un ou plusieurs jours et revenir sur leur bateau pour y dormir.

*Hébergement flottant* : Hébergement sur un yacht, un voilier ou un bateau de croisière.

*Hébergement terrestre* : Par opposition à un hébergement flottant, hébergement qui n'est pas un yacht, un voilier ou un bateau de croisière.

*Hébergement marchand* : Hébergement payant comme un hôtel, une pension de famille, une résidence de tourisme ou une location de vacances.

*Hébergement non marchand* : Hébergement non payant en général chez des particuliers (la famille ou les amis) ou dans une structure collective gratuite.

*Nuitée touristique* : L'unité de compte de la durée du séjour d'un touriste, constituée d\'une nuit par personne passée en hébergement hors de son domicile déclaré. Elle sert à mesurer la durée de séjour moyenne.

*Touristes* : Visiteurs qui passent au moins une nuit en Polynésie française dans un hébergement terrestre ou dans le cadre d'une croisière intrapolynésienne.

*Visiteurs* : Personnes non-résidentes qui font un voyage en Polynésie française pour une durée comprise entre une nuit et un an. Les passagers en transit et les membres d'équipage sont exclus des visiteurs. Les visiteurs sont qualifiés de touristes ou d'excursionnistes.

= Télécharger les données

#link(metapubli.lientelechargement)[\u{1F4BE} Toutes les données]