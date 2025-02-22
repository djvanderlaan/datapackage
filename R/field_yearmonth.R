
#' Add required fields to the fielddescriptor for a yearmonth column
#'
#' @param fielddescriptor should be a list.
#'
#' @return
#' Returns \code{fielddescriptor} with the required fields added. 
#'
complete_fielddescriptor_yearmonth <- function(fielddescriptor) {
  if (!exists("type", fielddescriptor)) fielddescriptor[["type"]] <- "yearmonth"
  fielddescriptor
}

#' Convert a vector to 'yearmonth' using the specified field descriptor
#' 
#' @param x the vector to convert.
#' @param fielddescriptor the field descriptor for the field.
#' @param ... passed on to other methods.
#'
#' @details
#' When \code{fielddescriptor} is missing a default field descriptor is
#' generated using \code{\link{complete_fielddescriptor_yearmonth}}. 
#'
#' Valid formats are "YYYY-MM" or "YYYYMM". When x is numeric or integer, it is
#' assumed that it was a yearmonth in the format "YYYYMM" that was accidentally
#' converted to numeric format.
#'
#' @return
#' Will return an \code{Date} vector with \code{fielddescriptor} added as the
#' 'fielddescriptor' attribute. The dates will be the first of the given month.
#' Therefore, a 'yearmonth' "2024-05" is translated to a date "2024-05-01".
#' 
#' @export
to_yearmonth <- function(x, fielddescriptor = list(), ...) {
  UseMethod("to_yearmonth")
}

#' @export
to_yearmonth.integer <- function(x, fielddescriptor = list(), ...) {
  # When we get an integer or numeric; assume date was accidentally read as 
  # numeric, e.g. when date = 202001 -> convert to character and 
  # convert
  to_yearmonth(sprintf("%06d", x))
}

#' @export
to_yearmonth.numeric <- function(x, fielddescriptor = list(), ...) {
  # When we get an integer or numeric; assume date was accidentally read as 
  # numeric, e.g. when date = 202001 -> convert to character and 
  # convert
  to_yearmonth(sprintf("%06d", x))
}

#' @export
to_yearmonth.character <- function(x, fielddescriptor = list(), ...) {
  fielddescriptor <- complete_fielddescriptor_yearmonth(fielddescriptor)
  # Consider "" as a NA
  na_values <- if (!is.null(fielddescriptor$missingValues)) 
    fielddescriptor$missingValues else ""
  x[x %in% na_values] <- NA
  na <- is.na(x);
  x <- gsub("^([0-9]{4})[-]?([0-9]{2})$", "\\1-\\2-01", x)
  res <- as.Date(x, format = c("%Y-%m-%d"))
  invalid <- is.na(res) & !na
  if (any(invalid)) 
    stop("Invalid values found: '", x[utils::head(which(invalid), 1)], "'.")
  structure(res, fielddescriptor = fielddescriptor)
}

#' @export
to_yearmonth.Date <- function(x, fielddescriptor = list(), ...) {
  fielddescriptor <- complete_fielddescriptor_yearmonth(fielddescriptor)
  to_yearmonth(format(x, "%Y-%m"))
}

#' @export
to_yearmonth.POSIXt <- function(x, fielddescriptor = list(), ...) {
  fielddescriptor <- complete_fielddescriptor_yearmonth(fielddescriptor)
  to_yearmonth(format(x, "%Y-%m"))
}


# @rdname csv_colclass
# @export
csv_colclass_yearmonth <- function(fielddescriptor = list(), ...) {
  "character"
}

