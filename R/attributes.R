

dpattributes <- function(x) {
  UseMethod("dpattributes")
}
dpattributes.readonlydatapackage <- function(x) {
  names(x)
}
dpattributes.editabledatapackage <- function(x) {
  dp <- readdatapackage(x$path, x$filename)
  dpattributes(dp)
}
dpattributes.dataresource <- function(x) {
  names(x)
}

# ==============================================================================
# GENERAL ATTRIBUTES
dpattr <- function(x, attribute) {
  UseMethod("dpattr")
}
dpattr.readonlydatapackage <- function(x, attribute) {
  x[[attribute]]
}
dpattr.dataresource <- function(x, attribute) {
  x[[attribute]]
}
dpattr.editabledatapackage <- function(x, attribute) {
  dp <- readdatapackage(x$path, x$filename)
  dpattr(dp, attribute)
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
  dpattr(x, "name")
}
dpname.dataresource <- function(x) {
  # Name is optional for data resource
  dpattr(x, "name")
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
  dpattr(x, "title")
}
dptitle.dataresource <- function(x) {
  # Title is optional for data resource
  dpattr(x, "title")
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
dpdescription <- function(x, firstparagraph = FALSE, dots = FALSE) {
  UseMethod("description")
}
dpdescription.datapackage <- function(x, firstparagraph = FALSE, dots = FALSE) {
  # Description is optional for data package
  res <- dpattr(x, "description")
  if (!is.null(res) && firstparagraph) getfirstparagraph(res, dots) else res
}
dpdescription.dataresource <- function(x, firstparagraph = FALSE, dots = FALSE) {
  # Description is optional for data resource
  res <- dpattr(x, "description")
  if (!is.null(res) && firstparagraph) getfirstparagraph(res, dots) else res
}

`dpdescription<-` <- function(x, value) {
  UseMethod("description<-")
}
`dpdescription<-.datapackage` <- function(x, value) {
  value <- paste0(value, collapse = "\n")
  # Because of the paste0 above value will always be a string
  x[["description"]] <- value
  x
}
`dpdescription<-.dataresource` <- function(x, value) {
  value <- paste0(value, collapse = "\n")
  # Because of the paste0 above value will always be a string
  x[["description"]] <- value
  x
}

