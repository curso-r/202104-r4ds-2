# Motivação: fazer uma análise descritiva do Ozônio

library(dplyr)
library(lubridate)
library(ggplot2)

cetesb <- readr::read_rds("data/cetesb.rds")

View(cetesb)

glimpse(cetesb)

cetesb %>% 
  filter(poluente == "O3", estacao_cetesb == "Pinheiros") %>%
  group_by(data) %>% 
  summarise(media_diaria = mean(concentracao, na.rm = TRUE)) %>% 
  ggplot(aes(x = data, y = media_diaria)) +
  geom_line()

cetesb %>% 
  filter(poluente == "O3", estacao_cetesb == "Pinheiros") %>%
  mutate(
    ano = year(data),
    mes = month(data),
    dia = day(data),
    dia_semana = wday(data),
    dia_hora = make_datetime(ano, mes, dia, hora, 0, 0)
  ) %>% 
  ggplot(aes(x = dia_hora, y = concentracao)) +
  geom_line()


ozonio <- cetesb %>% 
  filter(poluente == "O3", estacao_cetesb == "Pinheiros") %>%
  mutate(
    ano = year(data),
    mes = month(data),
    dia = day(data),
    dia_semana = wday(data),
    dia_hora = make_datetime(ano, mes, dia, hora, 0, 0)
  ) 


ozonio %>% 
  group_by(ano) %>% 
  summarise(media = mean(concentracao, na.rm = TRUE)) %>% 
  ggplot(aes(x = ano, y = media)) +
  geom_line()


ozonio %>% 
  mutate(mes = month(data, label = TRUE, locale = "pt_BR.UTF-8")) %>% 
  group_by(mes) %>% 
  summarise(media = mean(concentracao, na.rm = TRUE)) %>% 
  ggplot(aes(x = mes, y = media, group = 1)) +
  geom_line()

ozonio %>% 
  group_by(mes, ano) %>% 
  summarise(media = mean(concentracao, na.rm = TRUE)) %>% 
  mutate(
    mes_ano = make_date(ano, mes, 1)
  ) %>% 
  ggplot(aes(x = mes_ano, y = media)) +
  geom_line()

ozonio %>% 
  group_by(dia_semana) %>% 
  summarise(media = mean(concentracao, na.rm = TRUE)) %>% 
  ggplot(aes(x = dia_semana, y = media)) +
  geom_line()

ozonio %>% 
  group_by(hora) %>% 
  summarise(media = mean(concentracao, na.rm = TRUE)) %>% 
  ggplot(aes(x = hora, y = media)) +
  geom_line()



