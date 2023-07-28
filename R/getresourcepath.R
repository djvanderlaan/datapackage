getresourcepath <- function(x, ...) {
  UseMethod("getresourcepath")
}

getresourcepath.dataresource <- function(x, fullpath = TRUE) {
  # Determine path to data
  if (!exists("path", x)) return(NULL)
  filename <- x$path
  stopifnot(!is.null(filename), is.character(filename))
  # Check if path is valid; note path may be a vector of paths
  rel <- isrelativepath(filename)
  url <- isurl(filename)
  # They should either be all relative paths or all urls
  if (!(all(rel) || all(url))) 
    stop("Invalid path field. Paths should either be all relative paths or all URL's.")
  # Convert relative paths to full paths
  if (all(rel) && fullpath) {
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
  resource <- getresource(x, resourcename)
  getresourcepath(resource, fullpath = fullpath)
}

