

#' Get the names of the resources in a Data Package
#'
#' @param dp A \code{datapackage} object.
#'
#' @return
#' Returns a character vector with the names of the data resources in the Data
#' Package.
#'
#' @export
dp_resource_names <- function(dp) {
  resources <- sapply(dp_property(dp, "resources"), function(r) {
    if (!exists("name", r)) stop("Resource without name.")
    r$name
  })
  resources
}

