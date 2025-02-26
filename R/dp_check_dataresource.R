
#' Check if a data set is valid given a Data Resource
#'
#' @param x \code{data.frame} to check
#'
#' @param dataresource \code{dataresource} object to check \code{x} against.
#'
#' @param constraints also check relevant constraints in the field descriptor. 
#'
#' @param throw generate an error if the data set is not valid according to the 
#'   dataresource. 
#'
#' @param tolerance numerical tolerance used in some of the tests
#'
#' @return
#' Returns \code{TRUE} when the field is valid. Returns a character vector with
#' length >= 1 if the field is not valid. The text in the character values 
#' indicates why the field is not valid.
#'
#' When \code{throw = TRUE} the function will generate an error instead of
#' returning a character vector. When the dataset is valid the function returns
#' \code{TRUE} invisibly.
#'
#' @seealso
#' Use \code{\link{isTRUE}} to check if the test was successful. 
#' See \code{\link{dp_check_field}} for a function that checks a column or vector.
#'
#' @export
dp_check_dataresource <- function(x, dataresource = attr(x, "resource"), constraints = TRUE, 
    throw = FALSE, tolerance = sqrt(.Machine$double.eps)) {
  stopifnot(is.data.frame(x))
  if (throw) {
    res <- dp_check_dataresource(x, dataresource = dataresource, constraints = constraints, 
      throw = FALSE, tolerance = tolerance)
    if (!isTRUE(res)) stop(paste0(res, collapse = "\n"))
    return(invisible(TRUE))
  }
  # check fieldnames
  fieldnames  <- dp_field_names(dataresource)
  names       <- names(x)
  fieldsMatch <- dp_property(dataresource, "fieldsMatch")
  if (is.null(fieldsMatch)) fieldsMatch <- "exact"
  if (fieldsMatch == "exact") {
    if (!isTRUE(all.equal(as.character(names), as.character(fieldnames)))) 
      return ("Fieldnames do not match the names of the dataset x.")
  } else if (fieldsMatch == "equal") {
    if (!all(names %in% fieldnames) || !all(fieldnames %in% names))
      return ("Fieldnames do not match the names of the dataset x.")
  } else if (fieldsMatch == "subset") {
    if (!all(names %in% fieldnames))
      return ("Fieldnames do not match the names of the dataset x.")
  } else if (fieldsMatch == "superset") {
    if (!all(fieldnames %in% names))
      return ("Fieldnames do not match the names of the dataset x.")
  } else if (fieldsMatch == "partial") {
    if (!any(names %in% fieldnames) || !any(fieldnames %in% names))
      return ("Fieldnames do not match the names of the dataset x.")
  }
  # We will only check the fields that are in both the dataset and the 
  # schema; above we checked to what extent these two have to overlap
  fieldnames <- intersect(fieldnames, names)
  result <- character(0)
  all_checks_ok <- TRUE
  for (field in fieldnames) {
    check <- dp_check_field(x[[field]], dp_field(dataresource, field), 
      constraints = constraints, tolerance = tolerance)
    if (!isTRUE(check)) {
      all_checks_ok <- FALSE
      result <- c(result, check)
    } 
  }
  if (!all_checks_ok) return(result)
  TRUE
}



