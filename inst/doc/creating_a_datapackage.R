# n1
library(datapackage)

dir <- tempfile()
dp <- new_datapackage(dir, name = "example", 
  title = "An Example Data Package")
print(dp)

# n2
list.files(dir)

# n3
dp_description(dp) <- "This is a description of the Data Package"

# n4
dp_description(dp) <- readLines("description.md")

# n6
dp_add_contributor(dp) <- new_contributor("Jane Doe", role = "author",
  email = "j.doe@organisation.org")

# a1
data(iris)
head(iris)

# a10
res <- dp_generate_dataresource(iris, "iris") 

# a30
dp_title(res) <- "The Iris dataset"

# a40
dp_resources(dp) <- res

# a50
dp_write_data(dp, resourcename = "iris", data = iris)

# a60
readLines(file.path(dir, "iris.csv"), n = 10) |> writeLines()

# a70
dp2 <- open_datapackage(dir)
iris2 <- dp2 |> dp_resource("iris") |> dp_get_data(convert_categories = "to_factor")
all.equal(iris, iris2, check.attributes = FALSE)

# c00
data(chickwts)

res <- dp_generate_dataresource(chickwts, "chickwts") 
dp_resources(dp) <- res

(feed_name <- dp_resource(dp, "chickwts") |> 
  dp_field("feed") |> dp_property("categories"))

# c01
res <- dp_generate_dataresource(chickwts, "chickwts", 
  categories_type = "resource") 
dp_resources(dp) <- res

(feed_name <- dp_resource(dp, "chickwts") |> 
  dp_field("feed") |> dp_property("categories"))

# c02
dp_write_data(dp_resource(dp, "chickwts"), data = chickwts, write_categories = TRUE)
list.files(dir)

dp_resource(dp, "feed-categories") |> dp_get_data()

# c10
codelist <- data.frame(
  value = c(101, 102, 103, 202, 203, 204),
  label = c("casein", "horsebean", "linseed", "meatmeal", 
    "soybean", "sunflower")
)
res <- dp_generate_dataresource(codelist, "feed-categories")
res
dp_resources(dp) <- res

codelistres <- dp |> dp_resource("feed-categories")
dp_write_data(codelistres, data = codelist, write_categories = FALSE)

# c20
readLines(file.path(dir, "feed-categories.csv")) |> writeLines()

# c30
dp_write_data(dp, resourcename = "chickwts", data = chickwts, write_categories = FALSE)

# c40
readLines(file.path(dir, "chickwts.csv"), n = 10) |> writeLines()

# e00
edit <- open_datapackage(dir, readonly = FALSE)
 
dp_id(edit) <- "iris_chkwts"
dp_created(edit) <- Sys.time() |> as.Date()

# e10
readLines(file.path(dir, "datapackage.json")) |> writeLines()

# cleanup
file.remove(list.files(dir, full.names = TRUE)) 
file.remove(dir)

