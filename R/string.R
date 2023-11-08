# Generate field schema for a string field
#
# @param name name of the field
# @param description description of the field
# @param ... additional custom fields to add to the field schema.
#
# @return 
# A list with a least the fields "name" and "type".
#
# @examples
# x <- c("foo", "bar")
# schema(x) <- schema_string("field", "A text field")
#
# @export
schema_string <- function(name, description, ...) {
  res <- list(name = name, type = "string")
  if (!missing(description) && !is.null(description)) 
    res$description <- description
  c(res, list(...))
}


#' Add required fields to the schema for an string column
#'
#' @param schema should be a list.
#'
#' @return
#' Returns \code{schema} with the required fields added. 
#' 
#' @export
complete_schema_string <- function(schema) {
  if (!exists("type", schema)) schema[["type"]] <- "string"
  schema
}

#' Convert a vector to 'string' using the specified schema
#' 
#' @param x the vector to convert.
#' @param schema the table-schema for the field.
#' @param ... passed on to other methods.
#'
#' @details
#' When \code{schema} is missing a default schema is generated using
#' \code{\link{complete_schema_string}}. 
#'
#' @return
#' Will return an \code{character} vector with \code{schema} added as the
#' 'schema' attribute.
#' 
#' @export
to_string <- function(x, schema = list(), ...) {
  UseMethod("to_string")
}

#' @export
to_string.character <- function(x, schema = list(), ...) {
  schema <- complete_schema_string(schema)
  # Handle missing values
  na_values <- if (!is.null(schema$missingValues)) schema$missingValues else
    character(0)
  x[x %in% na_values] <- NA
  structure(x, fielddescriptor = schema)
}

# @rdname csv_colclass
# @export
csv_colclass_string <- function(schema = list(), ...) {
  "character"
}

# @rdname csv_format
# @export
csv_format_string <- function(x, schema = datapackage::schema(x)) {
  if (!is.null(schema$categories)) {
    # We are dealing with a categorical variable that is stored as 
    # a string
    x <- csv_format_categorical(x, schema)
  }
  # For a character we don't have to do anything; we can write as is
  x
}

