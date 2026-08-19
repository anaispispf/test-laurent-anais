G1 <- ggplot(DATA, aes(x = profession)) +
  geom_bar(fill = "steelblue") +
  labs(
    title = "Répartition des personnes par profession",
    x = "Profession",
    y = "Nombre de personnes"
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )
ggsave("output/repartition_profession.png", G1, width = 8, height = 5)

G2 <- ggplot(DATA, aes(x = sexe, fill = sexe)) +
  geom_bar() +
  labs(
    title = "Répartition des personnes par sexe",
    x = "Sexe",
    y = "Nombre de personnes"
  ) +
  scale_fill_manual(values = c("Femme" = "#e75480", "Homme" = "steelblue")) +
  theme_minimal() +
  theme(legend.position = "none")
ggsave("output/repartition_sexe.png", G2, width = 6, height = 5)
