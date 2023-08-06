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

iris <- resource(dp, "iris")
iris

getdata(iris)


file.remove("tmp/foo/datapackage.json")
new <- newdatapackage("tmp/foo", name = "foo", title = "Dit is een test")

name(new) <- "foo-bar"

r <- newdataresource(name = "test", title = "Dit is een titel")
property(r, "data") <- 1:4
resource(new, "test") <- r


readLines("tmp/foo/datapackage.json") |> writeLines()

getdata(new, "test")

resource(new, "test") |> getdata()




dp <- opendatapackage("examples/iris") 
dp

