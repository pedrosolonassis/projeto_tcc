# 📊 Data Science Project: Determinantes do Euroceticismo no Eixo Franco-Alemão

[![R Tool](https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white)](https://www.r-project.org/)
[![Tidyverse](https://img.shields.io/badge/Tidyverse-🎨-blue?style=for-the-badge)](https://www.tidyverse.org/)
[![Analytics Translator](https://img.shields.io/badge/Role-Data_Analyst_%2F_Product_Owner-orange?style=for-the-badge)]()

## 📌 Visão Geral do Projeto

Este repositório contém o desenvolvimento completo de uma solução analítica e estatística para mapear, quantificar e mensurar o impacto causal de variáveis político-ideológicas (como autoritarismo, nacionalismo e populismo) sobre o apoio partidário à integração da União Europeia.

O estudo de caso foca no motor macroeconômico e decisório da Europa, o **Eixo Franco-Alemão**, analisando a evolução temporal e eleitoral dos partidos **Alternativa para a Alemanha (AfD), da Alemanha** e **Reagrupamento Nacional (RN), da França**, por meio do banco de dados Chapel Hill Expert Survey, disponibilizado por especialistas da área de integração regional e União Europeia.

> **💡 Abordagem Analytics Translator:** Este projeto traduz um problema de cenário geopolítico abstrato em um modelo estatístico interpretável, utilizando engenharia de variáveis (Feature Engineering) e modelagem econométrica robusta (OLS) para gerar insights estratégicos que explicam a fragmentação de governabilidade no bloco europeu.

---

## 🛠️ Stack Tecnológica & Ferramentas

O pipeline de dados foi inteiramente construído utilizando a **Linguagem R**, priorizando a reprodutibilidade do código, eficiência na manipulação e rigor estatístico:

* **Ingestão e Manipulação de Dados:** `dplyr`, `tidyverse` (Feature Engineering e agregação de índices).
* **Modelagem Estatística:** `stats` (Estimação por Mínimos Quadrados Ordinários - OLS).
* **Diagnósticos e Correções:** `car` (Análise de Multicolinearidade - VIF), `lmtest` e `sandwich` (Correção de Heterocedasticidade com Erros-Padrão Robustos).
* **Visualização de Dados (Dataviz):** `ggplot2` (Gráficos de Dispersão e Séries), `sjPlot` (Plots de Coeficientes) e `stargazer` (Formatação de outputs analíticos).

---

## 🎲 O Dataset: Chapel Hill Expert Survey (CHES)

A base de dados utilizada provém do **CHES (Ciclo 1999-2024)**, uma referência global em Ciência Política que consolida o posicionamento de partidos europeus através de métricas quantificáveis de especialistas.

### 📐 Engenharia e Operacionalização de Variáveis (Feature Engineering)

Para viabilizar a modelagem, as métricas brutas do Codebook da CHES foram transformadas e agregadas em 7 eixos analíticos:

| Variável Analítica | Mapeamento Original (CHES) | Escala / Transformação | Objetivo de Negócio |
| :--- | :--- | :--- | :--- |
| **Apoio à Integração (VD)** | `eu_position` | 1 (Mín) a 7 (Máx) | Variável Dependente (Target). Mede o suporte ao bloco. |
| **Extremismo Ideológico** | Módulo de `Irgen` | `abs(Irgen - 5)` (0 a 5) | Captura de forma linear a distância do partido em relação ao centro político. |
| **Saliência Anti-Elite** | `antielite_salience` | 0 (Mín) a 10 (Máx) | Mensura o peso da retórica anti-establishment no ecossistema. |
| **Nacionalismo** | `nationalism` | 0 (Mín) a 10 (Máx) | Contrapõe discursos cosmopolitas a isolacionistas. |
| **Valores Sociais (GALTAN)**| `GALTAN` | 0 (Libertário) a 10 (Autoritário) | Mede a preferência por ordem e autoridade moral tradicional. |
| **Apoio à Diversidade** | Média de `immigrate_policy`, `multiculturalism`, `ethnic_minorities` | 0 a 10 (Escala invertida para alinhamento direcional) | Consolidação da dimensão de pluralismo sociocultural. |
| **Protecionismo** | `protecionism` | 0 (Livre Comércio) a 10 (Proteção) | Avalia a inclinação ao fechamento de mercados domésticos. |

---

## 📈 Pipeline de Análise de Dados (EDA e Insights)

### 1. Dinâmica Eleitoral e Fragmentação do Sistema Partidário Alemão
Como ponto de partida para a compreensão das transformações estruturais que tensionam a governabilidade do bloco, a análise histórica do comportamento do eleitorado alemão revela uma erosão consistente do espaço político outrora dominado pelas forças tradicionais do establishment.

![Evolução Eleitoral na Alemanha](outputs/figures/grafico_eleicoes_alemanha.jpg)
*Gráfico 1:*

O mapeamento dos ciclos eleitorais entre 2013 e 2025 (Gráfico 1) elucida o avanço contínuo da Alternativa para a Alemanha (AfD). Em sua estreia em 2013, o partido registrou 4,7% dos sufrágios, desempenho insuficiente para superar a cláusula de barreira institucional de 5%, deixando a legenda temporariamente sem representação no Parlamento Federal (Bundestag). No entanto, impulsionado pelas fraturas sociais decorrentes da crise de refugiados de 2015, o AfD consolidou sua transição rumo à "quarta onda" da ultradireita, saltando para 12,6% dos votos em 2017.

Embora o pleito de 2021 tenha sinalizado uma sutil acomodação conjuntural (10,4%), o colapso da coalizão governista ao final de 2024 culminou no resultado histórico de fevereiro de 2025, onde o AfD ascendeu como a segunda maior força política nacional, angariando 20,8% dos votos de legenda. Este crescimento estrangula os partidos tradicionais: a União Democrata-Cristã (CDU), que atingira 34,1% em 2013, viu sua dominância recuar, enquanto o Partido Social-Democrata (SPD) declinou acentuadamente para 16,4% em 2025, evidenciando que o avanço reacionário e populista não se trata de um protesto eleitoral efêmero, mas de uma variável estrutural e permanente na política interna do país.

### 2. O Perfil Ideológico da Ultradireita: O Caso Alemão em 2024
Para compreender as bases programáticas que sustentam o comportamento eleitoral observado, os dados extraídos junto aos especialistas da Chapel Hill Expert Survey (CHES) permitem radiografar tridimensionalmente o posicionamento das agremiações políticas.

![Posicionamento de Partidos na Alemanha - 2024](outputs/figures/grafico_barras_ale_2024.png)
*Gráfico 2:*

A espacialização das variáveis analíticas para o ano de 2024 (Gráfico 2) evidencia o isolamento do AfD em relação ao consenso programático alemão. Enquanto as legendas do establishment (CDU, CSU, FDP e SPD) orbitam em patamares elevados de suporte geral ao projeto europeu — com índices de posicionamento frente à integração (eu_position) situados acima de 5,0 —, o AfD colapsa para a base mínima da escala.

Essa rejeição frontal ao modelo supranacional é indissociável do tripé ideológico que define a direita radical contemporânea: o partido registra escores máximos (próximos a 10,0) nas variáveis de Nacionalismo, Retórica Populista e Identitária, e inclinação a valores tradicionais e autoritários (Índice GALTAN). Nota-se ainda que o avanço do partido consolida uma transição relevante: o antigo viés liberal-conservador focado na Zona do Euro deu lugar a uma agenda assentada no Protecionismo econômico e na rejeição absoluta ao Pluralismo e Multiculturalismo (indicador próximo a zero), materializando o conceito de "chauvinismo de bem-estar", onde a proteção estatal deve ser restrita estritamente aos nativos.

### 3. A Simbiose Populista: Saliência Anti-Elite e Suporte ao Bloco
Aprofundando o nível de análise para o plano comparado do eixo motor da integração, o cruzamento das variáveis sociopolíticas revela padrões comportamentais simétricos entre as forças reacionárias da França e da Alemanha.

![Scatter Plot Populismo vs União Europeia](outputs/figures/grafico_scatter.jpg)
*Gráfico 3:* 

O gráfico de dispersão (Gráfico 3) demonstra uma correlação linear estritamente negativa entre o grau de importância conferido ao discurso anti-establishment e o suporte ao ecossistema institucional de Bruxelas. A linha de tendência descendente ilustra que a instrumentalização da desconfiança popular age de forma inversamente proporcional à aceitação da legitimidade supranacional.

O aspecto analítico mais contundente repousa na localização geográfica das observações do AfD e do Reagrupamento Nacional (RN) nos ciclos de 2019 e 2024. Ambas as legendas situam-se de forma agrupada como outliers no quadrante inferior direito. A saturação de suas retóricas populistas (escalas superiores a 8,5) empurra o posicionamento de liderança em relação à UE para os patamares de rejeição mais severos da amostra. O padrão gráfico confirma a tese de que a narrativa de "irrealidade" e o maniqueísmo que cinde o espaço social entre o "povo puro" e a "elite globalista corrupta" servem como o principal combustível ideológico para justificar a agenda de "soberanismo integral" promovida por Marine Le Pen e pela cúpula do AfD.

---

## 🔬 Modelagem Econométrica e Validação

Visando isolar os efeitos distributivos e conferir robustez metodológica às inferências qualitativas, formulou-se um modelo econométrico de Regressão Linear Múltipla estimado por Mínimos Quadrados Ordinários (OLS), baseado em $487$ observações amostrais:

$$Y_{apoio} = \beta_0 + \beta_1 X_{populismo} + \beta_2 X_{ideologia} + \beta_3 X_{nacionalismo} + \beta_4 X_{diversidade} + \beta_5 X_{galtan} + \epsilon_i$$

![Coefficient Plot Regressão](outputs/figures/grafico_regressao.png)
*Gráfico 4:* 

### 📊 Resultados do Modelo

O modelo demonstrou um **$R^2$ Ajustado de 0.772**, indicando que as variáveis selecionadas possuem um altíssimo poder preditivo, **explicando 77,2% da variação** do euroceticismo na Europa.

* **Extremismo Ideológico ($\beta = -0.352^{***}$):** O preditor mais forte. Cada ponto de afastamento do centro político reduz o apoio à integração em 0.35 pontos na escala. Validação matemática do formato de ferradura (convergência de comportamento nos extremos).

* **Saliência Anti-Elite ($\beta = -0.302^{***}$):** Segundo maior vetor. A estratégia de marketing político focada na polarização ("povo puro" vs "elite corrupta de Bruxelas") possui impacto causal direto e negativo na estabilidade da marca institucional da UE.

* **As variáveis de Nacionalismo ($\beta = -0,149; p < 0,01$)** e **Tradicionalismo/GALTAN ($\beta = -0,117; p < 0,01$)** denotam que o euroceticismo contemporâneo é profundamente tracionado por uma reação cultural de caráter autoritário e comunitarista frente ao cosmopolitismo liberal europeu.

* **Variável de Controle Temporal (`as.factor`):** Não apresentou significância estatística. **Insight:** O desgaste do ecossistema europeu não é um efeito temporal passageiro ou sazonal, mas sim uma consequência direta da mudança estrutural na distribuição das forças partidárias domésticas.

### 🛡️ Diagnóstico de Qualidade do Modelo
1.  **Multicolinearidade:** Submetido ao teste de Fator de Inflação da Variância (VIF) pelo pacote `car`, garantindo que a alta correlação teórica entre Nacionalismo e GALTAN não enviesasse os estimadores.
2.  **Heterocedasticidade:** Corrigida através da aplicação de erros-padrão robustos (`lmtest` e `sandwich`), assegurando que a variabilidade residual inconstante não invalidasse as inferências e os intervalos de confiança ($95\%$).

---

## 🎯 Conclusão & Aplicação Prática (Product Owner Mindset)

Do ponto de vista de **Gestão de Produto e Governança**, os resultados indicam um cenário de travamento operacional e perda de eficiência no eixo motor da Europa. 

A ascensão do RN para 125 assentos na Assembleia Nacional (França, 2024) e do AfD para o recorde histórico de 152 cadeiras no Bundestag (Alemanha, 2025) transformou essas forças de meras minorias de protesto em **atores com poder de veto estrutural**. O "Consenso de Bruxelas" foi fragmentado porque os governos de centro agora operam sob a ameaça eleitoral constante de um eleitorado cativado pelo "chauvinismo de bem-estar".

---

## 📁 Estrutura do Repositório

PROJETO_TCC/
│
├── codebook/                               # Documentação e dicionários de dados do CHES
│   ├── 1999-2019_CHES_codebook.pdf
│   ├── 1999-2024_CHES_codebook.pdf
│   ├── 2019_CHES_codebook.pdf
│   └── CHES+2024+Codebook.pdf
│
├── data/                                   # Repositório de dados brutos e tratados (.csv e .xlsx)
│   ├── .RData                              # Ambiente de dados salvo do R
│   ├── 1999-2024_data.csv                  # Dataset master da Chapel Hill Expert Survey
│   ├── CHES_2024_final_v2.csv              # Dados consolidados e limpos do ciclo 2024
│   ├── dados_reg.csv                       # Tabela tratada estruturada para a regressão OLS
│   ├── data_2019.csv / data_2024.csv       # Amostras temporais estruturadas
│   ├── Expert Survey.csv                   # Base geral de especialistas
│   ├── ale_2014.xlsx / ale_2019.xlsx       # Dados macro eleitorais da Alemanha
│   ├── ale_2024 2025.xlsx                  # Resultados consolidados das eleições alemãs
│   └── fra_2014.xlsx / fra_2019.xlsx       # Dados macro eleitorais da França
│   └── fra_2019_2014.xlsx / fra_2024 2022.xlsx
│
├── outputs/                                # Diretório de resultados do projeto
│   └── figures/                            # Artefatos visuais e tabelas analíticas exportadas
│       ├── ale2014.png                     # Perfil de variáveis analíticas da Alemanha (2014)
│       ├── ale2019.png                     # Perfil de variáveis analíticas da Alemanha (2019)
│       ├── ale2024.png                     # Perfil de variáveis analíticas da Alemanha (2024)
│       ├── Assentos Alemanha.png           # Série temporal de assentos no Bundestag (2013-2025)
│       ├── Assentos França (2012-2017).png # Distribuição legislativa francesa (Ciclo I)
│       ├── Assentos França (2022-2024).png # Distribuição legislativa francesa (Ciclo II)
│       ├── fra2014.png                     # Perfil de variáveis analíticas da França (2014)
│       ├── fra2019.png                     # Perfil de variáveis analíticas da França (2019)
│       ├── fra2024.png                     # Perfil de variáveis analíticas da França (2024)
│       ├── grafico_barras_ale_2024.png     # Dataviz consolidado do abismo ideológico alemão
│       ├── grafico_eleicoes_alemanha.png   # Evolução percentual de votos em legenda (Alemanha)
│       ├── grafico_regressao.png           # Plot de coeficientes e intervalos de confiança (OLS)
│       ├── grafico_scatter.png             # Dispersão: Saliência Populista vs. Apoio à UE
│       ├── grafico_ue_tcc.png              # Análise de médias ponderadas de suporte geral ao bloco
│       ├── spec_ue.png                     # Médias ponderadas focadas em Mercado Comum e Política Externa
│       ├── tabela_regressao_tcc.png        # Renderização do output econométrico do Stargazer
│       ├── votos_franca_12_17.png          # Percentual de votos em primeiro turno na França (Ciclo I)
│       └── votos_franca_22_24.png          # Percentual de votos em primeiro turno na França (Ciclo II)
│
├── dados_eleicoes/                         # Scripts de Análise Exploratória (EDA) de dados eleitorais
│   ├── eleicoes_alemanha.R                 # Processamento de votos/assentos no Bundestag
│   └── eleicoes_frança.R                   # Processamento de dados da Assembleia Nacional
│
├── posicao_partidos/                       # Scripts de análise descritiva e Dataviz cultural
│   ├── graficos_partidos_ue_2014.R         # Mapeamento de eixos ideológicos (Ciclo 2014)
│   ├── graficos_partidos_ue_2019.R         # Mapeamento de eixos ideológicos (Ciclo 2019)
│   └── graficos_partidos_ue_2024.R         # Mapeamento de eixos ideológicos (Ciclo 2024)
│
├── posicao_ue/                             # Análise macro comparativa do bloco
│   └── grafico_ue.R                        # Script das médias ponderadas (Alemanha x França x UE)
│
├── regressao_graficos/                     # Scripts de modelagem estatística e diagnósticos
│   ├── regressao.R                         # Estimação do modelo linear múltipla (OLS) e correções
│   ├── coefficient.R                       # Geração do Coefficient Plot (Variáveis Causa-Efeito)
│   └── scatter.R                           # Geração do Scatter Plot (Saliência Anti-Elite x Apoio UE)
│
├── .gitignore                              # Arquivo de configuração de submissão do Git
└── README.md