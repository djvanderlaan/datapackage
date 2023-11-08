#' Get the Data Package associated with the object
#' 
#' @param x the object for which to determine the associated Data Package
#'
#' @details
#' This method can, of course, only determine the Data Package when this
#' information is stored in one of the attributes of the object. This can be
#' either be a \code{datapackage} attribute or an \code{dataresource}
#' attribute.
#'
#' @return
#' Returns a Data Resource object, or returns \code{NULL} when none could be
#' found.
#' 
#' @export
dpgetdatapackage <- function(x) {
  UseMethod("dpgetdatapackage")
}

#' @export
dpgetdatapackage.datapackage <- function(x) {
  x
}

#' @export
dpgetdatapackage.dataresource <- function(x) {
  attr(x, "datapackage")
}

#' @export
dpgetdatapackage.fielddescriptor <- function(x) {
  resource <- attr(x, "dataresource")
  if (is.null(resource)) {
    NULL
  } else {
    dpgetdatapackage(resource)
  }
}

