
#' Create a new Data Resource
#'
#' @param name The name of the Data Resource.
#'
#' @param title The title of the Data Resource.
#'
#' @param description The description of the Data Resource.
#'
#' @param ... Ignored for now.
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
#' title(res) <- "The Iris Data Set"
#' encoding(res) <- "UTF-8"
#' mediatype(res) <- "text/csv"
#' 
#' # resource adds a resource if it doesn't yet exist or updates
#' # an existing resource
#' resource(dp, "iris") <- res
#' 
#' \dontshow{
#' file.remove(file.path(dir, "datapackage.json"))
#' file.remove(dir)
#' }
#' 
#'
#' @export
newdataresource <- function(name, title = NULL, description = NULL, ...) {
  # Build object
  res <- structure(list(), class = 'dataresource')
  name(res) <- name
  if (!missing(title) && !is.null(title)) 
    title(res) <- title
  if (!missing(description) && !is.null(description)) 
    description(res) <- description
  # Return
  res
}

