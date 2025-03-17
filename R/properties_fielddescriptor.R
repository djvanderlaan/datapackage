
# ==============================================================================
# NAME
# Required; string; onl lower case alnum and _/-/.

#' Getting and setting properties of Data Resources
#'
#' @param x a \code{fielddescriptor} object.
#' 
#' @param value the new value of the property.
#'
#' @param ... used to pass additional arguments to other methods.
#'
#' @return
#' Either returns the property or modifies the object. If the property is not
#' set \code{NULL} is returned (unless \code{default = TRUE}).
#'
#' @seealso
#' See \link{PropertiesDatapackage} and \link{PropertiesDataresource} for methods
#' for Data Packages and Data Resources respectively. Also see
#' \code{\link{dp_property}} for a generic method for getting and setting
#' properties. These functions can also be used to get and set 'unofficial'
#' properties'
#' 
#' @export
#' @name PropertiesFielddescriptor
#' @rdname properties_fielddescriptor
dp_name.fielddescriptor <- function(x) {
  res <- dp_property(x, "name")
  # Name is required for data resource
  if (is.null(res))
    stop("Required attribute 'name' is missing from Field Descriptor.")
  res
}

#' @export
#' @rdname properties_dataresource
`dp_name<-.fielddescriptor` <- function(x, value) {
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
#' @rdname properties_fielddescriptor
dp_title.fielddescriptor <- function(x) {
  dp_property(x, "title")
}

#' @export
#' @rdname properties_dataresource
`dp_title<-.fielddescriptor` <- function(x, value) {
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
dp_description.fielddescriptor <- function(x, ..., first_paragraph = FALSE, 
    dots = FALSE) {
  res <- dp_property(x, "description")
  if (!is.null(res) && first_paragraph) getfirstparagraph(res, dots) else res
}

#' @export
#' @rdname properties_fielddescriptor
`dp_description<-.fielddescriptor` <- function(x, value) {
  if (!is.null(value)) {
    value <- paste0(value, collapse = "\n")
    # Because of the paste0 above value will always be a string
  }
  dp_property(x, "description") <- value
  x
}


# ==============================================================================
# FORMAT
# Optional; string

#' @export
#' @rdname properties_fielddescriptor
dp_format.fielddescriptor <- function(x, ...) {
  dp_property(x, "format")
}

#' @export
#' @rdname properties_dataresource
`dp_format<-.fielddescriptor` <- function(x, value) {
  if (!is.null(value)) {
    if (!is.character(value) && length(value) == 1)
      stop("format should be a character of length 1.")
    # TODO: accepted values depend on type
  }
  dp_property(x, "format") <- value
  x
}


# ==============================================================================
# TYPE
# Required; string; onl lower case alnum and _/-/.

#' @export
#' @rdname properties_fielddescriptor
dp_type <- function(x) {
  UseMethod("dp_type")
}

#' @export
#' @rdname properties_fielddescriptor
`dp_type<-` <- function(x, value) {
  UseMethod("dp_type<-")
}

#' @export
#' @name PropertiesFielddescriptor
#' @rdname properties_fielddescriptor
dp_type.fielddescriptor <- function(x) {
  res <- dp_property(x, "type")
  # Name is required for field descriptor
  if (is.null(res))
    stop("Required attribute 'type' is missing from Field Descriptor.")
  res
}

#' @export
#' @rdname properties_dataresource
`dp_type<-.fielddescriptor` <- function(x, value) {
  value <- paste0(value)
  supported <- c("boolean", "date", "datetime", "integer", "number", 
    "string", "time", "year", "yearmonth")
  official <- c(supported, "object", "array", "list", "duration", "geopoint",
    "geojson", "any")
  if (!(value %in% official)) {
    stop("'", value, "' is not an officially supported field type.")
  } else if (!(value %in% supported)) {
    warning("'", value, "' is not supported by the datapackage R-package.")
  }
  dp_property(x, "type") <- value
  x
}

