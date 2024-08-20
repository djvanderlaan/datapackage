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
res <- dpgeneratedataresource(iris, "iris") 

# a30
dptitle(res) <- "The Iris dataset"

# a40
dpresources(dp) <- res

# a50
dpwritedata(dp, resourcename = "iris", data = iris)

# a60
readLines(file.path(dir, "iris.csv"), n = 10) |> writeLines()

# a70
dp2 <- opendatapackage(dir)
iris2 <- dp2 |> dpresource("iris") |> dpgetdata(to_factor = TRUE)
all.equal(iris, iris2, check.attributes = FALSE)

# c00
data(chickwts)

res <- dpgeneratedataresource(chickwts, "chickwts") 
dpresources(dp) <- res

(feed_name <- dpresource(dp, "chickwts") |> 
  dpfield("feed") |> dpproperty("categories"))

# c01
res <- dpgeneratedataresource(chickwts, "chickwts", 
  categories_type = "resource") 
dpresources(dp) <- res

(feed_name <- dpresource(dp, "chickwts") |> 
  dpfield("feed") |> dpproperty("categories"))

# c02
dpwritedata(dpresource(dp, "chickwts"), data = chickwts, write_categories = TRUE)
list.files(dir)

dpresource(dp, "feed-categories") |> dpgetdata()

# c10
codelist <- data.frame(
  value = c(101, 102, 103, 202, 203, 204),
  label = c("casein", "horsebean", "linseed", "meatmeal", 
    "soybean", "sunflower")
)
res <- dpgeneratedataresource(codelist, "feed-categories")
res
dpresources(dp) <- res

codelistres <- dp |> dpresource("feed-categories")
dpwritedata(codelistres, data = codelist, write_categories = FALSE)

# c20
readLines(file.path(dir, "feed-categories.csv")) |> writeLines()

# c30
dpwritedata(dp, resourcename = "chickwts", data = chickwts, write_categories = FALSE)

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

