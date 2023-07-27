getresourcepath <- function(x, ...) {
  UseMethod("getresourcepath")
}

getresourcepath.dataresource <- function(x, fullpath = TRUE) {
  # Determine path to data
  if (!exists("path", x)) stop("Resource has no path defined")
  filename <- x$path
  stopifnot(!is.null(filename), is.character(filename), length(filename) == 1)
  if (fullpath && !isabsolutepath(filename)) {
    basepath <- attr(x, "path")
    if (is.null(basepath)) 
      warning("Path defined in resource is relative. ",
        "No base path is defined in resource. Returning relative path.")
    file.path(basepath, filename) 
  } else {
    filename
  }
}

getresourcepath.datapackage <- function(x, resourcename, fullpath = TRUE) {
  resource <- getdataresource(x, resourcename, fullpath = fullpath)
  getresourcepath(resource, ...)
}

