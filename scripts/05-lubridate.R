library(lubridate)

# Criando data-horas
dmy_hms("15/04/2021 02:25:30") # Data-hora
dmy_hm("15/04/2021 02:25")     # Sem segundo
dmy_h("15/04/2021 02")         # Sem minuto
as_datetime(1618453530)        # Numérico

# Fusos
mdy_hms("4/15/20 2:25:30 AM")                                # Americano
dmy_hms("15/04/2021 02:25:30", tz = "Europe/London")         # Com fuso
now() - dmy_hms("15/04/2021 02:25:30")                       # Diferença
now() - dmy_hms("15/04/2021 02:25:30", tz = "Europe/London") # Com fuso

# Partes
minute("2021-04-15 02:25:30")                   # Minuto
year("2021-04-15")                              # Ano
wday("2021-04-15")                              # Dia da semana
month("2021-04-15", label = TRUE, abbr = FALSE) # Mês (sem abrev.)

# Operações
today() + months(5)                              # Dia
now() + seconds(5)                               # Segundo
now() + days(5)                                  # Dia
as.period(today() - dmy("01/01/2021")) / days(1) # Dia - dia

# Mais fusos (horário de verão)
t1 <- dmy_hms("15/04/2021 02:25:00", tz = "America/Sao_Paulo")
t2 <- dmy_hms("15/04/2021 02:25:00")
t1 - t2
t1 <- dmy_hms("15/04/2021 02:25:00", tz = "America/Sao_Paulo")
t2 <- dmy_hms("15/04/2021 02:25:00", tz = "Europe/London")     # UTC != GMT
t1 - t2

# Lista dos fusos
OlsonNames()

# Output
format.Date(now(), "%d/%m/%Y %H:%M:%S")

# Conversão para SP (com horário de verão!)
with_tz(dmy_hms("15/02/2019 02:25:00"), tzone = "America/Sao_Paulo")
with_tz(dmy_hms("15/02/2020 02:25:00"), tzone = "America/Sao_Paulo")

# Arrendondar
floor_date(today(), unit = "month") # Função chão
rollforward(today())                # Fim do mês

# Feriados (usar o pacote bizdays)
bizdays::add.bizdays("2020-12-30", 5, cal = "Brazil/ANBIMA")

# Extra: clock ------------------------------------------------------------

# Biblioteca fresquinha!
library(clock)

# O dia 31/01/2020
x <- as.Date("2020-01-31")

# No lubridate, 31/01/2020 + 1 mês é NA
x + months(1)

# Não existe o dia 31/02/2020 (fevereiro tem menos dias), então o lubridate
# simplesmente considera a operação inválida e não nos avisa!

# No clock, 31/01/2020 + 1 mês é um erro que deve ser corrigido
add_months(x, 1)

# Agora podemos especificar uma estratégia de correção
add_months(x, 1, invalid = "overflow")
