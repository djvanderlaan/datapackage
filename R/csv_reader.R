
#' Read the CSV-data for a Data Resource
#' 
#' @param path path to the data set. 
#' 
#' @param resource a Data Resource.
#'
#' @seealso
#' Generally used by calling \code{\link{getdata}}.
#'
#' @return
#' Returns a \code{data.frame} with the data.
#'
#' @export
csv_reader <- function(path, resource) {
  schema <- property(resource, "schema")
  # TODO: do something with the CSV-description
  # TODO: merge csv_read and csv_reader
  if (is.null(schema)) {
    dta <- lapply(path, utils::read.csv)

  } else {
    # Handle the case that schema is a string e.g. a path
    if (is.character(schema)) {
      # Check if path is valid; note path may be a vector of paths
      rel <- isrelativepath(schema)
      url <- isurl(schema)
      # They should either be all relative paths or all urls
      if (!(all(rel) || all(url))) 
        stop("Invalid schema field. Paths should either be all relative paths or all URL's.")
      # Convert relative paths to full paths
      if (all(rel)) {
        basepath <- attr(resource, "path")
        if (is.null(basepath)) 
          warning("Schema defined in resource is on relative path. ",
            "No base path is defined in resource. Returning relative path.")
        schema <- file.path(basepath, schema) 
      } 
    } 
    # Read
    dta <- lapply(path, csv_read, schema = schema)
  }
  dta <- do.call(rbind, dta)
  structure(dta, resource = resource)
}

