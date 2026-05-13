# Dataframe de votos para as eleições francesas (2012, 2017)
fravotos_2019_2014 <- data.frame(
  party = c("EELV", "EELV", "FI", "FN", "RN", "UMP", "LR", "LREM", "MODEM", "MoDem", "PS", "PS"),
  electionyear = c(2012, 2017, 2017, 2012, 2017, 2012, 2017, 2017, 2012, 2017, 2012, 2017),
  vote = c(5.5, 4.3, 11.0, 13.6, 13.2, 27.1, 15.8, 28.2, 1.8, 4.1, 29.3, 7.4))

fra_eleiçao <- bind_rows(fravotos_2019_2014)

# Ajuste de dados
fra_eleiçao <- fra_eleiçao %>%
  # Renomear partidos
  mutate(
    party = case_when(
      party == "FN" | party == "RN" ~ "FN/RN",
      TRUE ~ party
    )
  ) %>%
mutate(
  party = case_when(
    party == "MODEM" | party == "MoDem" ~ "MODEM",
    TRUE ~ party
  )
) %>%
mutate(
  party = case_when(
    party == "UMP" | party == "LR" ~ "UMP/LR",
    TRUE ~ party
  )
) %>%
  filter(!is.na(party) & party != "") %>%
  # Configurar a posição dos rótulos
  mutate(
    v_ajustado = case_when(
      (electionyear == 2012 & party == "EELV") ~ -1.5,
      (electionyear == 2017 & party == "EELV") ~ -1.0,
      (electionyear == 2017 & party == "FI") ~ -1.2,
      (electionyear == 2012 & party == "FN/RN") ~ -1.0,
      (electionyear == 2017 & party == "FN/RN") ~ -1.0,
      (electionyear == 2012 & party == "UMP/LR") ~ -1.0,
      (electionyear == 2017 & party == "UMP/LR") ~ -1.5,
      (electionyear == 2017 & party == "LREM") ~ -1.0,
      (electionyear == 2012 & party == "MODEM") ~ -1.5,
      (electionyear == 2017 & party == "MODEM") ~ 1.7,
      (electionyear == 2012 & party == "PS") ~ -1.0,
      (electionyear == 2017 & party == "PS") ~ 1.8,
      TRUE ~ 0.5
    ))

# Cores
cores_frança <- c(
  "EELV" = "#50B848",    
  "FI" = "#990000",           
  "FN/RN" = "darkblue",        
  "UMP/LR" = "#0066CC",   
  "LREM" = "#C9AE00",   
  "MODEM" = "#FF8C00",     
  "PS" = "red"              
)

# Criar o gráfico de linhas
grafico_eleiçoesfra <- ggplot(fra_eleiçao, aes(x = as.factor(electionyear), y = vote, group = party, color = party)) +
  
  # Adicionar as linhas e os pontos
  geom_line(linewidth = 1) +
  geom_point(size = 3) +
  
  # Adicionar os rótulos de valor com ajuste de posição
  geom_text(aes(label = vote, vjust = v_ajustado), 
            size = 4, family = "serif") + 
  
  scale_color_manual(values = cores_frança) +
  
  # Títulos e rótulos
  labs(
    title = "Votos nas eleições legislativas da França entre 2012 e 2017 (%)",
    x = NULL, 
    y = NULL, 
    color = "Partidos" 
  ) +
  
  # Ajustar a escala do eixo Y
  scale_y_continuous(
    breaks = seq(0, 45, by = 10), 
    limits = c(0, max(fra_eleiçao$vote) * 1.05) 
  ) +
  
  # Tema
  theme_minimal() +
  
  # Ajustar a aparência
  theme(
    text = element_text(family = "serif"),
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16, family = "serif"),
    axis.text.x = element_text(size = 12, family = "serif"),
    axis.text.y = element_text(size = 12, family = "serif"),
    legend.text = element_text(size = 10, family = "serif"),
    
    # Destaque dos eixos X e Y em preto
    axis.line = element_line(colour = "black", linewidth = 1)
  )

print(grafico_eleiçoesfra)


#criação do gráfico de votos frança
fraassentos_2019_2014 <- data.frame(
  party = c("EELV", "EELV", "FI", "FN", "RN", "UMP", "LR", "LREM", "MODEM", "MoDem", "PS", "PS"),
  electionyear = c(2012, 2017, 2017, 2012, 2017, 2012, 2017, 2017, 2012, 2017, 2012, 2017),
  seat = c(17, 1, 17, 2, 8, 194, 112, 308, 2, 42, 280, 30))

fra_assentos <- bind_rows(fraassentos_2019_2014)

