library(ggrepel)
library(ggplot2)

# Médias dos Anos UE
 ue_spec_2014 <- mean(ue_2014_total$spec_eu, na.rm = TRUE)
 ue_spec_2019 <- mean(ue_2019$spec_eu, na.rm = TRUE)
 ue_spec_2024 <- mean(ue_2024$spec_eu, na.rm = TRUE)
 
 # Médias da Alemanha
 alemanha_spec_2014 <- mean(alemanha_2014_total$spec_eu, na.rm = TRUE)
 alemanha_spec_2019 <- mean(alemanha_2019$spec_eu, na.rm = TRUE)
 alemanha_spec_2024 <- mean(alemanha_2024$spec_eu, na.rm = TRUE)
 
 # Médias da França
 frança_spec_2014 <- mean(frança_2014_total$spec_eu, na.rm = TRUE)
 frança_spec_2019 <- mean(frança_2019$spec_eu, na.rm = TRUE)
 frança_spec_2024 <- mean(frança_2024$spec_eu, na.rm = TRUE)
 
 # Dados
 ue_spec <- c(4.81, 4.56, 4.32)
 frança_spec <- c(4.28, 3.80, 3.90) 
 alemanha_spec <- c(4.52, 4.69, 4.26) 
 anos <- c(2014, 2019, 2024)
 
 dados_combinados_spec <- data.frame(
   Ano = rep(anos, times = 3),
   Media = c(ue_spec, frança_spec, alemanha_spec),
   Grupo = factor(c(rep("União Europeia", 3), rep("França", 3), rep("Alemanha", 3)))
 )
 
 cores_personalizadas <- c(
   "União Europeia" = "darkblue", 
   "França" = "skyblue", 
   "Alemanha" = "red"
 )
 
 # Criacao do grafico ue_spec
 grafico_ue_spec <- ggplot(
   dados_combinados_spec, 
   aes(x = Ano, y = Media, group = Grupo, color = Grupo)
 ) +
   
   geom_line(size = 1) + 
   geom_point(size = 2.5) + 
   
   scale_color_manual(values = cores_personalizadas) +
   
   geom_text(
     aes(
       label = sprintf("%.2f", Media),
       vjust = case_when(
         Grupo == "Alemanha" & Ano == 2014 ~ -1.6,
         Grupo == "Alemanha" & Ano == 2019 ~ -1.2,
         Grupo == "Alemanha" & Ano == 2024 ~ 1.8,
         Grupo == "União Europeia" & Ano == 2014 ~ -1.2,
         Grupo == "União Europeia" & Ano == 2019 ~ -0.8,
         Grupo == "União Europeia" & Ano == 2024 ~ -1.0,
         Grupo == "França" ~ -1.0
       )
     ),
     size = 10 / 2.83,
     family = "serif",
     color = "black"
   ) +
   
   scale_x_continuous(breaks = anos) + 
   coord_cartesian(ylim = c(3.5, 5.5)) + 
   
   labs(
     title = "Posicionamento sobre Mercado Comum e Política Externa (2014-2024)",
     x = NULL, y = NULL, color = NULL
   ) +
   
   # Tema
   theme(
     plot.background = element_rect(fill = "white", color = NA),
     panel.background = element_rect(fill = "white", color = NA),
     axis.line.x = element_line(color = "black", size = 0.4), 
     axis.line.y = element_line(color = "black", size = 0.4), 
     axis.text.x = element_text(color = "black", size = 10, family = "serif"),
     axis.text.y = element_text(color = "black", size = 10, family = "serif"),
     panel.grid.major.y = element_line(color = "gray70", linetype = "dashed"),
     panel.grid.minor = element_blank(),
     text = element_text(family = "serif", size = 10),
     plot.title = element_text(hjust = 0.5, size = 12, color = "black", family = "serif"),
     legend.position = "bottom",
     legend.text = element_text(size = 10, family = "serif"),
     legend.background = element_rect(fill = "white", color = NA),
     legend.title = element_blank(),
     legend.key = element_rect(fill = "white", color = NA)
   )
 
 print(grafico_ue_spec)
 
 # OUTRO GRÁFICO: UE_POSITION 
 
 # Médias dos Anos UE_position
