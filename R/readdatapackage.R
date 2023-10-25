
readdatapackage <- function(path, filename) {
  dp <- read_json_yaml(file.path(path, filename))
  structure(dp, class = c("readonlydatapackage", "datapackage"), path = path, filename = filename)
}

