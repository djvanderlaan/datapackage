# Generate field schema for a date field
#
# @param name name of the field
# @param description description of the field
# @param format the textual format with which the date is stored. Can be 
#   "default", a valid format as accepted by \code{\link{strptime}} or 
#   "any" (no specified format, in R this the date is passed on to
#   \code{\link{as.Date}}. 
# @param ... additional custom fields to add to the field schema.
#
# @return 
# A list with a least the fields "name" and "type".
#
# @examples
# x <- as.Date(c("2020-01-01", "2022-12-31"))
# schema(x) <- schema_date("importantday")
#
# @export
schema_date <- function(name, description, format = "default", ...) {
  res <- list(name = name, type = "date")
  if (!missing(description) && !is.null(description)) 
    res$description <- description
  if (!missing(format) && !is.null(format)) 
    res$format <- format
  c(res, list(...))
}

#' Add required fields to the schema for a date column
#'
#' @param schema should be a list.
#'
#' @return
#' Returns \code{schema} with the required fields added. 
#' 
#' @export 
complete_schema_date <- function(schema) {
  if (!exists("type", schema)) schema[["type"]] <- "date"
  schema
}

#' Convert a vector to 'date' using the specified schema
#' 
#' @param x the vector to convert.
#' @param schema the table-schema for the field.
#' @param ... passed on to other methods.
#'
#' @details
#' When \code{schema} is missing a default schema is generated using
#' \code{\link{complete_schema_date}}. 
#'
#' @return
#' Will return an \code{Date} vector with \code{schema} added as the 'schema'
#' attribute.
#' 
#' @export
to_date <- function(x, schema = list(), ...) {
  UseMethod("to_date")
}

#' @export
to_date.integer <- function(x, schema = list(), ...) {
  # When we get an integer or numeric; assume date was accidentally read as 
  # numeric, e.g. when date = 20200101 or 01012020-> convert to character and 
  # convert
  to_date(sprintf("%08d", x))
}

#' @export
to_date.numeric <- function(x, schema = list(), ...) {
  # When we get an integer or numeric; assume date was accidentally read as 
  # numeric, e.g. when date = 20200101 or 01012020-> convert to character and 
  # convert
  to_date(sprintf("%08d", x))
}

#' @export
to_date.character <- function(x, schema = list(), ...) {
  schema <- complete_schema_date(schema)
  # Consider "" as a NA
  na_values <- if (!is.null(schema$missingValues)) schema$missingValues else ""
  x[x %in% na_values] <- NA
  na <- is.na(x);
  if (is.null(schema$format) || schema$format == "default") {
    res <- as.Date(x, format = "%Y-%m-%d")
  } else if (schema$format == "any") {
    res <- as.Date(x)
  } else {
    res <- as.Date(x, format = schema$format)
  }
  invalid <- is.na(res) & !na
  if (any(invalid)) 
    stop("Invalid values found: '", x[utils::head(which(invalid), 1)], "'.")
  structure(res, fielddescriptor = schema)
}

#' @export
to_date.Date <- function(x, schema = list(), ...) {
  schema <- complete_schema_date(schema)
  # Nothing to do; x is already a Data 
  structure(x, fielddescriptor = schema)
}

# @rdname csv_colclass
# @export
csv_colclass_date <- function(schema = list(), ...) {
  "character"
}

# @rdname csv_format
# @export
csv_format_date <- function(x, schema = datapackage::schema(x)) {
  #if (!is.null(schema$categories)) {
    # We are dealing with a categorical variable that is stored as 
    # a date
    #x <- csv_format_categorical(x, schema)
  #}
  if (is.null(schema$format) || schema$format == "default" || 
      schema$format == "any") {
    format <- "%Y-%m-%d"
  } else {
    format <- schema$format
  }
  format(x, format = format)
}

