library(readxl)
library(magrittr)
library(dplyr)
library(stringr)
library(tidyverse)
library(extrafont)
font_import()

setwd ("C:/Users/felip/Desktop/Ciencia de dados RI/TCC/2019 Chapel Hill expert survey")

data_2019 <- read.csv("data_2019.csv")

#filtrar os partidos
partidos <- filter(data, party == "FN" | party == "RN" | party == "AfD")

#retirar os partidos
parties_to_remove <- c("DieTier", "Piraten")
alemanha_2019 <- alemanha_2019 %>%
  filter(!party %in% parties_to_remove)
alemanha_2019 <- alemanha_2019 %>% 
  filter(!party %in% c("DieTier", "Piraten"))
frança_2019 <- frança_2019 %>% 
  filter(!party %in% c("DLF", "PCF"))

#filtrar os países
partidos <- partidos %>%
  filter(country >= 2)

#renomear os países
partidos <- partidos %>%
  mutate(country = case_when(
    +         country == 6 ~ "França",
    +         country == 3 ~ "Alemanha",
    +         TRUE ~ as.character(country)))

partidos$country <- factor(partidos$country, 
                           levels = c(3, 6), 
                           labels = c("Alemanha", "França"))


#Renomear as colunas
colnames(partidos) <- c("país", "ano", "especialista", "partido", "voto", 
                        "assento", "ano_eleição", "voto_efetivo", "família", 
                        "governo", "posição_ue", "relevância_ue")

#retirar as colunas
alemanha_2019 <- alemanha_2019 %>%
  select(-eastwest, -eu_position_sd, -eu_asylum, -eu_budgets, -lrecon_sd, -lrecon_salience, -lrecon_dissent, -lrecon_blur, - galtan_sd, - galtan_dissent, - galtan_blur, -redistribution, -redist_salience, - environment, -enviro_salience, -spendvtax, - deregulation, -econ_interven, -civlib_laworder, -urban_rural, - regions, - russian_interference, - corrupt_salience, - members_vs_leadership, - eu_econ_require, - eu_political_require, - eu_googov_require)


#deixar somente as colunas importante (ue)
dados_reduzidos <- dados %>%
  select(coluna1, coluna2, coluna5)

#fazer o index
partidos_ue <- partidos_ue %>%
  group_by(party_id) %>%
  mutate(index = sum(eu_position, na.rm = TRUE))

#fazer a média das variáveis (questões específicas UE)
alemanha_2019 <- alemanha_2019 %>%
  mutate(spec_eu = rowMeans(across(c(eu_intmark, eu_foreign)), na.rm = TRUE))

# média questões ideológicas
alemanha_2019 <- alemanha_2019 %>%
  mutate(ideology = rowMeans(across(c(lrgen)), na.rm = TRUE))

frança_2019 <- frança_2019 %>%
  mutate(ideology = rowMeans(across(c(lrgen)), na.rm = TRUE))

# média questões políticas
alemanha_2019 <- alemanha_2019 %>%
  mutate(policy = rowMeans(across(c(immigrate_policy, multiculturalism, ethnic_minorities)), na.rm = TRUE))

# média caracterísiticas partidárias
alemanha_2019 <- alemanha_2019 %>%
  mutate(party_char = rowMeans(across(c(people_vs_elite, antielite_salience, anti_islam_rhetoric)), na.rm = TRUE))

# Criar gráfico
# Conversão dos dados do formato LARGO para LONGO
# Transformar as colunas de valores em duas novas colunas: 'variavel' (nome da coluna) e 'valor' (valor da coluna).
df_alemanha_2019 <- alemanha_2019 %>% 
  pivot_longer(
    cols = c(eu_position, ideology, policy, party_char, galtan, nationalism, protectionism), # Colunas que contêm os valores a serem empilhados
    names_to = "variavel", # Novo nome da coluna para as categorias (os nomes das colunas originais)
    values_to = "valor") %>%  # Novo nome da coluna para os valores correspondentes

# RENOMEIA AS CHAVES CURTAS
mutate(variavel = case_when(
  variavel == "ideology" ~ "ideology",
  variavel == "eu_position" ~ "eu_position",
  variavel == "policy" ~ "policy",
  variavel == "party_char" ~ "party_char",
  variavel == "galtan" ~ "galtan",
  variavel == "nationalism" ~ "nationalism",
  variavel == "protectionism" ~ "protectionism",
  TRUE ~ variavel
)) %>%
  
  # APLICA A INVERSÃO NA COLUNA 'policy':
  mutate(valor = if_else(
    variavel == "policy",
    10 - valor,
    valor
  ))

# Cores
cores_intermediarias <- c(
  "ideology" = "#AA80C0",
  "eu_position" = "#6699CC",
  "policy" = "#55AA55",
  "party_char" = "#FFD700",
  "galtan" = "#8B4513",
  "nationalism" = "#CC0000",
  "protectionism" = "#FF9900"
)

# Definir o mapeamento de rótulos e ordem
ordem_legenda <- c("ideology", "eu_position", "policy", "party_char", "galtan", "nationalism", "protectionism")

legenda <- c(
  "ideology" = "Espectro Ideológico",
  "eu_position" = "Posicionamento frente à Integração",
  "policy" = "Pluralismo e Multiculturalismo",
  "party_char" = "Retórica Populista e Identitária",
  "galtan" = "Valores Sociais e Autoritarismo (GALTAN)",
  "nationalism" = "Nacionalismo",
  "protectionism" = "Protecionismo"
  )

