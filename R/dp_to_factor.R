#' Recode a variable to factor using the associated categories
#'
#' @param x the variable to recode
#'
#' @param categorieslist a \code{data.frame} with the categories as a
#' \code{data.frame}. 
#'
#' @param warn give a warning when there is no code list. 
#'
#' @details
#' By setting the option 'DP_TRIM_CODE' to \code{TRUE} white space at the
#' beginning and end of character values will be ignored when comparing \code{x}
#' and the category values. Also multiple hyphens at the beginning character
#' values will be ignored. This can be disabled by setting the option
#' 'DP_TRIM_HYPHEN' to \code{FALSE}.
#'
#' @return
#' Returns a factor vector or \code{x} when no categories could be found
#' (\code{categorieslist = NULL}).
#'
#' @seealso
#' An alternative is the \code{\link{dp_to_code}} function to convert to
#' 'code' object from the 'codelist' package. 
#'
#' @examples
#' fn <- system.file("examples/iris", package = "datapackage")
#' dp <- open_datapackage(fn)
#' dta <- dp |> dp_get_data("complex", convert_categories = "no")
#' dp_to_factor(dta$factor1)
#'
#' dp |> dp_get_data("complex", convert_categories = "to_factor")
#'
#' @export
dp_to_factor <- function(x, categorieslist = dp_categorieslist(x), warn = TRUE) {
  if (is.null(categorieslist)) {
    if (warn) warning("Field does not have an associated code list. ",
      "Returning original vector.")
    return(x)
  }
  stopifnot(is.data.frame(categorieslist))
  # Determine which columns from the categorieslist contain the 
  # codes and labels
  fields <- getfieldsofcategorieslist(categorieslist)
  # Get the codes and labels
  codes  <- categorieslist[[fields$value]]
  labels <- categorieslist[[fields$label]]
  # Handle x == ""; we will treat this as missing values
  if (is.character(x) & !("" %in% codes)) 
    x[!is.na(x) & (x == "")] <- NA_character_
  # check if codes are valid
  m <- match_codes(x, codes)
  ok <- !is.na(m) | is.na(x) | (is.character(x) & x == "")
  if (!all(ok)) {
    wrong <- unique(x[!ok])
    wrong <- paste0("'", wrong, "'")
    if (length(wrong) > 5) 
      wrong <- c(utils::head(wrong, 5), "...")
    stop("Invalid values found in x: ", paste0(wrong, collapse = ","))
  }
  structure(factor(codes[m], levels = codes, labels = labels), 
    fielddescriptor = attr(x, "fielddescriptor"))
}


getfieldsofcategorieslist <- function(categorieslist) {
  stopifnot(is.data.frame(categorieslist))
  # Determine which columns from the categorieslist contain the 
  # values and labels
  values <- "value"
  labels <- "label"
  if (!is.null(res <- attr(categorieslist, "resource"))) {
    fieldmap <- dp_property(res, "categoryFieldMap")
    if (!is.null(fieldmap) && utils::hasName(fieldmap, "value"))
      values <- fieldmap$value
    if (!is.null(fieldmap) && utils::hasName(fieldmap, "label")) {
      labels <- fieldmap$label
      if (!utils::hasName(categorieslist, labels)) 
        stop("The data resource with the categories does not have a column '", 
          labels, "'.")
    }
  }
  if (!utils::hasName(categorieslist, values)) 
    stop("The data resource with the categories does not have a column '", 
      values, "'.")
  # When there are no labels; the labels are the values
  if (!utils::hasName(categorieslist, labels)) 
    labels <- values
  # Return what we have found
  list(value = values, label = labels)
}

match_codes <- function(x, codes, trim_codes = getOption("DP_TRIM_CODES", FALSE),
    trim_hyphen = getOption("DP_TRIM_HYPHEN", TRUE)) {
  na <- is.na(x) | (is.character(x) & x == "")
  # Function for trimming the codes; we remove whitepase before and after the
  # codes; and we remove multiple -- at the beging of the code
  trimcodes <- function(x) {
    x <- trimws(x)
    if (trim_hyphen) x <- gsub("^[-][-]+", "", x)
    x
  }
  # First match using regular match if that works we don't need to trim the 
  # codes
  m <- match(x, codes)
  unmatched <- is.na(m) & !na
  # We couldn't match all codes; try again with trimming the codes
  if (any(unmatched) && trim_codes && is.character(x)) {
    x <- trimcodes(x)
    codes <- trimcodes(codes)
    m <- match(x, codes)
  }
  m
}

