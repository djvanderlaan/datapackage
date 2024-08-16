
#' Get the Field Descriptor associated with a certain field in a Data Resource
#'
#' @param x a \code{dataresource} or \code{tableschema} object.
#' @param fieldname length one character vector with the name of the field.
#'
#' @return
#' An object of type \code{fielddescriptor}.
#'
#' @export
dpfield <- function(x, fieldname) {
  UseMethod("dpfield")
}

#' @export
dpfield.tableschema <- function(x, fieldname) {
  fields <- x$fields
  if (is.null(fields)) stop("Fields are missing from Table Schema.")
  for (i in seq_along(fields)) {
    if (!exists("name", fields[[i]])) stop("Field without name.")
    if (fields[[i]]$name == fieldname) return(
      structure(fields[[i]], class = "fielddescriptor", 
        dataresource = attr(x, "dataresource"))
    )
  }
  stop("Field '", fieldname, "' not found.")
}

#' @export
dpfield.dataresource <- function(x, fieldname) {
  schema <- dpschema(x)
  if (is.null(schema)) stop("Data Resource does not have a schema property.")
  dpfield(schema, fieldname)
}

