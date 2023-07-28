
opendatapackage <- function(path, readonly = TRUE) {
  # Split path into the filename of the descriptor and the path of the 
  # datapackage
  ext <- tools::file_ext(path)
  if (ext != "json" && ext != "yaml") {
    filename <- "datapackage.json"
  } else {
    filename <- basename(path)
    path <- dirname(path)
  }
  # Make the path absolute; otherwise we cannot access it when the user changes
  # directory
  path <- normalizePath(path, mustWork = FALSE)
  # Open datapackage
  dp <- readdatapackage(path, filename)
  if (readonly) {
    dp
  } else {
    structure(list(path = path, filename = filename), 
      class = c("editabledatapackage", "datapackage"), 
      path = path, filename = filename)
  }
}

