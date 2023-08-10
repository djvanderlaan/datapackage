
#' @export
csv_reader <- function(path, resource) {
  # TODO: do something with the meta
  dta <- lapply(path, read.csv)
  dta <- do.call(rbind, dta)
  structure(dta, resource = resource)
}

