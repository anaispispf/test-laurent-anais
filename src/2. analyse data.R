DATA <- fread("input/gens.csv")
fwrite(DATA[, .N, sexe], "output/tab1.csv")
fwrite(DATA[, .N, profession], "output/tab2.csv")

DATA[sexe=="Femme" & profession=="Agriculteur"]
DATA[profession %like% "gri"]

DATA[age<=25, .(profession, sexe, age2=100*age)]
DATA[, age2:=age*7]
DATA[, div3:=id%%3]

DATA[, .N, .(profession, sexe)]
DATA[, .(Effectifs=.N, AgeMin=min(age), AgeMax=max(age)), .(profession, sexe)][profession=="Artisan"]

DATA_MELT <- melt(DATA, id.vars = "id")
dcast(DATA_MELT, id~variable)
 