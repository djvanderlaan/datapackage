
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

