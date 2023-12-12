


Welke use cases:
- Dataset opslaan; alle metadata wordt automatisch gegenereerd; resource voor de
dataset zelf moet aangemaakt worden en ook de dataresources voor eventuele
codelijsten.
- Dataset opslaan; maak gebruik van bestaande metadata. Opslaan moet voldoen aan
deze bestaande metadata.
- Metadata genereren en opslaan. Deze kan vervolgens handmatig geedit worden. 


# =============================================================================
# Create data resources from a dataset.
# This can generate multiple resources in case a dataset contains variables 
# with a codelist
# TODO: use existing fielddescriptors of variables if available
# TODO: option to store codelist in the metadata
# TODO: option to not store any codelist at all an store factor as character
# TODO: other types such as integer, boolean, date

pkgload::load_all()

dpgeneratedataresources <- function(x, name, path = paste0(name, ".csv"), ...) {
  stopifnot(is.data.frame(x))
  resources <- vector("list", 1)
  # Generate the table schema
  fields <- vector("list", ncol(x))
  for (i in seq_along(x)) {
    fd <- generatefielddescriptor(x[[i]], names(x)[i])
    codelist <- fd$codelist
    if (!is.null(codelist)) {
      # WE have a codelist and need to generate a dataresource for the codelist
      codelistname <- sprintf("%s-%s-codelist", 
         name, names(x)[i])
      fd$fielddescriptor$codelist <- codelistname
      codelist_res <- dpgeneratedataresources(codelist, codelistname)
      resources[[length(resources)+1L]] <- codelist_res[[1]]
    }
    fields[[i]] <- fd$fielddescriptor
  }
  res <- structure(list(name = name, format = "csv", mediatype = "text/csv", 
    path = path, encoding = "utf-8", schema = list(fields = fields)), 
    class = "dataresource")
  resources[[1L]] <- res
  resources
}

generatefielddescriptor <- function(x, name, ...) {
  UseMethod("generatefielddescriptor")
}
generatefielddescriptor.default <- function(x, name, ...) {
  fielddescriptor <- list(
    name = name,
    type = "string"
  )
  list(fielddescriptor = fielddescriptor)
}
generatefielddescriptor.numeric <- function(x, name, ...) {
  fielddescriptor <- list(
    name = name,
    type = "number"
  )
  list(fielddescriptor = fielddescriptor)
}
generatefielddescriptor.factor <- function(x, name, ...) {
  fielddescriptor <- list(
    name = name,
    type = "integer"
  )
  codelist <- data.frame(
    code = seq_len(nlevels(x)),
    label = levels(x)
  )
  list(fielddescriptor = fielddescriptor, codelist = codelist)
}

dpgeneratedataresources(iris, "iris") |> lapply(unclass) |> jsonlite::toJSON(pretty = TRUE, auto_unbox = TRUE)


system("rm -f -r work/test")

dp <- newdatapackage("work/test")

dpname(dp) <- "test"


res <- dpgeneratedataresources(iris, "iris") 

`dpresources<-` <- function(x, value) {
  for (i in seq_along(value)) {
    r <- value[[i]]
    name <- dpname(r)
    if (is.null(name)) name <- paste0("resource", i)
    dpresource(x, name) <- r
  }
  x
}

dpresources(dp) <- res


x <- iris
resourcename <- "iris"
datapackage <- dp
path <- "iris.csv"

dp

#csv_write <- function(x, resourcename, datapackage, ...) {
  dataresource <- dpresource(datapackage, resourcename)
  if (is.null(dataresource)) 
    stop("Data resource '", resourcename, "' does not exist in data package")
  decimalChar <- decimalchars(dataresource) |> head(1)
  delimiter <- "," # TODO: check csv specs in resource
  # Check if delimiter equal to decimalchar; ifso we will have issues reading
  delimiter_ok <- all(decimalchars(dataresource) != delimiter)
  if (delimiter == decimalChar || !delimiter_ok)
    stop("There are fields for which the decimalChar equals the field ", 
      "delimiter. This is not allowed.")
  # Keep track of the fields that were originally character field and should
  # be quoted in the output
  quote <- which(sapply(x, is.character))
  # Format the fields (if necessary)
  stopifnot(setequal(names(x), dpfieldnames(dataresource)))
  for (i in names(x)) 
    x[[i]] <- csv_format(x[[i]], dpfield(dataresource, i))
  # How to write missing values
  csvdialect <- dpproperty(dataresource, "dialect")
  encoding <- dpencoding(dataresource, "encoding")
  if (is.null(encoding)) encoding <- "UTF-8"
  path <- dppath(dataresource, fullpath = TRUE)
  if (is.null(path)) stop("Path is missing in dataresource.")
  if (isurl(path)) stop("Path is an URL; writing to a URL is not supported.")
  # Write
  csv_write_base(x, path, encoding = encoding, decimalChar = decimalChar, 
    csv_dialect = csvdialect, quote = quote)
  # TODO
  #write_schema(schema, filename_schema, pretty = TRUE)
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
    if (!missing(caseSensitiveHeader)) csv_dialect$caseSensitiveHeader <- caseSensitiveHeader
    if (!missing(nullSequence)) csv_dialect$nullSequence <- nullSequence
    args <- c(csv_dialect, list(filename = filename, colClasses = colClasses, na.strings = na.strings,
      use_fwrite = use_fwrite, decimalChar = decimalChar), list(...))
    return(do.call(csv_write_base, args))
  }
  # Check and process aguments
  stopifnot(is.character(filename))
  stopifnot(is.character(delimiter), length(delimiter) == 1, nchar(delimiter) == 1)
  stopifnot(is.character(decimalChar), length(decimalChar) == 1, nchar(decimalChar) == 1)
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
#  if (use_fwrite) {
#    if (!requireNamespace("data.table")) stop("In order to use ", 
#        "'use_fread=TRUE' the data.table package needs to be installed.")
#    lapply(filename, function(fn) {
#      d <- data.table::fread(filename, sep = delimiter, quote = quoteChar, 
#        dec = decimalChar, header = header, 
#        strip.white = skipInitialSpace, stringsAsFactors = FALSE, 
#        colClasses = colClasses, na.strings = na.strings, ...)
#      if (!caseSensitiveHeader) names(d) <- tolower(names(d))
#      d
#    }) |> data.table::rbindlist()
#  } else {
    write.table(x, filename, quote = quote, sep = delimiter, 
      eol = lineTerminator, na = nullSequence, dec = decimalChar, 
      row.names = FALSE, col.names = header, qmethod = "double", 
      fileEncoding = encoding)
#    if (length(dta) > 1) do.call(rbind, dta) else dta[[1]]
#  }
}


decimalchars <- function(x) {
  decimalChars <- sapply(dpfieldnames(x), \(fn) {
    char <- dpfield(x, fn) |> dpproperty("decimalChar")
    if (is.null(char)) {
      type <- dpfield(x, fn) |> dpproperty("type")
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

