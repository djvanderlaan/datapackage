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
#' the \code{write_categories} argument or the character string \code{"guess"}.
#'
#' @param ... additional arguments are passed on to the writer function.
#'
#' @param write_categories write both the data set \code{x} itself and any
#' categories lists of fields in the data set.
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
dpwritedata <- function(x, ..., write_categories = TRUE) {
  UseMethod("dpwritedata")
}

#' @rdname dpwritedata
#' @export
dpwritedata.datapackage <- function(x, resourcename, data, writer = "guess", ..., 
    write_categories = TRUE) {
  resource <- dpresource(x, resourcename)
  dpwritedata(resource, data = data, datapackage = x, writer = writer, ..., 
    write_categories = write_categories)
}

#' @rdname dpwritedata
#' @export
dpwritedata.dataresource <- function(x, data, datapackage = dpgetdatapackage(x), 
    writer = "guess", ..., write_categories = TRUE) {
  # First check to see of dataresource fits data
  stopifnot(setequal(names(data), dpfieldnames(x)))
  # Save categories lists
  if (write_categories) {
    for (field in dpfieldnames(x)) {
      categories <- dpfield(x, field) |> dpproperty("categories")
      if (!is.null(categories) && categoriestype(categories) == "dataresource") {
        categories_resource <- categories$resource
        if (is.null(categories_resource)) 
          stop("Resource missing for categories of '", field, "'.")
        cl <- NULL
        suppressWarnings(try({
          # This could fail if the categories list is not already saved
          cl <- dpcategorieslist(dpfield(x, field))
        }, silent = TRUE))
        if (is.null(cl)) cl <- dpcategorieslist(data[[field]])
        # Check if a resource for the categories list already exists; if not create it
        if (!(categories_resource %in% dpresourcenames(datapackage))) {
          res <- dpgeneratedataresource(cl, categories_resource)
          dpresources(datapackage) <- res
        }
        dpwritedata(data = cl, resourcename = categories_resource, datapackage, 
          write_categories = FALSE, ...)
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

