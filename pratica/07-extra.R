# Motivação: ver o número de categorias
# distintas em cada variável categórica

library(dplyr)

casas <- readr::read_rds("data/casas.rds")

casas %>% 
  select(where(is.character)) %>% 
  summarise(
    across(
      .cols = everything(),
      .fns = n_distinct
    )
  ) %>% 
  View()

casas %>% 
  select(where(is.character)) %>% 
  summarise(
    across(
      .fns = n_distinct
    )
  ) %>% 
  View()

casas %>% 
  summarise(
    across(
      .cols = where(is.character),
      .fns = n_distinct
    )
  ) %>% 
  View()

casas %>% select(where(is.factor))


# Motivação: substituir todos os NAs das variáveis
# categóricas por "sem informação"

casas %>% 
  mutate(
    across(
      where(is.character),
      tidyr::replace_na,
      replace = "Sem info"
    )
  ) %>% 
  View()

casas %>% 
  mutate(
    across(
      where(is.character),
      ~tidyr::replace_na(.x, replace = "Sem info")
    )
  ) %>% View

subs_por_sem_info <- function(xy) {
  tidyr::replace_na(xy, replace = "Sem info")
}

casas %>% 
  mutate(
    across(
      where(is.character),
      subs_por_sem_info
    )
  ) %>% View


casas %>% 
  transmute(
    across(
      1:10,
      .fns = ~tidyr::replace_na(.x, replace = "Sem info")
    )
  ) %>% View

# -------------------------------------------------------------------------

# Motivação: fazer uma tabela do lucro médio anual dos filmes
# de comédia, ação e romance (2000 a 2016)

library(dplyr)
library(tidyr)
library(stringr)

imdb <- readr::read_rds("data/imdb.rds")

imdb %>% 
  filter(ano >= 2000) %>% 
  mutate(
    lucro = receita - orcamento,
    flag_comedia = str_detect(generos, "Comedy"),
    flag_acao = str_detect(generos, "Action"),
    flag_romance = str_detect(generos, "Romance")
  ) %>%
  select(titulo, ano, lucro, starts_with("flag")) %>% 
  pivot_longer(
    starts_with("flag"),
    names_to = "genero",
    values_to = "flag"
  ) %>% View
filter(flag == TRUE) %>%
  group_by(genero, ano) %>% 
  summarise(lucro_medio = mean(lucro, na.rm = TRUE)) %>% 
  arrange(ano) %>% 
  pivot_wider(
    names_from = ano,
    values_from = lucro_medio
  ) %>% View()

# outra maneira de fazer

str_split(imdb$generos[1:2], "\\|")  

imdb %>% 
  filter(ano >= 2000) %>% 
  mutate(
    lucro = receita - orcamento,
    genero = str_split(generos, "\\|")
  ) %>% 
  unnest(genero) %>%
  # filter(genero %in% c("Comedy", "Action", "Romance")) %>%
  group_by(genero, ano) %>% 
  summarise(lucro_medio = mean(lucro, na.rm = TRUE)) %>% 
  arrange(ano) %>% 
  pivot_wider(
    names_from = ano,
    values_from = lucro_medio
  ) %>% View()

imdb %>% 
  tidyr::separate(
    generos,
    into = c("genero1", "genero2", "genero3"),
    sep = "\\|"
  ) %>% View


imdb %>% 
  mutate(
    num_generos = str_count(generos, pattern = "\\|") + 1
  ) %>% 
  select(generos, num_generos) %>% 
  summarise(maximo = max(num_generos))


imdb %>% 
  filter(ano >= 2000) %>% 
  mutate(
    lucro = receita - orcamento,
    genero = str_split(generos, "\\|")
  ) %>% 
  unnest(genero) %>%
  count(genero)

# Agrupando os generos menos frequentes

imdb %>% 
  filter(ano >= 2000) %>% 
  mutate(
    lucro = receita - orcamento,
    genero = str_split(generos, "\\|")
  ) %>% 
  unnest(genero) %>% View()
mutate(
  genero = forcats::fct_lump(genero, 5)
) %>% 
  group_by(genero, ano) %>% 
  summarise(lucro_medio = mean(lucro, na.rm = TRUE)) %>% 
  arrange(ano) %>% 
  pivot_wider(
    names_from = ano,
    values_from = lucro_medio
  )


# -------------------------------------------------------------------------

# Motivação: extrair o subtítulos dos filmes ***


library(dplyr)
library(tidyr)
library(stringr)

imdb <- readr::read_rds("data/imdb.rds")

imdb %>% 
  mutate(
    subtitulo = str_extract(titulo, ": .*"),
    subtitulo = str_remove(subtitulo, "^: ")
  ) %>%
  select(titulo, subtitulo) %>% View


# -------------------------------------------------------------------------
# Motivação: fazer uma análise descritiva do Ozônio

library(dplyr)
library(lubridate)
library(ggplot2)

cetesb <- readr::read_rds("data/cetesb.rds")

# correlação com lag

cetesb %>% 
  mutate(
    concentracao_lag3 = lag(concentracao, 3)
  ) %>% 
  relocate(concentracao_lag3, .after = concentracao) %>% 
  View()

cetesb %>% 
  filter(poluente == "O3", estacao_cetesb == "Ibirapuera") %>% 
  mutate(
    concentracao_lag3 = lag(concentracao, 3)
  ) %>% 
  ggplot(aes(y = concentracao, x = concentracao_lag3)) +
  geom_point()

cetesb %>%
  filter(
    poluente %in% c("O3", "NO2"),
    estacao_cetesb == "Ibirapuera"
  ) %>%
  select(data, hora, poluente, concentracao) %>%
  tidyr::pivot_wider(names_from = poluente, values_from = concentracao) %>%
  mutate(
    NO2 = lag(NO2, 3)
  ) %>%
  filter(hora == 13) %>% 
  ggplot(aes(x = NO2, y = O3)) +
  geom_point()



# -------------------------------------------------------------------------
# Motivação: criar coluna de pontos do time da casa
# ganhos a partir de um placar ({brasileirao}) 

library(purrr)
library(dplyr)

# remotes::install_github("williamorim/brasileirao")
# brasileirao::matches

brasileirao::matches %>% View()

gols <- stringr::str_split("1x2", "x", simplify = TRUE)
gols[1]
gols[2]

calcular_pontos <- function(placar) {
  gols <- stringr::str_split(placar, "x", simplify = TRUE)
  if (gols[1] > gols[2]) {
    return(3)
  } else if (gols[1] < gols[2]) {
    return(0)
  } else if (gols[1] == gols[2]) {
    return(1)
  }
}

purrr::map_dbl(c("1x2", "2x2"), calcular_pontos)

brasileirao::matches %>% 
  mutate(
    pontos = map_dbl(score, calcular_pontos)
  ) %>% View()

# Versão vetorizada

calcular_pontos2 <- function(placar) {
  gols <- stringr::str_split(placar, "x", simplify = TRUE)
  gols_casa <- gols[,1]
  gols_visitante <- gols[,2]
  case_when(
    gols_casa > gols_visitante ~ 3,
    gols_casa < gols_visitante ~ 0,
    TRUE ~ 1
  )
}

calcular_pontos2(c("2x3", "2x1", "1x1", "0x1"))

stringr::str_split(c("2x3", "2x1"), "x", simplify = TRUE)

x <- -10:10

case_when(
  x > 1 ~ "legal",
  TRUE ~ "não legal"
)

brasileirao::matches %>% 
  mutate(
    pontos = calcular_pontos2(score)
  ) %>% View()


























