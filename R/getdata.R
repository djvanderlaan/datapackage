
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

getdata <- function(x, ...) {
  UseMethod("getdata")
}

getdata.dataresource <- function(x, reader = "guess", ...) {
  # Check if resource includes data; ifso return that
  if (exists("data", x)) return(x$data)
  # Determine path to data
  filename <- getresourcepath(x)
  # Determine reader
  if (is.character(reader) && reader[1] == "guess") 
    reader <- guessreader(x$format, x$mediatype)
  stopifnot(is.function(reader))
  # Read
  reader(filename, x)
}

getdata.datapackage <- function(x, resourcename, reader = "guess", ...) {
  resource <- getresource(x, resourcename)
  getdata(resource, reader = "guess", ...)
}

