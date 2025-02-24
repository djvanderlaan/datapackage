# Add required fields to the fielddescriptor for a year column
#
# @param fielddescriptor should be a list.
#
# @return
# Returns \code{fielddescriptor} with the required fields added. 
#
complete_fielddescriptor_year <- function(fielddescriptor) {
  if (!exists("type", fielddescriptor)) fielddescriptor[["type"]] <- "year"
  fielddescriptor
}

#' Convert a vector to 'year' using the specified field descriptor
#' 
#' @param x the vector to convert.
#' @param fielddescriptor the field descriptor for the field.
#' @param ... passed on to other methods.
#'
#' @details
#' When \code{fielddescriptor} is missing a default field descriptor is
#' generated.
#'
#' @return
#' Will return an integer vector with \code{fielddescriptor} added as the
#' 'fielddescriptor' attribute. 
#' 
#' @export
dp_to_year <- function(x, fielddescriptor = list(), ...) {
  UseMethod("dp_to_year")
}

#' @export
dp_to_year.integer <- function(x, fielddescriptor = list(), ...) {
  fielddescriptor <- complete_fielddescriptor_year(fielddescriptor)
  structure(x, fielddescriptor = fielddescriptor)
}

#' @export
dp_to_year.numeric <- function(x, fielddescriptor = list(), ...) {
  fielddescriptor <- complete_fielddescriptor_year(fielddescriptor)
  structure(as.integer(x), fielddescriptor = fielddescriptor)
}

#' @export
dp_to_year.character <- function(x, fielddescriptor = list(), ...) {
  fielddescriptor <- complete_fielddescriptor_year(fielddescriptor)
  # Consider "" as a NA
  na_values <- if (!is.null(fielddescriptor$missingValues)) 
    fielddescriptor$missingValues else ""
  x[x %in% na_values] <- NA
  na <- is.na(x);
  # Convert
  res <- as.integer(x)
  invalid <- is.na(res) & !na
  if (any(invalid)) 
    stop("Invalid values found: '", x[utils::head(which(invalid), 1)], "'.")
  structure(res, fielddescriptor = fielddescriptor)
}

#' @export
dp_to_year.Date <- function(x, fielddescriptor = list(), ...) {
  dp_to_year(format(x, "%Y"))
}

#' @export
dp_to_year.POSIXt <- function(x, fielddescriptor = list(), ...) {
  dp_to_year(format(x, "%Y"))
}


# @rdname csv_colclass
# @export
csv_colclass_year <- function(fielddescriptor = list(), ...) {
  if (!is.null(fielddescriptor$missingValues)) {
    "character"
  } else {
    "integer"
  }
}

