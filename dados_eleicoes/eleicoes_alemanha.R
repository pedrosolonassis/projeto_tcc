#criação do gráfico de votos alemanha
alevotos_2021_2025 <- data.frame(
  party = c("AfD", "AfD", "CDU", "CDU", "CSU", "CSU", "DL", "DL", "FDP", "FDP", "Grünen", "Grünen", "SPD", "SPD"),
  electionyear = c(2021, 2025, 2021, 2025, 2021, 2025, 2021, 2025, 2021, 2025, 2021, 2025, 2021, 2025),
  vote = c(10.4, 20.8, 19.0, 22.6, 5.2, 6.0, 4.9, 8.8, 11.5, 4.3, 14.7, 11.6, 25.7, 16.4)
)

# Votos de 2017 e 2013

alevotos_2017 <- data.frame(
  party = c("AfD", "CDU", "CSU", "FDP", "Grünen", "LINKE", "SPD"),
  electionyear = 2017,
  vote = c(12.6, 26.8, 6.2, 10.7, 8.9, 9.2, 20.5) 
)

alevotos_2013 <- data.frame(
  party = c("AfD", "CDU", "CSU", "FDP", "Grünen", "LINKE", "SPD"),
  electionyear = 2013,
  vote = c(4.7, 34.1, 7.4, 4.8, 8.4, 8.6, 25.7)
)

ale_eleiçao <- bind_rows(alevotos_2021_2025, alevotos_2017, alevotos_2013)

# Ajuste de dados
ale_eleiçao <- ale_eleiçao %>%
  mutate(
    party = case_when(
      party == "DL" | party == "LINKE" ~ "Linke/DL",
      TRUE ~ party
    )
  ) %>%
  filter(!is.na(party) & party != "") %>%
  # Configurar a posição dos rótulos
  mutate(
    v_ajustado = case_when(
      (electionyear == 2013 & party == "AfD") ~ 2.0,
      (electionyear == 2017 & party == "AfD") ~ -1.0,
      (electionyear == 2021 & party == "AfD") ~ 2.0,
      (electionyear == 2025 & party == "AfD") ~ -1.0,
      (electionyear == 2013 & party == "CDU") ~ -1.0,
      (electionyear == 2017 & party == "CDU") ~ -1.0,
      (electionyear == 2021 & party == "CDU") ~ -1.0,
      (electionyear == 2025 & party == "CDU") ~ -1.0,
      (electionyear == 2013 & party == "CSU") ~ 1.5,
      (electionyear == 2017 & party == "CSU") ~ -1.0,
      (electionyear == 2021 & party == "CSU") ~ -1.0,
      (electionyear == 2025 & party == "CSU") ~ -1.0,
      (electionyear == 2013 & party == "FDP") ~ -1.0,
      (electionyear == 2017 & party == "FDP") ~ -1.0,
      (electionyear == 2021 & party == "FDP") ~ -1.0,
      (electionyear == 2025 & party == "FDP") ~ -1.0,
      (electionyear == 2013 & party == "Grünen") ~ 1.2,
      (electionyear == 2017 & party == "Grünen") ~ 1.8,
      (electionyear == 2021 & party == "Grünen") ~ -1.0,
      (electionyear == 2025 & party == "Grünen") ~ -1.0,
      (electionyear == 2013 & party == "Linke/DL") ~ -1.0,
      (electionyear == 2017 & party == "Linke/DL") ~ -0.8,
      (electionyear == 2021 & party == "Linke/DL") ~ 1.7,
      (electionyear == 2025 & party == "Linke/DL") ~ -1.0,
      (electionyear == 2013 & party == "SPD") ~ -1.0,
      (electionyear == 2017 & party == "SPD") ~ -1.0,
      (electionyear == 2021 & party == "SPD") ~ -1.0,
      (electionyear == 2025 & party == "SPD") ~ -1.0,
      TRUE ~ 0.5
    ))

# cores
cores_alemanha <- c(
  "AfD" = "dodgerblue",
  "CDU" = "black",
  "CSU" = "darkblue",
  "FDP" = "darkgoldenrod",
  "Grünen" = "darkgreen",
  "Linke/DL" = "purple",
  "SPD" = "red"
)

# Criar o gráfico de linhas com as cores ajustadas
grafico_eleiçoesale <- ggplot(ale_eleiçao, aes(x = as.factor(electionyear), y = vote, group = party, color = party)) +
  # Adicionar as linhas e os pontos
  geom_line(linewidth = 1) +
  geom_point(size = 3) +
  # Adicionar os rótulos de voto com ajuste vertical
  geom_text(aes(label = vote, vjust = v_ajustado), 
            size = 4,
            show.legend = FALSE) + 
  # Aplicação do esquema de cores manual
  scale_color_manual(values = cores_alemanha) +
  # Títulos e rótulos
  labs(
    title = "Votos nas eleições legislativas da Alemanha entre 2013 e 2025 (%)",
    x = NULL, 
    y = NULL, 
    color = "Partidos" 
  ) +
  
  scale_y_continuous(
    breaks = seq(0, 35, by = 5), 
    limits = c(0, max(ale_eleiçao$vote) * 1.05) 
  ) +
  
  # Tema
  theme_minimal() +
  
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16),
    axis.text.x = element_text(angle = 0, hjust = 0.5, size = 12),
    axis.text.y = element_text(size = 12),
    panel.grid.minor = element_blank(),
    legend.title = element_text(face = "bold"),
    legend.text = element_text(size = 10),

