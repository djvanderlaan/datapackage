#' Get the data belonging to a Data Resource
#'
#' @param x a \code{dataresource} or \code{datapackage} object.
#'
#' @param resourcename the name of the \code{dataresource}.
#'
#' @param reader the reader to use to read the data. This should be either a
#' function accepting the path to the data set (a character vector with possibly
#' multitple filenames) and the Data Resource as second argument, or the
#' character string \code{"guess"}.
#'
#' @param ... passed on to the \code{reader}
#'
#' @param as_connection Try to return a connection to the data instead of the
#' data itself. When a reader does not support returning connections it will
#' return the data.
#'
#' @details
#' When \code{reader = "guess"} the function will try to guess which reader to
#' use based on the \code{format} and \code{mediatype} of the Data Resource.
#' Currently only CSV is supported. For other data types a custom reader has to
#' be provided unless the data is stored inside the Data Resource object.
#'
#' It is also possible to assign default readers for data formats. For that see
#' \code{\link{dpaddreader}}.
#'
#' @seealso
#' \code{dpgetconnection} is a wrapper around 
#' \code{dpgetdata(..., as_connection = TRUE)}. 
#'
#' @return
#' Will return the data. This will generally be a \code{data.frame} but
#' depending on the file type can also be other types of R-objects. 
#'
#' When called with the \code{as_connection = TRUE} argument, it will try to
#' return a connection to the data. This depends on the reader. When the reader
#' does not support returning connections it will return the data.
#
#' @rdname dpgetdata
#' @export
dpgetdata <- function(x, ..., as_connection = FALSE) {
  UseMethod("dpgetdata")
}

#' @rdname dpgetdata
#' @export
dpgetdata.dataresource <- function(x, reader = "guess", ..., as_connection = FALSE) {
  # Check if resource includes data; ifso return that
  d <- dpproperty(x, "data")
  if (!is.null(d)) {
    # Try to transoform to data.frame 
    df <- d |> jsonlite::toJSON(auto_unbox = TRUE) |> jsonlite::fromJSON(simplifyVector = TRUE)
    if (is.data.frame(df)) df else d
  } else {
    # Determine path to data
    filename <- dppath(x, fullpath = TRUE)
    # Determine reader
    if (is.character(reader) && reader[1] == "guess") 
      reader <- guessreader(dpformat(x), dpmediatype(x), dppath(x))
    stopifnot(is.function(reader))
    # Read
    reader(filename, x, ..., as_connection = as_connection)
  }
}

#' @rdname dpgetdata
#' @export
dpgetdata.datapackage <- function(x, resourcename, reader = "guess", ..., as_connection = FALSE) {
  resource <- dpresource(x, resourcename)
  if (is.null(resource)) stop("Resource '", resourcename, "' not found.")
  dpgetdata(resource, reader = reader, ..., as_connection = as_connection)
}

