source("src/functions.R")

source("src/1. generateData.R")
source("src/2. analyse data.R")
source("src/3. ggplot.R")

fwrite(DATA[, .N, profession], "output/tab2.csv")

source("src/4. metadonnees.R")
