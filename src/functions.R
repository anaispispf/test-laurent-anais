library(data.table)
library(ini)

# Nombre de personnes
n <- 1000



generateFausseDonnes <- function() {
  
  dt <- data.table(
  id = 1:n,
  age = sample(18:80, n, replace = TRUE),
  sexe = sample(
    c("Femme", "Homme"),
    n,
    replace = TRUE,
    prob = c(0.52, 0.48)
  ),
  profession = sample(
    c("Enseignant", "Ingénieur", "Médecin", "Commerçant",
      "Avocat", "Informaticien", "Agriculteur", "Étudiant",
      "Artisan", "Retraité"),
    n,
    replace = TRUE
  ))
  dt
}
