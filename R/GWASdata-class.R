#' Class
#'
#' @importFrom RSQLite dbConnect dbListTables dbGetQuery dbDisconnect
#' @importFrom RNetCDF open.nc read.nc
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
    #mydb <- dbConnect(RSQLite::SQLite(), "./inst/extdata/small_metadata.sqlite")
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
