
#' Write data of data resource to CSV-file
#' 
#' @param x \code{data.frame} with the data to write
#'
#' @param resource_name name of the data resource in the data package.
#'
#' @param datapackage the Data Package to which the file should be written.
#'
#' @param use_fwrite write the file using \code{fwrite} from the
#' \code{data.table} package.
#'
#' @param ... ignored for now
#'
#' @return
#' The function doesn't return anything. It is called for it's side effect of
#' creating CSV-files in the directory of the data package.
#'
#' @export
csv_writer <- function(x, resource_name, datapackage, 
    use_fwrite = FALSE, ...) {
  dataresource <- dp_resource(datapackage, resource_name)
  if (is.null(dataresource)) 
    stop("Data resource '", resource_name, "' does not exist in data package")
  # First check to see of dataresourc fits data
  stopifnot(setequal(names(x), dp_field_names(dataresource)))
  # Write dataset; but first process arguments
  csvdialect <- dp_property(dataresource, "dialect")
  if (is.null(csvdialect)) csvdialect <- list()
  decimalChar <- csvdialect$decimalChar
  if (is.null(decimalChar))
    decimalChar <- decimalchars(dataresource) |> utils::head(1)
  delimiter <- "," 
  if (!is.null(csvdialect$delimiter)) delimiter <- csvdialect$delimiter
  # Check if delimiter equal to decimalchar; ifso we will have issues reading
  delimiter_ok <- all(decimalchars(dataresource) != delimiter)
  if (delimiter == decimalChar || !delimiter_ok)
    stop("There are fields for which the decimalChar equals the field ", 
      "delimiter. This is not allowed.")
  # Keep track of the fields that were originally character field and should
  # be quoted in the output
  quote <- which(sapply(x, is.character))
  # Format the fields (if necessary)
  for (i in names(x)) 
    x[[i]] <- csv_format(x[[i]], dp_field(dataresource, i), 
      decimalChar = decimalChar)
  # How to write missing values
  encoding <- dp_encoding(dataresource, default = TRUE)
  path <- dp_path(dataresource, full_path = TRUE)
  if (is.null(path)) stop("Path is missing in dataresource.")
  if (isurl(path)) stop("Path is an URL; writing to a URL is not supported.")
  # If create directories in datapackage
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  # Write
  csv_write_base(x, path, encoding = encoding, decimalChar = decimalChar, 
    csv_dialect = csvdialect, quote = quote)
}


csv_write_base <- function(x, filename, 
    delimiter = ",", decimalChar = ".",
    quoteChar = "\"", doubleQuote = TRUE, 
    commentChar  = "", lineTerminator = "\r\n", 
    header = TRUE, nullSequence = "", encoding = "UTF-8",
    skipInitialSpace = FALSE,  use_fwrite = FALSE, 
    quote = quoteChar != "", csv_dialect, ...) {
  # Handle input of the arguments through a named list
  if (!missing(csv_dialect) && !is.null(csv_dialect)) {
    stopifnot(is.list(csv_dialect))
    keep <- c("delimiter", "lineTerminator", "quoteChar", "doubleQuote", 
      "skipInitialSpace", "header", "commentChar", "nullSequence")
    csv_dialect <- csv_dialect[names(csv_dialect) %in% keep]
    if (!missing(delimiter)) csv_dialect$delimiter <- delimiter
    if (!missing(lineTerminator)) csv_dialect$lineTerminator <- lineTerminator
    if (!missing(quoteChar)) csv_dialect$quoteChar <- quoteChar
    if (!missing(doubleQuote)) csv_dialect$doubleQuote <- doubleQuote
    if (!missing(skipInitialSpace)) csv_dialect$skipInitialSpace <- skipInitialSpace
    if (!missing(header)) csv_dialect$header <- header
    if (!missing(commentChar)) csv_dialect$commentChar <- commentChar
    #if (!missing(caseSensitiveHeader)) csv_dialect$caseSensitiveHeader <- caseSensitiveHeader
    if (!missing(nullSequence)) csv_dialect$nullSequence <- nullSequence
    args <- c(csv_dialect, list(x = x, filename = filename, 
      use_fwrite = use_fwrite, decimalChar = decimalChar), list(...))
    return(do.call(csv_write_base, args))
  }
  # Check and process aguments
  stopifnot(is.character(filename))
  stopifnot(is.character(delimiter), length(delimiter) == 1, nchar(delimiter) == 1)
  stopifnot(is.character(decimalChar), length(decimalChar) == 1, nchar(decimalChar) == 1)
  stopifnot(decimalChar != delimiter)
  stopifnot(is.character(quoteChar), length(quoteChar) == 1)
  if (quoteChar != '"') 
    stop("Values other than \" for quoteChar are not supported.")
  stopifnot(length(doubleQuote) == 1)
  if (!doubleQuote) stop("Values other than TRUE for doubleQuote are not supported.")
  stopifnot(is.logical(header), length(header) == 1)
  stopifnot(is.character(commentChar), length(commentChar) == 1, nchar(commentChar) <= 1)
  if (commentChar != "") 
    stop('Values other than "" for commentChar are not supported.')
  stopifnot(is.character(lineTerminator), length(lineTerminator) == 1)
  if (!(lineTerminator %in% c("\n", "\r", "\r\n")))
    stop("Values other than '\\n', '\\r' or '\\r\\n' for lineTerminator are not supported.")
  stopifnot(is.character(nullSequence), length(nullSequence) == 1)
  stopifnot(is.logical(skipInitialSpace), length(skipInitialSpace) == 1)
  stopifnot(is.character(encoding), length(encoding) == 1)
  encoding <- toupper(encoding)
  # Write data
  if (use_fwrite) {
    if (!requireNamespace("data.table")) stop("In order to use ", 
        "'use_fwrite=TRUE' the data.table package needs to be installed.")
    if (tolower(encoding) != "utf-8") 
      stop("Encoding other than UTF-8 is not supported.")
    # TODO: do we handle encoding correclty?
    data.table::fwrite(x, filename, quote = quote, sep = delimiter, 
      eol = lineTerminator, na = nullSequence, dec = decimalChar, 
      row.names = FALSE, col.names = header, qmethod = "double")
  } else {
    utils::write.table(x, filename, quote = quote, sep = delimiter, 
      eol = lineTerminator, na = nullSequence, dec = decimalChar, 
      row.names = FALSE, col.names = header, qmethod = "double", 
      fileEncoding = encoding)
  }
}


decimalchars <- function(x) {
  decimalChars <- sapply(dp_field_names(x), \(fn) {
    char <- dp_field(x, fn) |> dp_property("decimalChar")
    if (is.null(char)) {
      type <- dp_field(x, fn) |> dp_type()
      if (type == "number") NA_character_ else '.'
    } else {
      char
    }
  }) 
  decimalChars <- decimalChars[!is.na(decimalChars)]
  if (length(decimalChars) == 0) decimalChars <- "."
  decimalChars <- sort(decimalChars) |> as.character()
  tmp <- rle(decimalChars)
  o <- order(tmp$lengths, decreasing = TRUE)
  tmp$values[o]
}

