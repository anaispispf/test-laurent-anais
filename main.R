source("src/functions.R")

#source("src/1. generateData.R")

DATA <- fread("input/gens.csv")
fwrite(DATA[, .N, profession], "output/tab1.csv")
