#' Add a reader function for a specific format
#'
#' @param format the data format read by the reader. Should be a length 1 character vector.
#' @param reader the reader function. See details.
#' @param mediatypes a character vector with the media-types that are used for the format.
#' @param extensions a character vector with typical file extensions used by the format.
#' 
#' @details
#' Adds a reader for a given format. The reader is added to a list of reades
#' references by the format. It is also possible to assign mediatypes and file
#' extensions to the format. When the format for a given Data Resource is
#' missing, \code{\link{dp_get_data}} will first check if a mediatype is
#' associated with the resource and will try to look up which format belongs to
#' the fiven mediatype. If that doesn't result in a valid format,
#' \code{\link{dp_get_data}} will try the same with the extension of the file.
#'
#' Note that adding a reader for an existing format will overwrite the existing
#' reader.
#'
#' @return
#' Does not return anything (\code{invisible(NULL)}). 
#'
#' @examples
#' # Add a very simple reader for json
#' json_reader <- function(path, resource, ...) {
#'   lapply(path, function(fn) {
#'     jsonlite::read_json(fn)
#'   })
#' }
#'
#' dp_add_reader("json", json_reader, c("application/json"), "json")
#' 
#' @export
dp_add_reader <- function(format, reader, mediatypes = character(0), extensions = character(0)) {
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

