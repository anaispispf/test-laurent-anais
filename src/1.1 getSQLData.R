conSQL <- dbConnect(odbc::odbc(), Driver = "SQL Server", Server = "sql" ,Database = "EBF2025")

readCube <- function(table) setDT(dbReadTable(conSQL, Id("CUBE", table)))
merge_nkl <- function(x, nkl, by.x, by.y=by.x) {
  if (anyDuplicated(nkl[[by.y]])) stop("Clé non unique : ", by.y)
  x <- merge(x, nkl, by.x=by.x, by.y=by.y, all.x=TRUE, sort=FALSE)
  if (anyDuplicated(names(x))) stop("Colonnes dupliquées : ", paste(names(x)[duplicated(names(x))], collapse=", "))
  x
}


DimDepense <- readCube("DimDepense")
n <- nrow(DimDepense)

DimDepense <- merge_nkl(DimDepense, readCube("NKLEtatProduit"), "EtatProduitID")
DimDepense <- merge_nkl(DimDepense, readCube("NKLConditionnementProduit"), "ConditionnementProduitID")
DimDepense <- merge_nkl(DimDepense, readCube("NKLModePaiement"), "ModePaiementID")
DimDepense <- merge_nkl(DimDepense, readCube("NKLDestinationDepense"), "DestinationDepenseID")
DimDepense <- merge_nkl(DimDepense, readCube("NKLOrigineProduitAutoconso"), "OrigineProduitAutoconsoID")
DimDepense <- merge_nkl(DimDepense, readCube("NKLDestinationVoyage"), "DestinationVoyageID")
DimDepense <- merge_nkl(DimDepense, readCube("NKLTypeMagasin"), "TypeMagasinID")
DimDepense <- merge_nkl(DimDepense, readCube("NKLTypeCeremonie"), "TypeCeremonieID")
NKLLieuGeo <- readCube("NKLLieuGeo")
NKLLieuGeo[, LieuGeoID := as.integer(LieuGeoID)]
DimDepense <- merge_nkl(DimDepense, NKLLieuGeo, "LieuGeoID")


COICOP04 <- setDT(dbReadTable(conSQL, Id("NKL", "COICOP2018_04")))
COICOP03 <- setDT(dbReadTable(conSQL, Id("NKL", "COICOP2018_03")))

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

COICOP <- rbindlist(list(COICOP04, COICOP03_nd), use.names=TRUE, fill=TRUE)
COICOP <- unique(COICOP)

DimDepense <- merge_nkl(DimDepense, COICOP, by.x="COICOP_04", by.y="COICOP4ID")



DimRessource <- readCube("DimRessource")
n <- nrow(DimRessource)

DimRessource <- merge_nkl(DimRessource, readCube("NKLTypeRessource"), "TypeRessourceID")
DimRessource <- merge_nkl(DimRessource, readCube("NKLRessource"), "RessourceID")
DimRessource <- merge_nkl(DimRessource, readCube("NKLActivite"), "ActID")
DimRessource <- merge_nkl(DimRessource, readCube("NKLTempsComplet"), "TempsCompletID")
DimRessource <- merge_nkl(DimRessource, readCube("NKLStatutProfession"), "StatutProfessionID")

stopifnot(nrow(DimRessource) == n)



DimIndividu <- readCube("DimIndividu")
n <- nrow(DimIndividu)

DimIndividu <- merge_nkl(DimIndividu, readCube("NKLActif"), "ActifID")
DimIndividu <- merge_nkl(DimIndividu, readCube("NKLLieuNaissance"), "LieuNaissanceID")
DimIndividu <- merge_nkl(DimIndividu, readCube("NKLStatutOccupation"), "StatutOccupation3ID")
DimIndividu <- merge_nkl(DimIndividu, readCube("NKLStatutMatrimonial"), "StatutMatrimonialID")
DimIndividu <- merge_nkl(DimIndividu, readCube("NKLPlusHautDiplome"), "PlusHautDiplomeID")
DimIndividu <- merge_nkl(DimIndividu, readCube("NKLClassificationPro"), "ClassificationProID")
DimIndividu <- merge_nkl(DimIndividu, readCube("NKLCouvertureSante"), "CouvertureSanteID")
DimIndividu <- merge_nkl(DimIndividu, readCube("NKLDispositifGratuiteSoin"), "DispositifGratuiteSoinID")


DimMenage <- readCube("DimMenage")
n <- nrow(DimMenage)

# Géographie : sélection des colonnes pour éviter les collisions
nkl <- readCube("NKLSubdivision")[, .(SubdivisionID=IDSub, SubdivisionLib=Subdivision)]
DimMenage <- merge_nkl(DimMenage, nkl, "SubdivisionID")

nkl <- readCube("NKLIle")[, .(IleID=IDIle, IleLib=Ile)]
DimMenage <- merge_nkl(DimMenage, nkl, "IleID")

nkl <- readCube("NKLComas")[, .(ComasID=IDComas, ComasLib=Comas, CommuneLib=Commune)]
DimMenage <- merge_nkl(DimMenage, nkl, "ComasID")

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

stopifnot(nrow(DimMenage) == n)


# ============================================================
# CONTROLE FINAL
# ============================================================

stopifnot(!anyDuplicated(names(DimDepense)))
stopifnot(!anyDuplicated(names(DimRessource)))
stopifnot(!anyDuplicated(names(DimIndividu)))
stopifnot(!anyDuplicated(names(DimMenage)))



saveRDS(DimDepense, "input/DimDepense.rds")
saveRDS(DimMenage, "input/DimMenage.rds")
saveRDS(DimIndividu, "input/DimIndividu.rds")
saveRDS(DimRessource, "input/DimRessource.rds")