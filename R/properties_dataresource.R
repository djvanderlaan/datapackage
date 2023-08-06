

# ==============================================================================
# NAME
# Required; string; onl lower case alnum and _/-/.

#' @export
#' @rdname attributes_dataresource
name.dataresource <- function(x) {
  res <- property(x, "name")
  # Name is required for data resource
  if (is.null(res))
    stop("Required attribute 'name' is missing from Data Resource.")
  res
}

#' @export
#' @rdname attributes_dataresource
`name<-.dataresource` <- function(x, value) {
  value <- paste0(value)
  if (!isname(value)) stop("name should consists only of lower case letters, ",
      "numbers, '-', '.' or '_'.")
  property(x, "name") <- value
}

# ==============================================================================
# TITLE
# Optional; string

#' @export
#' @rdname attributes_dataresource
title.dataresource <- function(x) {
  property(x, "title")
}

#' @export
#' @rdname attributes_dataresource
`title<-.dataresource` <- function(x, value) {
  if (!is.null(value)) {
    value <- paste0(value)
    if (!isstring(value)) stop("value should be a character of length 1.")
  }
  property(x, "title") <- value
}

# ==============================================================================
# DESCRIPTION
# Optional; string

#' @export
#' @rdname attributes_dataresource
description.dataresource <- function(x, ..., firstparagraph = FALSE, 
    dots = FALSE) {
  res <- property(x, "description")
  if (!is.null(res) && firstparagraph) getfirstparagraph(res, dots) else res
}

#' @export
#' @rdname attributes_dataresource
`description<-.dataresource` <- function(x, value) {
  if (!is.null(value)) {
    value <- paste0(value, collapse = "\n")
    # Because of the paste0 above value will always be a string
  }
  property(x, "description") <- value
}

# ==============================================================================
# PATH
# Required if no data attribute
# Should be an url (http[s]://) or relative path
# There is the path relative to the datapackage and there is the path relative
# to the working directory of R. The first is relevant for the datapackage the
# second when one wants to read the data from the path

#' @export
#' @rdname attributes_dataresource
path <- function(x, ...) {
  UseMethod("path")
}

#' @export
#' @rdname attributes_dataresource
`path<-` <- function(x, value, ...) {
  UseMethod("path<-")
}

#' @export
#' @rdname attributes_dataresource
path.dataresource <- function(x, fullpath = FALSE, ...) {
  # Determine path to data
  filename <- property(x, "path")
  if (is.null(filename)) return(NULL)
  stopifnot(is.character(filename))
  if (fullpath) {
    # Check if path is valid; note path may be a vector of paths
    rel <- isrelativepath(filename)
    url <- isurl(filename)
    # They should either be all relative paths or all urls
    if (!(all(rel) || all(url))) 
      stop("Invalid path field. Paths should either be all relative paths or all URL's.")
    # Convert relative paths to full paths
    if (all(rel)) {
      basepath <- attr(x, "path")
      if (is.null(basepath)) 
        warning("Path defined in resource is relative. ",
          "No base path is defined in resource. Returning relative path.")
      filename <- file.path(basepath, filename) 
    } 
  } 
  filename
}

#' @export
#' @rdname attributes_dataresource
`path<-.dataresource` <- function(x, value) {
  stopifnot(is.null(value) || (is.character(value) & length(value) > 0))
  if (!is.null(value)) {
    # Check if path is valid; note path may be a vector of paths
    rel <- isrelativepath(filename)
    url <- isurl(filename)
    # They should either be all relative paths or all urls
    if (!(all(rel) || all(url))) 
      stop("Invalid path field. Paths should either be all relative paths or all URL's.")
    # Check if value contains the location of the data package; should be relative
    # to location of datapackage
    #tmp_value <- normalizePath(path, mustWork = FALSE)
    #datapackage_path <- attr(x, "path")
    #if (any(grepl(paste0("^", datapackage_path), tmp_value))) {
    #  warning("TODO")
    #}
  }
  property(x, "path") <- value
}


