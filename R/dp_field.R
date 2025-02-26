
#' Get the Field Descriptor associated with a certain field in a Data Resource
#'
#' @param x a \code{dataresource} or \code{tableschema} object.
#' @param field_name length one character vector with the name of the field.
#'
#' @return
#' An object of type \code{fielddescriptor}.
#'
#' @export
dp_field <- function(x, field_name) {
  UseMethod("dp_field")
}

#' @export
dp_field.tableschema <- function(x, field_name) {
  fields <- x$fields
  if (is.null(fields)) stop("Fields are missing from Table Schema.")
  for (i in seq_along(fields)) {
    if (!exists("name", fields[[i]])) stop("Field without name.")
    if (fields[[i]]$name == field_name) return(
      structure(fields[[i]], class = "fielddescriptor", 
        dataresource = attr(x, "dataresource"))
    )
  }
  stop("Field '", field_name, "' not found.")
}

#' @export
dp_field.dataresource <- function(x, field_name) {
  schema <- dp_schema(x)
  if (is.null(schema)) stop("Data Resource does not have a schema property.")
  dp_field(schema, field_name)
}

