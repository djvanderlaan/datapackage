
#' Read the CSV-data for a Data Resource
#' 
#' @param path path to the data set. 
#' 
#' @param resource a Data Resource.
#' @param use_fread use the \code{\link[data.table]{fread}} function instead of
#'   \code{\link[utils]{read.csv}} and return a \code{data.table}.
#' @param convert_categories how to handle columns for which the field
#'   descriptor has a \code{categories} property. Passed on to
#'   \code{\link{dp_apply_schema}}.
#' @param as_connection This argument is ignored. The function will always
#'   return a \code{data.frame}.
#' @param ... additional arguments are passed on to \code{\link{read.csv}} or
#'   \code{\link[data.table]{fread}}. Note that some arguments are already set
#'   by \code{csv_reader}, so not all arguments are available to use as 
#'   additional arguments.
#'
#' @seealso
#' Generally used by calling \code{\link{dp_get_data}}.
#'
#' @return
#' Returns a \code{data.frame} with the data.
#'
#' @export
csv_reader <- function(path, resource, use_fread = FALSE, 
    convert_categories = c("no", "to_factor"), as_connection = FALSE, ...) {
  schema <- dp_schema(resource)
  if (is.null(schema)) {
    dta <- csv_read_base(path, use_fread = use_fread, ...)
  } else {
    dialect <- dp_property(resource, "dialect")
    if (is.null(dialect)) dialect <- list()
    dec <- if (!is.null(dialect$decimalChar)) dialect$decimalChar else
      determine_decimalchar(schema$fields)
    colclasses <- sapply(schema$fields, csv_colclass, decimalChar = dec)
    # TODO: missing values/na.strings
    dta <- csv_read_base(path, decimalChar = dec, colClasses = colclasses, 
      use_fread = use_fread, csv_dialect = dialect, ...)
    dta <- dp_apply_schema(dta, resource, convert_categories = convert_categories, 
      decimalChar = dec)
  }
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
    skipInitialSpace = FALSE, colClasses = "character", 
    use_fread = FALSE, csv_dialect, ...) {
  # Handle input of the arguments through a named list
  if (!missing(csv_dialect) && !is.null(csv_dialect)) {
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
    args <- c(csv_dialect, list(filename = filename, colClasses = colClasses, 
      use_fread = use_fread, decimalChar = decimalChar), list(...))
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
  #if (length(nullSequence) > 0)
    #stop("Specifying nullSequence is not supported.")
  stopifnot(is.logical(skipInitialSpace), length(skipInitialSpace) == 1)
  # Read data
  if (use_fread) {
    if (!requireNamespace("data.table")) stop("In order to use ", 
        "'use_fread=TRUE' the data.table package needs to be installed.")
    lapply(filename, function(fn) {
      d <- data.table::fread(fn, sep = delimiter, quote = quoteChar, 
        dec = decimalChar, header = header, check.names = FALSE, 
        strip.white = skipInitialSpace, stringsAsFactors = FALSE, 
        colClasses = colClasses, na.strings = nullSequence, ...)
      #if (!caseSensitiveHeader) names(d) <- tolower(names(d))
      d
    }) |> data.table::rbindlist()
  } else {
    dta <- lapply(filename, function(fn) {
      d <- utils::read.table(fn, sep = delimiter, quote = quoteChar, 
        dec = decimalChar, header = header, check.names =FALSE, 
        comment.char = commentChar, strip.white = skipInitialSpace, 
        stringsAsFactors = FALSE, colClasses = colClasses, 
        na.strings = nullSequence, ...)
      #if (!caseSensitiveHeader) names(d) <- tolower(names(d))
      d
    })
    if (length(dta) > 1) do.call(rbind, dta) else dta[[1]]
    #if (length(nullSequence)) {
    #  for (col in names(dta)) {
    #    if (is.character(dta[[col]])) {
    #      dta[[col]][ dta[[col]] %in% nullSequence ] <- NA_character_
    #    }
    #  }
    #}
    #dta
  }
}

