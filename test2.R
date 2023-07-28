# Test how we can distuingish between readonly (which is cahed in memory and
# writeable data packages where the information is stored on disk an read every
# time.

library(jsonlite)

for (file in list.files("R", pattern = "*.R", full.names = TRUE))
  source(file)


dp <- opendatapackage("examples/iris", readonly = FALSE) 
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

