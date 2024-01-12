#' Quickly read a dataset from a Data Package
#'
#' @param path the directory with the Data Package
#' @param name the name of the Data Resource. When omitted the Data Resource
#' with the same name as the Data Package is read in and when no such resource
#' exists the first Data Resource is read in.
#'
#' @param ... passed on to \code{\link{dpgetdata}}.
#'
#' @details
#' This function is a wrapper around \code{\link{opendatapackage}} and
#' \code{\link{dpgetdata}}. It offers a quick way to read in a dataset from a
#' Data Package.
#'
#' @return
#' Returns a dataset. Usually a \code{data.frame}.
#'
#' @export
dploadfromdatapackage <- function(path, name, ...) {
  missingname <- missing(name)
  dp <- opendatapackage(path)
  if (missingname) name <- dpname(dp)
  resourcenames <- dpresourcenames(dp)
  if (length(dpresourcenames) == 0) 
    stop("Data Package does not contain any resources.")
  if (is.null(name) | !(name %in% dpresourcenames(dp))) {
    if (!missingname) stop("Invalid resource name '", name, "'. ", 
      "Valid names are: ", paste0("'", resourcenames, "'", collapse = ", "))
    name <- dpresourcenames(dp)[1]
    warning("Using first data resource.")
  }
  dp |> dpresource(name) |> dpgetdata(...)
}
