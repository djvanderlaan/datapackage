library(jsonlite)

for (file in list.files("R", pattern = "*.R", full.names = TRUE))
  source(file)

dp <- opendatapackage("examples/iris")

dp

getdata(dp, "inline")

iris <- getresource(dp, "iris")
iris

getdata(iris)


is_string <- function(x) {
  is.character(x) && length(x) == 1
}

resource <- function(name, path, title = NULL, description = NULL, data = NULL, ...) {
  stopifnot(is_string(name))
  stopifnot(!missing(path) || !missing(data))
  stopifnot(missing(path) || is_string(path))
  stopifnot(missing(title) || is_string(title))
  stopifnot(missing(description) || is_string(description))
  # Build object
  res <- list(name = name, title = title, description = description, path = path, 
    data = data)
  res <- Filter(\(x) !is.null(x), res)
  structure(res, class = "resource")
}

resource(name = "foo", path = "foo.csv" ) |> str()

