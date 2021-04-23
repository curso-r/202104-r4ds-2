library(dplyr)
library(purrr)

# Curly-curly -------------------------------------------------------------

# Uma função simples

f <- function(x) {
  x + 1
}

f(x = 10)

a <- 20

f(x = a)
f(x = b)

# No dplyr

starwars %>%
  select(species)

species

starwars %>%
  filter(species == "Human")

# Construíndo uma função com NSE

meu_filter <- function(nome_coluna, valor) {
  starwars %>%
    filter(nome_coluna == valor)
}

meu_filter(species, "Human")
meu_filter("species", "Human")

# Solução: {{ }} (curly-curly)

meu_select <- function(nome_coluna) {
  starwars %>%
    select( {{nome_coluna}} )
}

meu_select(species)

meu_filter <- function(nome_coluna, valor) {
  starwars %>%
    filter({{nome_coluna}} == valor)
}

meu_filter(hair_color, "none")

# strings -----------------------------------------------------------------

# Problema: dar um nome para a média de certa coluna
summarise_mean <- function(nome, col) {
  starwars %>%
    summarise(nome = mean(col, na.rm = TRUE))
}

# É criada uma coluna 'nome' sem valor ('col' não existe)
summarise_mean("media", "height")

# Solução: := (walrus)
summarise_mean <- function(df, nome, col) {
  starwars %>%
    summarise({{nome}} := mean(col, na.rm = TRUE))
}

# É criada uma coluna 'media' sem valor ('col' não existe)
summarise_mean("media", "height")

# Solução: .data
summarise_mean <- function(df, nome, col) {
  starwars %>%
    summarise({{nome}} := mean(.data[[col]], na.rm = TRUE))
}

# É criada uma coluna 'media' com a média de 'height'
summarise_mean("media", "height")

# Exemplo da aula
mutate_menos_1 <- function(df, col_antiga, col_nova) {
  mutate(df, {{col_nova}} := .data[[col_antiga]] - 1)
}

starwars %>%
  select(height) %>%
  mutate_menos_1("height", "heightinha")

# Bônus: dupla interpolação
summarise_mean <- function(col, prefix = "avg") {
  starwars %>%
    summarise("{prefix}_{{col}}" := mean( {{col}} , na.rm = TRUE))
}

# Desafio: entender por que isso funciona!
summarise_mean(height)

# Demonstração em aula (sem precisar de tidy eval)
summarise_tema <- function(df, cols) {
  
  # Aux
  mean_rm <- partial(mean, ... = , na.rm = TRUE)
  
  df %>%
    summarise(across(
      .cols = all_of(cols),
      .fns = mean_rm
    ))
}

summarise_tema(starwars, c("height", "mass", "birth_year"))

# Demonstração em aula (com tidy eval)
summarise_tema <- function(df, cols) {
  
  # Aux
  mean_rm <- partial(mean, ... = , na.rm = TRUE)
  
  # Tabelinha de prefixo
  prefixo <- function(col) {
    switch(col,
      "height" = "corpo",
      "mass" = "corpo",
      "birth_year" = "idade"
    )
  }
  
  # Purrrtaria
  map_dfc(cols, ~summarise(df, "{prefixo(.x)}_{.x}" := mean_rm(.data[[.x]])))
}

summarise_tema(starwars, c("height", "mass", "birth_year"))
