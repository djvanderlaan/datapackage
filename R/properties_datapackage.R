
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

#' Getting and setting properties of Data Packages
#'
#' @param x a \code{datapackage} object.
#' 
#' @param value the new value of the property.
#'
#' @param ... used to pass additional arguments to other methods.
#'
#' @seealso
#' See \code{\link{dp_resource}} for methods for getting and setting the resources
#' of a Data Package.
#' 
#' @return
#' Either returns the property or modifies the object.
#'
#' @export
#' @rdname properties_datapackage
dp_name <- function(x) {
  UseMethod("dp_name")
}

#' @export
#' @rdname properties_datapackage
dp_name.datapackage <- function(x) {
  # Name is optional for data package
  dp_property(x, "name")
}

#' @export
#' @rdname properties_datapackage
`dp_name<-` <- function(x, value) {
  UseMethod("dp_name<-")
}

#' @export
#' @rdname properties_datapackage
`dp_name<-.datapackage` <- function(x, value) {
  value <- paste0(value)
  if (!is.null(value) && !isname(value)) stop("name should consists only of ", 
    "lower case letters, numbers, '-', '.' or '_' or NULL.")
  dp_property(x, "name") <- value
  x
}

# ==============================================================================
# TITLE
# Optional; string

#' @export
#' @rdname properties_datapackage
dp_title <- function(x) {
  UseMethod("dp_title")
}

#' @export
#' @rdname properties_datapackage
dp_title.datapackage <- function(x) {
  dp_property(x, "title")
}

#' @export
#' @rdname properties_datapackage
`dp_title<-` <- function(x, value) {
  UseMethod("dp_title<-")
}

#' @export
#' @rdname properties_datapackage
`dp_title<-.datapackage` <- function(x, value) {
  value <- paste0(value)
  if (!is.null(value) && !isstring(value)) 
    stop("value should be a character of length 1 or NULL.")
  dp_property(x, "title") <- value
  x
}

# ==============================================================================
# DESCRIPTION
# Optional; string

#' @export
#' @rdname properties_datapackage
dp_description <- function(x, ..., firstparagraph = FALSE, dots = FALSE) {
  UseMethod("dp_description")
}

#' @param firstparagraph Only return the first paragraph of the description.
#' 
#' @param dots When returning only the first paragraph indicate missing
#' paragraphs with \code{...}.
#'
#' @export
#' @rdname properties_datapackage
dp_description.datapackage <- function(x, ..., firstparagraph = FALSE, 
    dots = FALSE) {
  res <- dp_property(x, "description")
  if (!is.null(res) && firstparagraph) getfirstparagraph(res, dots) else res
}

#' @export
#' @rdname properties_datapackage
`dp_description<-` <- function(x, value) {
  UseMethod("dp_description<-")
}

#' @export
#' @rdname properties_datapackage
`dp_description<-.datapackage` <- function(x, value) {
  if (!is.null(value)) value <- paste0(value, collapse = "\n")
  # Because of the paste0 above value will always be a string
  dp_property(x, "description") <- value
  x
}


# ==============================================================================
# KEYWORDS
# Optional; array[string]

#' @export
#' @rdname properties_datapackage
dpkeywords <- function(x, ...) {
  UseMethod("dpkeywords")
}

#' @export
#' @rdname properties_datapackage
dpkeywords.datapackage <- function(x, ...) {
  dp_property(x, "keywords")
}

#' @export
#' @rdname properties_datapackage
`dpkeywords<-` <- function(x, value) {
  UseMethod("dpkeywords<-")
}

#' @export
#' @rdname properties_datapackage
`dpkeywords<-.datapackage` <- function(x, value) {
  if (!is.null(value) && !is.character(value)) 
    stop("value should be a character vector")
  dp_property(x, "keywords") <- value
  x
}

# ==============================================================================
# CREATED
# Optional; date

#' @export
#' @rdname properties_datapackage
dpcreated <- function(x, ...) {
  UseMethod("dpcreated")
}

#' @export
#' @rdname properties_datapackage
dpcreated.datapackage <- function(x, ...) {
  dp_property(x, "created")
}

#' @export
#' @rdname properties_datapackage
`dpcreated<-` <- function(x, value) {
  UseMethod("dpcreated<-")
}

#' @export
#' @rdname properties_datapackage
`dpcreated<-.datapackage` <- function(x, value) {
  if (!is.null(value) && !(methods::is(value, "Date") && length(value) == 1) )
    stop("value should be a Date vector of length 1.")
  dp_property(x, "created") <- value
  x
}

# ==============================================================================
# ID
# Optional; string

#' @export
#' @rdname properties_datapackage
dpid <- function(x, ...) {
  UseMethod("dpid")
}

#' @export
#' @rdname properties_datapackage
dpid.datapackage <- function(x, ...) {
  dp_property(x, "id")
}

#' @export
#' @rdname properties_datapackage
`dpid<-` <- function(x, value) {
  UseMethod("dpid<-")
}

#' @export
#' @rdname properties_datapackage
`dpid<-.datapackage` <- function(x, value) {
  if (!is.null(value) && !(isname(value)))
    stop("value should be a character vector of length 1.")
  dp_property(x, "id") <- value
  x
}

