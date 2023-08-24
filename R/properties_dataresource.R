

# ==============================================================================
# NAME
# Required; string; onl lower case alnum and _/-/.

#' Getting and setting properties of Data Resources
#'
#' @param x a \code{dataresource} object.
#' 
#' @param value the new value of the property.
#'
#' @param ... used to pass additional arguments to other methods.
#'
#' @return
#' Either returns the property or modifies the object.
#' 
#' @export
#' @rdname properties_dataresource
name.dataresource <- function(x) {
  res <- property(x, "name")
  # Name is required for data resource
  if (is.null(res))
    stop("Required attribute 'name' is missing from Data Resource.")
  res
}

#' @export
#' @rdname properties_dataresource
`name<-.dataresource` <- function(x, value) {
  value <- paste0(value)
  if (!isname(value)) stop("name should consists only of lower case letters, ",
      "numbers, '-', '.' or '_'.")
  property(x, "name") <- value
  x
}

# ==============================================================================
# TITLE
# Optional; string

#' @export
#' @rdname properties_dataresource
title.dataresource <- function(x) {
  property(x, "title")
}

#' @export
#' @rdname properties_dataresource
`title<-.dataresource` <- function(x, value) {
  if (!is.null(value)) {
    value <- paste0(value)
    if (!isstring(value)) stop("value should be a character of length 1.")
  }
  property(x, "title") <- value
  x
}

# ==============================================================================
# DESCRIPTION
# Optional; string

#' @param firstparagraph Only return the first paragraph of the description.
#' 
#' @param dots When returning only the first paragraph indicate missing
#' paragraphs with \code{...}.
#'
#' @export
#' @rdname properties_dataresource
description.dataresource <- function(x, ..., firstparagraph = FALSE, 
    dots = FALSE) {
  res <- property(x, "description")
  if (!is.null(res) && firstparagraph) getfirstparagraph(res, dots) else res
}

#' @export
#' @rdname properties_dataresource
`description<-.dataresource` <- function(x, value) {
  if (!is.null(value)) {
    value <- paste0(value, collapse = "\n")
    # Because of the paste0 above value will always be a string
  }
  property(x, "description") <- value
  x
}

# ==============================================================================
# PATH
# Required if no data attribute
# Should be an url (http[s]://) or relative path
# There is the path relative to the datapackage and there is the path relative
# to the working directory of R. The first is relevant for the datapackage the
# second when one wants to read the data from the path

#' @export
#' @rdname properties_dataresource
path <- function(x, ...) {
  UseMethod("path")
}

#' @export
#' @rdname properties_dataresource
`path<-` <- function(x, value) {
  UseMethod("path<-")
}

#' @param fullpath Return the full path including the path to the Data Package
#' and not only the path relative to the Data Package. This is only relevant for
#' relative paths.
#' 
#' @export
#' @rdname properties_dataresource
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
#' @rdname properties_dataresource
`path<-.dataresource` <- function(x, value) {
  stopifnot(is.null(value) || (is.character(value) & length(value) > 0))
  if (!is.null(value)) {
    # Check if path is valid; note path may be a vector of paths
    rel <- isrelativepath(value)
    url <- isurl(value)
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
  x
}

# ==============================================================================
# FORMAT
# Optional; string

#' @export
#' @rdname properties_dataresource
format <- function(x, ...) {
  UseMethod("format")
}

#' @export
#' @rdname properties_dataresource
`format<-` <- function(x, value) {
  UseMethod("format<-")
}

#' @export
#' @rdname properties_dataresource
format.dataresource <- function(x, ...) {
  property(x, "format")
}

#' @export
#' @rdname properties_dataresource
`format<-.dataresource` <- function(x, value) {
  if (!is.null(value) && !isstring(value))
    stop("value should be length 1 character vector or NULL.")
  property(x, "format") <- value
  x
}

# ==============================================================================
# MEDIATYPE
# Optional; string

#' @export
#' @rdname properties_dataresource
mediatype <- function(x, ...) {
  UseMethod("mediatype")
}

#' @export
#' @rdname properties_dataresource
`mediatype<-` <- function(x, value) {
  UseMethod("mediatype<-")
}

#' @export
#' @rdname properties_dataresource
mediatype.dataresource <- function(x, ...) {
  property(x, "mediatype")
}

#' @export
#' @rdname properties_dataresource
`mediatype<-.dataresource` <- function(x, value) {
  if (!is.null(value) && !isstring(value))
    stop("value should be length 1 character vector or NULL.")
  property(x, "mediatype") <- value
  x
}

# ==============================================================================
# ENCODING
# Optional; string

#' @export
#' @rdname properties_dataresource
encoding <- function(x, ...) {
  UseMethod("encoding")
}

#' @export
#' @rdname properties_dataresource
`encoding<-` <- function(x, value) {
  UseMethod("encoding<-")
}

#' @export
#' @rdname properties_dataresource
encoding.dataresource <- function(x, ...) {
  property(x, "encoding")
}

#' @export
#' @rdname properties_dataresource
`encoding<-.dataresource` <- function(x, value) {
  if (!is.null(value) && !isstring(value))
    stop("value should be length 1 character vector or NULL.")
  property(x, "encoding") <- value
  x
}

# ==============================================================================
# BYTES
# Optional; integer

#' @export
#' @rdname properties_dataresource
bytes <- function(x, ...) {
  UseMethod("bytes")
}

#' @export
#' @rdname properties_dataresource
`bytes<-` <- function(x, value) {
  UseMethod("bytes<-")
}

#' @export
#' @rdname properties_dataresource
bytes.dataresource <- function(x, ...) {
  property(x, "bytes")
}

#' @export
#' @rdname properties_dataresource
`bytes<-.dataresource` <- function(x, value) {
  if (!is.null(value) && !isinteger(value))
    stop("value should be length 1 integer vector or NULL.")
  property(x, "bytes") <- value
  x
}

# ==============================================================================
# HASH
# Optional; string

#' @export
#' @rdname properties_dataresource
hash <- function(x, ...) {
  UseMethod("hash")
}

#' @export
#' @rdname properties_dataresource
`hash<-` <- function(x, value) {
  UseMethod("hash<-")
}

#' @export
#' @rdname properties_dataresource
hash.dataresource <- function(x, ...) {
  property(x, "hash")
}

#' @export
#' @rdname properties_dataresource
`hash<-.dataresource` <- function(x, value) {
  if (!is.null(value) && !isstring(value))
    stop("value should be length 1 character vector or NULL.")
  property(x, "hash") <- value
  x
}


# TODO:
# - sources
# - licences