# Ajuste de dados
fra_assentos <- fra_assentos %>%
  # Renomear os partidos
  mutate(
    party = case_when(
      party == "FN" | party == "RN" ~ "FN/RN",
      TRUE ~ party
    )
  ) %>%
  mutate(
    party = case_when(
      party == "MODEM" | party == "MoDem" ~ "MODEM",
      TRUE ~ party
    )
  ) %>%
  mutate(
    party = case_when(
      party == "UMP" | party == "LR" ~ "UMP/LR",
      TRUE ~ party
    )
  ) %>%
  filter(!is.na(party) & party != "") %>%
  # Configurar a posição dos rótulos
  mutate(
    v_ajustado = case_when(
      (electionyear == 2012 & party == "EELV") ~ -1.0,
      (electionyear == 2017 & party == "EELV") ~ 1.7,
      (electionyear == 2017 & party == "FI") ~ -0.6,
      (electionyear == 2012 & party == "FN/RN") ~ -0.9,
      (electionyear == 2017 & party == "FN/RN") ~ 0,
      (electionyear == 2012 & party == "UMP/LR") ~ -1.0,
      (electionyear == 2017 & party == "UMP/LR") ~ -1.0,
      (electionyear == 2017 & party == "LREM") ~ -1.0,
      (electionyear == 2012 & party == "MODEM") ~ 1.8,
      (electionyear == 2017 & party == "MODEM") ~ -1.0,
      (electionyear == 2012 & party == "PS") ~ -1.0,
      (electionyear == 2017 & party == "PS") ~ 0,
      TRUE ~ 0.5
    ),
    # Ajuste Horizontal
    h_ajustado = case_when(
      (electionyear == 2017 & party == "PS") ~ -0.5,
      (electionyear == 2017 & party == "FN/RN") ~ -0.8,
      TRUE ~ 0.5
    ))

# Cores
cores_frança <- c(
  "EELV" = "#50B848",    
  "FI" = "#990000",           
  "FN/RN" = "darkblue",        
  "UMP/LR" = "#0066CC",   
  "LREM" = "#C9AE00",   
  "MODEM" = "#FF8C00",     
  "PS" = "red"              
)

# Criar o gráfico de linhas
grafico_assentosfra <- ggplot(fra_assentos, aes(x = as.factor(electionyear), y = seat, group = party, color = party)) +
  
  # Adicionar as linhas e os pontos
  geom_line(linewidth = 1) +
  geom_point(size = 3) +
  
  # Adicionar os rótulos de valor com ajuste de posição
  geom_text(aes(label = seat, vjust = v_ajustado, hjust = h_ajustado), 
            size = 4, family = "serif") + 
  
  scale_color_manual(values = cores_frança) +
  
  # Títulos e rótulos
  labs(
    title = "Assentos conquistados pelos partidos nas eleições legislativas da França (2012-2017)",
    x = NULL, 
    y = NULL, 
    color = "Partidos" 
  ) +
  
  # Ajustar a escala do eixo Y
  scale_y_continuous(
    breaks = seq(0, 310, by = 50), 
    limits = c(0, max(fra_assentos$seat) * 1.05) 
  ) +
  
  # Tema
  theme_minimal() +
  
  # Ajustar a aparência
  theme(
    text = element_text(family = "serif"),
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16, family = "serif"),
    axis.text.x = element_text(size = 12, family = "serif"),
    axis.text.y = element_text(size = 12, family = "serif"),
    legend.text = element_text(size = 10, family = "serif"),
    
    # Destaque dos eixos X e Y em preto
    axis.line = element_line(colour = "black", linewidth = 1)
  )

print(grafico_assentosfra)


#criação do gráfico de votos frança (2022 e 2024)
fravotos_2022_2024 <- data.frame(
  party = c("RN", "RN", "LR", "LR", "Ensemble", "Ensemble", "NUPES", "NFP"),
  electionyear = c(2022, 2024, 2022, 2024, 2022, 2024, 2022, 2024),
  vote = c(18.7, 29.3, 10.4, 6.6, 25.7, 20.0, 25.7, 28.0))

fra_eleiçao_2022_2024 <- bind_rows(fravotos_2022_2024)

# 2. Ajuste de dados (Agrupar FN e RN e ajuste de rótulos)
fra_eleiçao_2022_2024 <- fra_eleiçao_2022_2024 %>%
  # Renomear partidos
  mutate(
    party = case_when(
      party == "NUPES" | party == "NFP" ~ "NUPES/NFP",
      TRUE ~ party
    )
  ) %>%
  filter(!is.na(party) & party != "") %>%
  # Configurar a posição dos rótulos
  mutate(
    v_ajustado = case_when(
      (electionyear == 2022 & party == "NUPES/NFP") ~ -1.0,
      (electionyear == 2024 & party == "NUPES/NFP") ~ 1.8,
      (electionyear == 2022 & party == "Ensemble") ~ 1.5,
      (electionyear == 2024 & party == "Ensemble") ~ -1.0,
      (electionyear == 2022 & party == "RN") ~ -1.0,
      (electionyear == 2024 & party == "RN") ~ -1.0,
      (electionyear == 2022 & party == "LR") ~ -1.0,
      (electionyear == 2024 & party == "LR") ~ -1.0,
      TRUE ~ 0.5
    ))

