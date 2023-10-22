
# Write data to CSV-file and the table schema to a JSON file
# 
# @param x the dataset to write to file. 
# @param filename the name of the CSV-file. If empty string the contents are
#   written to the console.
# @param filename_schema the name fo the JSON-file to which the schema should be
#   written. If missing and \code{filename} is an empty string the output is 
#   written to the console.
# @param schema the table schema beloning to the dataset being written.
# @param delimiter the field separator character. See the \code{sep} argument
#   of \code{\link[utils]{read.csv}} and \code{\link[data.table]{fread}}.
# @param decimalChar the decimal separator to use in number field. Note that the
#   separator is only used for a field when the field schema does not specify a 
#   separator to use.
# @param ... ignored for now.
#
# @details
# The function will get the schema from the schema attribute of \code{x}. The
# schema of the fields will be rebuilt (using the schema attribute of the
# columns). When the data set does not contain any schema a default schema is
# generated. 
#
# The function should ensure that date written using \code{csv_write} can be 
# read again using \code{csv_read}. This should result in the same
# \code{data.frame} as initially written (barring things like precision and
# unsupported types).
# 
# @export
# TODO: this is from table.schema package
csv_write <- function(x, filename = "", 
    filename_schema = paste0(tools::file_path_sans_ext(filename), ".schema.json"), 
    schema = datapackage::schema(x), delimiter = ",", decimalChar = ".",
    ...) {
  if (filename == "" && missing(filename_schema)) filename_schema = stdout()
  if (decimalChar != ".") schema <- set_decimalchar(schema, decimalChar, FALSE)
  delimiter_ok <- sapply(schema$fields, function(x) x$type != "number" || 
    is.null(x$decimalChar) || x$decimalChar != delimiter)
  delimiter_ok <- all(delimiter_ok)
  if (delimiter == decimalChar || !delimiter_ok)
    stop("There are fields for which the decimalChar equals the field ", 
      "delimiter. This is not allowed.")
  # Keep track of the fields that were originally character field and should
  # be quoted in the output
  quote <- which(sapply(x, is.character))
  # Format the fields (if necessary)
  for (i in seq_along(x)) 
    x[[i]] <- csv_format(x[[i]], schema$fields[[i]])
  # How to write missing values
  nastrings <- if (!is.null(schema$missingValues)) schema$missingValues else ""
  na <- if (length(nastrings) > 0) nastrings[1] else ""
  # Write
  utils::write.table(x, file = filename, na = na, row.names = FALSE, 
    fileEncoding = "UTF-8", quote = quote, sep = delimiter, dec = ".", 
    qmethod = "double")
  write_schema(schema, filename_schema, pretty = TRUE)
}


# Set the decimalChar for number fields that don't already have it set (or all
# if all = TRUE).
set_decimalchar <- function(schema, value, all = TRUE) {
  for (i in seq_along(schema$fields)) {
    if (schema$fields[[i]]$type == "number") {
      if (all || is.null(schema$fields[[i]]$decimalChar)) {
        schema$fields[[i]]$decimalChar <- value
      }
    }
  }
  schema
}

