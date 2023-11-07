#' Recode a variable to factor using the associated Code List
#'
#' @param x the variable to recode
#' @param codelist a \code{data.frame} with the Code List. It is assumed that
#' the first column contains the codes and the second column the labels.
#' @param warn give a warning when there is no code list. 
#'
#' @return
#' Returns a factor vector or \code{x} when no Code List could be found
#' (\code{codelist = NULL}).
#'
#' @export
dptofactor <- function(x, codelist = dpcodelist(x), warn = TRUE) {
  if (is.null(codelist)) {
    if (warn) warning("Field does not have an associated code list. Returning original vector.")
    return(x)
  }
  stopifnot(is.data.frame(codelist))
  # TODO: more intelligence in determining which column to use as codes and
  # labels
  codes  <- codelist[[1]]
  labels <- codelist[[2]]
  # check if codes are valid
  ok <- x %in% codes | is.na(x)
  if (!all(ok)) {
    wrong <- unique(x[!ok])
    wrong <- paste0("'", wrong, "'")
    if (length(wrong) > 5) 
      wrong <- c(utils::head(wrong, 5), "...")
    stop("Invalid values found in x: ", paste0(wrong, collapse = ","))
  }
  factor(x, levels = codes, labels = labels)
}

