#' Write  data of resource to file
#'
#' @param x the Data Package or Data Resource to which the data is to be written
#' to.
#'
#' @param data \code{data.frame} with the data to write.
#'
#' @param resourcename name of the Data Resource in the Data Package to which
#' the data needs to be written.
#'
#' @param datapackage the Data Package to which the data needs to be written.
#'
#' @param writer the writer to use to write the data. This should be either a
#' function accepting the Data Package, name of the Data Resource, the data and
#' the \code{write_codelists} argument or the character string \code{"guess"}.
#'
#' @param ... additional arguments are passed on to the writer function.
#'
#' @param write_codelists write both the data set \code{x} itself and any
#' code lists of fields in the data set.
#'
#' @details
#' When \code{writer = "guess"} the function will try to guess which writer to
#' use based on the \code{format} and \code{mediatype} of the Data Resource.
#'
#' @return
#' The function doesn't return anything. It is called for it's side effect of
#' creating files in the directory of the Data Package.
#'
#' @rdname dpwritedata
#' @export
dpwritedata <- function(x, ..., write_codelists = TRUE) {
  UseMethod("dpwritedata")
}

#' @rdname dpwritedata
#' @export
dpwritedata.datapackage <- function(x, resourcename, data, writer = "guess", ..., 
    write_codelists = TRUE) {
  resource <- dpresource(x, resourcename)
  dpwritedata(resource, data = data, datapackage = x, writer = writer, ..., 
    write_codelists = write_codelists)
}

#' @rdname dpwritedata
#' @export
dpwritedata.dataresource <- function(x, data, datapackage = dpgetdatapackage(x), 
    writer = "guess", ..., write_codelists = TRUE) {
  # First check to see of dataresource fits data
  stopifnot(setequal(names(data), dpfieldnames(x)))
  # Save code lists
  if (write_codelists) {
    for (field in dpfieldnames(x)) {
      clresource <- dpfield(x, field) |> dpproperty("codelist")
      if (!is.null(clresource)) {
        cl <- NULL
        suppressWarnings(try({
          # This could fail if the codelist is not already saved
          cl <- dpcodelist(dpfield(x, field))
        }, silent = TRUE))
        if (is.null(cl)) cl <- dpcodelist(data[[field]])
        dpwritedata(data = cl, resourcename = clresource, datapackage, 
          write_codelists = FALSE, ...)
      }
    }
  }
  # Determine reader
  if (is.character(writer) && writer[1] == "guess") 
    writer <- getwriter(dpformat(x), dpmediatype(x))
  stopifnot(is.function(writer))
  writer(data, resourcename = dpname(x), datapackage = datapackage, ...)
}

getwriter <- function(format, mediatype) {
  if (missing(format) || is.null(format)) format <- ""
  if (missing(mediatype) || is.null(mediatype)) mediatype <- ""
  stopifnot(is.character(format) && length(format) == 1)
  stopifnot(is.character(mediatype) && length(mediatype) == 1)
  format <- tolower(format)
  mediatype <- tolower(mediatype)
  # Try to find the correct reader for the given format/mediatype/extension
  if (format == "") {
    if (mediatype != "") format <- readers$mediatypes[[mediatype]]
    if (is.null(format)) format <- ""
  }
  writer <- readers$writers[[format]]
  if (is.null(writer)) writer <- csv_write
  writer
}

