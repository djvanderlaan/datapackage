


Welke use cases:
- Dataset opslaan; alle metadata wordt automatisch gegenereerd; resource voor de
dataset zelf moet aangemaakt worden en ook de dataresources voor eventuele
codelijsten.
- Dataset opslaan; maak gebruik van bestaande metadata. Opslaan moet voldoen aan
deze bestaande metadata.
- Metadata genereren en opslaan. Deze kan vervolgens handmatig geedit worden. 


# =============================================================================
# Create data resources from a dataset.
# This can generate multiple resources in case a dataset contains variables 
# with a codelist
# TODO: use existing fielddescriptors of variables if available
# TODO: option to store codelist in the metadata
# TODO: option to not store any codelist at all an store factor as character
# TODO: other types such as integer, boolean, date

pkgload::load_all()


dpgeneratedataresources(iris, "iris") |> lapply(unclass) |> jsonlite::toJSON(pretty = TRUE, auto_unbox = TRUE)


system("rm -f -r work/test")

dp <- newdatapackage("work/test")

dpname(dp) <- "test"


res <- dpgeneratedataresources(iris, "iris") 


dpresources(dp) <- res

dp |> dpresource("iris") |> dpwritedata(iris)

dpwritedata(dp, "iris", iris)
readLines("work/test/iris.csv", n=10) |> writeLines()
readLines("work/test/iris-Species-codelist.csv", n=10) |> writeLines()



path <- "work/test"
data <- iris
name <- "iris"

dpsaveasdatapackage <- function(data, path, name) {
  if (missing(name))
    name <- deparse(substitute(data)) |> 
      gsub(pattern = "[^[:alnum:].-]", replacement = ".")
  dp <- newdatapackage(path, name)
  res <- dpgeneratedataresources(data, name)
  dpresources(dp) <- res
  dp |> dpresource(name) |> dpwritedata(data)
}

readLines("work/test/datapackage.json") |> writeLines()

dpsaveasdatapackage(iris, "work/test")

readLines("work/test/iris.csv", n=10) |> writeLines()
readLines("work/test/iris-Species-codelist.csv", n=10) |> writeLines()

dp <- opendatapackage("work/test")
dp |> dpresource("iris") |> dpgetdata()
# TODO: Species isn't a factor??

foo <- function(x) {
  deparse(substitute(x))
}

x <- "foo (bar-)ww"


