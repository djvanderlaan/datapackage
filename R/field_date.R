
# Add required fields to the fielddescriptor for a date column
#
# @param fielddescriptor should be a list.
#
# @return
# Returns \code{fielddescriptor} with the required fields added. 
#
complete_fielddescriptor_date <- function(fielddescriptor) {
  if (!exists("type", fielddescriptor)) fielddescriptor[["type"]] <- "date"
  fielddescriptor
}

#' Convert a vector to 'date' using the specified field descriptor
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
#' Will return an \code{Date} vector with \code{fielddescriptor} added as the
#' 'fielddescriptor' attribute.
#' 
#' @export
dp_to_date <- function(x, fielddescriptor = list(), ...) {
  UseMethod("dp_to_date")
}

#' @export
dp_to_date.integer <- function(x, fielddescriptor = list(), ...) {
  # When we get an integer or numeric; assume date was accidentally read as 
  # numeric, e.g. when date = 20200101 or 01012020-> convert to character and 
  # convert
  dp_to_date(sprintf("%08d", x))
}

#' @export
dp_to_date.numeric <- function(x, fielddescriptor = list(), ...) {
  # When we get an integer or numeric; assume date was accidentally read as 
  # numeric, e.g. when date = 20200101 or 01012020-> convert to character and 
  # convert
  dp_to_date(sprintf("%08d", x))
}

#' @export
dp_to_date.character <- function(x, fielddescriptor = list(), ...) {
  fielddescriptor <- complete_fielddescriptor_date(fielddescriptor)
  # Consider "" as a NA
  na_values <- if (!is.null(fielddescriptor$missingValues)) 
    fielddescriptor$missingValues else ""
  x[x %in% na_values] <- NA
  na <- is.na(x);
  if (is.null(fielddescriptor$format) || fielddescriptor$format == "default") {
    res <- as.Date(x, format = "%Y-%m-%d")
  } else if (fielddescriptor$format == "any") {
    res <- as.Date(x)
  } else {
    res <- as.Date(x, format = fielddescriptor$format)
  }
  invalid <- is.na(res) & !na
  if (any(invalid)) 
    stop("Invalid values found: '", x[utils::head(which(invalid), 1)], "'.")
  structure(res, fielddescriptor = fielddescriptor)
}

#' @export
dp_to_date.Date <- function(x, fielddescriptor = list(), ...) {
  fielddescriptor <- complete_fielddescriptor_date(fielddescriptor)
  # Nothing to do; x is already a Data 
  structure(x, fielddescriptor = fielddescriptor)
}

# @rdname csv_colclass
# @export
csv_colclass_date <- function(fielddescriptor = list(), ...) {
  "character"
}

