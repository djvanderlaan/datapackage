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
#' @rdname dp_property
dp_property <- function(x, attribute) {
  UseMethod("dp_property")
}

#' @export
#' @rdname dp_property
dp_property.readonlydatapackage <- function(x, attribute) {
  x[[attribute]]
}

#' @export
#' @rdname dp_property
dp_property.editabledatapackage <- function(x, attribute) {
  dp <- readdatapackage(attr(x, "path"), attr(x, "filename"))
  dp_property(dp, attribute)
}

#' @export
#' @rdname dp_property
`dp_property<-` <- function(x, attribute, value) {
  UseMethod("dp_property<-")
}

#' @export
#' @rdname dp_property
`dp_property<-.readonlydatapackage` <- function(x, attribute, value) {
  x[[attribute]] <- value
  x
}

#' @export
#' @rdname dp_property
`dp_property<-.editabledatapackage` <- function(x, attribute, value) {
  dp <- readdatapackage(attr(x, "path"), attr(x, "filename"))
  dp[[attribute]] <- value
  writedatapackage(dp) 
  x
}

#' @export
#' @rdname dp_property
dp_property.dataresource <- function(x, attribute) {
  x[[attribute]]
}

#' @export
#' @rdname dp_property
`dp_property<-.dataresource` <- function(x, attribute, value) {
  x[[attribute]] <- value
  x
}

#' @export
#' @rdname dp_property
dp_property.tableschema <- function(x, attribute) {
  x[[attribute]]
}

#' @export
#' @rdname dp_property
`dp_property<-.tableschema` <- function(x, attribute, value) {
  x[[attribute]] <- value
  x
}

#' @export
#' @rdname dp_property
dp_property.fielddescriptor <- function(x, attribute) {
  x[[attribute]]
}

#' @export
#' @rdname dp_property
`dp_property<-.fielddescriptor` <- function(x, attribute, value) {
  x[[attribute]] <- value
  x
}

