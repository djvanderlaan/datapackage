library(datapackage)
library(arrow)

file.remove(list.files("work/iris_parquet", full.names = TRUE))
file.remove("work/iris_parquet")

data(iris)

dp <- newdatapackage(path = "work/iris_parquet", name = "iris")

res <- dpgeneratedataresources(iris, "iris")

dpresources(dp) <- res

dpwritedata(dp, resourcename = "iris", data = iris)

tmp <- read.csv("work/iris_parquet/iris.csv")
write_parquet(tmp, sink = "work/iris_parquet/iris.parquet")

res <- dpresource(dp, "iris")
dpformat(res) <- "parquet"
dppath(res) <- "iris.parquet"
dpresource(dp, "iris") <- res

res <- dpresource(dp, "iris")
dpname(res) <- "iris2"
dppath(res) <- "iris2.parquet"
dpresource(dp, "iris2") <- res
write_parquet(iris, "work/iris_parquet/iris2.parquet")




parquet_reader <- function(path, resource, to_factor = FALSE, ...) {
  schema <- dpschema(resource)
  if (is.null(schema)) {
    dta <- arrow::read_parquet(path, ...)
  } else {
    dta <- arrow::read_parquet(path, ...)
    dta <- dpapplyschema(dta, resource, to_factor = to_factor)
  }
  structure(dta, resource = resource)
}

dp <- opendatapackage("work/iris_parquet")
dp

iris <- dpgetdata(dp, "iris", reader = parquet_reader, to_factor = FALSE)
iris |> head()

iris <- dpgetdata(dp, "iris", reader = parquet_reader, to_factor = TRUE)
iris |> head()

to_integer.factor <- function(x, schema = list(), ...) {
  schema <- complete_schema_integer(schema)
  codelist <- dpcodelist(schema)
  if (is.null(codelist)) {
    x <- as.integer(x)
  } else {
    na <- is.na(x)
    res <- match(x, codelist[[2]])
    wrong <- is.na(res) & !na
    if (any(wrong)) {
      wrong <- unique(x[wrong])
      wrong <- paste0("'", wrong, "'")
      if (length(wrong) > 5) 
        wrong <- c(utils::head(wrong, 5), "...")
      stop("Invalid values found in x: ", paste0(wrong, collapse = ","))
    }
    x <- res
  }
  structure(x, fielddescriptor = schema)
}

iris2 <- dpgetdata(dp, "iris2", reader = parquet_reader, to_factor = FALSE)
iris2 |> head()

# This solution with do_integer.factor is inefficient. Now the column is first 
# converted from factor to integer and then back to factor.
# Better would be, in case of `to_factor = TRUE` to check if the levels match 
# those of the code list and if so do nothing. If not, there should be an error.
iris2 <- dpgetdata(dp, "iris2", reader = parquet_reader, to_factor = TRUE)
iris2 |> head()



# ================== READ AS CONNECTION


iris <- dpgetdata(dp, "iris", reader = parquet_reader, to_factor = TRUE, as_data_frame = FALSE)

library(dplyr)
tmp <- read_parquet("work/iris_parquet/iris2.parquet", as_data_frame = FALSE)
tmp |> slice_head(n = 1) |> collect() |> (\(x) levels(x$Species))()

# Kan ook zonder dplyr
tmp$Take(1) |> as.data.frame()


a <- data.frame(a=1:4, b = letters[1:4], c=factor(LETTERS[1:4]))
a <- a[rep(1:4, 1000), ]

write_parquet(a, sink = "work/test.parquet")
ap <- read_parquet("work/test.parquet", as_data_frame = FALSE)
ap

write_parquet(a, sink = "work/test.parquet", use_dictionary = FALSE)
ap <- read_parquet("work/test.parquet", as_data_frame = FALSE)
ap

ap$Take(1) |> as.data.frame()

