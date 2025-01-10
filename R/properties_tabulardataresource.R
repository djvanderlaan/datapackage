

# ==============================================================================
# SCHEMA

#' @export
#' @rdname properties_dataresource
dp_schema <- function(x) {
  UseMethod("dp_schema")
}

#' @export
#' @rdname properties_dataresource
dp_schema.dataresource <- function(x) {
  schema <- dp_property(x, "schema")
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


