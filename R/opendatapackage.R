
opendatapackage <- function(path) {
  # Split path into the filename of the descriptor and the path of the 
  # datapackage
  filename <- path
  ext <- tools::file_ext(path)
  if (ext != "json" || ext != "yaml") {
    filename <- file.path(path, "datapackage.json")
  } else {
    path <- dirname(path)
  }
  # Make the path absolute; otherwise we cannot access it when the user changes
  # directory
  path <- normalizePath(path, mustWork = FALSE)
  # Read the descriptor
  dp <- jsonlite::read_json(filename)
  structure(dp, class = "datapackage", path = path, filename = filename)
}
