# n1
library(datapackage)

dir <- tempfile()
dp <- newdatapackage(dir, name = "example", 
  title = "An Example Data Package")
print(dp)

# n2
list.files(dir)

# n3
dpdescription(dp) <- "This is a description of the Data Package"

# n4
dpdescription(dp) <- readLines("description.md")

# n6
dpaddcontributor(dp) <- newcontributor("Jane Doe", role = "author",
  email = "j.doe@organisation.org")

# a1
data(iris)
head(iris)

# a10
res <- dpgeneratedataresources(iris, "iris") 

# a20
print(res)

# a30
dptitle(res[[1]]) <- "The Iris dataset"

# a40
dpresources(dp) <- res

# a50
dpwritedata(dp, resourcename = "iris", data = iris, write_codelists = TRUE)

# a60
readLines(file.path(dir, "iris.csv"), n = 10) |> writeLines()
readLines(file.path(dir, "Species-codelist.csv")) |> writeLines()

# a70
dp2 <- opendatapackage(dir)
iris2 <- dp2 |> dpresource("iris") |> dpgetdata(to_factor = TRUE)
all.equal(iris, iris2, check.attributes = FALSE)

# c00
data(chickwts)

res <- dpgeneratedataresources(chickwts, "chickwts") 
dpresources(dp) <- res

# c10
codelist <- data.frame(
  code = c(101, 102, 103, 202, 203, 204),
  label = c("casein", "horsebean", "linseed", "meatmeal", 
    "soybean", "sunflower")
)
codelistres <- dp |> dpresource("feed-codelist")
dpwritedata(codelistres, data = codelist, write_codelists = FALSE)

# c20
readLines(file.path(dir, "feed-codelist.csv")) |> writeLines()

# c30
dpwritedata(dp, resourcename = "chickwts", data = chickwts, write_codelists = FALSE)

# c40
readLines(file.path(dir, "chickwts.csv"), n = 10) |> writeLines()

# e00
edit <- opendatapackage(dir, readonly = FALSE)
 
dpid(edit) <- "iris_chkwts"
dpcreated(edit) <- Sys.time() |> as.Date()

# e10
readLines(file.path(dir, "datapackage.json")) |> writeLines()

# cleanup
file.remove(list.files(dir, full.names = TRUE)) 
file.remove(dir)

