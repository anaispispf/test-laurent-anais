# =============================================================================
# PREPARATION DES TABLES D'ANALYSE EBF 2025
#
# Ce script extrait depuis SQL Server les principales tables du schéma CUBE
# utilisées pour l'analyse de l'Enquête Budget des Familles 2025 :
#
#   - DimDepense   : dépenses des ménages
#   - DimRessource : ressources et revenus
#   - DimIndividu  : caractéristiques individuelles
#   - DimMenage    : caractéristiques des ménages
#
# Les tables principales contiennent essentiellement des identifiants de
# modalités. Elles sont donc enrichies avec les tables de nomenclature NKL
# afin d'ajouter les libellés nécessaires aux analyses statistiques.
#
# La fonction merge_nkl() sécurise les jointures en vérifiant :
#   - l'unicité de la clé dans chaque nomenclature ;
#   - l'absence de noms de colonnes dupliqués après jointure.
#
# La nomenclature COICOP est reconstruite en R à partir des tables
# NKL.COICOP2018_04 et NKL.COICOP2018_03. Une modalité spécifique
# "n.d. (15.1.1)" est ajoutée afin de reproduire la logique historiquement
# utilisée dans la vue SQL correspondante.
#
# Pour les données géographiques, seules les colonnes nécessaires sont
# sélectionnées et renommées avant les jointures afin d'éviter les collisions
# entre les champs Subdivision, Ile et Comas.
#
# Une fois les enrichissements terminés, la connexion SQL est fermée et les
# quatre tables finales sont enregistrées au format RDS dans le dossier input/.
# Ces fichiers constituent les données d'entrée des scripts d'analyse et de
# production des tableaux et graphiques EBF 2025.
# =============================================================================


# -----------------------------------------------------------------------------
# Connexion à SQL Server et fonctions utilitaires
# -----------------------------------------------------------------------------

conSQL <- dbConnect(odbc::odbc(), Driver = "SQL Server", Server = "sql" ,Database = "EBF2025")

# Lecture d'une table du schéma CUBE directement sous forme de data.table
readCube <- function(table) setDT(dbReadTable(conSQL, Id("CUBE", table)))

# Jointure sécurisée entre une table principale et une nomenclature
merge_nkl <- function(x, nkl, by.x, by.y=by.x) {
  if (anyDuplicated(nkl[[by.y]])) stop("Clé non unique : ", by.y)
  x <- merge(x, nkl, by.x=by.x, by.y=by.y, all.x=TRUE, sort=FALSE)
  if (anyDuplicated(names(x))) stop("Colonnes dupliquées : ", paste(names(x)[duplicated(names(x))], collapse=", "))
  x
}


# -----------------------------------------------------------------------------
# DEPENSES
# Enrichissement des dépenses avec les différentes nomenclatures associées
# -----------------------------------------------------------------------------

DimDepense <- readCube("DimDepense")
DimDepense <- merge_nkl(DimDepense, readCube("NKLEtatProduit"), "EtatProduitID")
DimDepense <- merge_nkl(DimDepense, readCube("NKLConditionnementProduit"), "ConditionnementProduitID")
DimDepense <- merge_nkl(DimDepense, readCube("NKLModePaiement"), "ModePaiementID")
DimDepense <- merge_nkl(DimDepense, readCube("NKLDestinationDepense"), "DestinationDepenseID")
DimDepense <- merge_nkl(DimDepense, readCube("NKLOrigineProduitAutoconso"), "OrigineProduitAutoconsoID")
DimDepense <- merge_nkl(DimDepense, readCube("NKLDestinationVoyage"), "DestinationVoyageID")
DimDepense <- merge_nkl(DimDepense, readCube("NKLTypeMagasin"), "TypeMagasinID")
DimDepense <- merge_nkl(DimDepense, readCube("NKLTypeCeremonie"), "TypeCeremonieID")

# Harmonisation du type de LieuGeoID avant la jointure
NKLLieuGeo <- readCube("NKLLieuGeo")
NKLLieuGeo[, LieuGeoID := as.integer(LieuGeoID)]
DimDepense <- merge_nkl(DimDepense, NKLLieuGeo, "LieuGeoID")


# -----------------------------------------------------------------------------
# COICOP
# Reconstruction en R de la nomenclature COICOP de niveau 4
# -----------------------------------------------------------------------------

COICOP04 <- setDT(dbReadTable(conSQL, Id("NKL", "COICOP2018_04")))
COICOP03 <- setDT(dbReadTable(conSQL, Id("NKL", "COICOP2018_03")))

# Ajout de la modalité non déterminée rattachée au niveau 15.1.1
COICOP03_nd <- COICOP03[
  COICOP3ID == "15.1.1",
  .(
    COICOP4ID = "n.d. (15.1.1)",
    COICOP3ID,
    COICOP2ID,
    COICOP1ID,
    COICOP4 = "n.d. (15.1.1)",
    COICOP3,
    COICOP2,
    COICOP1,
    COICOP4CL = "n.d. (15.1.1)",
    COICOP3CL,
    COICOP2CL,
    COICOP1CL,
    COICOP1999_03ID = NA_character_
  )
]

# Equivalent du UNION SQL
COICOP <- rbindlist(list(COICOP04, COICOP03_nd), use.names=TRUE, fill=TRUE)
COICOP <- unique(COICOP)

