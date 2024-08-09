
# TODO: create method; e.g. for when x is missing

#' Get the Code List for a variable.
#'
#' @param x the variable for which to get the Code List
#' @param fielddescriptor the Field Descriptor associated with the variable.
#' @param datapackage the Data Package where the variable is from.
#' @param ... used to pass extra arguments on to other methods.
#'
#' @return
#' Returns a \code{data.frame} with the Code List or \code{NULL} when none could
#' be found.
#'
#' @rdname dpcodelist
#' @export
dpcodelist <- function(x, ...) {
  UseMethod("dpcodelist")
}

#' @rdname dpcodelist
#' @export
dpcodelist.default <- function(x, fielddescriptor = attr(x, "fielddescriptor"), 
    datapackage = dpgetdatapackage(fielddescriptor), ...) {
  res <- NULL
  if (!is.null(fielddescriptor)) res <- dpcodelist(fielddescriptor)
  if (is.null(res) && is.factor(x)) {
    res <- data.frame(
      value = seq_len(nlevels(x)),
      label = levels(x)
    )
  }
  res
}

## @rdname dpcodelist
## @export
#dpcodelist.fielddescriptor <- function(x, datapackage = dpgetdatapackage(x), ...) {
#  codelist <- x$codelist
#  if (is.null(codelist)) return(NULL)
#  if (is.character(codelist)) {
#    stopifnot(is.character(codelist), length(codelist) == 1)
#    codelist <- dpgetdata(datapackage, codelist)
#  }
#  stopifnot(is.data.frame(codelist))
#  codelist
#}

#' @rdname dpcodelist
#' @export
dpcodelist.fielddescriptor <- function(x, datapackage = dpgetdatapackage(x), ...) {
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
    } else {
      # We have a reference to a data resource
      if (!utils::hasName(codelist, "resource")) 
        stop("'resource' field missing from categories.")
      resource <- codelist$resource
      categories <- codelist
      codelist <- dpgetdata(datapackage, resource)
      if (utils::hasName(categories, "valueField")) 
        names(codelist)[names(codelist) == categories$valueField] <- "value"
      if (utils::hasName(categories, "labelField")) 
        names(codelist)[names(codelist) == categories$labelField] <- "label"
    }
  } else if (is.numeric(codelist) || is.character(codelist) || is.logical(codelist)) {
    # We have a vector with categories
    codelist <- data.frame(value = codelist, label = codelist)
  } else {
    stop("Unsupported format for categories: '", 
      paste0(class(codelist), collapse ="', '"), "'.")
  }
  # Check of output seems ok
  stopifnot(is.data.frame(codelist))
  if (!("value" %in% names(codelist))) stop("'value' column missing from codelist.")
  if (!("label" %in% names(codelist))) stop("'label' column missing from codelist.")
  codelist
}



