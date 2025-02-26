# Add required fields to the fielddescriptor for a time column
#
# @param fielddescriptor should be a list.
#
# @return
# Returns \code{fielddescriptor} with the required fields added. 
#
complete_fielddescriptor_time <- function(fielddescriptor) {
  if (!exists("type", fielddescriptor)) fielddescriptor[["type"]] <- "time"
  fielddescriptor
}

#' Convert a vector to 'time' using the specified field descriptor
#' 
#' @param x the vector to convert.
#' @param fielddescriptor the field descriptor for the field.
#' @param ... passed on to other methods.
#'
#' @details
#' When \code{fielddescriptor} is missing a default field descriptor is
#' generated using \code{\link{complete_fielddescriptor_time}}. 
#'
#' For the default format `iso8601::iso8601totime` is used to convert. This
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
dp_to_time <- function(x, fielddescriptor = list(), ...) {
  UseMethod("dp_to_time")
}

#' @export
dp_to_time.integer <- function(x, fielddescriptor = list(), ...) {
  fielddescriptor <- complete_fielddescriptor_time(fielddescriptor)
  res <- as.POSIXct(x, tz = "GMT")
  res <- format(res, "1970-01-01 %H:%M:%S") |> as.POSIXct(tz = "GMT")
  structure(res, fielddescriptor = fielddescriptor, 
    class = c("Time", class(res)))
}

#' @export
dp_to_time.numeric <- function(x, fielddescriptor = list(), ...) {
  fielddescriptor <- complete_fielddescriptor_time(fielddescriptor)
  res <- as.POSIXct(x, tz = "GMT")
  res <- format(res, "1970-01-01 %H:%M:%S") |> as.POSIXct(tz = "GMT")
  structure(res, fielddescriptor = fielddescriptor, 
    class = c("Time", class(res)))
}

#' @export
dp_to_time.character <- function(x, fielddescriptor = list(), ...) {
  fielddescriptor <- complete_fielddescriptor_time(fielddescriptor)
  # Consider "" as a NA
  na_values <- if (!is.null(fielddescriptor$missingValues)) 
    fielddescriptor$missingValues else ""
  x[x %in% na_values] <- NA
  na <- is.na(x);
  if (is.null(fielddescriptor$format) || fielddescriptor$format == "default") {
    res <- iso8601::iso8601totime(x)
  } else if (fielddescriptor$format == "any") {
    res <- iso8601::iso8601totime(x)
  } else {
    res <- as.POSIXct(x, format = fielddescriptor$format, tz = "GMT")
    res <- format(res, "1970-01-01 %H:%M:%S") |> as.POSIXct(tz = "GMT")
    class(res) <- c("Time", class(res))
  }
  invalid <- is.na(res) & !na
  if (any(invalid)) 
    stop("Invalid values found: '", x[utils::head(which(invalid), 1)], "'.")
  structure(res, fielddescriptor = fielddescriptor)
}

#' @export
dp_to_time.POSIXlt <- function(x, fielddescriptor = list(), ...) {
  fielddescriptor <- complete_fielddescriptor_time(fielddescriptor)
  res <- format(x, "1970-01-01 %H:%M:%S") |> as.POSIXct(tz = "GMT")
  class(res) <- c("Time", class(res))
  structure(res, fielddescriptor = fielddescriptor)
}


#' @export
dp_to_time.POSIXt <- function(x, fielddescriptor = list(), ...) {
  fielddescriptor <- complete_fielddescriptor_time(fielddescriptor)
  res <- format(x, "1970-01-01 %H:%M:%S") |> as.POSIXct(tz = "GMT")
  class(res) <- c("Time", class(res))
  structure(res, fielddescriptor = fielddescriptor)
}

# @rdname csv_colclass
# @export
csv_colclass_time <- function(fielddescriptor = list(), ...) {
  "character"
}

