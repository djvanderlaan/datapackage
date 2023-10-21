

# ==============================================================================
# SCHEMA

#' @export
#' @rdname properties_dataresource
dpschema <- function(x) {
  UseMethod("schema")
}

#' @export
#' @rdname properties_dataresource
dpschema.dataresource <- function(x) {
  schema <- property(x, "schema")
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
      basepath <- attr(resource, "path")
      if (is.null(basepath)) 
        warning("Schema defined in resource is on relative path. ",
          "No base path is defined in resource. Returning relative path.")
      schema <- file.path(basepath, schema) 
      # TODO: read schema
      schema <- readschema(schema)
    } 
  } 
  schema
}




readschema <- function(filename, type = c("detect", "json", "yaml")) {
  type <- match.arg(type)
  if (type == "detect") {
    ext <- tools::file_ext(filename) |> tolower()
    if (ext %in% c("yaml", "yml")) {
      type <- "yaml" 
    } else {
      type <- "json"
    }
  }
  if (type == "json") {
    jsonlite::read_json(filename, simplifyVector = TRUE, 
      simplifyDataFrame = FALSE, simplifyMatrix = FALSE)
    # TODO: some properties are probably read incorrectly;
    # see e.g. table-schema::read_schema
  } else if (type == "yaml") {
    yaml::read_yaml(filename)
  }
}



