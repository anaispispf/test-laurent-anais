DimDepense   <- readRDS("input/DimDepense.rds")
DimMenage    <- readRDS("input/DimMenage.rds")
DimIndividu  <- readRDS("input/DimIndividu.rds")
DimRessource <- readRDS("input/DimRessource.rds")


DepenseMenage <- DimDepense[, .(DepenseAnnuelle=sum(MontantAnnuel, na.rm=TRUE), DepenseAnnuellePondere=sum(MontantAnnuelPondere, na.rm=TRUE)),by=MenageID]
DepenseMenage <- merge(DepenseMenage, DimMenage, by="MenageID",all.x=TRUE, sort=FALSE)

DepenseMenage[, DepenseMensuelle := DepenseAnnuelle/12]
DepenseMenage[, DepenseMensuelleUC := DepenseMensuelle/UC]
DepenseMenage[, DepenseMensuelleUCoxford := DepenseMensuelle/UCoxford]

RessourceMenage <- DimRessource[,.(RessourceAnnuelle=sum(RessourceAnnuelle, na.rm=TRUE)),by=MenageID]
RessourceMenage <- merge(RessourceMenage,DimMenage[, .(MenageID, PonderationMenage, UC, UCoxford)], by="MenageID",all.x=TRUE, sort=FALSE)
RessourceMenage[, RevenuMensuel := RessourceAnnuelle/12]
RessourceMenage[, RevenuMensuelUC := RevenuMensuel/UC]
RessourceMenage[, RevenuMensuelUCoxford := RevenuMensuel/UCoxford]



bornes <- wquantile(RessourceMenage$RevenuMensuelUC,RessourceMenage$PonderationMenage,probs=seq(0,1,0.2))
bornes <- unique(bornes)
RessourceMenage[, QuintileRevenu := cut(RevenuMensuelUC, breaks=bornes, include.lowest=TRUE, labels=paste0("Q", seq_len(length(bornes)-1)))]


# Ajout du niveau de vie aux dépenses
DimDepense <- merge(DimDepense, RessourceMenage[, .(MenageID, RevenuMensuel, RevenuMensuelUC, RevenuMensuelUCoxford, QuintileRevenu)],
                    by="MenageID", all.x=TRUE,sort=FALSE)
