
#' Add required fields to the field descriptor for an number column
#'
#' @param fielddescriptor should be a list.
#'
#' @return
#' Returns \code{fielddescriptor} with the required fields added. 
#'
#' @export
complete_fielddescriptor_number <- function(fielddescriptor) {
  if (!exists("type", fielddescriptor)) fielddescriptor[["type"]] <- "number"
  fielddescriptor
}

#' Convert a vector to 'number' using the specified field descriptor
#' 
#' @param x the vector to convert.
#' @param fielddescriptor the field descriptor for the field.
#' @param decimalChar decimal separator. Used when the field field descriptor
#' does not specify a decimal separator.
#' @param ... passed on to other methods.
#'
#' @details
#' When \code{fielddescriptor} is missing a default field descriptor is
#' generated using \code{\link{complete_fielddescriptor_number}}. 
#'
#' @return
#' Will return an \code{numeric} vector with \code{fielddescriptor} added as
#' the 'fielddescriptor' attribute.
#' 
#' @export
to_number <- function(x, fielddescriptor = list(),  decimalChar = ".", ...) {
  UseMethod("to_number")
}

#' @export
to_number.numeric <- function(x, fielddescriptor = list(),  decimalChar = ".", ...) {
  fielddescriptor <- complete_fielddescriptor_number(fielddescriptor)
  structure(x, fielddescriptor = fielddescriptor)
}

#' @export
to_number.character <- function(x, fielddescriptor = list(), decimalChar = ".", ...) {
  fielddescriptor <- complete_fielddescriptor_number(fielddescriptor)
  decimalChar <- if (is.null(fielddescriptor$decimalChar)) 
    decimalChar else fielddescriptor$decimalChar
  # Consider "" as a NA
  na_values <- if (!is.null(fielddescriptor$missingValues)) 
    fielddescriptor$missingValues else ""
  na <- x %in% na_values | is.na(x);
  x[x %in% na_values] <- NA
  if (!is.null(fielddescriptor$groupChar)) 
    x <- gsub(fielddescriptor$groupChar, "", x, fixed = TRUE)
  if (decimalChar != ".") 
    x <- gsub(decimalChar, ".", x, fixed = TRUE)
  res <- suppressWarnings(as.numeric(x))
  invalid <- is.na(res) & !na & !is.nan(res)
  if (any(invalid)) 
    stop("Invalid values found: '", x[utils::head(which(invalid), 1)], "'.")
  structure(res, fielddescriptor = fielddescriptor)
}

# @param decimalChar the decimal separator used when reading the CSV-file.
# @rdname csv_colclass
# @export
csv_colclass_number <- function(fielddescriptor = list(), decimalChar = ".", ...) {
  fielddescriptor <- complete_fielddescriptor_number(fielddescriptor)
  dec <- if (is.null(fielddescriptor$decimalChar)) 
    decimalChar else fielddescriptor$decimalChar
  if (!is.null(fielddescriptor$groupChar) || dec != decimalChar || 
      !is.null(fielddescriptor$missingValues)) {
    "character"
  } else {
    "numeric"
  }
}

