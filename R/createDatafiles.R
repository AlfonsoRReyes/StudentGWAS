
#' Open a SQLite file
#' @importFrom RSQLite dbConnect dbListTables dbGetQuery dbDisconnect
#' @export
#'
openMySQLiteFile <- function() {
  # connect to sqlite
  #library(DBI)
  mydb <- dbConnect(RSQLite::SQLite(), "./inst/extdata/small_metadata.sqlite")
  dbListTables(mydb)
  dbGetQuery(mydb, "SELECT * FROM subjects")
  dbGetQuery(mydb, "SELECT * FROM snps")
  dbDisconnect(mydb)
  # @importFrom DBI dbConnect dbListTables dbGetQuery dbDisconnect
  # @importMethodsFrom RSQlite dbConnect dbListTables dbGetQuery dbDisconnect
}
