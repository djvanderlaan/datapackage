
#' Get a list of properties defined for the object
#'
#' @param x the object for which to obtain the properties
#' 
#' @return
#' Returns a character vector (possibly zero length) with the names of the
#' properties.
#'
#' @seealso
#' The \code{\link{dp_property}} method can be used to get the values of the
#' properties.
#'
#' @export
#' @rdname dp_properties
dp_properties <- function(x) {
  UseMethod("dp_properties")
}

#' @export
#' @rdname dp_properties
dp_properties.readonlydatapackage <- function(x) {
  names(x)
}

#' @export
#' @rdname dp_properties
dp_properties.editabledatapackage <- function(x) {
  dp <- readdatapackage(attr(x, "path"), attr(x, "filename"))
  dp_properties(dp)
}

#' @export
#' @rdname dp_properties
dp_properties.dataresource <- function(x) {
  names(x)
}

#' @export
#' @rdname dp_properties
dp_properties.tableschema <- function(x) {
  names(x)
}

