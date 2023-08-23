
#' Get a list of properties defined for the object
#'
#' @param x the object for which to obtain the properties
#' 
#' @return
#' Returns a character vector (possibly zero length) with the names of the
#' properties.
#'
#' @seealso
#' The \code{\link{property}} method can be used to get the values of the
#' properties.
#'
#' @export
#' @rdname properties
properties <- function(x) {
  UseMethod("properties")
}

#' @export
#' @rdname properties
properties.readonlydatapackage <- function(x) {
  names(x)
}

#' @export
#' @rdname properties
properties.editabledatapackage <- function(x) {
  dp <- readdatapackage(attr(x, "path"), attr(x, "filename"))
  properties(dp)
}

#' @export
#' @rdname properties
properties.dataresource <- function(x) {
  names(x)
}

