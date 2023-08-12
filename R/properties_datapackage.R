
# + (in resource.R) resources
# + id (should)
# licenses (should) (object must name and/or path, may title)
# profile (should)
# + (in contributors.R) contributors (name (should), email, path, role, organisation)
# + keywords (array[string])
# +created (date)

# ==============================================================================
# NAME
# Optional (should); string; onl lower case alnum and _/-/.

#' @export
#' @rdname properties_datapackage
name <- function(x) {
  UseMethod("name")
}

#' @export
#' @rdname properties_datapackage
name.datapackage <- function(x) {
  # Name is optional for data package
  property(x, "name")
}

#' @export
#' @rdname properties_datapackage
`name<-` <- function(x, value) {
  UseMethod("name<-")
}

#' @export
#' @rdname properties_datapackage
`name<-.datapackage` <- function(x, value) {
  value <- paste0(value)
  if (!is.null(value) && !isname(value)) stop("name should consists only of ", 
    "lower case letters, numbers, '-', '.' or '_' or NULL.")
  property(x, "name") <- value
  x
}

# ==============================================================================
# TITLE
# Optional; string

#' @export
#' @rdname properties_datapackage
title <- function(x) {
  UseMethod("title")
}

#' @export
#' @rdname properties_datapackage
title.datapackage <- function(x) {
  property(x, "title")
}

#' @export
#' @rdname properties_datapackage
`title<-` <- function(x, value) {
  UseMethod("title<-")
}

#' @export
#' @rdname properties_datapackage
`title<-.datapackage` <- function(x, value) {
  value <- paste0(value)
  if (!is.null(value) && !isstring(value)) 
    stop("value should be a character of length 1 or NULL.")
  property(x, "title") <- value
  x
}

# ==============================================================================
# DESCRIPTION
# Optional; string

#' @export
#' @rdname properties_datapackage
description <- function(x, ..., firstparagraph = FALSE, dots = FALSE) {
  UseMethod("description")
}

#' @export
#' @rdname properties_datapackage
description.datapackage <- function(x, ..., firstparagraph = FALSE, 
    dots = FALSE) {
  res <- property(x, "description")
  if (!is.null(res) && firstparagraph) getfirstparagraph(res, dots) else res
}

#' @export
#' @rdname properties_datapackage
`description<-` <- function(x, value) {
  UseMethod("description<-")
}

#' @export
#' @rdname properties_datapackage
`description<-.datapackage` <- function(x, value) {
  if (!is.null(value)) value <- paste0(value, collapse = "\n")
  # Because of the paste0 above value will always be a string
  property(x, "description") <- value
  x
}


# ==============================================================================
# KEYWORDS
# Optional; array[string]

#' @export
#' @rdname properties_datapackage
keywords <- function(x, ...) {
  UseMethod("keywords")
}

#' @export
#' @rdname properties_datapackage
keywords.datapackage <- function(x, ...) {
  property(x, "keywords")
}

#' @export
#' @rdname properties_datapackage
`keywords<-` <- function(x, value) {
  UseMethod("keywords<-")
}

#' @export
#' @rdname properties_datapackage
`keywords<-.datapackage` <- function(x, value) {
  if (!is.null(value) && !is.character(value)) 
    stop("value should be a character vector")
  property(x, "keywords") <- value
  x
}

# ==============================================================================
# CREATED
# Optional; date

#' @export
#' @rdname properties_datapackage
created <- function(x, ...) {
  UseMethod("created")
}

#' @export
#' @rdname properties_datapackage
created.datapackage <- function(x, ...) {
  property(x, "created")
}

#' @export
#' @rdname properties_datapackage
`created<-` <- function(x, value) {
  UseMethod("created<-")
}

#' @export
#' @rdname properties_datapackage
`created<-.datapackage` <- function(x, value) {
  if (!is.null(value) && !(is(value, "Date") && length(value) == 1) )
    stop("value should be a Date vector of length 1.")
  property(x, "created") <- value
  x
}

# ==============================================================================
# ID
# Optional; string

#' @export
#' @rdname properties_datapackage
id <- function(x, ...) {
  UseMethod("id")
}

#' @export
#' @rdname properties_datapackage
id.datapackage <- function(x, ...) {
  property(x, "id")
}

#' @export
#' @rdname properties_datapackage
`id<-` <- function(x, value) {
  UseMethod("id<-")
}

#' @export
#' @rdname properties_datapackage
`id<-.datapackage` <- function(x, value) {
  if (!is.null(value) && !(isname(value)))
    stop("value should be a character vector of length 1.")
  property(x, "id") <- value
  x
}

