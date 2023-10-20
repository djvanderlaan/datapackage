#' Read the FWF-data for a Data Resource
#' 
#' @param path path to the data set. 
#' 
#' @param resource a Data Resource.
#'
#' @seealso
#' Generally used by calling \code{\link{getdata}}.
#'
#' @return
#' Returns a \code{data.frame} with the data.
#'
#' @export
fwf_reader <- function(path, resource) {
  # Read fwfspec
  if (!exists("fwfspec", resource)) {
    stop("Required fwfspec is missing from resource meta.")
  }
  lengths <- sapply(resource$fwfspec, \(x) x$length)
  names   <- sapply(resource$fwfspec, \(x) x$name)
  # Determine decimalChar
  dec <- determine_decimalchar(resource$schema$fields)
  # Determine column types; for that we need dec as numeric
  # columns with another decimalChar than dec have to be
  # read as character
  column_types <- sapply(resource$schema$fields, function(x, dec) {
      if (x$type == "integer") {
        "integer"
      } else if (x$type == "number") {
        decimalChar <- if (exists("decimalChar", x)) x$decimalChar else "."
        if (dec == decimalChar) "double" else "string"
      } else {
        "string"
      }
    }, dec = dec)
  # Read data
  if (!requireNamespace("LaF"))
    stop("The package LaF is needed to read fixed width files.")
  con <- LaF::laf_open_fwf(path, column_types = column_types, 
    column_names = names, column_widths = lengths)
  #on.exit(close(con))
  dta <- con[,]
  # handle encoding
  encoding <- if (exists("encoding", resource)) resource$encoding else "latin1"
  if (encoding == "cp1252") {
    warning("Encoding CP-1252 not supported by R. Using latin1, which is often ", 
      "the same. See ?Encoding.")
    encoding <- "latin1"
  }
  if (!encoding %in% c("latin1", "UTF-8", "bytes")) warning("Unsupported encoding '", 
    encoding, "'. Ignoring. See ?Encoding.")
  for (col in names(dta)) 
    if (is.character(dta[[col]])) Encoding(dta[[col]]) <- encoding
  # apply schema
  dta <- convert_using_schema(dta, resource$schema, to_factor = TRUE, 
    decimalChar = dec)
  structure(dta, resource = resource)
}

determine_decimalchar <- function(fields, default = ".") {
  dec <- sapply(fields, function(x, default = default) {
      if (x$type == "number") {
        if (exists("decimalChar", x)) x$decimalChar else default
      } else character(0)
    }, default = default) |> Reduce(f = c) |> unique() 
  if (length(dec) >= 1) dec[1] else default
}

