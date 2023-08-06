
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

