#' Modify a set of Data Resources in a Data Package
#'
#' @param x a \code{datapackage} object
#'
#' @param value a \code{dataresource} object or a list of \code{dataresource}
#' objects .
#'
#' @return
#' Returns a modified \code{x}.
#'
#' @export
`dpresources<-` <- function(x, value) {
  if (methods::is(value, "dataresource")) {
    name <- dpname(value)
    if (is.null(name)) stop("name of data resource is missing")
    dpresource(x, name) <- value
  } else {
    for (i in seq_along(value)) {
      dpresources(x) <- value[[i]]
    }
  }
  x
}

