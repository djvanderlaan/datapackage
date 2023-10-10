#' Write table-schema object to file
#'
#' @param schema table-schema object
#' @param filename file to write object to.
#' @param pretty add identation to the JSON output
#' @param ... passed on to \code{\link[jsonlite]{write_json}}.
#'
#' @details
#' Object is stored as an JSON-file. This function tries to make sure that
#' fields that need to be stored as an vector are stored as a vector in the
#' JSON-file. 
#' 
#' @return
#' The function does not return anything. It is called for its side effect of
#' creating a file.
#' 
#' @export
write_schema <- function(schema, filename = stdout(), pretty = TRUE, ...) {
  # Some fields should be stored as a vector even when they contain
  # only a single values; make sure that they are indeed stored as
  # a vector
  # Withing the field meta
  nounbox_fields <- c("trueValues", "falseValues")
  schema$fields[] <- lapply(schema$fields, function(f, nounbox) {
    nounbox <- intersect(nounbox, names(f))
    for (n in nounbox) f[[n]] <- I(f[[n]])
    f
  }, nounbox = nounbox_fields)
  # General within schema
  nounbox <- c("missingValues")
  to_nounbox <- intersect(nounbox, names(schema))
  for (n in to_nounbox) schema[[n]] <- I(schema[[n]])
  # Write
  jsonlite::write_json(schema, filename, auto_unbox = TRUE, 
    pretty = pretty, ...)
}

