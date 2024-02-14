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




parquet_reader <- function(path, resource, to_factor = FALSE, as_connection = FALSE, ...) {
  print(as_connection)
  schema <- dpschema(resource)
  if (is.null(schema)) {
    dta <- arrow::read_parquet(path, as_data_frame = !s_connection, ...)
  } else {
    dta <- arrow::read_parquet(path, as_data_frame = !as_connection, ...)
    if (as_connection) {
      # Check if parquet file is valid
      # First try to convert the first few rows; this should already catch quite a few
      # possiblee issues; e.g. levels of factor not matching code list
      tmp <- dta$Take(1) |> as.data.frame()
      tmp <- dpapplyschema(tmp, resource, to_factor = to_factor)
      # However, we also want an integer column to be numeric etc. dpapplyschema will
      # accept character for most fields.
      for (fieldname in dpfieldnames(schema)) {
        field <- dpfield(schema, fieldname)
        type  <- dpproperty(field, "type")
        class <- class(tmp[[fieldname]])
        if (is.factor(tmp[[fieldname]]) && !is.null(dpproperty(field, "codelist"))) {
          # this is ok
        } else if (type == "boolean") {
          if (!is(tmp[[fieldname]], "logical"))
            stop("Field '", fieldname, "' is of wrong type. Should be a logical")
        } else if (type == "date") {
          if (!is(tmp[[fieldname]], "Date"))
            stop("Field '", fieldname, "' is of wrong type. Should be a Date.")
        } else if (type == "integer") {
          if (!is(tmp[[fieldname]], "integer"))
            stop("Field '", fieldname, "' is of wrong type. Should be an integer.")
        } else if (type == "number") {
          if (!is(tmp[[fieldname]], "numeric"))
            stop("Field '", fieldname, "' is of wrong type. Should be an numeric")
        } else if (type == "string") {
          if (!is(tmp[[fieldname]], "character"))
            stop("Field '", fieldname, "' is of wrong type. Should be an character")
        }
      }
    } else {
      dta <- dpapplyschema(dta, resource, to_factor = to_factor)
    }
  }
  structure(dta, resource = resource)
}


parquet_reader0 <- function(path, resource, to_factor = FALSE, ...) {
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


iris2 <- dpgetdata(dp, "iris2", reader = parquet_reader, to_factor = FALSE)
iris2 |> head()

# This solution with do_integer.factor is inefficient. Now the column is first 
# converted from factor to integer and then back to factor.
# Better would be, in case of `to_factor = TRUE` to check if the levels match 
# those of the code list and if so do nothing. If not, there should be an error.
iris2 <- dpgetdata(dp, "iris2", reader = parquet_reader, to_factor = TRUE)
iris2 |> head()



# ================== READ AS CONNECTION


# ERROR: doesn't work as to_number etc don't work on parquet column (ChunkedArray)
#iris <- dpgetdata(dp, "iris", reader = parquet_reader, to_factor = TRUE, as_data_frame = FALSE)

tmp <- read_parquet("work/iris_parquet/iris2.parquet", as_data_frame = FALSE)
h <- tmp$Take(1) |> as.data.frame()
levels(h$Species)


iris <- dpgetdata(dp, "iris", reader = parquet_reader, to_factor = TRUE, as_connection = TRUE)
iris$Take(1:10) |> as.data.frame()

iris <- dpgetdata(dp, "iris", reader = parquet_reader, to_factor = FALSE, as_connection = TRUE)
iris$Take(1:10) |> as.data.frame()

iris <- dpgetdata(dp, "iris2", reader = parquet_reader, to_factor = FALSE, as_connection = TRUE)
iris$Take(1:10) |> as.data.frame()

iris <- dpgetdata(dp, "iris2", reader = parquet_reader, to_factor = TRUE, as_connection = TRUE)
iris$Take(1:10) |> as.data.frame()

iris <- dpgetconnection(dp, "iris", reader = parquet_reader, to_factor = TRUE)
iris$Take(1:10) |> as.data.frame()

iris <- dpgetconnection(dp, "iris", reader = parquet_reader, to_factor = FALSE)
iris$Take(1:10) |> as.data.frame()

iris <- dpgetconnection(dp, "iris2", reader = parquet_reader, to_factor = FALSE)
iris$Take(1:10) |> as.data.frame()

iris <- dpgetconnection(dp, "iris2", reader = parquet_reader, to_factor = TRUE)
iris$Take(1:10) |> as.data.frame()

a <- data.frame(a=1:4, b = letters[1:4], c=factor(LETTERS[1:4]))
a <- a[rep(1:4, 1000), ]

write_parquet(a, sink = "work/test.parquet")
ap <- read_parquet("work/test.parquet", as_data_frame = FALSE)
ap

write_parquet(a, sink = "work/test.parquet", use_dictionary = FALSE)
ap <- read_parquet("work/test.parquet", as_data_frame = FALSE)
ap

ap$Take(1) |> as.data.frame()

