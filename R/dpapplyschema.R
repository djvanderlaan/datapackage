#' Convert columns of data.frame to their correct types using table schema
#'
#' @param dta a \code{data.frame} or \code{data.table}.
#' @param resource an object with the Data Resource of the data set.
#' @param to_factor convert columns to factor if the field descriptor had a
#'   \code{categories} field for the column.
#' @param ... additional arguments are passed on to the \code{to_<fieldtype>} 
#'   functions (e.g. \code{\link{to_number}}). 
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
dpapplyschema <- function(dta, resource, to_factor = FALSE, ...) {
  # Check columnnames
  fieldnames <- dpfieldnames(resource)
  if (!all(names(dta) == fieldnames)) 
    stop("Column names of dta do not match those in the table schema")
  # Convert columns to correct type
  is_data_table <- methods::is(dta, "data.table")
  for (field in fieldnames) {
    fielddescriptor <- dpfield(resource, field)
    fun <- paste0("to_", fielddescriptor$type)
    if (!exists(fun)) {
      warning("'", fun, "' does not exist; not converting field '", field, "'.")
      fun <- function(x, fielddescriptor = list(), ...) {
        structure(x, fielddescriptor = fielddescriptor)
      }
    } else fun <- get(fun)
    #stopifnot(exists(fun))
    #fun <- get(fun)
    res <- fun(dta[[field]], fielddescriptor, ...)
    if (to_factor) res <- dptofactor(res, warn = FALSE)
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
