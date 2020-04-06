library(dplyr)

bety_src <- src_postgres(
  dbname = "bety",
  password = 'DelchevskoOro',
  host = 'localhost',
  user = 'viewer',
  port = 5432
)