# Gerar o Gráfico de Coeficientes
library(sjPlot)
library(ggplot2)
library(dplyr)

grafico_regressao <- plot_model(modelo_contemporaneo, 
           type = "est", 
           title = "Coefficient Plot: Determinantes do apoio à integração da UE (2019-2024)",
           # Definimos os nomes das variáveis para o gráfico (na ordem inversa do modelo)
           axis.labels = c(
             "as.factor(2019-2024)",
             "Tradicionalismo (GALTAN)",
             "Apoio à Diversidade",
             "Nacionalismo",
             "Extremismo Ideológico",
             "Retórica Anti-Islã",
             "Povo vs. Elite",
             "Saliência Anti-Elite"
           ),
           show.values = TRUE,
           value.offset = 0.4,
           show.p = TRUE,
           dot.size = 3,
           line.size = 1,
           colors = c("#004080", "#A50026")) +
  theme_minimal() +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey50") +
  labs(subtitle = "Estimativas de Coeficientes OLS com Intervalos de Confiança (95%)")
theme(text = element_text(family = "serif", size = 12))