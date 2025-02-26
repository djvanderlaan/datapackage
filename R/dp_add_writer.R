#' Add a writer function for a specific format
#'
#' @param format the data format read by the writer Should be a length 1 character vector.
#' @param writer the writer function. See details.
#' 
#' @details
#' Adds a writer for a given format. The writer is added to a list of writers
#' referenced by the format. The writer function should accept 'data' with
#' the data as its first argument, 'resource_name' the name of the resource to
#' which the data set belongs, 'datapackage' that datapackage to which the data
#' should be written.
#'
#' Note that adding a writer for an existing format will overwrite the existing
#' writer
#'
#' @return
#' Does not return anything (\code{invisible(NULL)}). 
#'
#' @examples
#' # Add a very simple writer for json
#' json_writer <- function(data, resource_name, datapackage, ...) {
#'   dataresource <- dp_resource(datapackage, resource_name)
#'   path <- dp_path(dataresource, full_path = TRUE)
#'   jsonlite::write_json(data, path)
#' }
#'
#' dp_add_writer("json", json_writer)
#' 
#' @export
dp_add_writer <- function(format, writer) {
  stopifnot(is.character(format), length(format) == 1)
  stopifnot(is.function(writer))
  readers$writers[[format]] <- writer
  invisible(NULL)
}

# TODO: same type of arguments as reader?
