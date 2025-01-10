#' List the fields in a Data Resource
#' 
#' @param x object for which to get the field names. This can either be a Data
#' Resource or Table Schema.
#'
#' @return
#' Returns a character vector with the fields in the Data Resource.
#'
#' @export
dp_field_names <- function(x) {
  UseMethod("dp_field_names")
}

#' @export
dp_field_names.tableschema <- function(x) {
  # TODO: convert to dp_property
  fields <- x$fields
  if (is.null(fields)) stop("Fields are missing from Table Schema of Data Resource.")
  sapply(fields, function(f) {
    if (!exists("name", f)) stop("Field without name.")
    f$name
  })
}

#' @export
dp_field_names.dataresource <- function(x) {
  schema <- dpschema(x)
  if (is.null(schema)) stop("Data Resource does not have a schema property.")
  dp_field_names(schema)
}

