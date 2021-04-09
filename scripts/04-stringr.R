library(stringr)

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
str_extract(frutas, "[a-z]")
str_extract(frutas, "[A-Z]")
str_extract(frutas, "[0-9]")
str_extract(ois, "(oi)+") # Tudo
str_extract("oioioi!", "(oi)+")

str_remove_all("Meu número é 392023904", "[0-9]")

# Regex com escapados
cat("Eu disse \"oi\"")
str_replace("Bom dia.", ".", "!")
str_replace("Bom dia.", "\\.", "!")      # Escapando
str_replace("Bom. Dia.", "\\.", "!")
str_replace_all("Bom. Dia.", "\\.", "!") # Lembrar do _all
str_remove_all("Bom \"dia\"", "\\\"")    # Escapando escape

# Para um filter()
str_detect(frutas, "ma$")

str_replace("Uma barra: \\", "\\\\", "!")
str_trim("     asdkjfhasdf   ")
str_squish("     as   dkjf        hasdf   ")
