
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
      code = seq_len(nlevels(x)),
      label = levels(x)
    )
  }
  res
}

#' @rdname dpcodelist
#' @export
dpcodelist.fielddescriptor <- function(x, datapackage = dpgetdatapackage(x), ...) {
  codelist <- x$codelist
  if (is.null(codelist)) return(NULL)
  if (is.character(codelist)) {
    stopifnot(is.character(codelist), length(codelist) == 1)
    codelist <- dpgetdata(datapackage, codelist)
  }
  stopifnot(is.data.frame(codelist))
  codelist
}



