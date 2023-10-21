
#' Read the CSV-data for a Data Resource
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
csv_reader <- function(path, resource) {
  schema <- dpschema(resource)
  # TODO: do something with the CSV-description
  # TODO: merge csv_read and csv_reader
  if (is.null(schema)) {
    dta <- lapply(path, utils::read.csv)
  } else {
    # Read
    dta <- lapply(path, csv_read, schema = schema)
  }
  dta <- do.call(rbind, dta)
  structure(dta, resource = resource)
}




# Wrapper around read.table and data.table::fread that accepts options are
# present in csv dialect specification 
# (https://specs.frictionlessdata.io/csv-dialect/#specification). Not all
# options from the dialect specification are supported; the function wil; then
# either generate a warning or error. 
#
# From Spec: delimiter, lineTerminator, quoteChar, doubleQuote, excapeChar, 
# skipInitialSpace, header, commentChar, caseSensitiveHeader, nullSequence
csv_read_base <- function(filename, 
    delimiter = ",", decimalChar = ".",
    quoteChar = "\"", doubleQuote = TRUE, 
    commentChar  = "", lineTerminator = "\r\n", 
    header = TRUE, caseSensitiveHeader = FALSE, nullSequence = character(0),
    skipInitialSpace = FALSE, colClasses = character(), 
    na.strings = character(0), use_fread = FALSE, csv_dialect, ...) {
  # Handle input of the arguments through a named list
  if (!missing(csv_dialect)) {
    stopifnot(is.list(csv_dialect))
    keep <- c("delimiter", "lineTerminator", "quoteChar", "doubleQuote", 
      "skipInitialSpace", "header", "commentChar", 
      "caseSensitiveHeader", "nullSequence")
    csv_dialect <- csv_dialect[names(csv_dialect) %in% keep]
    if (!missing(delimiter)) csv_dialect$delimiter <- delimiter
    if (!missing(lineTerminator)) csv_dialect$lineTerminator <- lineTerminator
    if (!missing(quoteChar)) csv_dialect$quoteChar <- quoteChar
    if (!missing(doubleQuote)) csv_dialect$doubleQuote <- doubleQuote
    if (!missing(skipInitialSpace)) csv_dialect$skipInitialSpace <- skipInitialSpace
    if (!missing(header)) csv_dialect$header <- header
    if (!missing(commentChar)) csv_dialect$commentChar <- commentChar
    if (!missing(caseSensitiveHeader)) csv_dialect$caseSensitiveHeader <- caseSensitiveHeader
    if (!missing(nullSequence)) csv_dialect$nullSequence <- nullSequence
    args <- c(csv_dialect, filename = filename, colClasses = colClasses, na.strings = na.strings,
      use_fread = use_fread, ...)
    return(do.call(csv_read_base, args))
  }
  # Check and process aguments
  stopifnot(is.character(filename))
  stopifnot(is.character(delimiter), length(delimiter) == 1, nchar(delimiter) == 1)
  stopifnot(is.character(decimalChar), length(decimalChar) == 1, nchar(decimalChar) == 1)
  stopifnot(is.character(quoteChar), length(quoteChar) == 1)
  stopifnot(length(doubleQuote) == 1)
  if (!doubleQuote) stop("Values other than TRUE for doubleQuote are not supported.")
  stopifnot(is.logical(header), length(header) == 1)
  stopifnot(is.character(commentChar), length(commentChar) == 1, nchar(commentChar) <= 1)
  if (use_fread && commentChar != "") 
    stop('Values other than "" for commentChar are not supported.')
  stopifnot(is.character(lineTerminator), length(lineTerminator) == 1)
  if (!(lineTerminator %in% c("\n", "\r", "\r\n")))
    stop("Values other than '\\n', '\\r' or '\\r\\n' for lineTerminator are not supported.")
  stopifnot(is.logical(caseSensitiveHeader), length(caseSensitiveHeader) == 1)
  if (!missing(caseSensitiveHeader) && header) 
    warning("The value for caseSentitiveHeader is ignored as header=FALSE.")
  stopifnot(is.character(nullSequence), length(nullSequence) <= 1)
  if (length(nullSequence) > 0)
    stop("Specifying nullSequence is not supported.")
  stopifnot(is.logical(skipInitialSpace), length(skipInitialSpace) == 1)
  # Read data
  if (use_fread) {
    if (!requireNamespace("data.table")) stop("In order to use ", 
        "'use_fread=TRUE' the data.table package needs to be installed.")
    lapply(filename, function(fn) {
      d <- data.table::fread(filename, sep = delimiter, quote = quoteChar, 
        dec = decimalChar, header = header, 
        strip.white = skipInitialSpace, stringsAsFactors = FALSE, 
        colClasses = colClasses, na.strings = na.strings, ...)
      if (!caseSensitiveHeader) names(d) <- tolower(names(d))
      d
    }) |> data.table::rbindlist()
  } else {
    dta <- lapply(filename, function(fn) {
      d <- read.table(filename, sep = delimiter, quote = quoteChar, 
        dec = decimalChar, header = header, comment.char = commentChar, 
        strip.white = skipInitialSpace, stringsAsFactors = FALSE, 
        colClasses = colClasses, na.strings = na.strings, ...)
      if (!caseSensitiveHeader) names(d) <- tolower(names(d))
      d
    })
    if (length(dta) > 1) do.call(rbind, dta) else dta[[1]]
  }
}

