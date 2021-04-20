library(purrr)

# Posição
vetor <- c(1, 2, 3, 4)
vetor[4]

# Elemento
lista <- list(1, 2, 3, 4)
lista[[3]]

# Indexação profunda
lista <- list(1, 2, list("3.1", list(3.11, 3.12, 3.13, 3.14), "3.3"), 4)
lista[[3]][[2]][[4]]
pluck(lista, 3, 2, 4)

# Estrutura
str(lista)

# Várias formas de fazer o mesmo
lista <- list(um = 1, dois = 2, tres = 3, quatro = 4)
lista$quatro
lista[[4]]
pluck(lista, 1)
lista[["quatro"]]
pluck(lista, "quatro")

# Map normal e com achatamento
vec <- 1:5
soma_dez <- function(x) {
  x + 10
}

map(vec, soma_dez)
map_dbl(vec, soma_dez)


# Construindo um lambda
f <- function(x) {
  x + 3
}
map_dbl(1:10, f)

map_dbl(1:10, function(x) {
  x + 3
})

map_dbl(1:10, function(x) x + 3)

map_dbl(1:10, ~ .x + 3)

# Os vetores não reciclam!
strings <- c("oiii", "como vai", "tchau")
padroes <- c(".$")
map_chr(strings, stringr::str_extract, pattern = ".$")
stringr::str_extract(strings, pattern = ".$")

# Por que os argumentos fixos ficam de fora?
for (string in strings) {
  print(paste0(string, "-sufixo"))
}

map_chr(strings, paste0, "-sufixo")

map_chr(strings, paste0("-sufixo"))

# Exemplo de como fazer um map de "todos contra todos"
cross(list(list("a", "b", "c"), list(1, 2, 3))) %>%
  map(flatten_chr) %>%
  map_chr(paste0, collapse = "")

# Pergunta do Hidelbrando sobre maps que retornam data frames
funcao <- function(cidade) {
  mtcars %>%
    tibble::rownames_to_column("nome") %>%
    dplyr::filter(nome == cidade) %>%
    dplyr::mutate(mpg * 2)
}

vetor <- c("Mazda RX4", "Mazda RX4 Wag", "Valiant")
map_dfr(vetor, funcao)

# Dois jeitos de fazer pivot_wider em uma list-column de comprimento irregular
library(dplyr)
library(tidyr)

"data/imdb.rds" %>%
  readr::read_rds() %>%
  mutate(split_generos = stringr::str_split(generos, "\\|")) %>%
  select(titulo, split_generos) %>%
  unnest(split_generos)

"data/imdb.rds" %>%
  readr::read_rds() %>%
  mutate(split_generos = stringr::str_split(generos, "\\|")) %>%
  select(titulo, split_generos) %>%
  unnest(split_generos) %>%
  mutate(tem = TRUE) %>%
  pivot_wider(
    names_from = split_generos, values_from = tem,
    values_fn = list, values_fill = list(FALSE)
  ) %>%
  unnest(-titulo) %>%
  glimpse()

"data/imdb.rds" %>%
  readr::read_rds() %>%
  mutate(split_generos = stringr::str_split(generos, "\\|")) %>%
  select(titulo, split_generos) %>%
  unnest(split_generos) %>%
  group_by(titulo) %>%
  slice(1:3) %>%
  dplyr::mutate(n_genero = paste0(1:n(), "_genero")) %>%
  pivot_wider(
    names_from = n_genero, values_from = split_generos,
    values_fill = NA
  ) %>%
  glimpse()

# Map dentro de um mutate e como seria sem
"data/imdb.rds" %>%
  readr::read_rds() %>%
  mutate(split_generos = stringr::str_split(generos, "\\|")) %>%
  select(titulo, split_generos) %>%
  mutate(numero_generos = map_dbl(split_generos, length))

"data/imdb.rds" %>%
  readr::read_rds() %>%
  mutate(split_generos = stringr::str_split(generos, "\\|")) %>%
  select(titulo, split_generos) %>%
  unnest(split_generos) %>%
  group_by(titulo) %>%
  summarise(numero_generos = n())

# set_names()
set_names(mtcars, stringr::str_to_upper)
