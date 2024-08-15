
# TODO: create method; e.g. for when x is missing

#' Get the Code List for a variable.
#'
#' @param x the variable for which to get the Code List
#' @param fielddescriptor the Field Descriptor associated with the variable.
#' @param datapackage the Data Package where the variable is from.
#' @param normalised if \code{TRUE} the column with values will be named 
#'   \code{value} and the the columnd with labels \code{label}.
#' @param ... used to pass extra arguments on to other methods.
#'
#' @return
#' Returns a \code{data.frame} with the Code List or \code{NULL} when none could
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

## @rdname dpcategorieslist
## @export
#dpcategorieslist.fielddescriptor <- function(x, datapackage = dpgetdatapackage(x), ...) {
#  codelist <- x$codelist
#  if (is.null(codelist)) return(NULL)
#  if (is.character(codelist)) {
#    stopifnot(is.character(codelist), length(codelist) == 1)
#    codelist <- dpgetdata(datapackage, codelist)
#  }
#  stopifnot(is.data.frame(codelist))
#  codelist
#}

#' @rdname dpcategorieslist
#' @export
dpcategorieslist.fielddescriptor <- function(x, datapackage = dpgetdatapackage(x), 
    normalised = FALSE, ...) {
  codelist <- x$categories
  if (is.null(codelist)) {
    return(NULL)
  } else if (is.data.frame(codelist)) {
    stop("Unsupported format for categories: 'data.frame'.")
  } else if (is.list(codelist)) {
    if (is.null(names(codelist))) {
      # We have a list with labels and values
      values <- sapply(codelist, \(x) x$value)
      labels <- sapply(codelist, \(x) 
        if (utils::hasName(x, "label")) x$label else x$value)
      codelist <- data.frame(value = values, label = labels)
      stopifnot(is.data.frame(codelist))
      if (!("value" %in% names(codelist))) stop("'value' column missing from codelist.")
      if (!("label" %in% names(codelist))) stop("'label' column missing from codelist.")
    } else {
      # We have a reference to a data resource
      if (!utils::hasName(codelist, "resource")) 
        stop("'resource' field missing from categories.")
      resource <- codelist$resource
      categories <- codelist
      codelist <- dpgetdata(datapackage, resource)
      stopifnot(is.data.frame(codelist))
      valueField <- if (utils::hasName(categories, "valueField")) 
        categories$valueField else "value"
      labelField <- if (utils::hasName(categories, "labelField")) 
        categories$labelField else "label"
      if (!(valueField %in% names(codelist))) 
        stop("Categories list does not contain a field '", valueField, "'.")
      if (!(labelField %in% names(codelist))) 
        stop("Categories list does not contain a field '", labelField, "'.")
      if (normalised) {
        names(codelist)[names(codelist) == valueField] <- "value"
        names(codelist)[names(codelist) == labelField] <- "label"
      }
    }
  } else if (is.numeric(codelist) || is.character(codelist) || is.logical(codelist)) {
    # We have a vector with categories
    codelist <- data.frame(value = codelist, label = codelist)
  } else {
    stop("Unsupported format for categories: '", 
      paste0(class(codelist), collapse ="', '"), "'.")
  }
  codelist
}



