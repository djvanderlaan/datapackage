# Test how we can distuingish between readonly (which is cahed in memory and
# writeable data packages where the information is stored on disk an read every
# time.

library(jsonlite)

for (file in list.files("R", pattern = "*.R", full.names = TRUE))
  source(file)

readdatapackage <- function(path, filename) {
  dp <- jsonlite::read_json(file.path(path, filename))
  structure(dp, class = "datapackage", path = path, filename = filename)
}
dpopen <- function(path, readonly = TRUE) {
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
      class = "editabledatapackage")
  }
}
print.editabledatapackage <- function(x, ...) {
  dp <- readdatapackage(x$path, x$filename)
  print(dp, ...)
}

dp <- dpopen("examples/iris", readonly = FALSE)

dp

dpopen("examples/iris") |> str()

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

