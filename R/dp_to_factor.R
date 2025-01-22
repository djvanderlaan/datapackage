#' Recode a variable to factor using the associated categories
#'
#' @param x the variable to recode
#'
#' @param categorieslist a \code{data.frame} with the categories as a
#' \code{data.frame}. 
#'
#' @param warn give a warning when there is no code list. 
#'
#' @return
#' Returns a factor vector or \code{x} when no categories could be found
#' (\code{categorieslist = NULL}).
#'
#' @export
dp_to_factor <- function(x, categorieslist = dp_categorieslist(x), warn = TRUE) {
  if (is.null(categorieslist)) {
    if (warn) warning("Field does not have an associated code list. Returning original vector.")
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

