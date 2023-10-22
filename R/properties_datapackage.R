
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
#' See \code{\link{dpresource}} for methods for getting and setting the resources
#' of a Data Package.
#' 
#' @return
#' Either returns the property or modifies the object.
#'
#' @export
#' @rdname properties_datapackage
dpname <- function(x) {
  UseMethod("dpname")
}

#' @export
#' @rdname properties_datapackage
dpname.datapackage <- function(x) {
  # Name is optional for data package
  dpproperty(x, "name")
}

#' @export
#' @rdname properties_datapackage
`dpname<-` <- function(x, value) {
  UseMethod("dpname<-")
}

#' @export
#' @rdname properties_datapackage
`dpname<-.datapackage` <- function(x, value) {
  value <- paste0(value)
  if (!is.null(value) && !isname(value)) stop("name should consists only of ", 
    "lower case letters, numbers, '-', '.' or '_' or NULL.")
  dpproperty(x, "name") <- value
  x
}

# ==============================================================================
# TITLE
# Optional; string

#' @export
#' @rdname properties_datapackage
dptitle <- function(x) {
  UseMethod("dptitle")
}

#' @export
#' @rdname properties_datapackage
dptitle.datapackage <- function(x) {
  dpproperty(x, "title")
}

#' @export
#' @rdname properties_datapackage
`dptitle<-` <- function(x, value) {
  UseMethod("dptitle<-")
}

#' @export
#' @rdname properties_datapackage
`dptitle<-.datapackage` <- function(x, value) {
  value <- paste0(value)
  if (!is.null(value) && !isstring(value)) 
    stop("value should be a character of length 1 or NULL.")
  dpproperty(x, "title") <- value
  x
}

# ==============================================================================
# DESCRIPTION
# Optional; string

#' @export
#' @rdname properties_datapackage
dpdescription <- function(x, ..., firstparagraph = FALSE, dots = FALSE) {
  UseMethod("dpdescription")
}

#' @param firstparagraph Only return the first paragraph of the description.
#' 
#' @param dots When returning only the first paragraph indicate missing
#' paragraphs with \code{...}.
#'
#' @export
#' @rdname properties_datapackage
dpdescription.datapackage <- function(x, ..., firstparagraph = FALSE, 
    dots = FALSE) {
  res <- dpproperty(x, "description")
  if (!is.null(res) && firstparagraph) getfirstparagraph(res, dots) else res
}

#' @export
#' @rdname properties_datapackage
`dpdescription<-` <- function(x, value) {
  UseMethod("dpdescription<-")
}

#' @export
#' @rdname properties_datapackage
`dpdescription<-.datapackage` <- function(x, value) {
  if (!is.null(value)) value <- paste0(value, collapse = "\n")
  # Because of the paste0 above value will always be a string
  dpproperty(x, "description") <- value
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
  dpproperty(x, "keywords")
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
  dpproperty(x, "keywords") <- value
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
  dpproperty(x, "created")
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
  dpproperty(x, "created") <- value
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
  dpproperty(x, "id")
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
  dpproperty(x, "id") <- value
  x
}

