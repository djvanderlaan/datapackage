#' Convert columns of data.frame to their correct types using table schema
#'
#' @param dta a \code{data.frame} or \code{data.table}.
#'
#' @param resource an object with the Data Resource of the data set.
#'
#' @param convert_categories how to handle columns for which the field
#' descriptor has a \code{categories} property.  This should either be the
#' strings "no", "to_factor", "to_code", the name of a function or a function.
#' When equal to "no" the field is returned as is; when equal to "to_factor"
#' each column is transformed using \code{\link{dp_to_factor}}; when equal to
#' "to_code" each column is transformed using \code{\link{dp_to_code}}. In
#' other cased the function is called with the column as its first parameter and
#' \code{warn = FALSE} as its second argument. The result of this function call
#' is added to the resulting data set.
#'
#' @param ... additional arguments are passed on to the \code{to_<fieldtype>}
#' functions (e.g. \code{\link{to_number}}). 
#'
#' @details
#' Converts each column in \code{dta} to the correct R-type using the type
#' information in the table schema. For example, if the original column type in
#' \code{dta} is a character vector and the table schema specifies that the field is
#' of type number, the column is converted to numeric using the decimal
#' separator and thousands separator specified in the field descriptor (or default values
#' for these if not). 
#'
#' @seealso
#' This function calls conversion functions for each of the columns, see 
#' \code{\link{to_number}}, \code{\link{to_boolean}}, \code{\link{to_integer}}, 
#' and \code{\link{to_date}}.
#'
#'@export
dp_apply_schema <- function(dta, resource, 
    convert_categories = c("no", "to_factor", "to_code"), ...) {
  # Check columnnames
  fieldnames <- dp_field_names(resource)
  if (!all(names(dta) == fieldnames)) 
    stop("Column names of dta do not match those in the table schema")
  catconvfun <- get_convert_categories(convert_categories)
  # Convert columns to correct type
  is_data_table <- methods::is(dta, "data.table")
  for (field in fieldnames) {
    fielddescriptor <- dp_field(resource, field)
    fun <- paste0("to_", fielddescriptor$type)
    if (!exists(fun)) {
      warning("'", fun, "' does not exist; not converting field '", field, "'.")
      fun <- function(x, fielddescriptor = list(), ...) {
        structure(x, fielddescriptor = fielddescriptor)
      }
    } else fun <- get(fun)
    res <- fun(dta[[field]], fielddescriptor, ...)
    if (!isFALSE(catconvfun)) res <- catconvfun(res, warn = FALSE)
    if (is_data_table) {
      data.table::set(dta, j = field, value = res)
    } else {
      dta[[field]] <- res
    }
  }
  # The fields descriptor is stored in the fields; drop it
  # TODO: ? schema$fields <- NULL
  # TODO: probably beter to not store the schema with the data.frame; unlikely 
  # that the schema remains valid
  if (is_data_table) {
    data.table::setattr(dta, "resource", resource)
  } else {
    attr(dta, "resource") <- resource
  }
  dta[]
}


get_convert_categories <- function(convert_categories) {
  stopifnot(is.character(convert_categories) || is.function(convert_categories))
  if (is.character(convert_categories)) {
    stopifnot(length(convert_categories) > 0)
    convert_categories  <- convert_categories[1]
    stopifnot(!is.na(convert_categories))
    if (convert_categories == "no") return(FALSE)
    if (convert_categories == "to_factor") return(datapackage::dp_to_factor)
    if (convert_categories == "to_code") return(datapackage::dp_to_code)
    if (!exists(convert_categories)) 
      stop("'", convert_categories, "' does not exist; not converting categories.")
    fun <- get(convert_categories)
    if (!is.function(fun)) 
      stop("'", convert_categories, "' is not a function; not converting categories.")
    convert_categories <- fun
  } 
  convert_categories
}

