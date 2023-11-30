library(datapackage)
source("helpers.R")

dir <- system.file("tests/test01", package = "datapackage")
if (dir == "") dir <- "../inst/tests/test01"

dp <- opendatapackage(dir)

expect_equal(dpname(dp), "test01")
expect_equal(dptitle(dp), "Test datapackage 01")
expect_equal(dpdescription(dp), "A data package to test if tooling functions correctly")
expect_equal(dpresourcenames(dp), c("complex", "complex-empty", "codelist-factor1", 
    "codelist-factor2", "inline", "fixed-width"))

res <- dpresource(dp, "complex")
expect_equal(dppath(res), "complex.csv")
expect_equal(dpencoding(res), "utf-8")
expect_equal(dpmediatype(res), "text/csv")
expect_equal(dpformat(res), "csv")
expect_equal(dpfieldnames(res), c("string1", "integer1", "boolean1", 
    "number1", "number2", "boolean2", "date1", "factor1", "factor2"))

dta <- dpgetdata(res)
expect_equal(sapply(dta, class), 
  c(string1 = "character", integer1 = "integer", boolean1 = "logical", 
  number1 = "numeric", number2 = "numeric", boolean2 = "logical", 
  date1 = "Date", factor1 = "integer", factor2 = "character")
)
dta_test <- readRDS(file.path(dir, "complex.RDS"))
expect_equal(dta_test, dta, attributes = FALSE)


expect_equal(dptofactor(dta$factor1), 
  factor(c(1,2,1,3,NA,3), levels=1:4, labels=c("Purple", "Red", "Other", "Not given")),
  attributes = FALSE
)

dta <- dpgetdata(res, to_factor = TRUE)
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
dta <- dp |> dpresource("complex-empty") |> dpgetdata()
expect_equal(class(dta), "data.frame")
expect_equal(nrow(dta), 0)
expect_equal(sapply(dta, class), 
  c(string1 = "character", integer1 = "integer", boolean1 = "logical", 
  number1 = "numeric", number2 = "numeric", boolean2 = "logical", 
  date1 = "Date", factor1 = "integer", factor2 = "character")
)

dta <- dp |> dpresource("complex-empty") |> dpgetdata(to_factor = TRUE)
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

