
#' @export
newdatapackage <- function(path, name = NULL, title = NULL, description = NULL, ...) {
  stopifnot(missing(name) || isname(name))
  stopifnot(missing(title) || isstring(title))
  stopifnot(missing(description) || isstring(description))
  # Build object
  res <- list(name = name, title = title, description = description)
  res <- Filter(\(x) !is.null(x), res)
  if (!exists("resources", res)) res$resources <- list()
  res <- structure(res, class = "datapackage")
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
  # Check if datapackage already exists in directory
  if (file.exists(file.path(path, filename))) 
    stop("'", file.path(path, filename), "' already exists.")
  # Write the datapackage
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  writedatapackage(res, path = path, filename = filename)
  opendatapackage(path, readonly = FALSE)
}

