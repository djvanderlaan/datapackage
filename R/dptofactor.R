#' Recode a variable to factor using the associated categories
#'
#' @param x the variable to recode
#'
#' @param categorieslist a \code{data.frame} with the categories as a
#' \code{data.frame}. It is assumed that the first column contains the codes
#' and the second column the labels.
#'
#' @param warn give a warning when there is no code list. 
#'
#' @return
#' Returns a factor vector or \code{x} when no categories could be found
#' (\code{categorieslist = NULL}).
#'
#' @export
dptofactor <- function(x, categorieslist = dpcategorieslist(x), warn = TRUE) {
  if (is.null(categorieslist)) {
    if (warn) warning("Field does not have an associated code list. Returning original vector.")
    return(x)
  }
  stopifnot(is.data.frame(categorieslist))
  # TODO: more intelligence in determining which column to use as codes and
  # labels
  codes  <- categorieslist[[1]]
  labels <- categorieslist[[2]]
  # Handle x == ""; we will treat this as missing values
  if (is.character(x) & !("" %in% codes)) 
    x[!is.na(x) & (x == "")] <- NA_character_
  # check if codes are valid
  ok <- x %in% codes | is.na(x) | (is.character(x) & x == "")
  if (!all(ok)) {
    wrong <- unique(x[!ok])
    wrong <- paste0("'", wrong, "'")
    if (length(wrong) > 5) 
      wrong <- c(utils::head(wrong, 5), "...")
    stop("Invalid values found in x: ", paste0(wrong, collapse = ","))
  }
  structure(factor(x, levels = codes, labels = labels), 
    fielddescriptor = attr(x, "fielddescriptor"))
}

