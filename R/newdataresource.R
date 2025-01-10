
#' Create a new Data Resource
#'
#' @param name The name of the Data Resource.
#'
#' @param title The title of the Data Resource.
#'
#' @param description The description of the Data Resource.
#'
#' @param path the path of the Data Resource
#'
#' @param format the format of the Data Resource
#'
#' @param mediatype the mediatype of the Data Resource
#'
#' @param encoding the encoding of the Data Resource
#'
#' @param bytes the number of bytes of the Data Resource
#'
#' @param hash the hash of the Data Resource
#'
#' @param ... additional arguments are added as additional properties. It is 
#' checked if these are valid. 
#'
#' @return
#' Returns a \code{dataresource} object which is a list with the properties of
#' the Data Resource.
#'
#' @examples
#' dir <- tempdir()
#' dp <- newdatapackage(dir, name = "test-package")
#'
#' res <- newdataresource(name = "iris")
#' dptitle(res) <- "The Iris Data Set"
#' dpencoding(res) <- "UTF-8"
#' dpmediatype(res) <- "text/csv"
#' 
#' # resource adds a resource if it doesn't yet exist or updates
#' # an existing resource
#' dp_resource(dp, "iris") <- res
#' 
#' \dontshow{
#' file.remove(file.path(dir, "datapackage.json"))
#' file.remove(dir)
#' }
#' 
#'
#' @export
newdataresource <- function(name, title = NULL, description = NULL, 
    path = NULL, format = NULL, mediatype = NULL, encoding = NULL, 
    bytes = NULL, hash = NULL, ...) {
  # Build object
  res <- structure(list(), class = 'dataresource')
  dpname(res) <- name
  if (!missing(title) && !is.null(title)) 
    dptitle(res) <- title
  if (!missing(description) && !is.null(description)) 
    dpdescription(res) <- description
  if (!missing(path) && !is.null(path)) 
    dppath(res) <- path
  if (!missing(format) && !is.null(format)) 
    dpformat(res) <- format
  if (!missing(mediatype) && !is.null(mediatype)) 
    dpmediatype(res) <- mediatype
  if (!missing(encoding) && !is.null(encoding)) 
    dpencoding(res) <- encoding
  if (!missing(bytes) && !is.null(bytes)) 
    dpbytes(res) <- bytes
  if (!missing(hash) && !is.null(hash)) 
    dphash(res) <- hash
  other <- list(...)
  for (property in names(other)) dp_property(res, property) <- other[[property]]
  # Return
  res
}

