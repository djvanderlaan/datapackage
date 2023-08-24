
#' Get the data belonging to a Data Resource
#'
#' @param x a \code{dataresource} or \code{datapackage} object.
#'
#' @param resourcename the name of the \code{dataresource}.
#'
#' @param reader the reader to use to read the data. This should be either a
#' function accepting the path to the data set (a character vector with possibly
#' multitple filenames) and the Data Resource as second argument, or the
#' character string \code{"guess"}.
#'
#' @param ... passed on to the \code{reader}
#'
#' @details
#' When \code{reader = "guess"} the function will try to guess which reader to
#' used based on the \code{format} and \code{mediatype} of the Data Resource.
#' Currently only CSV is supported. For other data types a custom reader has to
#' be provided unless the data is stored inside the Data Resource object.
#'
#' @return
#' Will return the data. This will generally be a \code{data.frame} but
#' depending on the file type can also be other types of R-objects.
#
#' @rdname getdata
#' @export
getdata <- function(x, ...) {
  UseMethod("getdata")
}

#' @rdname getdata
#' @export
getdata.dataresource <- function(x, reader = "guess", ...) {
  # Check if resource includes data; ifso return that
  if (exists("data", x)) return(x$data)
  # Determine path to data
  filename <- path(x, fullpath = TRUE)
  # Determine reader
  if (is.character(reader) && reader[1] == "guess") 
    reader <- guessreader(x$format, x$mediatype)
  stopifnot(is.function(reader))
  # Read
  reader(filename, x, ...)
}

#' @rdname getdata
#' @export
getdata.datapackage <- function(x, resourcename, reader = "guess", ...) {
  resource <- resource(x, resourcename)
  if (is.null(resource)) stop("Resource '", resourcename, "' not found.")
  getdata(resource, reader = "guess", ...)
}

guessreader <- function(format, mediatype) {
  if (missing(format) || is.null(format)) format <- ""
  if (missing(mediatype) || is.null(mediatype)) format <- ""
  stopifnot(is.character(format) && length(format) == 1)
  stopifnot(is.character(mediatype) && length(mediatype) == 1)
  format <- tolower(format)
  mediatype <- tolower(mediatype)
  # Try to find the correct reader for the given format/mediatype
  if (format == "csv") return(csv_reader)
  if (mediatype == "text/csv") return(csv_reader)
  # default reader = csv
  csv_reader
}

