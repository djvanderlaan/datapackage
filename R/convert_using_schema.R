
#' Convert columns of data.frame to their correct types using table schema
#'
#' @param dta a \code{data.frame} or \code{data.table}.
#' @param schema an object with the table schema
#' @param to_factor convert columns to factor if the schema has a categories
#'   field for the column.
#' @param ... additional arguments are passed on to the \code{to_<fieldtype>} 
#'   functions (e.g. \code{\link{to_number}}). 
#'
#' @details
#' Converts each column in \code{dta} to the correct R-type using the type
#' information in the schema. For example, if the original column type in
#' \code{dta} is a character vector and the schema specifies that the field is
#' of type number, the column is converted to numeric using the decimal
#' separator and thousands separator specified in the schema (or default values
#' for these if not). 
#'
#' @seealso
#' This function calls conversion functions for each of the columns, see 
#' \code{\link{to_number}}, \code{\link{to_boolean}}, \code{\link{to_integer}}, 
#' and \code{\link{to_date}}.
#'
#' @examples
#' schema <- list(fields = list(
#'   list(name = "field1", type = "number", decimalChar=",")
#' ))
#' dta <- data.frame(field1 = c("10,1", "-10,1"))
#' convert_using_schema(dta, schema)
#'
#' @export
convert_using_schema <- function(dta, schema, to_factor = TRUE, ...) {
  # Check columnnames
  colnames <- sapply(schema$fields, function(x) x$name)
  if (!all(names(dta) == colnames)) 
    stop("Column names of dta do not match those in the schema.")
  # Convert columns to correct type
  is_data_table <- methods::is(dta, "data.table")
  for (i in seq_along(dta)) {
    fun <- paste0("to_", schema$fields[[i]]$type)
    stopifnot(exists(fun))
    fun <- get(fun)
    col <- names(dta)[i]
    if (is_data_table) {
      data.table::set(dta, j = col, 
        value = fun(dta[[col]], schema$fields[[i]], to_factor, ...))
    } else {
      dta[[i]] <- fun(dta[[i]], schema$fields[[i]], to_factor, ...)
    }
  }
  # The fields schema is stored in the fields; drop it
  schema$fields <- NULL
  if (is_data_table) {
    data.table::setattr(dta, "schema", schema)
  } else {
    attr(dta, "schema") <- schema
  }
  dta[]
}

