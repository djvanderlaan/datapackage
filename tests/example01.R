library(datapackage)
source("helpers.R")

dir <- system.file("tests/test01", package = "datapackage")
if (dir == "") dir <- "../inst/tests/test01"

dp <- open_datapackage(dir)

expect_equal(dp_name(dp), "test01")
expect_equal(dp_title(dp), "Test datapackage 01")
expect_equal(dp_description(dp), "A data package to test if tooling functions correctly")
expect_equal(dp_resource_names(dp), c("complex", "complex-empty", "codelist-factor1", 
    "codelist-factor2", "inline", "fixed-width", "fixed-width-latin1"))

res <- dp_resource(dp, "complex")
expect_equal(dp_path(res), "complex.csv")
expect_equal(dp_encoding(res), "utf-8")
expect_equal(dp_mediatype(res), "text/csv")
expect_equal(dp_format(res), "csv")
expect_equal(dp_field_names(res), c("string1", "integer1", "boolean1", 
    "number1", "number2", "boolean2", "date1", "factor1", "factor2"))

dta <- dp_get_data(res)
expect_equal(sapply(dta, class), 
  c(string1 = "character", integer1 = "integer", boolean1 = "logical", 
  number1 = "numeric", number2 = "numeric", boolean2 = "logical", 
  date1 = "Date", factor1 = "integer", factor2 = "character")
)
dta_test <- readRDS(file.path(dir, "complex.RDS"))
expect_equal(dta_test, dta, attributes = FALSE)


expect_equal(dp_to_factor(dta$factor1), 
  factor(c(1,2,1,3,NA,3), levels=1:4, labels=c("Purple", "Red", "Other", "Not given")),
  attributes = FALSE
)

dta <- dp_get_data(res, convert_categories = "to_factor")
# We expect that other fields than the factor fields are ok; we tested that
# previously. Here test only the factor variables
expect_equal(dta$factor1, 
  factor(c(1,2,1,3,NA,3), levels=1:4, labels=c("Purple", "Red", "Other", "Not given")),
  attributes = FALSE
)
stopifnot(!is.null(attr(dta$factor1, "fielddescriptor")))
expect_equal(dta$factor2, 
  factor(c(1,2,1,3,2,NA), levels=1:3, labels=c("circle", "square", "triangle")),
  attributes = FALSE
)
stopifnot(!is.null(attr(dta$factor2, "fielddescriptor")))


# =============================================================================
# Test the empty dataset
dta <- dp |> dp_resource("complex-empty") |> dp_get_data()
expect_equal(class(dta), "data.frame")
expect_equal(nrow(dta), 0)
expect_equal(sapply(dta, class), 
  c(string1 = "character", integer1 = "integer", boolean1 = "logical", 
  number1 = "numeric", number2 = "numeric", boolean2 = "logical", 
  date1 = "Date", factor1 = "integer", factor2 = "character")
)

dta <- dp |> dp_resource("complex-empty") |> dp_get_data(convert_categories = "to_factor")
# We expect that other fields than the factor fields are ok; we tested that
# previously. Here test only the factor variables
expect_equal(dta$factor1, 
  factor(integer(0), levels=1:4, labels=c("Purple", "Red", "Other", "Not given")),
  attributes = FALSE
)
stopifnot(!is.null(attr(dta$factor1, "fielddescriptor")))
expect_equal(dta$factor2, 
  factor(integer(0), levels=1:3, labels=c("circle", "square", "triangle")),
  attributes = FALSE
)
stopifnot(!is.null(attr(dta$factor2, "fielddescriptor")))

