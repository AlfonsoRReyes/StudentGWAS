#' Class
#'
#' @importFrom RSQLite dbConnect dbListTables dbGetQuery dbDisconnect
#' @importFrom RNetCDF open.nc read.nc
#' @importFrom methods new
#'
setClass("GWASdata", slots = c(datapath = "character",
                               dataconn = "list",
                               metadatapath = "character",
                               metadataconn = "SQLiteConnection",
                               nrow = "integer",
                               ncol = "integer"
                               ))


GWASdataRead <- function(datapath, metadatapath) {
    # open the SQLite connection
    mydb <- dbConnect(RSQLite::SQLite(), metadatapath)
    dbListTables(mydb)
    subjects <- dbGetQuery(mydb, "SELECT * FROM subjects")
    snps <- dbGetQuery(mydb, "SELECT * FROM snps")
    dbDisconnect(mydb)

    # open the netcdf connection
    nc <- open.nc(datapath)
    print(nc)
    nc_data <- read.nc(nc)
    mytemp <- as.data.frame(nc_data$temperature)

    return(list(subjects, snps, mytemp))
}



GWASdata <- function(datapath, metadatapath) {

    dataconn <- open.nc(datapath)
    class(dataconn) <- NULL
    dataconn <- list(dataconn)
    nrow <- 1L
    ncol <- 1L
    metadataconn <- dbConnect(RSQLite::SQLite(), metadatapath)

    new("GWASdata", datapath = datapath, dataconn = dataconn,
        metadatapath = metadatapath, metadataconn = metadataconn,
        nrow = nrow, ncol = ncol)
    # dataconn
}


setGeneric("dataconn", function(x) standardGeneric("dataconn"))
setMethod("dataconn", "GWASdata",
          function(x) {
              dataconn <- x@dataconn
              class(dataconn) <- "ncdf"
              x@dataconn
          })


setMethod("nrow", "GWASdata",
          function(x) {
              mydb <- dbConnect(RSQLite::SQLite(), x@metadatapath)
              subjects <- dbGetQuery(mydb, "SELECT * FROM subjects")
              return(nrow(subjects))
})


setMethod("ncol", "GWASdata",
          function(x) {
              mydb <- dbConnect(RSQLite::SQLite(), x@metadatapath)
              ncol_subjects <- ncol(dbGetQuery(mydb, "SELECT * FROM subjects"))
              ncol_snps <- ncol(dbGetQuery(mydb, "SELECT * FROM snps"))
              return(list(ncol_subjects = ncol_subjects, ncol_snps = ncol_snps))
          })
