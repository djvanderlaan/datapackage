

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
dpname.dataresource <- function(x) {
  res <- dpproperty(x, "name")
  # Name is required for data resource
  if (is.null(res))
    stop("Required attribute 'name' is missing from Data Resource.")
  res
}

#' @export
#' @rdname properties_dataresource
`dpname<-.dataresource` <- function(x, value) {
  value <- paste0(value)
  if (!isname(value)) stop("name should consists only of lower case letters, ",
      "numbers, '-', '.' or '_'.")
  dpproperty(x, "name") <- value
  x
}

# ==============================================================================
# TITLE
# Optional; string

#' @export
#' @rdname properties_dataresource
dptitle.dataresource <- function(x) {
  dpproperty(x, "title")
}

#' @export
#' @rdname properties_dataresource
`dptitle<-.dataresource` <- function(x, value) {
  if (!is.null(value)) {
    value <- paste0(value)
    if (!isstring(value)) stop("value should be a character of length 1.")
  }
  dpproperty(x, "title") <- value
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
dpdescription.dataresource <- function(x, ..., firstparagraph = FALSE, 
    dots = FALSE) {
  res <- dpproperty(x, "description")
  if (!is.null(res) && firstparagraph) getfirstparagraph(res, dots) else res
}

#' @export
#' @rdname properties_dataresource
`dpdescription<-.dataresource` <- function(x, value) {
  if (!is.null(value)) {
    value <- paste0(value, collapse = "\n")
    # Because of the paste0 above value will always be a string
  }
  dpproperty(x, "description") <- value
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
dppath <- function(x, ...) {
  UseMethod("dppath")
}

#' @export
#' @rdname properties_dataresource
`dppath<-` <- function(x, value) {
  UseMethod("dppath<-")
}

#' @param fullpath Return the full path including the path to the Data Package
#' and not only the path relative to the Data Package. This is only relevant for
#' relative paths.
#' 
#' @export
#' @rdname properties_dataresource
dppath.dataresource <- function(x, fullpath = FALSE, ...) {
  # Determine path to data
  filename <- dpproperty(x, "path")
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
`dppath<-.dataresource` <- function(x, value) {
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
  dpproperty(x, "path") <- value
  x
}

# ==============================================================================
# FORMAT
# Optional; string

#' @export
#' @rdname properties_dataresource
dpformat <- function(x, ...) {
  UseMethod("dpformat")
}

#' @export
#' @rdname properties_dataresource
`dpformat<-` <- function(x, value) {
  UseMethod("dpformat<-")
}

#' @export
#' @rdname properties_dataresource
dpformat.dataresource <- function(x, default = FALSE, ...) {
  res <- dpproperty(x, "format")
  if (is.null(res) && default) {
    path <- dppath(x)
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
`dpformat<-.dataresource` <- function(x, value) {
  if (!is.null(value) && !isstring(value))
    stop("value should be length 1 character vector or NULL.")
  dpproperty(x, "format") <- value
  x
}

# ==============================================================================
# MEDIATYPE
# Optional; string

#' @export
#' @rdname properties_dataresource
dpmediatype <- function(x, ...) {
  UseMethod("dpmediatype")
}

#' @export
#' @rdname properties_dataresource
`dpmediatype<-` <- function(x, value) {
  UseMethod("dpmediatype<-")
}

#' @export
#' @rdname properties_dataresource
dpmediatype.dataresource <- function(x, ...) {
  dpproperty(x, "mediatype")
}

#' @export
#' @rdname properties_dataresource
`dpmediatype<-.dataresource` <- function(x, value) {
  if (!is.null(value) && !isstring(value))
    stop("value should be length 1 character vector or NULL.")
  dpproperty(x, "mediatype") <- value
  x
}

# ==============================================================================
# ENCODING
# Optional; string

#' @export
#' @rdname properties_dataresource
dpencoding <- function(x, default = FALSE, ...) {
  UseMethod("dpencoding")
}

#' @export
#' @rdname properties_dataresource
`dpencoding<-` <- function(x, value) {
  UseMethod("dpencoding<-")
}

#' @export
#' @rdname properties_dataresource
dpencoding.dataresource <- function(x, default = FALSE, ...) {
  res <- dpproperty(x, "encoding")
  if (is.null(res) && default) res <- "UTF-8"
  res
}

#' @export
#' @rdname properties_dataresource
`dpencoding<-.dataresource` <- function(x, value) {
  if (!is.null(value) && !isstring(value))
    stop("value should be length 1 character vector or NULL.")
  dpproperty(x, "encoding") <- value
  x
}

# ==============================================================================
# BYTES
# Optional; integer

#' @export
#' @rdname properties_dataresource
dpbytes <- function(x, ...) {
  UseMethod("dpbytes")
}

#' @export
#' @rdname properties_dataresource
`dpbytes<-` <- function(x, value) {
  UseMethod("dpbytes<-")
}

#' @export
#' @rdname properties_dataresource
dpbytes.dataresource <- function(x, ...) {
  dpproperty(x, "bytes")
}

#' @export
#' @rdname properties_dataresource
`dpbytes<-.dataresource` <- function(x, value) {
  if (!is.null(value) && !isinteger(value))
    stop("value should be length 1 integer vector or NULL.")
  dpproperty(x, "bytes") <- value
  x
}

# ==============================================================================
# HASH
# Optional; string

#' @export
#' @rdname properties_dataresource
dphash <- function(x, ...) {
  UseMethod("dphash")
}

#' @export
#' @rdname properties_dataresource
`dphash<-` <- function(x, value) {
  UseMethod("dphash<-")
}

#' @export
#' @rdname properties_dataresource
dphash.dataresource <- function(x, ...) {
  dpproperty(x, "hash")
}

#' @export
#' @rdname properties_dataresource
`dphash<-.dataresource` <- function(x, value) {
  if (!is.null(value) && !isstring(value))
    stop("value should be length 1 character vector or NULL.")
  dpproperty(x, "hash") <- value
  x
}


# TODO:
# - sources
# - licences

