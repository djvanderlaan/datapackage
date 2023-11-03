
# Generate field schema for a boolean field
#
# @param name name of the field
# @param description description of the field
# @param trueValues a vector with strings that should be interpreted as
#  true values when representing the field as text.
# @param falseValues a vector with strings that should be interpreted as
#  false values when representing the field as text.
# @param ... additional custom fields to add to the field schema.
#
# @return 
# A list with a least the fields "name", "type", "trueValues" and
# "falseValues".
#
# @examples
# x <- 1:4 > 2
# schema(x) <- schema_boolean("field", "A logical field")
#
# @export
schema_boolean <- function(name, description, 
    trueValues = c("true", "TRUE", "True", "1"),
    falseValues = c("false", "FALSE", "False", "0"),...) {
  res <- list(name = name, type = "boolean")
  if (!missing(description) && !is.null(description)) 
    res$description <- description
  res$trueValues <- trueValues
  res$falseValues <- falseValues
  c(res, list(...))
}


#' Add required fields to the schema for an boolean column
#'
#' @param schema should be a list.
#'
#' @return
#' Returns \code{schema} with the required fields added. 
#' 
#' @export
complete_schema_boolean <- function(schema) {
  if (!exists("type", schema)) schema[["type"]] <- "boolean"
  if (!exists("trueValues", schema))
    schema[["trueValues"]] <- c("true", "TRUE", "True", "1")
  if (!exists("falseValues", schema))
    schema[["falseValues"]] <- c("false", "FALSE", "False", "0")
  schema
}

#' Convert a vector to 'boolean' using the specified schema
#' 
#' @param x the vector to convert.
#' @param schema the table-schema for the field.
#' @param ... passed on to other methods.
#'
#' @details
#' When \code{schema} is missing a default schema is generated using
#' \code{\link{complete_schema_boolean}}. 
#'
#' @return
#' Will return an \code{logical} vector with \code{schema} added as the 'schema'
#' attribute.
#' 
#' @export
to_boolean <- function(x, schema = list(), ...) {
  UseMethod("to_boolean")
}

#' @export
to_boolean.integer <- function(x, schema = list(), ...) {
  schema <- complete_schema_boolean(schema)
  true_values <- suppressWarnings(as.integer(schema$trueValues))
  if (any(is.na(true_values))) 
    stop("Not all falseValues in schema are integer.")
  false_values <- suppressWarnings(as.integer(schema$falseValues))
  if (any(is.na(false_values))) 
    stop("Not all falseValues in schema are integer.")
  # Handle the easy fastest case of int to logical conversion
  # this is possible if false == 0
  if (length(false_values) == 1 && false_values == 0L) {
    res <- as.logical(x)
    if (!all(x %in% c(false_values, true_values, NA))) 
      warning("Invalid trueValues in x.")
  } else {
    s1  <- x %in% true_values
    s0 <- x %in% false_values
    res <- ifelse(s1, TRUE, NA)
    res[s0] <- FALSE
    invalid <- !(s0 | s1 | is.na(x))
    if (any(invalid)) 
      stop("Invalid values found: '", x[utils::head(which(invalid), 1)], "'.")
  }
  structure(res, schema = schema)
}

#' @export
to_boolean.character <- function(x, schema = list(), ...) {
  schema <- complete_schema_boolean(schema)
  # Unless "" is a true of false value we will consider it a missing value
  na_values <- if (!is.null(schema$missingValues)) schema$missingValues else 
    setdiff("", c(schema$trueValues, schema$falseValues))
  if (length(na_values)) x[x %in% na_values] <- NA
  s1  <- x %in% schema$trueValues
  s0  <- x %in% schema$falseValues
  res <- ifelse(s1, TRUE, NA)
  res[s0] <- FALSE
  invalid <- !(s0 | s1 | is.na(x))
  if (any(invalid)) 
    stop("Invalid values found: '", x[utils::head(which(invalid), 1)], "'.")
  structure(res, schema = schema)
}

#' @export
to_boolean.logical <- function(x, schema = list(), ...) {
  schema <- complete_schema_boolean(schema)
  structure(x, schema = schema)
}

# @rdname csv_colclass
# @export
csv_colclass_boolean <- function(schema = list(), ...) {
  schema <- complete_schema_boolean(schema)
  res <- "character"
  if (is.null(schema$missingValues) && length(schema$trueValues) == 1 && 
      length(schema$falseValues) == 1) {
    if (schema$trueValues == "TRUE" && schema$falseValues == "FALSE")
      res <- "logical"
    if (schema$trueValues == "True" && schema$falseValues == "False")
      res <- "logical"
    if (schema$trueValues == "true" && schema$falseValues == "false")
      res <- "logical"
    if (schema$trueValues == "1" && schema$falseValues == "0")
      res <- "integer"
  }
  res
}

# @rdname csv_format
# @export
csv_format_boolean <- function(x, schema = datapackage::schema(x)) {
  if (!is.null(schema$categories)) {
    # We are dealing with a categorical variable that is stored as 
    # a boolean
    x <- csv_format_categorical(x, schema)
  }
  if (is.logical(x) && ("TRUE" %in% schema$trueValues) && 
      ("FALSE" %in% schema$falseValues)) {
    # We can as is as R writes TRUE/FALSE by default
    x
  } else {
    trueval <- utils::head(schema$trueValues, 1)
    falseval <- utils::head(schema$falseValues, 1)
    # When x is not logical; we let ifelse handle that
    ifelse(x, trueval, falseval)
  }
}

