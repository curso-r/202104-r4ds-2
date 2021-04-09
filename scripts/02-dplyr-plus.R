library(dplyr)

casas <- dados::casas
casas

casas %>%
  group_by(geral_qualidade) %>%
  summarise(
    lote_area_media = mean(lote_area, na.rm = TRUE),
    venda_valor_medio = mean(venda_valor, na.rm = TRUE)
  )

casas %>%
  group_by(geral_qualidade) %>%
  summarise_at(
    .vars = vars(lote_area, venda_valor),
    .funs = ~mean(.x, na.rm = TRUE)
  )

casas %>%
  group_by(geral_qualidade) %>%
  summarise_if(
    .predicate = is.numeric,
    .funs = ~mean(.x, na.rm = TRUE)
  )

# summarise()
# summarise_at()
# summarise_if()
# summarise_all()

# summarise_at
casas %>%
  group_by(geral_qualidade) %>%
  summarise(across(
    .cols = c(lote_area, venda_valor),       # Variáveis
    .fns  = list(mean, median), na.rm = TRUE # Função
  ))

casas %>%
  group_by(geral_qualidade) %>%
  summarise(across(
    .cols = c(lote_area, venda_valor),
    .fns  = list(media = mean, mediana = median), na.rm = TRUE
  ))

casas %>%
  group_by(geral_qualidade) %>%
  summarise(across(
    .cols = c(lote_area, venda_valor),
    .fns  = list(media = mean, mediana = median), na.rm = TRUE,
    .names = "{.fn}_{.col}"
  ))

# summarise_all
casas %>%
  group_by(geral_qualidade) %>%
  summarise(across(.fns = n_distinct))

# summarise_if
casas %>%
  group_by(geral_qualidade) %>%
  summarise(across(
    .cols = where(is.numeric), # Variáveis
    .fns  = mean, na.rm = TRUE # Função
  ))

casas %>%
  summarise(across(
    where(is.numeric) & ends_with("_area"), mean, na.rm = TRUE
  ))

casas %>%
  group_by(fundacao_tipo) %>%
  summarise(
    across(contains("area"), mean, na.rm = TRUE),
    across(where(is.character), ~sum(is.na(.x))),
    n_obs = n()
  )
