#' Quickly read a dataset from a Data Package
#'
#' @param path the directory with the Data Package
#' @param resource_name the name of the Data Resource. When omitted the Data Resource
#' with the same name as the Data Package is read in and when no such resource
#' exists the first Data Resource is read in.
#'
#' @param ... passed on to \code{\link{dp_get_data}}.
#'
#' @details
#' This function is a wrapper around \code{\link{open_datapackage}} and
#' \code{\link{dp_get_data}}. It offers a quick way to read in a dataset from a
#' Data Package.
#'
#' @return
#' Returns a dataset. Usually a \code{data.frame}.
#'
#' @export
dp_load_from_datapackage <- function(path, resource_name, ...) {
  missingname <- missing(resource_name)
  dp <- open_datapackage(path)
  if (missingname) resource_name <- dp_name(dp)
  resourcenames <- dp_resource_names(dp)
  if (length(dp_resource_names) == 0) 
    stop("Data Package does not contain any resources.")
  if (is.null(resource_name) | !(resource_name %in% dp_resource_names(dp))) {
    if (!missingname) stop("Invalid resource name '", resource_name, "'. ", 
      "Valid names are: ", paste0("'", resourcenames, "'", collapse = ", "))
    resource_name <- dp_resource_names(dp)[1]
    warning("Using first data resource.")
  }
  dp |> dp_resource(resource_name) |> dp_get_data(...)
}
