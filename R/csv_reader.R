
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
  # TODO: do something with the meta
  dta <- lapply(path, utils::read.csv)
  dta <- do.call(rbind, dta)
  structure(dta, resource = resource)
}

