library(datapackage)
source("helpers.R")


fn <- tempfile()


# === SIMPLE EXAMPLE
csvdata <- "col1;col2
1;A
2;B"
resource <- list(
    path = fn,
    schema = list(
        fields = list(
            list(name = "col1", type = "integer"),
            list(name = "col2", type = "string")
          )
      ),
    dialect = list( 
        delimiter = ";",
        decimalChar = ","
      )
  )
resource <- structure(resource, class = "dataresource")
writeLines(csvdata, fn)
res <- csv_reader(fn, resource)
expect_equal(names(res), c("col1", "col2"))
expect_equal(res$col1, c(1L, 2L), attributes = FALSE)
expect_equal(res$col2, c("A", "B"), attributes = FALSE)

res <- csv_reader(fn, resource, use_fread = TRUE)
expect_equal(names(res), c("col1", "col2"))
expect_equal(res$col1, c(1L, 2L), attributes = FALSE)
expect_equal(res$col2, c("A", "B"), attributes = FALSE)

# === WEIRD COLUMN NAMES
# Regression test; col-1 -> col.1 
csvdata <- "col-1;column,number 2
1;A
2;B"
resource <- list(
    path = fn,
    schema = list(
        fields = list(
            list(name = "col-1", type = "integer"),
            list(name = "column,number 2", type = "string")
          )
      ),
    dialect = list( 
        delimiter = ";",
        decimalChar = ","
      )
  )
resource <- structure(resource, class = "dataresource")
writeLines(csvdata, fn)
res <- csv_reader(fn, resource)
expect_equal(names(res), c("col-1", "column,number 2"))
expect_equal(res[["col-1"]], c(1L, 2L), attributes = FALSE)
expect_equal(res[["column,number 2"]], c("A", "B"), attributes = FALSE)

res <- csv_reader(fn, resource, use_fread = TRUE)
expect_equal(names(res), c("col-1", "column,number 2"))
expect_equal(res[["col-1"]], c(1L, 2L), attributes = FALSE)
expect_equal(res[["column,number 2"]], c("A", "B"), attributes = FALSE)


# === INTEGER
csvdata <- "col1;col2
€1;FOO
2%;10"
resource <- list(
    path = fn,
    schema = list(
        fields = list(
            list(name = "col1", type = "integer", bareNumber = FALSE),
            list(name = "col2", type = "integer", missingValues = "FOO")
          )
      ),
    dialect = list( 
        delimiter = ";",
        decimalChar = ","
      )
  )
resource <- structure(resource, class = "dataresource")
writeLines(csvdata, fn)
res <- csv_reader(fn, resource)
expect_equal(names(res), c("col1", "col2"))
expect_equal(res$col1, c(1L, 2L), attributes = FALSE)
expect_equal(res$col2, c(NA_integer_, 10L), attributes = FALSE)

res <- csv_reader(fn, resource, use_fread = TRUE)
expect_equal(names(res), c("col1", "col2"))
expect_equal(res$col1, c(1L, 2L), attributes = FALSE)
expect_equal(res$col2, c(NA_integer_, 10L), attributes = FALSE)

# === nUMBER
csvdata <- "col1;col2
€1,15;FOO
2,50%;10 000,15"
resource <- list(
    path = fn,
    schema = list(
        fields = list(
            list(name = "col1", type = "number", bareNumber = FALSE),
            list(name = "col2", type = "number", 
              missingValues = "FOO", groupChar = " ")
          )
      ),
    dialect = list( 
        delimiter = ";",
        decimalChar = ","
      )
  )
resource <- structure(resource, class = "dataresource")
writeLines(csvdata, fn)
res <- csv_reader(fn, resource)
expect_equal(names(res), c("col1", "col2"))
expect_equal(res$col1, c(1.15, 2.5), attributes = FALSE)
expect_equal(res$col2, c(NA_integer_, 10000.15), attributes = FALSE)
res <- csv_reader(fn, resource, use_fread = TRUE)
expect_equal(names(res), c("col1", "col2"))
expect_equal(res$col1, c(1.15, 2.5), attributes = FALSE)
expect_equal(res$col2, c(NA_integer_, 10000.15), attributes = FALSE)



ignore <- file.remove(fn)
