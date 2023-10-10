
#' Read table-schema from JSON-file
#' 
#' @param filename the name of the file to read from or a string of JSON
#'   containing the schema. 
#' @param json logical indicating if \code{filename} should be interpreted as
#'   a filename or a string of JSON. If not specified it assumes that a 
#'   string starting with '\{' (after optional white space) is JSON. Therefore, the
#'   \code{json} argument is only needed when a filename starts with '\{' or the 
#'   JSON does not start with '\{' (which it should to be valid table schema).
#'
#' @return
#' Return a \code{list} with the table-schema.
#' 
#' @export
read_schema <- function(filename, 
    json = grepl("^[[:space:]]*\\{", paste0(filename, collapse=" "))) {
  if (json) {
    schema <- jsonlite::parse_json(filename, simplifyVector = TRUE, 
      simplifyDataFrame = FALSE, simplifyMatrix = FALSE)
  } else {
    schema <- jsonlite::read_json(filename, simplifyVector = TRUE, 
      simplifyDataFrame = FALSE, simplifyMatrix = FALSE)
  }
  # Following to handle case "missingValues: []", e.g. no missing values
  # this results in list()
  if (!is.null(schema$missingValues)) 
    schema$missingValues <- as.character(schema$missingValues)
  schema
}

