

# ==============================================================================
# SCHEMA

#' @export
#' @rdname properties_dataresource
dpschema <- function(x) {
  UseMethod("dpschema")
}

#' @export
#' @rdname properties_dataresource
dpschema.dataresource <- function(x) {
  schema <- dpproperty(x, "schema")
  if (is.null(schema)) return(schema)
  # Handle the case that schema is a string e.g. a path
  if (is.character(schema)) {
    # Check if path is valid; note path may be a vector of paths
    rel <- isrelativepath(schema)
    url <- isurl(schema)
    # They should either be all relative paths or all urls
    if (!(all(rel) || all(url))) 
      stop("Invalid schema field. Path should either be a relative path or a URL.")
    # Convert relative paths to full paths
    if (all(rel)) {
      basepath <- attr(x, "path")
      if (is.null(basepath)) 
        warning("Schema defined in resource is on relative path. ",
          "No base path is defined in resource. Returning relative path.")
      schema <- file.path(basepath, schema) 
      schema <- read_json_yaml(schema)
      # TODO: some properties are probably read incorrectly;
      # see e.g. table-schema::read_schema
    } 
  } 
  structure(schema, class = "tableschema", dataresource = x)
}




#==============================================================================
# GETTING FIELD META




#' Get the field schema associated with a certain field in a Data Resource
#'
#' @param resource a \code{dataresource} object.
#' @param fieldname length one character vector with the name of the field.
#'
#' @return
#' An object of type \code{fielddescriptor}.
#'
#' @export
dpfield <- function(resource, fieldname) {
  schema <- dpschema(resource)
  if (is.null(schema)) stop("Data Resource does not have a schema property.")
  fields <- schema$fields
  if (is.null(fields)) stop("Fields are missing from schema of Data Resource.")
  for (i in seq_along(fields)) {
    if (!exists("name", fields[[i]])) stop("Field without name.")
    if (fields[[i]]$name == fieldname) return(
      structure(fields[[i]], class = "fielddescriptor", dataresource = resource)
    )
  }
  stop("Field '", fieldname, "' not found.")
}

