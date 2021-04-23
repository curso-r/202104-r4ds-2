# Motivação: fazer uma função que recebe uma tab e uma coluna
# e devolve uma tab sem as linhas com NA na coluna especificada

library(dplyr)

imdb <- readr::read_rds("data/imdb.rds")

filtrar_na <- function(tab, col) {
  tab %>% 
    filter(!is.na({{col}}))
}

imdb_filtrada <- filtrar_na(imdb, orcamento)

any(is.na(imdb_filtrada$orcamento))

# passar como string
filtrar_na <- function(tab, col) {
  tab %>% 
    filter(!is.na(.data[[col]]))
}

filtrar_na(imdb, "orcamento")

# Motivação: fazer uma função que recebe uma tab e uma coluna
# e faz um gráfico de barras da frequência dessa coluna

library(ggplot2)

fazer_grafico <- function(tab, col) {
  tab %>% 
    count({{col}}) %>% 
    ggplot(aes(x = {{col}}, y = n)) +
    geom_col()
}

imdb %>% 
  slice(1:10) %>% 
  fazer_grafico(diretor) +
  theme_bw()

# mtcars %>% 
#   count(cyl)


fazer_grafico <- function(tab, col) {
  tab %>% 
    count(.data[[col]]) %>% 
    ggplot(aes(x = .data[[col]], y = n)) +
    geom_col()
}

fazer_grafico(imdb, "cor")

lubridate::month(lubridate::today())

purrr::map(1:10, sqrt)

imdb %>% 
  na.omit()

imdb %>% 
  ggplot(aes(x = receita, y = nota_imdb)) +
  geom_point()




