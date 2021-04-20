# Motivação: ler e empilhar as bases IMDB separadas por ano.

library(dplyr)

imdb_2000 <- readr::read_rds("data/imdb_por_ano/imdb_2000.rds")

arquivos <- list.files("data/imdb_por_ano", full.names = TRUE)
imdb <- purrr::map_dfr(arquivos, readr::read_rds)

imdb <- purrr::map(arquivos, readr::read_rds) %>% 
  bind_rows()

is.list(imdb)
str(imdb)

#  Supondo que a coluna ano não existisse

file %>% 
  stringr::str_extract("[0-9]{4}\\.rds$") %>% 
  stringr::str_remove("\\.rds") %>% 
  as.numeric()

ler_base <- function(file) {
  ano_ <- file %>% 
    stringr::str_extract("[0-9]{4}\\.rds$") %>% 
    stringr::str_remove("\\.rds") %>% 
    as.numeric()
  
  readr::read_rds(file) %>% 
    mutate(ano_2 = ano_, arquivo = basename(file))
}

imdb2 <- purrr::map_dfr(arquivos, ler_base)
View(select(imdb2, ano, ano_2))
View(imdb2)

# exemplo com número sequencial em vez do ano

ler_base <- function(file, id_) {
  readr::read_rds(file) %>% 
    mutate(id = id_)
}

id <- seq_along(arquivos)

imdb3 <- purrr::map2_dfr(arquivos, id, ler_base)
View(imdb3)
imdb3 %>% select(ano, id) %>% View()


# lubridate::as_date("imdb_2014.rds", format = "imdb_%Y.rds")
# readr::parse_number("imdb_2014.rds")

# -------------------------------------------------------------------------

# Motivação: fazer gráficos de dispersão do orçamento vs receita
# para todos os anos da base

library(dplyr)
library(purrr)
library(ggplot2)
library(tidyr)

imdb <- readr::read_rds("data/imdb.rds")

imdb_nest <- imdb %>% 
  group_by(ano) %>% 
  tidyr::nest()

fazer_grafico_receita_orcamento <- function(tab) {
  tab %>% 
    ggplot(aes(x = orcamento, y = receita)) +
    geom_point()
}

fazer_grafico_receita_orcamento(imdb_nest$data[[1]])

imdb_graficos <- imdb %>% 
  filter(!is.na(ano)) %>% 
  group_by(ano) %>% 
  tidyr::nest() %>% 
  mutate(grafico = map(data, fazer_grafico_receita_orcamento))

imdb_graficos$grafico[3]

imdb_graficos %>% 
  filter(ano == 1989) %>% 
  pull(grafico)

imdb_graficos %>% 
  filter(ano == 1989) %>% 
  pull(ano)

walk2(
  imdb_graficos$ano,
  imdb_graficos$grafico,
  ~ ggsave(filename = paste0("graficos/", .x, ".png"), .y)
)

iwalk

criar_coluna_lucro <- function(tab) {
  tab %>% 
    mutate(lucro = receita - orcamento)
}

imdb_nest_lucro <- imdb_nest %>% 
  mutate(
    data = map(data, criar_coluna_lucro)
  )

View(imdb_nest_lucro$data[[1]])















