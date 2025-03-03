
# Add required fields to the field descriptor for an integer column
#
# @param fielddescriptor should be a list.
#
# @return
# Returns \code{fielddescriptor} with the required fields added. 
#
complete_fielddescriptor_integer <- function(fielddescriptor) {
  if (!exists("type", fielddescriptor)) fielddescriptor[["type"]] <- "integer"
  fielddescriptor
}


#' Convert a vector to 'integer' using the specified field descriptor
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
#' Will return an \code{integer} vector with \code{fielddescriptor} added as
#' the 'fielddescriptor' attribute.
#' 
#' @export
dp_to_integer <- function(x, fielddescriptor = list(), ...) {
  UseMethod("dp_to_integer")
}

#' @export
dp_to_integer.integer <- function(x, fielddescriptor = list(), ...) {
  fielddescriptor <- complete_fielddescriptor_integer(fielddescriptor)
  structure(x, fielddescriptor = fielddescriptor)
}

#' @export
dp_to_integer.numeric <- function(x, fielddescriptor = list(), ...) {
  fielddescriptor <- complete_fielddescriptor_integer(fielddescriptor)
  # Need to check for rounding errors? Would round(x) be better? 
  x <- as.integer(round(x))
  structure(x, fielddescriptor = fielddescriptor)
}

#' @export
dp_to_integer.factor <- function(x, fielddescriptor = list(), ...) {
  fielddescriptor <- complete_fielddescriptor_integer(fielddescriptor)
  categorieslist <- dp_categorieslist(fielddescriptor)
  if (is.null(categorieslist)) {
    x <- as.integer(x)
  } else {
    na <- is.na(x)
    if (length(intersect(levels(x), categorieslist[[2]])) != nlevels(x)) {
      stop("Levels of x do not match categorieslist.")
    }
    x <- match(x, categorieslist[[2]])
  }
  structure(x, fielddescriptor = fielddescriptor)
}

#' @export
dp_to_integer.character <- function(x, fielddescriptor = list(), ...) {
  fielddescriptor <- complete_fielddescriptor_integer(fielddescriptor)
  # Consider "" as a NA
  na_values <- if (!is.null(fielddescriptor$missingValues)) 
    fielddescriptor$missingValues else ""
  na <- x %in% na_values | is.na(x);
  x[x %in% na_values] <- NA
  # handle bareNumber
  if (!is.null(fielddescriptor$bareNumber) && 
      (fielddescriptor$bareNumber == FALSE)) {
    res <- bareNumber(x, warn = FALSE)
    x <- res$remainder
  }
  # groupChar
  if (!is.null(fielddescriptor$groupChar)) 
    x <- gsub(fielddescriptor$groupChar, "", x, fixed = TRUE)
  # Convert
  res <- suppressWarnings(as.integer(x))
  invalid <- is.na(res) & !na
  if (any(invalid)) 
    stop("Invalid values found: '", x[utils::head(which(invalid), 1)], "'.")
  structure(res, fielddescriptor = fielddescriptor)
}

#' @export
dp_to_integer.integer64 <- function(x, fielddescriptor = list(), ...) {
  # integer64 is automaticall used by fread for large numbers
  fielddescriptor <- complete_fielddescriptor_integer(fielddescriptor)
  structure(x, fielddescriptor = fielddescriptor)
}


# @rdname csv_colclass
# @export
csv_colclass_integer <- function(fielddescriptor = list(), ...) {
  colclass <- "integer"
  # When there are specific strings that encode a missing values we have to
  # read the field as character; otherwise we can leave the conversion to
  # integer to the csv reader.
  if (!is.null(fielddescriptor$missingValues)) colclass <- "character"
  # When the field can contain additional text; e.g. "50%" we have to 
  # read as character
  if (!is.null(fielddescriptor$bareNumber) && 
      (fielddescriptor$bareNumber == FALSE)) colclass <- "character"
  # Same for thousands separator
  if (!is.null(fielddescriptor$groupChar) && 
      (fielddescriptor$groupChar != "")) colclass <- "character"
  colclass
}

