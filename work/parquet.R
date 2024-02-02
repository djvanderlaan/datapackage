library(datapackage)
library(arrow)

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

iris <- dpgetdata(dp, "iris", reader = parquet_reader, to_factor = TRUE)

iris <- dpgetdata(dp, "iris", reader = parquet_reader, to_factor = TRUE, as_data_frame = FALSE)

fielddescriptor <- dpfield(dp |> dpresource("iris"), "Species")

codelist <- dpcodelist(fielddescriptor)
 
m <- match(iris$Species, codelist[[2]])
m

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

foo <- factor(c(1,2,3,3), levels = 1:4, labels = c("virginica", "setosa", "versicolor", "foo"))
to_integer.factor(foo, fielddescriptor) |> dptofactor()

to_integer(iris$Species, fielddescriptor)

