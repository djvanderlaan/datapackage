#' Create a new Data Package
#'
#' @param path The directory which will contain the Data Package or the filename
#' in which to write the Data Package. 
#'
#' @param name The name of the Data Package.
#'
#' @param title The title of the Data Package.
#'
#' @param description The description of the Data Package.
#'
#' @param ... Ignored for now.
#'
#' @return
#' The directory of \code{path}, or the directory containing \code{path} if path
#' is a file name, is created and the file with the Data Package information is
#' created. When \code{path} is a directory a file \code{datapackage.json} is
#' created. The function returns an editable \code{datapackage} object. 
#'
#' @examples
#' dir <- tempdir()
#' dp <- new_datapackage(dir, name = "test-package")
#' 
#' dp_title(dp) <- "A Test Data Package"
#' dp_add_contributor(dp) <- new_contributor(title = "John Doe")
#' 
#' \dontshow{
#' file.remove(file.path(dir, "datapackage.json"))
#' file.remove(dir)
#' }
#' 
#' @export
new_datapackage <- function(path, name = NULL, title = NULL, description = NULL, ...) {
  stopifnot(missing(name) || isname(name))
  stopifnot(missing(title) || isstring(title))
  stopifnot(missing(description) || isstring(description))
  # Build object
  res <- list(name = name, title = title, description = description)
  res <- Filter(\(x) !is.null(x), res)
  if (!exists("resources", res)) res$resources <- list()
  res <- structure(res, class = "datapackage")
  # Split path into the filename of the descriptor and the path of the 
  # datapackage
  ext <- tools::file_ext(path)
  if (ext != "json" && ext != "yaml") {
    filename <- "datapackage.json"
  } else {
    filename <- basename(path)
    path <- dirname(path)
  }
  # Make the path absolute; otherwise we cannot access it when the user changes
  # directory
  path <- normalizePath(path, mustWork = FALSE)
  # Check if datapackage already exists in directory
  if (file.exists(file.path(path, filename))) 
    stop("'", file.path(path, filename), "' already exists.")
  # Write the datapackage
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  writedatapackage(res, path = path, filename = filename)
  open_datapackage(path, readonly = FALSE)
}

