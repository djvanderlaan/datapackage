
#' Read the CSV-data for a Data Resource
#' 
#' @param path path to the data set. 
#' 
#' @param resource a Data Resource.
#'
#' @seealso
#' Generally used by calling \code{\link{getdata}}.
#'
#' @return
#' Returns a \code{data.frame} with the data.
#'
#' @export
csv_reader <- function(path, resource) {
  tableschema <- property(resource, "schema")
  # TODO: do something with the CSV-description
  if (is.null(tableschema)) {
    dta <- lapply(path, utils::read.csv)
  } else {
    dta <- lapply(path, csv_read, schema = tableschema)
  }
  dta <- do.call(rbind, dta)
  structure(dta, resource = resource)
}

