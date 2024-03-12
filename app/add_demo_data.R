library(stringi)
library(DBI)
library(RPostgres)


dt <- data.frame(
  id = stri_rand_strings(40,5),
  quarto = floor(runif(40,min = 0, max = 5)),
  publishing = sample(c("Quarto","LaTeX", "Word"),
                      size = 40,replace = TRUE),
  programming = sample(c("R","Python","Julia","Go"),
                       size = 40,replace = TRUE),
  stringsAsFactors = FALSE
)

con <- dbConnect(
  drv = Postgres(),
  dbname = "postgres",
  port = 1111,
  user = Sys.getenv("PG_USER"),
  password = Sys.getenv("PG_PASSWORD"),
  host = "localhost"
) 

dbExecute(con,"SET SEARCH_PATH=rseed")


dbWriteTable(con, "survey_responses", dt, append = TRUE)
dbDisconnect(con)
