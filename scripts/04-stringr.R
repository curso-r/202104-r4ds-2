library(stringr)

# CEP
cep <- "04066-094"
bairo <- str_sub(cep, start = 1, end = 5)
loco  <- str_sub(cep, start = 7, end = 9)
loco  <- str_sub(cep, start = -3, end = -1)

# Nome
nome <- c("Ghion", "Guion", "Gxion")
str_detect(nome, "G.ion")

# Escapando caracteres especiais
ponto <- c("Teste", "Teste.")
str_detect(ponto, "\\.")

# Strigs de exemplo
frutas <- c("banana", "TANGERINA", "maçã", "lima")
ois <- c("oi", "oii", "oiii!", "oiii!!!")

# Regex básico
str_subset(frutas, "na")  # Texto
str_subset(frutas, "NA")  # Maiúscula
str_subset(frutas, "ma")
str_subset(frutas, "^ma") # Início
str_subset(frutas, "ma$") # Final
str_subset(frutas, ".a")  # Qualquer
str_subset("nao", "na")
str_subset("nao", ".na")

# Regex com quantidades
str_extract(ois, "i+")     # 1 ou mais
str_extract_all("oioiiioi", "i+")
str_extract(ois, "i+!")
str_extract(ois, "i+!?")   # 0 ou 1
str_extract(ois, "i+!*")   # 0 ou mais
str_extract(ois, "i*")
str_extract(ois, "i{1,2}") # Entre m e n

# Regex com conjuntos
str_extract(ois, "[i!]$") # Algum
str_extract(ois, "[i!]+") # Algum
str_extract("oi!i!i!i!", "[i!]+")
str_subset(frutas, "[nN]")
str_subset(c("ghion", "Guion", "Gxion"), "[Gg][hu]ion")
str_extract(frutas, "[a-z]")
str_extract(frutas, "[A-Z]")
str_extract(frutas, "[0-9]")
str_extract(ois, "(oi)+") # Tudo
str_extract("oioioi!", "(oi)+")

str_remove("Meu número é 392023904", "[0-9]")     # Não funciona
str_remove("Meu número é 392023904", "[0-9]+")
str_remove_all("Meu número é 392023904", "[0-9]")

# 1a texto
"teste "disso" aqui"
"teste \"disso\" aqui"
'teste \'disso\' aqui'
'teste "disso" aqui' # <- Usar isso aqui
"teste 'disso' aqui"

# 2a regex
str_replace("Bom dia.", pattern = "\\.", replacement = "!")

# Regex com escapados
cat("Eu disse \"oi\"")
cat('Eu disse "oi"') # <- Usar isso aqui
str_replace("Bom dia.", ".", "!")
str_replace("Bom dia.", "\\.", "!")      # Escapando
str_replace("Bom. Dia.", "\\.", "!")
str_replace_all("Bom. Dia.", "\\.", "!") # Lembrar do _all
str_remove_all("Bom \"dia\"", "\\\"")    # Escapando escape

# Para um filter()
dplyr::select(str_detect(frutas, "ma$"))

# Escapando a barra
str_replace("Uma barra: \\", "\\\\", "!")

# Português
stringi::stri_trans_general("Váríös àçêntõs", "Latin-ASCII")
str_extract("número: (11) 91234-1234", "[a-z]+")     # Acentos
str_extract("número: (11) 91234-1234", "[:alpha:]+") # Acentos
str_replace(c("Cassio", "Cássio"), "C[aá]ssio")

# Extra
str_replace(c("Cassio sio teste"), "(\\W)sio(\\W)", "\\1AQUI\\2")

# Ignorando maíuscula
str_detect(frutas, "[nN][aA]")
str_detect(frutas, regex("na", ignore_case = TRUE))
