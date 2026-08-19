source("src/functions.R")

#source("src/1. generateData.R")

# ca serait pas de rajouter du code qui corrige ce bug

fwrite(DATA[, .N, profession], "output/tab2.csv")

