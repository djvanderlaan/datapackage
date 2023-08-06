
readdatapackage <- function(path, filename) {
  dp <- jsonlite::read_json(file.path(path, filename), simplifyVector = TRUE, 
    simplifyDataFrame = FALSE, simplifyMatrix = FALSE)
  structure(dp, class = c("readonlydatapackage", "datapackage"), path = path, filename = filename)
}

