
#' Get and set the schema of a data set or columns in the data set
#
#' @param x the data.frame or vector for which the schema should be set or
#'   obtained. 
#' @param attribute the optional name of the specific attribute to get or set.
#'   When omitted the complete schema is set or obtained.
#' @param value the value to set the schema or attribute with.
#' @param ... passed on to other methods.
#
#' @details
#' The schema is stored in the \code{schema} attribute of the object. When the
#' object does not have a schema associated with it, a default schema appropiate
#' for the object is generated.
#
#' @rdname schema
#' @export
schema <- function(x, attribute, ...) {
  UseMethod("schema")
}

#' @rdname schema
#' @export
schema.default <- function(x, attribute, ...) {
  schema <- generate_schema(x)
  if (!missing(attribute)) schema[[attribute]] else schema
}

#' @rdname schema
#' @export
`schema<-` <- function(x, attribute, value) {
  UseMethod("schema<-")
}

#' @rdname schema
#' @export
`schema<-.default` <- function(x, attribute, value) {
  schema <- schema(x)
  if (!missing(attribute)) {
    schema[[attribute]] <- value
  } else {
    schema <- value
  }
  attr(x, "schema") <- schema
}