# Ajout des niveaux COICOP 1 à 4 dans DimDepense
DimDepense <- merge_nkl(DimDepense, COICOP, by.x="COICOP_04", by.y="COICOP4ID")


# -----------------------------------------------------------------------------
# RESSOURCES
# Ajout des libellés décrivant la nature et les conditions des ressources
# -----------------------------------------------------------------------------

DimRessource <- readCube("DimRessource")
DimRessource <- merge_nkl(DimRessource, readCube("NKLTypeRessource"), "TypeRessourceID")
DimRessource <- merge_nkl(DimRessource, readCube("NKLRessource"), "RessourceID")
DimRessource <- merge_nkl(DimRessource, readCube("NKLActivite"), "ActID")
DimRessource <- merge_nkl(DimRessource, readCube("NKLTempsComplet"), "TempsCompletID")
DimRessource <- merge_nkl(DimRessource, readCube("NKLStatutProfession"), "StatutProfessionID")


# -----------------------------------------------------------------------------
# INDIVIDUS
# Ajout des principales caractéristiques socio-démographiques
# -----------------------------------------------------------------------------

DimIndividu <- readCube("DimIndividu")
DimIndividu <- merge_nkl(DimIndividu, readCube("NKLActif"), "ActifID")
DimIndividu <- merge_nkl(DimIndividu, readCube("NKLLieuNaissance"), "LieuNaissanceID")
DimIndividu <- merge_nkl(DimIndividu, readCube("NKLStatutOccupation"), "StatutOccupation3ID")
DimIndividu <- merge_nkl(DimIndividu, readCube("NKLStatutMatrimonial"), "StatutMatrimonialID")
DimIndividu <- merge_nkl(DimIndividu, readCube("NKLPlusHautDiplome"), "PlusHautDiplomeID")
DimIndividu <- merge_nkl(DimIndividu, readCube("NKLClassificationPro"), "ClassificationProID")
DimIndividu <- merge_nkl(DimIndividu, readCube("NKLCouvertureSante"), "CouvertureSanteID")
DimIndividu <- merge_nkl(DimIndividu, readCube("NKLDispositifGratuiteSoin"), "DispositifGratuiteSoinID")


# -----------------------------------------------------------------------------
# MENAGES
# Ajout des caractéristiques géographiques, familiales et de logement
# -----------------------------------------------------------------------------

DimMenage <- readCube("DimMenage")

# Géographie : sélection et renommage des colonnes afin d'éviter les collisions
nkl <- readCube("NKLSubdivision")[, .(SubdivisionID=IDSub, SubdivisionLib=Subdivision)]
DimMenage <- merge_nkl(DimMenage, nkl, "SubdivisionID")

nkl <- readCube("NKLIle")[, .(IleID=IDIle, IleLib=Ile)]
DimMenage <- merge_nkl(DimMenage, nkl, "IleID")

nkl <- readCube("NKLComas")[, .(ComasID=IDComas, ComasLib=Comas, CommuneLib=Commune)]
DimMenage <- merge_nkl(DimMenage, nkl, "ComasID")

# Composition du ménage et conditions de logement
DimMenage <- merge_nkl(DimMenage, readCube("NKLTypeMenage"), "TypeMenageID")
DimMenage <- merge_nkl(DimMenage, readCube("NKLCSPMenage"), "CSPMenageID")
DimMenage <- merge_nkl(DimMenage, readCube("NKLMenageComplexe"), "MenageComplexeID")
DimMenage <- merge_nkl(DimMenage, readCube("NKLTypeConstructionResPrincipale"), "TypeConstructionResPrincipaleID")
DimMenage <- merge_nkl(DimMenage, readCube("NKLTypeChauffeEau"), "TypeChauffeEauID")
DimMenage <- merge_nkl(DimMenage, readCube("NKLEauBuvable"), "EauBuvableID")
DimMenage <- merge_nkl(DimMenage, readCube("NKLRamassageOrdure"), "RamassageOrdureID")
DimMenage <- merge_nkl(DimMenage, readCube("NKLEvacuationEauxUsees"), "EvacuationEauxUseesID")
DimMenage <- merge_nkl(DimMenage, readCube("NKLAutreSourceElectricite"), "AutreSourceElectriciteID")
DimMenage <- merge_nkl(DimMenage, readCube("NKLStatutPropriete"), "StatutProprieteID")
DimMenage <- merge_nkl(DimMenage, readCube("NKLEmpruntLogement"), "EmpruntLogementID")
DimMenage <- merge_nkl(DimMenage, readCube("NKLDestinataireLoyer"), "DestinataireLoyerID")


# -----------------------------------------------------------------------------
# NETTOYAGE ET SAUVEGARDE
# Fermeture de la connexion et création des fichiers d'entrée des analyses
# -----------------------------------------------------------------------------

dbDisconnect(conSQL)

rm(conSQL)
rm(nkl)
rm(NKLLieuGeo)
rm(COICOP03)
rm(COICOP03_nd)
rm(COICOP04)

saveRDS(DimDepense, "input/DimDepense.rds")
saveRDS(DimMenage, "input/DimMenage.rds")
saveRDS(DimIndividu, "input/DimIndividu.rds")
saveRDS(DimRessource, "input/DimRessource.rds")