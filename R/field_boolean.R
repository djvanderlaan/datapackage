
#' Add required fields to the field descriptor for an boolean column
#'
#' @param fielddescriptor should be a list.
#'
#' @return
#' Returns \code{fielddescriptor} with the required fields added. 
#'
complete_fielddescriptor_boolean <- function(fielddescriptor) {
  if (!exists("type", fielddescriptor)) fielddescriptor[["type"]] <- "boolean"
  if (!exists("trueValues", fielddescriptor))
    fielddescriptor[["trueValues"]] <- c("true", "TRUE", "True", "1")
  if (!exists("falseValues", fielddescriptor))
    fielddescriptor[["falseValues"]] <- c("false", "FALSE", "False", "0")
  fielddescriptor
}

#' Convert a vector to 'boolean' using the specified field descriptor
#' 
#' @param x the vector to convert.
#' @param fielddescriptor the field descriptor for the field.
#' @param ... passed on to other methods.
#'
#' @details
#' When \code{fielddescriptor} is missing a default field descriptor is
#' generated using \code{\link{complete_fielddescriptor_boolean}}. 
#'
#' @return
#' Will return an \code{logical} vector with \code{fielddescriptor} added as
#' the 'fielddescriptor' attribute.
#' 
#' @export
to_boolean <- function(x, fielddescriptor = list(), ...) {
  UseMethod("to_boolean")
}

#' @export
to_boolean.integer <- function(x, fielddescriptor = list(), ...) {
  fielddescriptor <- complete_fielddescriptor_boolean(fielddescriptor)
  true_values <- suppressWarnings(as.integer(fielddescriptor$trueValues))
  if (any(is.na(true_values))) 
    stop("Not all falseValues in fielddescriptor are integer.")
  false_values <- suppressWarnings(as.integer(fielddescriptor$falseValues))
  if (any(is.na(false_values))) 
    stop("Not all falseValues in fielddescriptor are integer.")
  # Handle the easy fastest case of int to logical conversion
  # this is possible if false == 0
  if (length(false_values) == 1 && false_values == 0L) {
    res <- as.logical(x)
    if (!all(x %in% c(false_values, true_values, NA))) 
      warning("Invalid trueValues in x.")
  } else {
    s1  <- x %in% true_values
    s0 <- x %in% false_values
    res <- ifelse(s1, TRUE, NA)
    res[s0] <- FALSE
    invalid <- !(s0 | s1 | is.na(x))
    if (any(invalid)) 
      stop("Invalid values found: '", x[utils::head(which(invalid), 1)], "'.")
  }
  structure(res, fielddescriptor = fielddescriptor)
}

#' @export
to_boolean.character <- function(x, fielddescriptor = list(), ...) {
  fielddescriptor <- complete_fielddescriptor_boolean(fielddescriptor)
  # Unless "" is a true of false value we will consider it a missing value
  na_values <- if (!is.null(fielddescriptor$missingValues)) 
    fielddescriptor$missingValues else 
    setdiff("", c(fielddescriptor$trueValues, fielddescriptor$falseValues))
  if (length(na_values)) x[x %in% na_values] <- NA
  s1  <- x %in% fielddescriptor$trueValues
  s0  <- x %in% fielddescriptor$falseValues
  res <- ifelse(s1, TRUE, NA)
  res[s0] <- FALSE
  invalid <- !(s0 | s1 | is.na(x))
  if (any(invalid)) 
    stop("Invalid values found: '", x[utils::head(which(invalid), 1)], "'.")
  structure(res, fielddescriptor = fielddescriptor)
}

#' @export
to_boolean.logical <- function(x, fielddescriptor = list(), ...) {
  fielddescriptor <- complete_fielddescriptor_boolean(fielddescriptor)
  structure(x, fielddescriptor = fielddescriptor)
}

# @rdname csv_colclass
# @export
csv_colclass_boolean <- function(fielddescriptor = list(), ...) {
  fielddescriptor <- complete_fielddescriptor_boolean(fielddescriptor)
  res <- "character"
  if (is.null(fielddescriptor$missingValues) && length(fielddescriptor$trueValues) == 1 && 
      length(fielddescriptor$falseValues) == 1) {
    if (fielddescriptor$trueValues == "TRUE" && fielddescriptor$falseValues == "FALSE")
      res <- "logical"
    if (fielddescriptor$trueValues == "True" && fielddescriptor$falseValues == "False")
      res <- "logical"
    if (fielddescriptor$trueValues == "true" && fielddescriptor$falseValues == "false")
      res <- "logical"
    if (fielddescriptor$trueValues == "1" && fielddescriptor$falseValues == "0")
      res <- "integer"
  }
  res
}

