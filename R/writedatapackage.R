
writedatapackage <- function(datapackage, path = attr(datapackage, "path"), 
    filename = attr(datapackage, "filename")) {
  tmp <- unclass(datapackage)
  attr(tmp, "filename") <- NULL
  attr(tmp, "path") <- NULL
  jsonlite::write_json(tmp, file.path(path, filename), 
    pretty = TRUE, auto_unbox = TRUE)
}

