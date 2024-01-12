
#' Modify a set of Data Resources in a Data Package
#'
#' @param x a \code{datapackage} object
#' @param value a list of \code{dataresource} objects
#'
#' @return
#' Returns a modified \code{x}.
#'
#' @export
`dpresources<-` <- function(x, value) {
  for (i in seq_along(value)) {
    r <- value[[i]]
    name <- dpname(r)
    if (is.null(name)) name <- paste0("resource", i)
    dpresource(x, name) <- r
  }
  x
}

