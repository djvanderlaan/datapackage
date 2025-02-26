
# Add required fields to the fielddescriptor for a datetime column
#
# @param fielddescriptor should be a list.
#
# @return
# Returns \code{fielddescriptor} with the required fields added. 
#
complete_fielddescriptor_datetime <- function(fielddescriptor) {
  if (!exists("type", fielddescriptor)) fielddescriptor[["type"]] <- "datetime"
  fielddescriptor
}

#' Convert a vector to 'datetime' using the specified field descriptor
#' 
#' @param x the vector to convert.
#' @param fielddescriptor the field descriptor for the field.
#' @param ... passed on to other methods.
#'
#' @details
#' When \code{fielddescriptor} is missing a default field descriptor is
#' generated.
#'
#' For the default format `iso8601::iso8601todatetime` is used to convert. This
#' function allows more formats than the Data Package standard prescribes. When 
#' format equals "any" the default `as.POSIXct` function is used.
#'
#' When \code{x} is numeric or integer, it is assumed that these are seconds
#' since the unix time epoch (1970-01-01T00:00:00).
#'
#' @return
#' Will return an \code{POSIXct} vector with \code{fielddescriptor} added as the
#' 'fielddescriptor' attribute.
#' 
#' @export
dp_to_datetime <- function(x, fielddescriptor = list(), ...) {
  UseMethod("dp_to_datetime")
}

#' @export
dp_to_datetime.integer <- function(x, fielddescriptor = list(), ...) {
  fielddescriptor <- complete_fielddescriptor_datetime(fielddescriptor)
  structure(as.POSIXct(x), fielddescriptor = fielddescriptor)
}

#' @export
dp_to_datetime.numeric <- function(x, fielddescriptor = list(), ...) {
  fielddescriptor <- complete_fielddescriptor_datetime(fielddescriptor)
  structure(as.POSIXct(x), fielddescriptor = fielddescriptor)
}

#' @export
dp_to_datetime.character <- function(x, fielddescriptor = list(), ...) {
  fielddescriptor <- complete_fielddescriptor_datetime(fielddescriptor)
  # Consider "" as a NA
  na_values <- if (!is.null(fielddescriptor$missingValues)) 
    fielddescriptor$missingValues else ""
  x[x %in% na_values] <- NA
  na <- is.na(x);
  if (is.null(fielddescriptor$format) || fielddescriptor$format == "default") {
    res <- iso8601::iso8601todatetime(x)
  } else if (fielddescriptor$format == "any") {
    res <- as.POSIXct(x)
  } else {
    res <- as.POSIXct(x, format = fielddescriptor$format)
  }
  invalid <- is.na(res) & !na
  if (any(invalid)) 
    stop("Invalid values found: '", x[utils::head(which(invalid), 1)], "'.")
  structure(res, fielddescriptor = fielddescriptor)
}

#' @export
dp_to_datetime.POSIXlt <- function(x, fielddescriptor = list(), ...) {
  fielddescriptor <- complete_fielddescriptor_datetime(fielddescriptor)
  structure(as.POSIXct(x), fielddescriptor = fielddescriptor)
}


#' @export
dp_to_datetime.POSIXt <- function(x, fielddescriptor = list(), ...) {
  fielddescriptor <- complete_fielddescriptor_datetime(fielddescriptor)
  # Nothing to do; x is already the correct type 
  structure(x, fielddescriptor = fielddescriptor)
}

# @rdname csv_colclass
# @export
csv_colclass_datetime <- function(fielddescriptor = list(), ...) {
  "character"
}

