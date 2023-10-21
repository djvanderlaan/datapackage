
# Wrapper around read.table and data.table::fread that accepts options are
# present in csv dialect specification 
# (https://specs.frictionlessdata.io/csv-dialect/#specification). Not all
# options from the dialect specification are supported; the function wil; then
# either generate a warning or error. 
#
csv_read_base <- function(filename, 
    delimiter = ",", decimalChar = ".",
    quoteChar = "\"", doubleQuote = TRUE, 
    commentChar  = "", lineTerminator = "\r\n", 
    header = TRUE, caseSensitiveHeader = FALSE, 
    skipInitialSpace = FALSE, colClasses = character(), 
    na.strings = character(0), use_fread = FALSE, ...) {
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
    }) |> rbindlist()
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

