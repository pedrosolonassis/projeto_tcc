library(readxl)
library(magrittr)
library(dplyr)
library(stringr)
library(tidyverse)

setwd ("C:/Users/felip/Desktop/Ciencia de dados RI/TCC/2024 Chapel Hill expert survey")

data_2024 <- read.csv("data_2024.csv")

# filtrar os partidos
partidos_2024 <- filter(data_2024, party == "FN" | party == "RN" | party == "AfD")

# retirar os partidos
parties_to_remove <- c("BSW", "FW")
alemanha_2024 <- alemanha_2024 %>%
  filter(!party %in% parties_to_remove)
alemanha_2024 <- alemanha_2024 %>% 
  filter(!party %in% c("BSW", "FW"))

# filtrar os países
partidos_2024 <- partidos_2024 %>%
  filter(country >= 2)

# renomear os países
partidos <- partidos %>%
  mutate(country = case_when(
    +         country == 6 ~ "França",
    +         country == 3 ~ "Alemanha",
    +         TRUE ~ as.character(country)))

partidos$country <- factor(partidos$country, 
                           levels = c(3, 6), 
                           labels = c("Alemanha", "França"))


# Renomear as colunas
colnames(partidos) <- c("país", "ano", "especialista", "partido", "voto", 
                        "assento", "ano_eleição", "voto_efetivo", "família", 
                        "governo", "posição_ue", "relevância_ue")

# retirar as colunas
alemanha_2024 <- alemanha_2024 %>%
  select(-lrecon_blur, -lrecon_dissent,-lrecon_salience, -galtan_blur, -galtan_dissent, -redistribution, -redist_salience, -climate_change, -climate_change_salience, -environment, -environment_salience, -spendvtax, -deregulation, -civlib_laworder, -urban_rural, - regions, -executive_power, -judicial_independence, -corrupt_salience, -eu_russia)


# deixar somente as colunas importante (ue)
dados_reduzidos <- dados %>%
  select(coluna1, coluna2, coluna5)

# fazer o index
partidos_ue <- partidos_ue %>%
  group_by(party_id) %>%
  mutate(index = sum(eu_position, na.rm = TRUE))

# fazer a média das variáveis (questões específicas UE)
alemanha_2024 <- alemanha_2024 %>%
  mutate(spec_eu = rowMeans(across(c(eu_intmark, eu_foreign)), na.rm = TRUE))

# média questões ideológicas
alemanha_2024 <- alemanha_2024 %>%
  mutate(ideology = rowMeans(across(c(lrgen)), na.rm = TRUE))

frança_2024 <- frança_2024 %>%
  mutate(ideology = rowMeans(across(c(lrgen)), na.rm = TRUE))

# média questões políticas
alemanha_2024 <- alemanha_2024 %>%
  mutate(spec_policy = rowMeans(across(c(immigrate_policy, multiculturalism, lgbtq_rights, samesex_marriage, womens_rights, ethnic_minorities)), na.rm = TRUE))

# média caracterísiticas partidárias
alemanha_2024 <- alemanha_2024 %>%
  mutate(party_char = rowMeans(across(c(people_v_elite, anti_elite_salience, anti_islam)), na.rm = TRUE))

# Criar gráfico
# Transformar as colunas de valores em duas novas colunas: 'variavel' (nome da coluna) e 'valor' (valor da coluna).
df_alemanha_2024 <- alemanha_2024 %>% 
  pivot_longer(
    cols = c(eu_position, ideology, policy, party_char, galtan, protectionism, nationalism),
    names_to = "variavel",
    values_to = "valor") %>%
  
  # Renomear chaves
  mutate(variavel = case_when(
    variavel == "ideology" ~ "ideology",
    variavel == "eu_position" ~ "eu_position",
    variavel == "policy" ~ "policy",
    variavel == "party_char" ~ "party_char",
    variavel == "galtan" ~ "galtan",
    variavel == "protectionism" ~ "protectionism",
    variavel == "nationalism" ~ "nationalism",
    TRUE ~ variavel
  )) %>%
  
  # Inversão da coluna 'policy'
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
  

ordem_legenda <- c("ideology", "eu_position", "policy", "party_char", "galtan", "nationalism", "protectionism")
ordem_partidos_ale <- c("AfD", "CDU", "CSU", "FDP", "Grunen", "DL", "SPD")

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
df_alemanha_2024 <- df_alemanha_2024 %>%
  mutate(variavel = factor(variavel, levels = ordem_legenda))

# Inverter ordem tabelas
df_alemanha_2024 <- df_alemanha_2024 %>%
  mutate(party = factor(party, levels = ordem_partidos_ale))

# Criação do gráfico
grafico_barras_ale_2024 <- ggplot(df_alemanha_2024, aes(x = variavel, y = valor, fill = variavel)) +
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
    title = "Posicionamento dos Partidos na Alemanha (2024)",
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

df_frança_2024 <- frança_2024 %>% 
  pivot_longer(
    cols = c(eu_position, ideology, policy, party_char, galtan, nationalism, protectionism),
    names_to = "variavel",
    values_to = "valor") %>%
  
  # Renomear chaves
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
  
  # Inversão da coluna 'policy'
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

ordem_legenda <- c("ideology", "eu_position", "policy", "party_char", "galtan", "nationalism", "protectionism")
ordem_partidos_2024 <- c("RN", "LE/EELV", "MoDem", "PCF", "PS", "LR", "FI", "RE")

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
df_frança_2024 <- df_frança_2024 %>%
  mutate(variavel = factor(variavel, levels = ordem_legenda))

# Inverter ordem tabelas
df_frança_2024 <- df_frança_2024 %>%
  mutate(party = factor(party, levels = ordem_partidos_2024))

# Criação do gráfico
grafico_barras_fra_2024 <- ggplot(df_frança_2024, aes(x = variavel, y = valor, fill = variavel)) +
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
    title = "Posicionamento dos Partidos na França (2024)",
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