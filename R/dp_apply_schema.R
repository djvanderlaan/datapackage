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
#' @param reorder put the columns in the same order as the fields in the data
#' resource.
#'
#' @param ... additional arguments are passed on to the \code{dp_to_<fieldtype>}
#' functions (e.g. \code{\link{dp_to_number}}). 
#'
#' @details
#' Converts each column in \code{dta} to the correct R-type using the type
#' information in the table schema. For example, if the original column type in
#' \code{dta} is a character vector and the table schema specifies that the field is
#' of type number, the column is converted to numeric using the decimal
#' separator and thousands separator specified in the field descriptor (or default values
#' for these if not). 
#'
#' @return
#' Returns a copy of the input data.frame with columns modified to match the
#' types given in de table schema. When \code{reorder = TRUE} columns are put in the 
#' same order as in the data resource with fields not in the data resource put
#' at the back of the data.frame.
#'
#' @seealso
#' This function calls conversion functions for each of the columns, see 
#' \code{\link{dp_to_number}}, \code{\link{dp_to_boolean}}, \code{\link{dp_to_integer}}, 
#' \code{\link{dp_to_date}}. \code{\link{dp_to_datetime}}, \code{\link{dp_to_yearmonth}}, 
#' and \code{\link{dp_to_string}}.
#'
#'@export
dp_apply_schema <- function(dta, resource, 
    convert_categories = c("no", "to_factor", "to_code"), 
    reorder = TRUE, ...) {
  # Check columnnames
  fieldnames <- dp_field_names(resource)
  fieldsMatch <- NULL
  if (!is.null(schema <- dp_schema(resource)))
    fieldsMatch <- dp_property(schema, "fieldsMatch")
  res <- check_fields(names(dta), fieldnames, fieldsMatch)
  if (!isTRUE(res)) stop(res)
  # We will only check the fields that are in both the dataset and the 
  # schema; above we checked to what extent these two have to overlap
  fieldnames <- intersect(fieldnames, names(dta))
  # Put fields in order of schema
  namesremain <- setdiff(names(dta), fieldnames)
  dta <- subset(dta, select = c(fieldnames, namesremain))
  # Convert columns to correct type
  catconvfun <- get_convert_categories(convert_categories)
  is_data_table <- methods::is(dta, "data.table")
  for (field in fieldnames) {
    fielddescriptor <- dp_field(resource, field)
    fun <- paste0("dp_to_", fielddescriptor$type)
    if (!exists(fun)) {
      warning("'", fun, "' does not exist; not converting field '", field, "'.")
      fun <- function(x, fielddescriptor = list(), ...) {
        structure(x, fielddescriptor = fielddescriptor)
      }
    } else fun <- get(fun)
    # Convert the field
    tryCatch({
      res <- fun(dta[[field]], fielddescriptor, ...)
    }, error = function(e) {
      stop("Conversion of '", field, "' failed: ", e$message, ".")
    }, warning = function(w) {
      warning("Conversion of '", field, "' gave a warning: ", w$message, ".")
    })
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

