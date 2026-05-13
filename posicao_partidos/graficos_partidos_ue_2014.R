library(readxl)
library(magrittr)
library(dplyr)
library(stringr)
library(tidyverse)

setwd ("C:/Users/felip/Desktop/Ciencia de dados RI/TCC/1999-2019 Chapel Hill Expert Survey (CHES)")

data_1999 <- read.csv("Expert Survey.csv")

# filtrar os partidos
partidos <- filter(data, party == "FN" | party == "RN" | party == "AfD")

# retirar os partidos
parties_to_remove <- c("DieTier", "DVU", "Piraten", "REP")
alemanha_1999 <- alemanha_1999 %>%
  filter(!party %in% parties_to_remove)
alemanha_1999 <- alemanha_1999 %>% 
  filter(!party %in% c("DieTier", "DVU", "Piraten", "REP"))
frança_1999 <- frança_1999 %>% 
filter(!party %in% c("AC", "Ensemble", "MPF", "NC", "PG", "PRV", "PCF", "PRG", "PCF", "DLF"))

# filtrar os países
alemanha_2019 <- alemanha_2019 %>%
  filter(country == 3)

# filtrar os anos
alemanha_2014 <- filter(data_1999, year == "2014")

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
partidos <- partidos %>%
  select(-eastwest, -eumember, -cmp_id, - eu_benefit, -eu_fiscal, -eu_employ, -eu_budgets, -eu_agri, -eu_environ, -eu_asylum, -eu_turkey, -lrecon_blur, -lrecon_salience, - lrecon_dissent, -galtan_dissent, -galtan_blur, -spendvtax, -spendvtax_salience, -deregulation, -dereg_salience, -redistribution, -redist_salience, -econ_interven, -civlib_laworder, -civlib_salience, -social_salience, -relig_salience, -urban_rural, -urban_salience, -environment, -enviro_salience, -cosmo, -cosmo_salience, -regions, -region_salience, -international_security, -international_salience, -us, -us_salience, -russian_interference, -corrupt_salience, -members_vs_leadership, -mip_one, -mip_two, -mip_three, -chesversion)


# deixar somente as colunas importante (ue)
dados_reduzidos <- dados %>%
  select(coluna1, coluna2, coluna5)

# fazer o index
partidos_ue <- partidos_ue %>%
  group_by(party_id) %>%
  mutate(index = sum(eu_position, na.rm = TRUE))

# remover o index
frança_2014 <- frança_2014 %>%
  select(-spec_eu, -ideology, -policy, -party_char)

# fazer a média das variáveis (questões específicas UE)
alemanha_2014 <- alemanha_2014 %>%
    mutate(spec_eu = rowMeans(across(c(eu_intmark, eu_foreign)), na.rm = TRUE))

# média questões ideológicas
alemanha_2014 <- alemanha_2014 %>%
  mutate(ideology = rowMeans(across(c(lrgen)), na.rm = TRUE))

# média questões ideológicas
frança_2014 <- frança_2014 %>%
  mutate(ideology = rowMeans(across(c(lrgen)), na.rm = TRUE))

# média questões políticas
alemanha_2014 <- alemanha_2014 %>%
  mutate(policy = rowMeans(across(c(immigrate_policy, multiculturalism, ethnic_minorities)), na.rm = TRUE))

# média caracterísiticas partidárias
alemanha_2014 <- alemanha_2014 %>%
  mutate(party_char = rowMeans(across(c(people_vs_elite, antielite_salience, anti_islam_rhetoric)), na.rm = TRUE))

# Criar gráfico de barras para a Alemanha em 2014
# Transformar as colunas de valores em duas novas colunas: 'variavel' (nome da coluna) e 'valor' (valor da coluna).
df_alemanha_2014 <- alemanha_2014 %>%
  pivot_longer(
    cols = c(eu_position, ideology, policy, party_char, galtan, nationalism),
    names_to = "variavel",
    values_to = "valor"
  ) %>%
  
  # mutate para renomear e a inversão
  mutate(variavel = case_when(
    variavel == "ideology" ~ "ideology",
    variavel == "eu_position" ~ "eu_position",
    variavel == "policy" ~ "policy",
    variavel == "party_char" ~ "party_char",
    variavel == "galtan" ~ "galtan",
    variavel == "nationalism" ~ "nationalism",
    TRUE ~ variavel
  )) %>%
  
  # inversão na coluna 'policy' para que valores mais altos representem mais pluralismo e multiculturalismo
  mutate(valor = if_else(
    variavel == "policy", 
    10 - valor,
    valor
  ))