ue_position_2014 <- mean(ue_2014_total$eu_position, na.rm = TRUE)
ue_position_2019 <- mean(ue_2019$eu_position, na.rm = TRUE)
ue_position_2024 <- mean(ue_2024$eu_position, na.rm = TRUE)
 
 # Médias dos Anos UE_position
 frança_position_2014 <- mean(frança_2014_total$eu_position, na.rm = TRUE)
 frança_position_2019 <- mean(frança_2019$eu_position, na.rm = TRUE)
 frança_position_2024 <- mean(frança_2024$eu_position, na.rm = TRUE)
 
 
 # Médias dos Anos UE_position
 alemanha_position_2014 <- mean(alemanha_2014_total$eu_position, na.rm = TRUE)
 alemanha_position_2019 <- mean(alemanha_2019$eu_position, na.rm = TRUE)
 alemanha_position_2024 <- mean(alemanha_2024$eu_position, na.rm = TRUE)
 
 # Dados
 ue_position <- c(4.92, 5.05, 4.80)
 frança_position <- c(4.54, 4.84, 4.89) 
 alemanha_position <- c(4.45, 5.37, 5.21) 
 anos <- c(2014, 2019, 2024)
 
 dados_combinados_ue <- data.frame(
   Ano = rep(anos, times = 3),
   Media = c(ue_position, frança_position, alemanha_position),
   Grupo = factor(c(rep("União Europeia", 3), rep("França", 3), rep("Alemanha", 3)))
 )
 
 cores_personalizadas <- c(
   "União Europeia" = "darkblue", 
   "França" = "skyblue", 
   "Alemanha" = "red"
 )

 # Criacao do grafico ue_position
 grafico_ue_geral <- ggplot(
   dados_combinados_ue, 
   aes(x = Ano, y = Media, group = Grupo, color = Grupo)
 ) +

   geom_line(size = 1) + 
   geom_point(size = 2.5) + 
   
   scale_color_manual(values = cores_personalizadas) +
   
   geom_text(
     aes(
       label = sprintf("%.2f", Media),
       vjust = case_when(
         Grupo == "Alemanha" & Ano == 2014 ~ 1.6,
         Grupo == "Alemanha" & Ano == 2019 ~ -1.5,
         Grupo == "Alemanha" & Ano == 2024 ~ -1.5,
         Grupo == "União Europeia" & Ano == 2014 ~ -1.2,
         Grupo == "União Europeia" & Ano == 2019 ~ -1.2,
         Grupo == "União Europeia" & Ano == 2024 ~ 1.7,
         Grupo == "França" ~ -1.2
         )
     ),
     size = 10 / 2.83,
     family = "serif",
     color = "black"
   ) +
   
   scale_x_continuous(breaks = anos) + 
   coord_cartesian(ylim = c(4.0, 6.0)) + 

   labs(
     title = "Posicionamento Geral sobre a Integração da União Europeia (2014-2024)",
     x = NULL, y = NULL, color = NULL
   ) +
   
   # Tema
   theme(
     plot.background = element_rect(fill = "white", color = NA),
     panel.background = element_rect(fill = "white", color = NA),
     axis.line.x = element_line(color = "black", size = 0.4), 
     axis.line.y = element_line(color = "black", size = 0.4), 
     axis.text.x = element_text(color = "black", size = 10, family = "serif"),
     axis.text.y = element_text(color = "black", size = 10, family = "serif"),
     panel.grid.major.y = element_line(color = "gray70", linetype = "dashed"),
     panel.grid.minor = element_blank(),
     text = element_text(family = "serif", size = 10),
     plot.title = element_text(hjust = 0.5, size = 12, color = "black", family = "serif"),
     legend.position = "bottom",
     legend.text = element_text(size = 10, family = "serif"),
     legend.background = element_rect(fill = "white", color = NA),
     legend.title = element_blank(),
     legend.key = element_rect(fill = "white", color = NA)
   )
 
 print(grafico_ue_geral)