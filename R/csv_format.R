
# Format the field before writing to CSV
# 
# @param x the field
#
# @param fielddescriptor the field descriptor
#
# @param ... passed on to other methods
#
# @return
# Returns a formatted version of the column that can be used by
# \code{write.csv} to write the column.
# 
# @rdname csv_format
# @export
csv_format <- function(x, fielddescriptor = attr(x, "fielddescriptor"), ...) {
  type <- fielddescriptor$type
  x <- clearandcheckcategories(x, fielddescriptor)
  format_fun <- paste0("csv_format_", type)
  format_fun <- get(format_fun)
  format_fun(x, fielddescriptor, ...)
}

# @rdname csv_format
# @export
csv_format_boolean <- function(x, fielddescriptor = attr(x, "fielddescriptor"), ...) {

  if (is.null(fielddescriptor$trueValues))
    fielddescriptor$trueValues <- c("true", "True", "TRUE", "1")
  if (is.null(fielddescriptor$falseValues))
    fielddescriptor$falseValues <- c("false", "False", "FALSE", "0")
  if (is.logical(x) && ("TRUE" %in% fielddescriptor$trueValues) && 
      ("FALSE" %in% fielddescriptor$falseValues)) {
    # We can as is as R writes TRUE/FALSE by default
    x
  } else {
    trueval <- utils::head(fielddescriptor$trueValues, 1)
    falseval <- utils::head(fielddescriptor$falseValues, 1)
    # When x is not logical; we let ifelse handle that
    ifelse(x, trueval, falseval)
  }
}

# @rdname csv_format
# @export
csv_format_date <- function(x, fielddescriptor = attr(x, "fielddescriptor"), ...) {
  if (is.null(fielddescriptor$format) || fielddescriptor$format == "default" || 
      fielddescriptor$format == "any") {
    format <- "%Y-%m-%d"
  } else {
    format <- fielddescriptor$format
  }
  format(x, format = format)
}

# @rdname csv_format
# @export
csv_format_integer <- function(x, fielddescriptor = attr(x, "fielddescriptor"), ...) {
  as.integer(x)
}

# @rdname csv_format
# @export
csv_format_number <- function(x, fielddescriptor = attr(x, "fielddescriptor"), decimalChar = ".") {
  has_groupchar <- !is.null(fielddescriptor$groupChar) && fielddescriptor$groupChar != ""
  has_decimalchar <- !is.null(fielddescriptor$decimalChar) && fielddescriptor$decimalChar != decimalChar
  x <- as.numeric(x)
  if (has_groupchar || has_decimalchar) {
    groupchar <- if (has_groupchar) fielddescriptor$groupChar else ""
    decimalchar <- if (has_decimalchar) fielddescriptor$decimalChar else 
      decimalChar
    na <- is.na(x)
    x <- formatC(x, big.mark = groupchar, decimal.mark = decimalchar, 
     format = "fg", digits = 15, width = 1)
    x[na] <- NA
    x
  } else x
}

# @rdname csv_format
# @export
csv_format_string <- function(x, fielddescriptor = attr(x, "fielddescriptor"), ...) {
  # For a character we don't have to do anything; we can write as is
  x
}

# @rdname csv_format
# @export
csv_format_datetime <- function(x, fielddescriptor = attr(x, "fielddescriptor"), ...) {
  format <- "%Y-%m-%dT%H:%M:%S%z"
  if (is.null(fielddescriptor$format) || fielddescriptor$format == "default" || 
      fielddescriptor$format == "any") {
    format <- "%Y-%m-%dT%H:%M:%S%z"
    res <- format(x, format = format)
    # iso8601: positive sign time zone = east of gmt
    res <- gsub("[+]([0-9]{2})([0-9]{2})$", "+\\1:\\2", res)
    res <- gsub("[-]([0-9]{2})([0-9]{2})$", "-\\1:\\2", res)
    res <- gsub("[+]00:00$", "Z", res)
  } else {
    format <- fielddescriptor$format
    res <- format(x, format = format)
  }
  if (!is.null(fielddescriptor$missingValues)) {
    res[is.na(res)] <- fielddescriptor$missingValues[1]
  }
  res
}