cores_2014 <- c(
  "ideology" = "#AA80C0",   
  "eu_position" = "#6699CC",    
  "policy" = "#55AA55",     
  "party_char" = "#FFD700",
  "galtan" = "#8B4513",
  "nationalism" = "#CC0000"    
)

ordem_2014 <- c("ideology", "eu_position", "policy", "party_char", "galtan", "nationalism")

legenda_2014 <- c(
  "ideology" = "Espectro Ideológico",
  "eu_position" = "Posicionamento frente à Integração",
  "policy" = "Pluralismo e Multiculturalismo",
  "party_char" = "Retórica Populista e Identitária",
  "galtan" = "Valores Sociais e Autoritarismo (GALTAN)",
  "nationalism" = "Nacionalismo"
)
# ordenar eixo x igual à legenda
df_alemanha_2014 <- df_alemanha_2014 %>%
  mutate(variavel = factor(variavel, levels = ordem_2014))# Transforma 'variavel' em um fator, forçando a ordem definida em 'ordem_2014'

# Criação do gráfico
grafico_barras_ale_2014 <- ggplot(df_alemanha_2014, aes(x = variavel, y = valor, fill = variavel)) +
  geom_bar(stat = "identity", position = "dodge") +
  
  # Cores, Ordem e Rótulos da Legenda
  scale_fill_manual(
    values = cores_2014,
    limits = ordem_2014,
    labels = legenda_2014
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
    title = "Posicionamento dos Partidos na Alemanha (2014)",
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

df_frança_2014 <- frança_2014 %>%
  pivot_longer(
    cols = c(eu_position, ideology, policy, party_char, galtan, nationalism),
    names_to = "variavel",
    values_to = "valor"
  ) %>%
  
  # mutate para renomear e a inversão
  mutate(variavel = case_when(
    variavel == "ideology" ~ "ideology",
    variavel == "eu_position" ~ "eu_position",
    variavel == "policy" ~ "policy",
    variavel == "party_char" ~ "party_char",
    variavel == "galtan" ~ "galtan",
    variavel == "nationalism" ~ "nationalism",
    TRUE ~ variavel
  )) %>%
  
  # inversão da coluna "policy"
  mutate(valor = if_else(
    variavel == "policy", 
    10 - valor,
    valor
  ))

# Cores
cores_2014 <- c(
  "ideology" = "#AA80C0",
  "eu_position" = "#6699CC",
  "policy" = "#55AA55",
  "party_char" = "#FFD700",
  "galtan" = "#8B4513",
  "nationalism" = "#CC0000" 
)

ordem_2014 <- c("ideology", "eu_position", "policy", "party_char", "galtan", "nationalism")
ordem_partidos_2014 <- c("FN", "EELV", "MODEM", "PCF", "PS", "UMP")

legenda_2014 <- c(
  "ideology" = "Espectro Ideológico",
  "eu_position" = "Posicionamento frente à Integração",
  "policy" = "Pluralismo e Multiculturalismo",
  "party_char" = "Retórica Populista e Identitária",
  "galtan" = "Valores Sociais e Autoritarismo (GALTAN)",
  "nationalism" = "Nacionalismo"
)
# ordenar eixo x igual à legenda
df_frança_2014 <- df_frança_2014 %>%
  mutate(variavel = factor(variavel, levels = ordem_2014))# Transforma 'variavel' em um fator, forçando a ordem definida em 'ordem_2014'

df_frança_2014 <- df_frança_2014 %>%
  mutate(party = factor(party, levels = ordem_partidos_2014))

# Criação do gráfico
grafico_barras_fra_2014 <- ggplot(df_frança_2014, aes(x = variavel, y = valor, fill = variavel)) +
  geom_bar(stat = "identity", position = "dodge") +
  
  # Cores, Ordem e Rótulos da Legenda
  scale_fill_manual(
    values = cores_2014,
    limits = ordem_2014,
    labels = legenda_2014
  ) +
  
  # Padrão eixo Y:
  scale_y_continuous(
    breaks = c(0, 2, 4, 6, 8, 10),
    limits = c(0, 10)
  ) +
  
  facet_wrap(~ party, 
             scales = "fixed", 
             ncol = 4,
             strip.position = "bottom") + 
  
  labs(
    title = "Posicionamento dos Partidos na França(2014)",
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