
#' Recode a variable to \code{code} using the associated categories
#'
#' @param x the variable to recode
#'
#' @param categorieslist a \code{data.frame} with the categories as a
#' \code{data.frame}. 
#'
#' @param warn give a warning when there is no code list. 
#'
#' @param ... passed on to \code{\link[codelist]{as.codelist}}.
#'
#' @details
#' Uses the \code{\link[codelist]{code}} method from the  'codelist' package.
#' This package therefore needs to be installed. See the documentation of that
#' package for how to work with 'code' objects.
#'
#' By setting the option 'DP_TRIM_CODE' to \code{TRUE} white space at the
#' beginning and end of character values will be removes from the category
#' values and from \code{x}.  Also multiple hyphens at the beginning character
#' values will be removed This can be disabled by setting the option
#' 'DP_TRIM_HYPHEN' to \code{FALSE}.
#'
#'
#' @return
#' Returns a '\link[codelist]{code}' object or \code{x} when no categories
#' could be found (\code{categorieslist = NULL}).
#'
#' @seealso
#' An alternative is the \code{\link{dp_to_factor}} function to convert to
#' regular R factor.
#'
#' @examples
#' fn <- system.file("examples/iris", package = "datapackage")
#' dp <- open_datapackage(fn)
#' dta <- dp |> dp_get_data("complex", convert_categories = "no")
#' dp_to_code(dta$factor1)
#'
#' dp |> dp_get_data("complex", convert_categories = "dp_to_code")
#'
#'
#' @export
dp_to_code <- function(x, categorieslist = dp_categorieslist(x), ..., 
    warn = FALSE) {
  if (!requireNamespace("codelist")) {
    stop("In order to use 'dp_to_code' the 'codelist' package needs ",
      "to be installed.")
  }
  if (is.null(categorieslist)) {
    if (warn) warning("Field does not have an associated code list. ", 
      "Returning original vector.")
    return(x)
  }
  stopifnot(is.data.frame(categorieslist))
  # Determine which columns from the categorieslist contain the 
  # codes and labels
  fields <- getfieldsofcategorieslist(categorieslist)
  categorieslist[[fields$value]] <- trimcodes(categorieslist[[fields$value]])
  codelist <- codelist::as.codelist(categorieslist, code = fields$value, 
    label = fields$label, ...)
  res <- codelist::code(trimcodes(x), codelist = codelist)
  structure(res, fielddescriptor = attr(x, "fielddescriptor"))
}


trimcodes <- function(x, trim = getOption("DP_TRIM_CODES", FALSE), 
    trim_hyphen = getOption("DP_TRIM_HYPHEN", TRUE)) {
  if (trim && is.character(x)) {
    x <- trimws(x)
    if (trim_hyphen) x <- gsub("^[-][-]+", "", x)
  } 
  x
}

