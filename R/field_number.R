# Generate field schema for a number field
#
# @param name name of the field
# @param description description of the field
# @param decimalChar character used to separate the decimal part of the 
#   number.
# @param groupChar character used to separate multiples of thousand in 
#   large numbers.
# @param ... additional custom fields to add to the field schema.
#
# @return 
# A list with a least the fields "name" and "type".
#
# @examples
# x <- c(10, 20.1)
# schema(x) <- schema_number("field", "A numeric field", 
#   decimalChar = ",")
#
# @export
schema_number <- function(name, description = NULL, decimalChar = ".", 
    groupChar = "", ...) {
  res <- list(name = name, type = "number")
  if (!missing(description) && !is.null(description)) 
    res$description <- description
  if (!missing(decimalChar)) 
    res$decimalChar <- decimalChar
  if (!missing(groupChar)) 
    res$groupChar <- groupChar
  c(res, list(...))
}


#' Add required fields to the schema for an number column
#'
#' @param schema should be a list.
#'
#' @return
#' Returns \code{schema} with the required fields added. 
#' 
#' @export
complete_schema_number <- function(schema) {
  if (!exists("type", schema)) schema[["type"]] <- "number"
  schema
}

#' Convert a vector to 'number' using the specified schema
#' 
#' @param x the vector to convert.
#' @param schema the field schema for the field.
#' @param decimalChar decimal separator. Used when the field schema does not
#'   specify a decimal separator.
#' @param ... passed on to other methods.
#'
#' @details
#' When \code{schema} is missing a default schema is generated using
#' \code{\link{complete_schema_number}}. 
#'
#' @return
#' Will return an \code{numeric} vector with \code{schema} added as the 'schema'
#' attribute.
#' 
#' @export
to_number <- function(x, schema = list(),  decimalChar = ".", ...) {
  UseMethod("to_number")
}

#' @export
to_number.numeric <- function(x, schema = list(),  decimalChar = ".", ...) {
  schema <- complete_schema_number(schema)
  structure(x, fielddescriptor = schema)
}

#' @export
to_number.character <- function(x, schema = list(), decimalChar = ".", ...) {
  schema <- complete_schema_number(schema)
  decimalChar <- if (is.null(schema$decimalChar)) 
    decimalChar else schema$decimalChar
  # Consider "" as a NA
  na_values <- if (!is.null(schema$missingValues)) schema$missingValues else ""
  na <- x %in% na_values | is.na(x);
  x[x %in% na_values] <- NA
  if (!is.null(schema$groupChar)) 
    x <- gsub(schema$groupChar, "", x, fixed = TRUE)
  if (decimalChar != ".") 
    x <- gsub(decimalChar, ".", x, fixed = TRUE)
  res <- suppressWarnings(as.numeric(x))
  invalid <- is.na(res) & !na & !is.nan(res)
  if (any(invalid)) 
    stop("Invalid values found: '", x[utils::head(which(invalid), 1)], "'.")
  structure(res, fielddescriptor = schema)
}

# @param decimalChar the decimal separator used when reading the CSV-file.
# @rdname csv_colclass
# @export
csv_colclass_number <- function(schema = list(), decimalChar = ".", ...) {
  schema <- complete_schema_number(schema)
  dec <- if (is.null(schema$decimalChar)) decimalChar else schema$decimalChar
  if (!is.null(schema$groupChar) || dec != decimalChar || 
      !is.null(schema$missingValues)) {
    "character"
  } else {
    "numeric"
  }
}

