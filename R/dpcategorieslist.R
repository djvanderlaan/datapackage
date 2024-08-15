
# TODO: create method; e.g. for when x is missing

#' Get the a data.frame with the categories for a variable.
#'
#' @param x the variable for which to get the Categories List
#' @param fielddescriptor the Field Descriptor associated with the variable.
#' @param datapackage the Data Package where the variable is from.
#' @param normalised if \code{TRUE} the column with values will be named 
#'   \code{value} and the the columnd with labels \code{label}.
#' @param ... used to pass extra arguments on to other methods.
#'
#' @return
#' Returns a \code{data.frame} with the categories or \code{NULL} when none could
#' be found.
#'
#' @rdname dpcategorieslist
#' @export
dpcategorieslist <- function(x, ...) {
  UseMethod("dpcategorieslist")
}

#' @rdname dpcategorieslist
#' @export
dpcategorieslist.default <- function(x, fielddescriptor = attr(x, "fielddescriptor"), 
    datapackage = dpgetdatapackage(fielddescriptor), ...) {
  res <- NULL
  if (!is.null(fielddescriptor)) res <- dpcategorieslist(fielddescriptor, ...)
  if (is.null(res) && is.factor(x)) {
    res <- data.frame(
      value = seq_len(nlevels(x)),
      label = levels(x)
    )
  }
  res
}

#' @rdname dpcategorieslist
#' @export
dpcategorieslist.fielddescriptor <- function(x, datapackage = dpgetdatapackage(x), 
    normalised = FALSE, ...) {
  categorieslist <- x$categories
  if (is.null(categorieslist)) {
    return(NULL)
  } else if (is.data.frame(categorieslist)) {
    stop("Unsupported format for categories: 'data.frame'.")
  } else if (is.list(categorieslist)) {
    if (is.null(names(categorieslist))) {
      # We have a list with labels and values
      values <- sapply(categorieslist, \(x) x$value)
      labels <- sapply(categorieslist, \(x) 
        if (utils::hasName(x, "label")) x$label else x$value)
      categorieslist <- data.frame(value = values, label = labels)
      stopifnot(is.data.frame(categorieslist))
      if (!("value" %in% names(categorieslist))) stop("'value' column missing from categories list.")
      if (!("label" %in% names(categorieslist))) stop("'label' column missing from categories list.")
    } else {
      # We have a reference to a data resource
      if (!utils::hasName(categorieslist, "resource")) 
        stop("'resource' field missing from categories.")
      resource <- categorieslist$resource
      categories <- categorieslist
      categorieslist <- dpgetdata(datapackage, resource)
      stopifnot(is.data.frame(categorieslist))
      valueField <- if (utils::hasName(categories, "valueField")) 
        categories$valueField else "value"
      labelField <- if (utils::hasName(categories, "labelField")) 
        categories$labelField else "label"
      if (!(valueField %in% names(categorieslist))) 
        stop("Categories list does not contain a field '", valueField, "'.")
      if (!(labelField %in% names(categorieslist))) 
        stop("Categories list does not contain a field '", labelField, "'.")
      if (normalised) {
        names(categorieslist)[names(categorieslist) == valueField] <- "value"
        names(categorieslist)[names(categorieslist) == labelField] <- "label"
      }
    }
  } else if (is.numeric(categorieslist) || is.character(categorieslist) || is.logical(categorieslist)) {
    # We have a vector with categories
    categorieslist <- data.frame(value = categorieslist, label = categorieslist)
  } else {
    stop("Unsupported format for categories: '", 
      paste0(class(categorieslist), collapse ="', '"), "'.")
  }
  categorieslist
}



