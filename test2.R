# Test how we can distuingish between readonly (which is cahed in memory and
# writeable data packages where the information is stored on disk an read every
# time.

library(jsonlite)
for (file in list.files("R", pattern = "*.R", full.names = TRUE))
  source(file)

dir <- tempdir()
file.copy("examples/iris", dir, recursive = TRUE)
cat("Dir '", dir, "'\n", sep ="")

dp <- opendatapackage(file.path(dir, "iris"), readonly = FALSE) 

dp

property(dp, "name") <- "iris2"

getdata(dp, "inline")

iris <- getresource(dp, "iris")
iris

getdata(iris)


new <- newdatapackage("tmp/foo", name = "foo", title = "Dit is een test")

name(new) <- "foo-bar"

readLines("tmp/foo/datapackage.json") |> writeLines()



value <- path(iris, fullpath = TRUE)
dppath <- attr(iris, "path")


dp <- opendatapackage("examples/iris") 
dp

nm <- function(x, ...) {
  UseMethod("nm")
}
nm.datapackage <- function(x, resourcename, ...) {
  if (missing(resourcename)) {
    x$name
  } else {
    for (i in seq_along(x$resources)) {
      if (x$resources[[i]]$name == resourcename) {
        return (x$resources[[i]]$name)
      }
    }
    stop("Resource'", resource, "' not found.")
  }
}
`nm<-` <- function(x, value, ...) {
  UseMethod("nm<-")
}
`nm<-.datapackage` <- function(x, value, ..., resource) {
  if (!missing(resource)) {
    for (i in seq_along(x$resources)) {
      if (x$resources[[i]]$name == resource) {
        x$resources[[i]]$name <- value
        return(x)
      }
    }
    stop("Resource'", resource, "' not found.")
  } else {
    x$name <- value
    x
  }
}

nm(dp)
nm(dp) <- "foo"


nm(dp, resource = "iris") <- "foo"

