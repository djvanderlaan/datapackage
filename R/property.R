#' Get and set properties of Data Packages and Data Resources
#' 
#' @param x a \code{datapackage} or \code{dataresource} object.
#' 
#' @param attribute a length 1 character vector with the name of the property.
#' 
#' @param value the new value of the property.
#'
#' @seealso
#' See \code{\link{dpname}} etc. for methods for specific properties for Data
#' Packages and \code{\link{dpencoding}} etc. for specific properties for Data
#' Resources. These specific methods also check if the input is valid for the
#' given property.
#'
#' @return
#' Either returns the property or modifies the object.
#' 
#' @export
#' @rdname dpproperty
dpproperty <- function(x, attribute) {
  UseMethod("dpproperty")
}

#' @export
#' @rdname dpproperty
dpproperty.readonlydatapackage <- function(x, attribute) {
  x[[attribute]]
}

#' @export
#' @rdname dpproperty
dpproperty.editabledatapackage <- function(x, attribute) {
  dp <- readdatapackage(attr(x, "path"), attr(x, "filename"))
  dpproperty(dp, attribute)
}

#' @export
#' @rdname dpproperty
`dpproperty<-` <- function(x, attribute, value) {
  UseMethod("dpproperty<-")
}

#' @export
#' @rdname dpproperty
`dpproperty<-.readonlydatapackage` <- function(x, attribute, value) {
  x[[attribute]] <- value
  x
}

#' @export
#' @rdname dpproperty
`dpproperty<-.editabledatapackage` <- function(x, attribute, value) {
  dp <- readdatapackage(attr(x, "path"), attr(x, "filename"))
  dp[[attribute]] <- value
  writedatapackage(dp) 
  x
}

#' @export
#' @rdname dpproperty
dpproperty.dataresource <- function(x, attribute) {
  x[[attribute]]
}

#' @export
#' @rdname dpproperty
`dpproperty<-.dataresource` <- function(x, attribute, value) {
  x[[attribute]] <- value
  x
}

