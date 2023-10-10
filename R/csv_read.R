#' Read data from a CSV-file using table-schema
#'
#' @param filename the name of the CSV-file
#' @param schema the name of the file containing the table-schema (when of type
#'   character) or the table schema directly (otherwise).
#' @param delimiter the field separator character. See the \code{sep} argument
#'   of \code{\link[utils]{read.csv}} and \code{\link[data.table]{fread}}.
#' @param decimalChar the decimal separator to use in number field. Note that 
#'   separator is only used for a field when the field schema does not specify a 
#'   separator to use.
#' @param use_fread use the \code{\link[data.table]{fread}} function instead of
#'   \code{\link[utils]{read.csv}} and return a \code{data.table}.
#' @param to_factor convert columns to factor if the schema has a categories
#'   field for the column.
#' @param ... additional arguments are passed on to \code{read.csv} or 
#'   \code{fread}.
#'
#' @details
#' The data is read and the converted to the correct R-type using the schema.
#' When possible it is attempted to leave the conversion to \code{read.csv} or
#' \code{fread}. For example, a column of type \code{number} with a decimal mark
#' of '.' and no thousand separator is read in as is. Other fields are generally
#' read in as character and then converted to the correct R-type. 
#'
#' When \code{use_fread = FALSE}, \code{\link[utils]{read.csv}} is called. 
#' Therefore, \code{filename} can also be other types of connections as 
#' accepted by \code{read.csv} such as a \code{\link{textConnection}} for 
#' direct input of CSV-data.
#'
#' @return
#' Returns a \code{data.frame} (or \code{data.table} when 
#' \code{use_fread = TRUE}). The schema is added in the \code{schema} attribute
#' of the \code{data.frame} and the schema of the columns/fields is added to
#' each of the columns. 
#' 
#' @examples
#' csv <- "col1,col2
#' 10*2,30-12-1971
#' -10*2,01-01-2000"
#' 
#' json <- '{
#'   "fields" : [
#'     {"name": "col1", "type": "number", "decimalChar": "*"},
#'     {"name": "col2", "type": "date", "format": "%d-%m-%Y"}
#'   ]
#' } '
#' 
#' csv_read(textConnection(csv), json)
#' 
#' @export
csv_read <- function(filename, 
    schema = paste0(tools::file_path_sans_ext(filename), ".schema.json"), 
    delimiter = ",", decimalChar = c(".", ","),
    #quoteChar = "\"", doubleQuote = TRUE, 
    #header = TRUE, commentChar  = "",
    #lineTerminator = "\r\n",
    use_fread = FALSE, to_factor = TRUE, ...) {
  # TODO: hangle quoteChar, doubleQuote, header, commentChar, lineTerminator
  if (is.character(schema)) schema <- read_schema(schema)
  decimalChar <- match.arg(decimalChar)
  # Determine how we need to read each of the columns
  colclasses <- sapply(schema$fields, csv_colclass, decimalChar = decimalChar)
  # Missing values
  nastrings <- if (!is.null(schema$missingValues)) schema$missingValues else ""
  nastrings <- as.character(nastrings)
  # Read
  if (use_fread) {
    if (!requireNamespace("data.table")) stop("In order to use ", 
        "'use_fread=TRUE' the data.table package needs to be installed.")
    dta <- data.table::fread(filename, colClasses = colclasses, 
      stringsAsFactors = FALSE, na.strings = nastrings, sep = delimiter, 
      dec = decimalChar, ...)
  } else {
    dta <- utils::read.csv(filename, colClasses = colclasses, 
      stringsAsFactors = FALSE, na.strings = nastrings, sep = delimiter, 
      dec = decimalChar, ...)
  }
  convert_using_schema(dta, schema, to_factor = to_factor, 
    decimalChar = decimalChar)
}

