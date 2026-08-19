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
