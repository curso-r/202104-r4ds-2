install.packages("usethis")

usethis::create_project("~/Documents/aular2")

`%>%` <- magrittr::`%>%`
usethis::use_pipe() # CURSO PACOTES

source("R/meu_script.R")
devtools::load_all() # CURSO PACOTES

# CRIAR UMA PASTA data/
readr::write_rds()
usethis::use_data() # CURSO PACOTES

usethis::use_git()

usethis::use_git_config(
  user.name = "clente",
  user.email = "clente@curso-r.com"
)

usethis::create_github_token()
gitcreds::gitcreds_set()

usethis::use_github()
# SELECIONAR HTTPS

# PARA COISAS PRIVADAS
usethis::use_github(private = TRUE)
