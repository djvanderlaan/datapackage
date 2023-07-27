
# ==============================================================================
# GENERAL ATTRIBUTES
dpattr <- function(x, attribute) {
  UseMethod("dpattr")
}
dpattr.datapackage <- function(x, attribute) {
  x[[attribute]]
}
dpattr.dataresource <- function(x, attribute) {
  x[[attribute]]
}
`dpattr<-` <- function(x, attribute, value) {
  UseMethod("dpattr<-")
}
`dpattr<-.datapackage` <- function(x, attribute, value) {
  x[[attribute]] <- value
  x
}
`dpattr<-.dataresource` <- function(x, attribute, value) {
  x[[attribute]] <- value
  x
}

# ==============================================================================
# NAME
dpname <- function(x) {
  UseMethod("dpname")
}
dpname.datapackage <- function(x) {
  # Name is optional for data package
  x[["name"]]
}
dpname.dataresource <- function(x) {
  # Name is optional for data resource
  x[["name"]]
}

`dpname<-` <- function(x, value) {
  UseMethod("dpname<-")
}
`dpname<-.datapackage` <- function(x, value) {
  value <- paste0(value)
  if (!isname(value)) stop("name should consists only of lower case letters, ",
      "numbers, '-', '.' or '_'.")
  x[["name"]] <- value
  x
}
`dpname<-.dataresource` <- function(x, value) {
  value <- paste0(value)
  if (!isname(value)) stop("name should consists only of lower case letters, ",
      "numbers, '-', '.' or '_'.")
  x[["name"]] <- value
  x
}

# ==============================================================================
# TITLE
dptitle <- function(x) {
  UseMethod("dptitle")
}
dptitle.datapackage <- function(x) {
  # Title is optional for data package
  x[["title"]]
}
dptitle.dataresource <- function(x) {
  # Title is optional for data resource
  x[["title"]]
}

`dptitle<-` <- function(x, value) {
  UseMethod("dptitle<-")
}
`dptitle<-.datapackage` <- function(x, value) {
  value <- paste0(value)
  if (!isstring(value)) stop("value should be a character of length 1.")
  x[["title"]] <- value
  x
}
`dptitle<-.dataresource` <- function(x, value) {
  value <- paste0(value)
  if (!isstring(value)) stop("value should be a character of length 1.")
  x[["title"]] <- value
  x
}

# ==============================================================================
# DESCRIPTION
description <- function(x, firstparagraph = FALSE, dots = FALSE) {
  UseMethod("description")
}
description.datapackage <- function(x, firstparagraph = FALSE, dots = FALSE) {
  # Description is optional for data package
  res <- x[["description"]]
  if (!is.null(res) && firstparagraph) getfirstparagraph(res, dots) else res
}
description.dataresource <- function(x, firstparagraph = FALSE, dots = FALSE) {
  # Description is optional for data resource
  x[["description"]]
  if (!is.null(res) && firstparagraph) getfirstparagraph(res, dots) else res
}

`description<-` <- function(x, value) {
  UseMethod("description<-")
}
`description<-.datapackage` <- function(x, value) {
  value <- paste0(value, collapse = "\n")
  # Because of the paste0 above value will always be a string
  x[["description"]] <- value
  x
}
`description<-.dataresource` <- function(x, value) {
  value <- paste0(value, collapse = "\n")
  # Because of the paste0 above value will always be a string
  x[["description"]] <- value
  x
}

