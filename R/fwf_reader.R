#' Read the FWF-data for a Data Resource
#' 
#' @param path path to the data set. 
#' 
#' @param resource a Data Resource.
#'
#' @param convert_categories how to handle columns for which the field
#'   descriptor has a \code{categories} property. Passed on to
#'   \code{\link{dp_apply_schema}}.
#'
#' @param ... additional arguments are passed on to \code{\link{dp_apply_schema}}.
#'
#' @seealso
#' Generally used by calling \code{\link{dp_get_data}}.
#'
#' @return
#' Returns a \code{data.frame} with the data.
#'
#' @export
fwf_reader <- function(path, resource, convert_categories = c("no", "to_factor"), ...) {
  # Read fwfspec
  fwfspec <- dp_property(resource, "fwfspec")
  if (is.null(fwfspec)) stop("Required fwfspec is missing from resource meta.")
  lengths <- sapply(fwfspec, \(x) x$length)
  names   <- sapply(fwfspec, \(x) x$name)
  # Get schema
  schema  <- dp_schema(resource)
  # 
  dec <- "."
  column_types <- rep("string", length(lengths))
  if (!is.null(schema)) {
    # Determine decimalChar
    dec <- determine_decimalchar(schema$fields)
    # Determine column types; for that we need dec as numeric
    # columns with another decimalChar than dec have to be
    # read as character
    column_types <- sapply(schema$fields, function(x, dec) {
        if (x$type == "integer") {
          "integer"
        } else if (x$type == "number") {
          decimalChar <- if (exists("decimalChar", x)) x$decimalChar else "."
          if (dec == decimalChar) "double" else "string"
        } else {
          "string"
        }
      }, dec = dec)
  }
  # Read data
  if (!requireNamespace("LaF"))
    stop("The package LaF is needed to read fixed width files.")
  con <- LaF::laf_open_fwf(path, column_types = column_types, 
    column_names = names, column_widths = lengths)
  #on.exit(close(con))
  dta <- con[,]
  # handle encoding
  encoding <- dp_property(resource, "encoding") |> tolower()
  if (is.null(encoding)) encoding <- "latin1"
  if (encoding == "utf-8") encoding <- "UTF-8"
  if (encoding == "latin-1") encoding <- "latin1"
  if (encoding == "cp1252" || encoding == "cp-1252" || encoding == "windows-1252") {
    warning("Encoding CP-1252 not supported. Using latin1, which is often ", 
      "the same. See ?Encoding.")
    encoding <- "latin1"
  }
  if (!encoding %in% c("latin1", "UTF-8", "bytes")) warning("Unsupported encoding '", 
    encoding, "'. Ignoring. See ?Encoding.")
  for (col in names(dta)) 
    if (is.character(dta[[col]])) Encoding(dta[[col]]) <- encoding
  # apply schema
  if (!is.null(schema)) {
    dta <- dp_apply_schema(dta, resource, convert_categories = convert_categories, 
      decimalChar = dec, ...)
  }
  structure(dta, resource = resource)
}



# === UTILITY FUNCTIONS

determine_decimalchar <- function(fields, default = ".") {
  if (is.null(fields)) return(default)
  dec <- sapply(fields, function(x, default = default) {
      if (x$type == "number") {
        if (exists("decimalChar", x)) x$decimalChar else default
      } else character(0)
    }, default = default) |> Reduce(f = c) |> unique() 
  if (length(dec) >= 1) dec[1] else default
}