# Ordenar eixo X igual à legenda
df_alemanha_2019 <- df_alemanha_2019 %>%
  mutate(variavel = factor(variavel, levels = ordem_legenda))

# Criação do gráfico
grafico_barras_ale_2019 <- ggplot(df_alemanha_2019, aes(x = variavel, y = valor, fill = variavel)) +
  geom_bar(stat = "identity", position = "dodge") +
  
  # Cores, Ordem e Rótulos da Legenda
  scale_fill_manual(
    values = cores_intermediarias,
    limits = ordem_legenda,
    labels = legenda
  ) +
  
  # Padrão eixo Y:
  scale_y_continuous(
    breaks = c(0, 2, 4, 6, 8, 10),
    limits = c(0, 10)
  ) +
  
  # Cria mini-gráficos e move os rótulos dos partidos para baixo
  facet_wrap(~ party, 
             scales = "fixed", 
             ncol = 4,
             strip.position = "bottom") + 
  
  # Rótulos do Gráfico
  labs(
    title = "Posicionamento dos Partidos na Alemanha (2019)",
    x = "", 
    y = "", 
    fill = "Variáveis"
  ) +
  
  # Estilo
  theme_classic() +
  theme(
    # Padronização da Fonte
    text = element_text(family = "Times New Roman", size = 12), 
    
    # Centralização e Fonte dos Títulos
    plot.title = element_text(hjust = 0.5, family = "Times New Roman", size = 12), 
    legend.title = element_text(hjust = 0.5, family = "Times New Roman", size = 12),
    
    # Limpeza de Estilo
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "white", colour = "white"),
    
    # Remoção de Eixos
    axis.text.x = element_blank(), 
    axis.ticks.x = element_blank(),
    axis.line.x = element_blank()
  )


#PARA FRANÇA

df_frança_2019 <- frança_2019 %>% 
  pivot_longer(
    cols = c(eu_position, ideology, policy, party_char, galtan, nationalism, protectionism),
    names_to = "variavel",
    values_to = "valor") %>%
  
  # Renomeia chaves
  mutate(variavel = case_when(
    variavel == "ideology" ~ "ideology",
    variavel == "eu_position" ~ "eu_position",
    variavel == "policy" ~ "policy",
    variavel == "party_char" ~ "party_char",
    variavel == "galtan" ~ "galtan",
    variavel == "nationalism" ~ "nationalism",
    variavel == "protectionism" ~ "protectionism",
    TRUE ~ variavel
  )) %>%
  
  mutate(valor = if_else(
    variavel == "policy",
    10 - valor,
    valor
  ))

# Cores
cores_intermediarias <- c(
  "ideology" = "#AA80C0",
  "eu_position" = "#6699CC",
  "policy" = "#55AA55",
  "party_char" = "#FFD700",
  "galtan" = "#8B4513",
  "nationalism" = "#CC0000",
  "protectionism" = "#FF9900"
)

# Definir o mapeamento de rótulos e ordem
ordem_legenda <- c("ideology", "eu_position", "policy", "party_char", "galtan", "nationalism", "protectionism")
ordem_partidos_2019 <- c("RN", "EELV", "MoDem", "PCF", "PS", "LR", "FI", "LREM")

legenda <- c(
  "ideology" = "Espectro Ideológico",
  "eu_position" = "Posicionamento frente à Integração",
  "policy" = "Pluralismo e Multiculturalismo",
  "party_char" = "Retórica Populista e Identitária",
  "galtan" = "Valores Sociais e Autoritarismo (GALTAN)",
  "nationalism" = "Nacionalismo",
  "protectionism" = "Protecionismo"
)

# Ordenar o eixo X igual à legenda
df_frança_2019 <- df_frança_2019 %>%
  mutate(variavel = factor(variavel, levels = ordem_legenda))

# Inverter ordem tabelas
df_frança_2019 <- df_frança_2019 %>%
  mutate(party = factor(party, levels = ordem_partidos_2019))

# Criação do gráfico
grafico_barras_fra_2019 <- ggplot(df_frança_2019, aes(x = variavel, y = valor, fill = variavel)) +
  geom_bar(stat = "identity", position = "dodge") +
  
  # Cores, Ordem e Rótulos da Legenda
  scale_fill_manual(
    values = cores_intermediarias,
    limits = ordem_legenda,
    labels = legenda
  ) +
  
  # Padrão eixo Y:
  scale_y_continuous(
    breaks = c(0, 2, 4, 6, 8, 10),
    limits = c(0, 10)
  ) +
  
  # Cria mini-gráficos e move os rótulos dos partidos para baixo
  facet_wrap(~ party, 
             scales = "fixed", 
             ncol = 4,
             strip.position = "bottom") + 
  
  # Rótulos do Gráfico
  labs(
    title = "Posicionamento dos Partidos na França (2019)",
    x = "", 
    y = "", 
    fill = "Variáveis"
  ) +
  
  # Estilo
  theme_classic() +
  theme(
    # Padronização da Fonte
    text = element_text(family = "Times New Roman", size = 12), 
    
    # Centralização e Fonte dos Títulos
    plot.title = element_text(hjust = 0.5, family = "Times New Roman", size = 12), 
    legend.title = element_text(hjust = 0.5, family = "Times New Roman", size = 12),
    
    # Limpeza de Estilo
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "white", colour = "white"),
    
    # Remoção de Eixos
    axis.text.x = element_blank(), 
    axis.ticks.x = element_blank(),
    axis.line.x = element_blank()
  )