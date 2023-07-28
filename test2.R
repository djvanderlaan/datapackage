# Test how we can distuingish between readonly (which is cahed in memory and
# writeable data packages where the information is stored on disk an read every
# time.

library(jsonlite)

for (file in list.files("R", pattern = "*.R", full.names = TRUE))
  source(file)

dpopen <- function(path, readonly = TRUE) {
  if (readonly) {
    opendatapackage(path)
  } else {
    # check if we can open
    dp <- opendatapackage(path)
    structure(list(path = attr(dp, "path"), filename = attr(dp, "filename")), 
      class = "editabledatapackage")
  }
}
print.editabledatapackage <- function(x, ...) {
  dp <- jsonlite::read_json(x$filename)
  dp <- structure(dp, class = "datapackage", path = x$path, filename = x$filename)
  print(dp, ...)
}

dp <- dpopen("examples/iris", readonly = FALSE)



dp

getdata(dp, "inline")

iris <- getresource(dp, "iris")
iris

getdata(iris)


resource <- function(name, path, title = NULL, description = NULL, data = NULL, ...) {
  stopifnot(isstring(name))
  stopifnot(!missing(path) || !missing(data))
  stopifnot(missing(path) || isstring(path))
  stopifnot(missing(title) || isstring(title))
  stopifnot(missing(description) || isstring(description))
  # Build object
  res <- list(name = name, title = title, description = description, path = path, 
    data = data)
  res <- Filter(\(x) !is.null(x), res)
  structure(res, class = "resource")
}

resource(name = "foo", path = "foo.csv" ) |> str()

