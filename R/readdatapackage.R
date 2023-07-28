
readdatapackage <- function(path, filename) {
  dp <- jsonlite::read_json(file.path(path, filename))
  structure(dp, class = c("readonlydatapackage", "datapackage"), path = path, filename = filename)
}

