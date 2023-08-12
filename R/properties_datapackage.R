
# resources
# id (should)
# licenses (should) (object must name and/or path, may title)
# profile (should)
# (in contributors.R) contributors (name (should), email, path, role, organisation)
# keywords (array[string])
# created (date)

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
  if (!isname(value)) stop("name should consists only of lower case letters, ",
      "numbers, '-', '.' or '_'.")
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
  if (!isstring(value)) stop("value should be a character of length 1.")
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
  value <- paste0(value, collapse = "\n")
  # Because of the paste0 above value will always be a string
  property(x, "description") <- value
  x
}

# ==============================================================================
# RESOURCE (look up a single resource)


