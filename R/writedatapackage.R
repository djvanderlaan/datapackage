
writedatapackage <- function(datapackage, path = attr(datapackage, "path"), 
    filename = attr(datapackage, "filename")) {
  tmp <- removeclasses(datapackage)
  #tmp <- unclass(datapackage)
  attr(tmp, "filename") <- NULL
  attr(tmp, "path") <- NULL
  jsonlite::write_json(tmp, file.path(path, filename), 
    pretty = TRUE, auto_unbox = TRUE)
}

removeclasses <- function(x) {
  classes <- c("fielddescriptor", "datapackage", "dataresource")
  if (is.list(x)) {
    if (any(class(x) %in% classes)) x <- unclass(x)
    x <- lapply(x, removeclasses)
  }
  x
}
