
#' Add required fields to the field descriptor for a string column
#'
#' @param fielddescriptor should be a list.
#'
#' @return
#' Returns \code{fielddescriptor} with the required fields added. 
#'
complete_fielddescriptor_string <- function(fielddescriptor) {
  if (!exists("type", fielddescriptor)) 
    fielddescriptor[["type"]] <- "string"
  fielddescriptor
}

#' Convert a vector to 'string' using the specified fielddescriptor
#' 
#' @param x the vector to convert.
#' @param fielddescriptor the field descriptor for the field.
#' @param ... passed on to other methods.
#'
#' @details
#' When \code{fielddescriptor} is missing a default field descriptor is
#' generated using \code{\link{complete_fielddescriptor_string}}. 
#'
#' @return
#' Will return an \code{character} vector with \code{fielddescriptor} added as
#' the 'fielddescriptor' attribute.
#' 
#' @export
dp_to_string <- function(x, fielddescriptor = list(), ...) {
  UseMethod("dp_to_string")
}

#' @export
dp_to_string.character <- function(x, fielddescriptor = list(), ...) {
  fielddescriptor <- complete_fielddescriptor_string(fielddescriptor)
  # Handle missing values
  na_values <- if (!is.null(fielddescriptor$missingValues)) 
    fielddescriptor$missingValues else character(0)
  x[x %in% na_values] <- NA
  structure(x, fielddescriptor = fielddescriptor)
}

# @rdname csv_colclass
# @export
csv_colclass_string <- function(fielddescriptor = list(), ...) {
  "character"
}

