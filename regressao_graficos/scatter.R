library(ggplot2)
library(dplyr)

# Preparação da base de dados
df_grafico <- df_contemporaneo %>%
  mutate(family_label = case_when(
    family == 7 ~ "Direita Radical",
    family %in% c(3, 4, 5, 6) ~ "Mainstream (Cons/Lib/Soc/ChrDem)",
    family == 10 ~ "Esquerda Radical",
    family == 8 ~ "Verdes",
    TRUE ~ "Outros"
  )) %>%
  mutate(
    v_ajustado = case_when(
      (party == "RN"  & year == 2024) ~ -1.5, # Move para CIMA
      (party == "AfD" & year == 2024) ~ 2.2,  # Move para BAIXO
      (party == "AfD" & year == 2019) ~ -1.5, # Move para CIMA
      (party == "RN"  & year == 2019) ~ 2.2,  # Move para BAIXO
      TRUE ~ 0.5
    )
  )

#   Gerar o Scatter Plot com 2019 e 2024
grafico_scatter <- ggplot(df_grafico, aes(x = antielite_salience, y = eu_position)) +
  
  # Camada 1: Todos os pontos (2019 e 2024) coloridos por família
  geom_point(aes(color = family_label), alpha = 0.3, size = 2) +
  
  # Camada 2: Linha de Regressão Geral (Tendência para todo o período)
  geom_smooth(method = "lm", color = "black", linetype = "dashed", se = TRUE) +
  
  # Camada 3: Destaque para AfD e RN em AMBOS os anos (2019 e 2024)
  geom_point(data = df_grafico %>% filter(party %in% c("AfD", "RN") & year %in% c(2019, 2024)),
             aes(fill = party), shape = 21, size = 4, color = "black", stroke = 1.2) +
  
  # Camada 4: Rótulos identificando Partido e Ano
  geom_text(data = df_grafico %>% filter(party %in% c("AfD", "RN") & year %in% c(2019, 2024)),
            aes(label = paste(party, year),
                vjust = v_ajustado),
            fontface = "bold", 
            size = 3.5, 
            family = "serif",
            box.padding = 0.5) +
  
  # Customização de Cores (Ajustei para o padrão clássico que você usou)
  scale_color_manual(values = c("Direita Radical" = "#377eb8", 
                                "Mainstream (Cons/Lib/Soc/ChrDem)" = "#984ea3", 
                                "Esquerda Radical" = "#e41a1c",
                                "Verdes" = "#4daf4a",
                                "Outros" = "grey70")) +
  
  # Cores de preenchimento para os partidos destacados
  scale_fill_manual(values = c("AfD" = "dodgerblue", "RN" = "darkblue")) + 
  
  theme_minimal() +
  labs(
    title = "Scatter Plot: Populismo Anti-Elite vs. Apoio à União Europeia (2019-2024)",
    x = "Saliência da Retórica Anti-Elite (0-10)",
    y = "Apoio à Integração Europeia (1-7)",
    color = "Família Partidária",
    fill = "Partidos"
  ) +
  theme(
    legend.position = "bottom", 
    legend.box = "vertical",
    text = element_text(family = "serif", size = 12),
    axis.text = element_text(family = "serif", size = 11),
    axis.title = element_text(family = "serif", face = "bold"),
    legend.text = element_text(family = "serif", size = 10),
    panel.grid.minor = element_blank()
  )

print(grafico_scatter)