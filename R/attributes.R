


# ==============================================================================
# NAME
name <- function(x) {
  UseMethod("name")
}
name.datapackage <- function(x) {
  # Name is optional for data package
  x[["name"]]
}
name.resource <- function(x) {
  # Name is optional for data resource
  x[["name"]]
}

`name<-` <- function(x, value) {
  UseMethod("name<-")
}
`name<-.datapackage` <- function(x, value) {
  value <- paste0(value)
  if (!is.character(value) || length(value) != 1)
    stop("value should be a character of length 1.")
  if (!grepl("^[a-z0-9_.-]+$", value))
    stop("name should consists only of lower case letters, ",
      "numbers, '-', '.' or '_'.")
  x[["name"]] <- value
  x
}
`name<-.resource` <- function(x, value) {
  value <- paste0(value)
  if (!is.character(value) || length(value) != 1)
    stop("value should be a character of length 1.")
  if (!grepl("^[a-z0-9_.-]+$", value))
    stop("name should consists only of lower case letters, ",
      "numbers, '-', '.' or '_'.")
  x[["name"]] <- value
  x
}

# ==============================================================================
# TITLE
title <- function(x) {
  UseMethod("title")
}
title.datapackage <- function(x) {
  # Title is optional for data package
  x[["title"]]
}
title.resource <- function(x) {
  # Title is optional for data resource
  x[["title"]]
}

`title<-` <- function(x, value) {
  UseMethod("title<-")
}
`title<-.datapackage` <- function(x, value) {
  value <- paste0(value)
  if (!is.character(value) || length(value) != 1)
    stop("value should be a character of length 1.")
  x[["title"]] <- value
  x
}
`title<-.resource` <- function(x, value) {
  value <- paste0(value)
  if (!is.character(value) || length(value) != 1)
    stop("value should be a character of length 1.")
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
description.resource <- function(x, firstparagraph = FALSE, dots = FALSE) {
  # Description is optional for data resource
  x[["description"]]
  if (!is.null(res) && firstparagraph) getfirstparagraph(res, dots) else res
}

`description<-` <- function(x, value) {
  UseMethod("description<-")
}
`description<-.datapackage` <- function(x, value) {
  value <- paste0(value, collapse = "\n")
  x[["description"]] <- value
  x
}
`description<-.resource` <- function(x, value) {
  value <- paste0(value)
  x[["description"]] <- value
  x
}

