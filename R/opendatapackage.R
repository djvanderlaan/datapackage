#' Open a data package
#'
#' @param path The filename or the data package description or the directory in
#' which the data package is located. 
#' 
#' @param readonly Open the data package as a read-only data package or not. See
#' 'details'
#'
#' @details
#' When \code{path} is a directory name, the function looks for the files
#' 'datapackage.json' or 'datapackage.yaml' in the directory. Otherwise, the
#' function assumes the file contains the description of the data package.
#' 
#' When the data package is read with \code{readonly = FALSE}, any operations
#' reading properties from the data package read those properties directly from
#' the file on disk. And setting the properties will change the file on disk.
#' This ensures the file is always consistent. 
#'
#' @return
#' Returns a list with the contents of the data package when 
#' \code{readonly = TRUE}. Otherwise an empty list is returned. In both cases
#' the filename of the data package description (typically 'datapackage.json')
#' and the director in which the data package is located are stored in
#' attributes of the result.
#' 
#' @export
opendatapackage <- function(path, readonly = TRUE) {
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
  # Open datapackage
  dp <- readdatapackage(path, filename)
  if (readonly) {
    dp
  } else {
    structure(list(), 
      class = c("editabledatapackage", "datapackage"), 
      path = path, filename = filename)
  }
}

