#gráfico regressão TCC

library(sjPlot)
library(ggplot2)
library(dplyr)

ue_reg <- read.csv2("dados_reg.csv")

# Rodar a Regressão Linear Múltipla
modelo_ue <- lm(eu_position ~ lrgen + policy + party_char + nationalism, data = ue_reg)

# Visualizar o sumário estatístico no console
summary(modelo_ue)

# Gráfico de Coeficientes (Para testar as Hipóteses H1 a H4)
plot_model(modelo_ue, 
           show.values = TRUE, 
           value.offset = .3,
           vline.color = "red",
           title = "Efeito das Variáveis da Ultradireita no Suporte à UE",
           axis.labels = c("Nacionalismo (H3)", 
                           "Características do Partido (H4)", 
                           "Retórica Populista/Policy (H1)", 
                           "Extremismo Ideológico (H2)"),
           order.terms = c(4, 3, 2, 1)) +
  theme_minimal()

# Gráfico de Tendência (Efeitos Previstos)
plot_model(modelo_ue, 
           type = "pred", 
           grid = TRUE, # Cria um painel com todos os gráficos
           title = "Impacto Estimado das Variáveis Independentes sobre spec_eu") +
  theme_bw()



# Modelo regressão 

library(sjPlot)

# Garantir que o modelo foi criado corretamente
modelo_ue <- lm(spec_eu ~ ideology + policy + party_char + nationalism, data = ue_reg)

# Gerar a tabela formatada
tab_model(
  modelo_ue,
  show.ci = FALSE,            
  show.se = TRUE,             
  collapse.se = TRUE,         
  p.style = "stars",
  dv.labels = "Suporte à Integração da UE (spec_eu)", 
  pred.labels = c(
    "(Intercepto)", 
    "Ideologia (H2)", 
    "Retórica Populista (H1)", 
    "Características do Partido (H4)", 
    "Nacionalismo (H3)"
  ),
  title = "Tabela 1: Determinantes do Suporte à UE (Regressão Linear)",
  string.pred = "Preditores",
  string.est = "Coeficiente (B)",
  string.se = "Erro Padrão",
  string.p = "p-valor"
)

# REGRESSÃO CONTEMPORÂNEA (2019-2024)
# Preparação dos Dados (Ajustando para 2019 e 2024)

# CARREGAR PACOTES NECESSÁRIOS

library(tidyverse)
library(stargazer)
library(car)         # Teste de Multicolinearidade (VIF)
library(sandwich)    # Erros padrão robustos
library(lmtest)      # Testes de hipóteses

# IMPORTAÇÃO E LIMPEZA
# Preparação dos Dados (Ajustando para 2019 e 2024)
df_contemporaneo <- data_total %>%
  filter(year %in% c(2019, 2024)) %>%
  mutate(
    extremismo_ideologico = abs(lrgen - 5),
    nacionalismo = nationalism,
    # H4: Índice de "Apoio à Diversidade" com a inversão
    apoio_diversidade = ((10 - immigrate_policy) + (10 - multiculturalism) + (10 - ethnic_minorities)) / 3
  )

# Regressão Contemporânea (2019 + 2024)
# Incluir o as.factor(year) para controlar mudanças globais entre esses dois anos
modelo_contemporaneo <- lm(eu_position ~ 
                             antielite_salience +    # H1
                             people_vs_elite +       # H1
                             anti_islam_rhetoric +   # H1
                             extremismo_ideologico + # H2
                             nacionalismo +          # H3
                             apoio_diversidade +     # H4
                             galtan +                # H5
                             as.factor(year),        # Controle temporal
                           data = df_contemporaneo)

# Visualização do Resultado
library(stargazer)
stargazer(modelo_contemporaneo, type = "text", 
          title = "Resultados da Regressão Linear Múltipla (Determinantes do apoio à UE)")

# GERAR TABELA PARA O TCC
# Definir os nomes das variáveis para a tabela (na ordem do modelo)
labels_variaveis <- c(
  "Saliência Anti-Elite", 
  "Povo vs. Elite", 
  "Retórica Anti-Islã", 
  "Extremismo Ideológico", 
  "Nacionalismo", 
  "Apoio à Diversidade", 
  "Tradicionalismo (GALTAN)", 
  "as.factor(2019-2024)"
)

# Exportando para HTML
stargazer(modelo_contemporaneo, 
          type = "html", 
          out = "tabela_regressao_tcc.html",
          title = "",
          column.labels = "Recorte Temporal (2019-2024)",
          covariate.labels = labels_variaveis,
          dep.var.labels = "Apoio à Integração Europeia",
          digits = 3,
          decimal.mark = ",",
          notes = "Notas: Coeficientes de regressão linear (OLS). Erros padrão entre parênteses.",
          omit.stat = c("f", "ser"))