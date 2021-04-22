library(tidyverse)

tab <- tibble(
  paciente = 1:10,
  idade = sample(18:60, 10, replace = TRUE),
  memoria_pre = runif(10),
  memoria_pos = runif(10),
  atencao_pre = runif(10),
  atencao_pos = runif(10),
  outra_pre = runif(10),
  outra_pos = runif(10),
  fdtatencao_pre = runif(10),
  fdtatencao_pos = runif(10)
)

View(tab)

tab %>%
  pivot_longer(
    -c(idade, paciente),
    names_to = c(".value", "momento"),
    names_pattern = "(.+)_(.+)"
  )
