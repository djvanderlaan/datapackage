

# ==============================================================================
# NAME
# Required; string; onl lower case alnum and _/-/.

#' Getting and setting properties of Data Resources
#'
#' @param x a \code{dataresource} object.
#' 
#' @param value the new value of the property.
#' @param default return the default value if the property had a default value 
#'   and the property is not set.
#'
#' @param ... used to pass additional arguments to other methods.
#'
#' @return
#' Either returns the property or modifies the object. If the property of not
#' set \code{NULL} is returned (unless \code{default = TRUE}).
#' 
#' @export
#' @rdname properties_dataresource
dp_name.dataresource <- function(x) {
  res <- dp_property(x, "name")
  # Name is required for data resource
  if (is.null(res))
    stop("Required attribute 'name' is missing from Data Resource.")
  res
}

#' @export
#' @rdname properties_dataresource
`dp_name<-.dataresource` <- function(x, value) {
  value <- paste0(value)
  if (!isname(value)) stop("name should consists only of lower case letters, ",
      "numbers, '-', '.' or '_'.")
  dp_property(x, "name") <- value
  x
}

# ==============================================================================
# TITLE
# Optional; string

#' @export
#' @rdname properties_dataresource
dp_title.dataresource <- function(x) {
  dp_property(x, "title")
}

#' @export
#' @rdname properties_dataresource
`dp_title<-.dataresource` <- function(x, value) {
  if (!is.null(value)) {
    value <- paste0(value)
    if (!isstring(value)) stop("value should be a character of length 1.")
  }
  dp_property(x, "title") <- value
  x
}

# ==============================================================================
# DESCRIPTION
# Optional; string

#' @param first_paragraph Only return the first paragraph of the description.
#' 
#' @param dots When returning only the first paragraph indicate missing
#' paragraphs with \code{...}.
#'
#' @export
#' @rdname properties_dataresource
dp_description.dataresource <- function(x, ..., first_paragraph = FALSE, 
    dots = FALSE) {
  res <- dp_property(x, "description")
  if (!is.null(res) && first_paragraph) getfirstparagraph(res, dots) else res
}

#' @export
#' @rdname properties_dataresource
`dp_description<-.dataresource` <- function(x, value) {
  if (!is.null(value)) {
    value <- paste0(value, collapse = "\n")
    # Because of the paste0 above value will always be a string
  }
  dp_property(x, "description") <- value
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
dp_path <- function(x, ...) {
  UseMethod("dp_path")
}

#' @export
#' @rdname properties_dataresource
`dp_path<-` <- function(x, value) {
  UseMethod("dp_path<-")
}

#' @param full_path Return the full path including the path to the Data Package
#' and not only the path relative to the Data Package. This is only relevant for
#' relative paths.
#' 
#' @export
#' @rdname properties_dataresource
dp_path.dataresource <- function(x, full_path = FALSE, ...) {
  # Determine path to data
  filename <- dp_property(x, "path")
  if (is.null(filename)) return(NULL)
  stopifnot(is.character(filename))
  if (full_path) {
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
`dp_path<-.dataresource` <- function(x, value) {
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
  dp_property(x, "path") <- value
  x
}

# ==============================================================================
# FORMAT
# Optional; string

#' @export
#' @rdname properties_dataresource
dp_format <- function(x, ...) {
  UseMethod("dp_format")
}

#' @export
#' @rdname properties_dataresource
`dp_format<-` <- function(x, value) {
  UseMethod("dp_format<-")
}

#' @export
#' @rdname properties_dataresource
dp_format.dataresource <- function(x, default = FALSE, ...) {
  res <- dp_property(x, "format")
  if (is.null(res) && default) {
    path <- dp_path(x)
    if (!is.null(path)) {
      ext <- sapply(path, tools::file_ext) |> tolower() |> unique()
      if (length(ext) == 1) {
        res <- ext
      }
    }
  }
  res
}

#' @export
#' @rdname properties_dataresource
`dp_format<-.dataresource` <- function(x, value) {
  if (!is.null(value) && !isstring(value))
    stop("value should be length 1 character vector or NULL.")
  dp_property(x, "format") <- value
  x
}

# ==============================================================================
# MEDIATYPE
# Optional; string

#' @export
#' @rdname properties_dataresource
dp_mediatype <- function(x, ...) {
  UseMethod("dp_mediatype")
}

#' @export
#' @rdname properties_dataresource
`dp_mediatype<-` <- function(x, value) {
  UseMethod("dp_mediatype<-")
}

#' @export
#' @rdname properties_dataresource
dp_mediatype.dataresource <- function(x, ...) {
  dp_property(x, "mediatype")
}

#' @export
#' @rdname properties_dataresource
`dp_mediatype<-.dataresource` <- function(x, value) {
  if (!is.null(value) && !isstring(value))
    stop("value should be length 1 character vector or NULL.")
  dp_property(x, "mediatype") <- value
  x
}

# ==============================================================================
# ENCODING
# Optional; string

#' @export
#' @rdname properties_dataresource
dp_encoding <- function(x, default = FALSE, ...) {
  UseMethod("dp_encoding")
}

#' @export
#' @rdname properties_dataresource
`dp_encoding<-` <- function(x, value) {
  UseMethod("dp_encoding<-")
}

#' @export
#' @rdname properties_dataresource
dp_encoding.dataresource <- function(x, default = FALSE, ...) {
  res <- dp_property(x, "encoding")
  if (is.null(res) && default) res <- "UTF-8"
  res
}

#' @export
#' @rdname properties_dataresource
`dp_encoding<-.dataresource` <- function(x, value) {
  if (!is.null(value) && !isstring(value))
    stop("value should be length 1 character vector or NULL.")
  dp_property(x, "encoding") <- value
  x
}

# ==============================================================================
# BYTES
# Optional; integer

#' @export
#' @rdname properties_dataresource
dp_bytes <- function(x, ...) {
  UseMethod("dp_bytes")
}

#' @export
#' @rdname properties_dataresource
`dp_bytes<-` <- function(x, value) {
  UseMethod("dp_bytes<-")
}

#' @export
#' @rdname properties_dataresource
dp_bytes.dataresource <- function(x, ...) {
  dp_property(x, "bytes")
}

#' @export
#' @rdname properties_dataresource
`dp_bytes<-.dataresource` <- function(x, value) {
  if (!is.null(value) && !isinteger(value))
    stop("value should be length 1 integer vector or NULL.")
  dp_property(x, "bytes") <- value
  x
}

# ==============================================================================
# HASH
# Optional; string

#' @export
#' @rdname properties_dataresource
dp_hash <- function(x, ...) {
  UseMethod("dp_hash")
}

#' @export
#' @rdname properties_dataresource
`dp_hash<-` <- function(x, value) {
  UseMethod("dp_hash<-")
}

#' @export
#' @rdname properties_dataresource
dp_hash.dataresource <- function(x, ...) {
  dp_property(x, "hash")
}

#' @export
#' @rdname properties_dataresource
`dp_hash<-.dataresource` <- function(x, value) {
  if (!is.null(value) && !isstring(value))
    stop("value should be length 1 character vector or NULL.")
  dp_property(x, "hash") <- value
  x
}


# TODO:
# - sources
# - licences