axis.line = element_line(colour = "black", linewidth = 1)
)

print(grafico_eleiçoesale)

#criação do gráfico de assentos Alemanha
aleassentos_2021_2025 <- data.frame(
  party = c("AfD", "AfD", "CDU", "CDU", "CSU", "CSU", "DL", "DL", "FDP", "FDP", "Grünen", "Grünen", "SPD", "SPD"),
  electionyear = c(2021, 2025, 2021, 2025, 2021, 2025, 2021, 2025, 2021, 2025, 2021, 2025, 2021, 2025),
  seat = c(83, 152, 152, 164, 45, 44, 39, 64, 92, 0, 118, 85, 206, 120)
)

aleassentos_2017 <- data.frame(
  party = c("AfD", "CDU", "CSU", "FDP", "Grünen", "LINKE", "SPD"),
  electionyear = 2017,
  seat = c(94, 200, 46, 80, 67, 69, 153) 
)

aleassentos_2013 <- data.frame(
  party = c("AfD", "CDU", "CSU", "FDP", "Grünen", "LINKE", "SPD"),
  electionyear = 2013,
  seat = c(0, 255, 56, 0, 63, 64, 193)
)

ale_assentos <- bind_rows(aleassentos_2021_2025, aleassentos_2017, aleassentos_2013)

# Ajuste de dados
ale_assentos <- ale_assentos %>%
  mutate(
    party = case_when(
      party == "DL" | party == "LINKE" ~ "Linke/DL",
      TRUE ~ party
    )
  ) %>%
  filter(!is.na(party) & party != "") %>%
  mutate(
    # Ajuste Vertical
    v_ajustado = case_when(
      (electionyear == 2013 & party == "AfD") ~ -1.0,
      (electionyear == 2017 & party == "AfD") ~ -1.2,
      (electionyear == 2021 & party == "AfD") ~ 2.0,
      (electionyear == 2025 & party == "AfD") ~ 2.0,
      (electionyear == 2013 & party == "CDU") ~ -1.0,
      (electionyear == 2017 & party == "CDU") ~ -1.0,
      (electionyear == 2021 & party == "CDU") ~ -1.0,
      (electionyear == 2025 & party == "CDU") ~ -1.0,
      (electionyear == 2013 & party == "CSU") ~ 1.8,
      (electionyear == 2017 & party == "CSU") ~ 2.0,
      (electionyear == 2021 & party == "CSU") ~ -1.0,
      (electionyear == 2025 & party == "CSU") ~ -1.0,
      (electionyear == 2013 & party == "FDP") ~ 1.8,
      (electionyear == 2017 & party == "FDP") ~ -1.0,
      (electionyear == 2021 & party == "FDP") ~ -1.0,
      (electionyear == 2025 & party == "FDP") ~ -1.0,
      (electionyear == 2013 & party == "Grünen") ~ 0.5,
      (electionyear == 2017 & party == "Grünen") ~ 1.8,
      (electionyear == 2021 & party == "Grünen") ~ -1.0,
      (electionyear == 2025 & party == "Grünen") ~ -1.0,
      (electionyear == 2013 & party == "Linke/DL") ~ -1.0,
      (electionyear == 2017 & party == "Linke/DL") ~ -0.7,
      (electionyear == 2021 & party == "Linke/DL") ~ 1.7,
      (electionyear == 2025 & party == "Linke/DL") ~ -1.0,
      (electionyear == 2013 & party == "SPD") ~ -1.0,
      (electionyear == 2017 & party == "SPD") ~ -1.0,
      (electionyear == 2021 & party == "SPD") ~ -1.0,
      (electionyear == 2025 & party == "SPD") ~ -1.0,
      TRUE ~ 0.5
    ),
    
    # Ajuste Horizontal
    h_ajustado = case_when(
      (electionyear == 2013 & party == "Grünen") ~ 1.8,
      TRUE ~ 0.5
    )
  )

cores_alemanha<- c(
  "AfD" = "dodgerblue",
  "CDU" = "black",
  "CSU" = "darkblue",
  "FDP" = "darkgoldenrod",
  "Grünen" = "darkgreen", 
  "Linke/DL" = "purple",
  "SPD" = "red"            
)


# Criar o gráfico de linhas com os assentos
grafico_assentosale <- ggplot(ale_assentos, aes(x = as.factor(electionyear), y = seat, group = party, color = party)) +
  
  geom_line(linewidth = 1) +
  geom_point(size = 3) +
  
  geom_text(aes(label = seat, vjust = v_ajustado, hjust = h_ajustado), 
            size = 4,
            family = "serif") + 
  
  scale_color_manual(values = cores_alemanha) +
  
  labs(
    title = "Assentos conquistados pelos partidos nas eleições legislativas da Alemanha (2013-2025)",
    x = NULL, 
    y = NULL, 
    color = "Partidos" 
  ) +
  
  # Ajustar a escala do eixo Y
  scale_y_continuous(
    breaks = seq(0, 300, by = 50), 
    limits = c(0, max(ale_assentos$seat) * 1.1) 
  ) +
  
  # Tema
  theme_minimal() +

  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16),
    axis.text.x = element_text(angle = 0, hjust = 0.5, size = 12),
    axis.text.y = element_text(size = 12),
    panel.grid.minor = element_blank(),
    legend.title = element_text(face = "bold"),
    legend.text = element_text(size = 10),
    
    axis.line = element_line(colour = "black", linewidth = 1)
  )

print(grafico_assentosale)