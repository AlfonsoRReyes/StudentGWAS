#' Class
#'
#' @importFrom RSQLite dbConnect dbListTables dbGetQuery dbDisconnect
#'
setClass("GWASdata", slots = c(datapath = "character",
                               dataconn = "list",
                               metadatapath = "character",
                               metadataconn = "SQLiteConnection",
                               nrow = "integer",
                               ncol = "integer"
                               ))

GWASdata <- function(datapath, metadatapath) {

  #mydb <- dbConnect(RSQLite::SQLite(), "./inst/extdata/small_metadata.sqlite")
  mydb <- dbConnect(RSQLite::SQLite(), metadatapath)
  dbListTables(mydb)
  subjects <- dbGetQuery(mydb, "SELECT * FROM subjects")
  snps <- dbGetQuery(mydb, "SELECT * FROM snps")
  dbDisconnect(mydb)


  return(list(subjects, snps))
}
