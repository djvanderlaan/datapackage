
#' Get a list of properties defined for the object
#'
#' @param x the object for which to obtain the properties
#' 
#' @return
#' Returns a character vector (possibly zero length) with the names of the
#' properties.
#'
#' @seealso
#' The \code{\link{dpproperty}} method can be used to get the values of the
#' properties.
#'
#' @export
#' @rdname dpproperties
dpproperties <- function(x) {
  UseMethod("dpproperties")
}

#' @export
#' @rdname dpproperties
dpproperties.readonlydatapackage <- function(x) {
  names(x)
}

#' @export
#' @rdname dpproperties
dpproperties.editabledatapackage <- function(x) {
  dp <- readdatapackage(attr(x, "path"), attr(x, "filename"))
  dpproperties(dp)
}

#' @export
#' @rdname dpproperties
dpproperties.dataresource <- function(x) {
  names(x)
}

#' @export
#' @rdname dpproperties
dpproperties.tableschema <- function(x) {
  names(x)
}

