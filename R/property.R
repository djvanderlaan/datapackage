#' Get and set properties of Data Packages and Data Resources
#' 
#' @param x a \code{datapackage} or \code{dataresource} object.
#' 
#' @param attribute a length 1 character vector with the name of the property.
#' 
#' @param value the new value of the property.
#'
#' @seealso
#' See \code{\link{name}} etc. for methods for specific properties for Data
#' Packages and \code{\link{encoding}} etc. for specific properties for Data
#' Resources. These specific methods also check if the input is valid for the
#' given property.
#'
#' @return
#' Either returns the property or modifies the object.
#' 
#' @export
#' @rdname property
property <- function(x, attribute) {
  UseMethod("property")
}

#' @export
#' @rdname property
property.readonlydatapackage <- function(x, attribute) {
  x[[attribute]]
}

#' @export
#' @rdname property
property.editabledatapackage <- function(x, attribute) {
  dp <- readdatapackage(attr(x, "path"), attr(x, "filename"))
  property(dp, attribute)
}

#' @export
#' @rdname property
`property<-` <- function(x, attribute, value) {
  UseMethod("property<-")
}

#' @export
#' @rdname property
`property<-.readonlydatapackage` <- function(x, attribute, value) {
  x[[attribute]] <- value
  x
}

#' @export
#' @rdname property
`property<-.editabledatapackage` <- function(x, attribute, value) {
  dp <- readdatapackage(attr(x, "path"), attr(x, "filename"))
  dp[[attribute]] <- value
  writedatapackage(dp) 
  x
}

#' @export
#' @rdname property
property.dataresource <- function(x, attribute) {
  x[[attribute]]
}

#' @export
#' @rdname property
`property<-.dataresource` <- function(x, attribute, value) {
  x[[attribute]] <- value
  x
}

