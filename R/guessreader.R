
guessreader <- function(format, mediatype, filename = "") {
  if (missing(format) || is.null(format)) format <- ""
  if (missing(mediatype) || is.null(mediatype)) mediatype <- ""
  if (missing(filename) || is.null(filename)) filename <- ""
  stopifnot(is.character(format) && length(format) == 1)
  stopifnot(is.character(mediatype) && length(mediatype) == 1)
  stopifnot(is.character(filename))
  extension <- tools::file_ext(filename) |> utils::head(1) |> tolower()
  format <- tolower(format)
  mediatype <- tolower(mediatype)
  # Try to find the correct reader for the given format/mediatype/extension
  if (format == "") {
    if (mediatype != "") format <- readers$mediatypes[[mediatype]]
    if (is.null(format)) format <- ""
  }
  if (format == "") {
    if (extension != "") format <- readers$extensions[[extension]]
    if (is.null(format)) format <- ""
  }
  # If format is not found, try looking in extensions for format
  if (format != "") {
    reader <- readers$readers[[format]]
    if (is.null(reader)) {
      f <- readers$extensions[[format]]
      if (!is.null(f)) format <- f
    }
  }
  reader <- readers$readers[[format]]
  if (is.null(reader)) reader <- csv_reader
  reader
}


