library(dplyr)
library(tidyr)

dados::casas
casas <- readr::read_rds("data/casas.rds")

View(casas)

# Motivação: ver o número de categorias
# distintas em cada variável categórica

glimpse(casas)
skimr::skim(casas)

casas %>% 
  summarise(
    across(
      .cols = where(is.character),
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
  pivot_longer(
    cols = everything(),
    names_to = "variavel",
    values_to = "num_categorias"
  ) %>% 
  arrange(desc(num_categorias)) %>% 
  View()

# Motivação: ver quais colunas possuem NAs e quantos

sum(is.na(casas$piscina_qualidade))

casas %>% 
  summarise(
    across(
      .cols = everything(),
      .fns = ~sum(is.na(.x))
    )
  ) %>% 
  View()

casas %>% 
  select(starts_with("piscina"))

casas %>% 
  summarise(
    across(
      .cols = everything(),
      .fns = ~sum(is.na(.x))
    )
  ) %>% 
  select(
    where(~.x > 0)
  ) %>% 
  View()

casas %>% 
  summarise(
    across(
      .cols = everything(),
      .fns = ~sum(is.na(.x))
    )
  ) %>% 
  pivot_longer(
    cols = everything(),
    names_to = "variavel",
    values_to = "num_na"
  ) %>% 
  filter(num_na > 0) %>% 
  arrange(desc(num_na))

vetor <- c(1, NA, 2, NA, 3)
vetor <- c("M", NA, "F", NA)

tidyr::replace_na(vetor, replace = "Sem informação")

casas %>% 
  mutate(
    across(
      where(is.character),
      tidyr::replace_na,
      replace = "A casa não possui"
    )
  ) %>% 
  View()


# -------------------------------------------------------------------------

# Motivação: Descobrir o ator com o maior lucro médio na base IMDB,
# considerando as 3 colunas de elenco.

library(dplyr)
library(tidyr)
library(ggplot2)

imdb <- readr::read_rds("data/imdb.rds")

imdb %>% 
  pivot_longer(
    cols = starts_with("ator"),
    names_to = "protagonismo",
    values_to = "ator_atriz"
  ) %>% 
  View()


imdb %>% 
  pivot_longer(
    cols = starts_with("ator"),
    names_to = "protagonismo",
    values_to = "ator_atriz"
  ) %>% 
  mutate(lucro = receita - orcamento) %>%
  group_by(ator_atriz) %>% 
  # arrange(.by_group = TRUE) %>% 
  summarise(lucro_medio = mean(lucro, na.rm = TRUE)) %>% 
  # arrange(desc(lucro_medio))
  # slice_max(lucro_medio, n = 10)
  top_n(10, lucro_medio)


imdb %>% 
  pivot_longer(
    cols = starts_with("ator"),
    names_to = "protagonismo",
    values_to = "ator_atriz"
  ) %>% View()
  mutate(lucro = receita - orcamento) %>%
  group_by(ator_atriz) %>% 
  summarise(
    lucro_medio = mean(lucro, na.rm = TRUE),
    num_filmes = n()
  ) %>% 
  filter(num_filmes > 10) %>% 
  slice_max(lucro_medio, n = 10)

  