
guessreader <- function(format, mediatype, filename = "") {
  if (missing(format) || is.null(format)) format <- ""
  if (missing(mediatype) || is.null(mediatype)) mediatype <- ""
  if (missing(filename) || is.null(filename)) filename <- ""
  stopifnot(is.character(format) && length(format) == 1)
  stopifnot(is.character(mediatype) && length(mediatype) == 1)
  stopifnot(is.character(filename))
  extension <- tools::file_ext(filename) |> head(1) |> tolower()
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


#' Add a reader function for a specific format
#'
#' @param format the data format read by the reader. Should be a length 1 character vector.
#' @param reader the reader function. See details.
#' @param mediatypes a character vector with the media-types that are used for the format.
#' @param extensions a character vector with typical file extensions used by the format.
#' 
#' @details
#' TODO
#'
#' @return
#' Does not return anything (\code{invisible(NULL)}). 
#' 
#' @export
dpaddreader <- function(format, reader, mediatypes = character(0), extensions = character(0)) {
  stopifnot(is.character(format), length(format) == 1)
  stopifnot(is.function(reader))
  stopifnot(is.character(mediatypes))
  stopifnot(is.character(extensions))
  for (mediatype in mediatypes)
    readers$mediatypes[[mediatype]] <- format
  for (extension in extensions)
    readers$extensions[[extension]] <- format
  readers$readers[[format]] <- reader
  invisible(NULL)
}