# Cores
cores_frança_2022 <- c(
  "RN" = "darkblue",        
  "LR" = "#0066CC",   
  "Ensemble" = "#C9AE00",
  "NUPES/NFP" = "red" )

# Criar o gráfico de linhas com as cores ajustadas
grafico_eleiçoesfra_2022 <- ggplot(fra_eleiçao_2022_2024, aes(x = as.factor(electionyear), y = vote, group = party, color = party)) +
  
  # Adicionar as linhas e os pontos
  geom_line(linewidth = 1) +
  geom_point(size = 3) +
  
  # Adicionar os rótulos de valor com ajuste de posição
  geom_text(aes(label = vote, vjust = v_ajustado), 
            size = 4,
            show.legend = FALSE) + 
  
  scale_color_manual(values = cores_frança_2022) +
  
  # Títulos e rótulos
  labs(
    title = "Votos nas eleições legislativas da França entre 2022 e 2024 (%)",
    x = NULL, 
    y = NULL, 
    color = "Partidos" 
  ) +
  
  # Ajustar a escala do eixo Y
  scale_y_continuous(
    breaks = seq(0, 40, by = 10), 
    limits = c(0, max(fra_eleiçao_2022_2024$vote) * 1.05) 
  ) +
  
  # Tema
  theme_minimal() +
  
  # Ajustar a aparência
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16),
    axis.text.x = element_text(angle = 0, hjust = 0.5, size = 12),
    axis.text.y = element_text(size = 12),
    panel.grid.minor = element_blank(),
    legend.title = element_text(face = "bold"),
    legend.text = element_text(size = 10),
    
    # Destaque dos eixos X e Y em preto
    axis.line = element_line(colour = "black", linewidth = 1)
  )

print(grafico_eleiçoesfra_2022)


#criação do gráfico de assentos frança (2022 e 2024)
fraassentos_2022_2024 <- data.frame(
  party = c("RN", "RN", "LR", "LR", "Ensemble", "Ensemble", "NUPES", "NFP"),
  electionyear = c(2022, 2024, 2022, 2024, 2022, 2024, 2022, 2024),
  seat = c(89, 125, 61, 39, 245, 150, 131, 178))

fra_assentos_2022_2024 <- bind_rows(fraassentos_2022_2024)

# Ajuste de dados
fra_assentos_2022_2024 <- fra_assentos_2022_2024 %>%
  # Renomear partidos
  mutate(
    party = case_when(
      party == "NUPES" | party == "NFP" ~ "NUPES/NFP",
      TRUE ~ party
    )
  ) %>%
  filter(!is.na(party) & party != "") %>%
  # Configurar a posição dos rótulos
  mutate(
    v_ajustado = case_when(
      (electionyear == 2022 & party == "NUPES/NFP") ~ -1.0,
      (electionyear == 2024 & party == "NUPES/NFP") ~ -1.0,
      (electionyear == 2022 & party == "Ensemble") ~ -1.0,
      (electionyear == 2024 & party == "Ensemble") ~ -1.0,
      (electionyear == 2022 & party == "RN") ~ -1.0,
      (electionyear == 2024 & party == "RN") ~ -1.0,
      (electionyear == 2022 & party == "LR") ~ -1.0,
      (electionyear == 2024 & party == "LR") ~ -1.0,
      TRUE ~ 0.5
    ))

# Cores
cores_frança_2022 <- c(
  "RN" = "darkblue",        
  "LR" = "#0066CC",   
  "Ensemble" = "#C9AE00",
  "NUPES/NFP" = "red" )

# Criar o gráfico de linhas com as cores ajustadas
grafico_assentosfra_2022 <- ggplot(fra_assentos_2022_2024, aes(x = as.factor(electionyear), y = seat, group = party, color = party)) +
  
  # Adicionar as linhas e os pontos
  geom_line(linewidth = 1) +
  geom_point(size = 3) +
  
  # Adicionar os rótulos de valor com ajuste de posição
  geom_text(aes(label = seat, vjust = v_ajustado), 
            size = 4,
            show.legend = FALSE) + 
  
  scale_color_manual(values = cores_frança_2022) +
  
  # Títulos e rótulos
  labs(
    title = "Assentos conquistados pelos partidos nas eleições legislativas da França (2022-2024)",
    x = NULL, 
    y = NULL, 
    color = "Partidos" 
  ) +
  
  scale_y_continuous(
    breaks = seq(0, 250, by = 50), 
    limits = c(0, max(fra_assentos_2022_2024$seat) * 1.05) 
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

print(grafico_assentosfra_2022)