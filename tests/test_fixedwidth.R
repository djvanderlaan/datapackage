library(datapackage)
source("helpers.R")

dir <- system.file("tests/test01", package = "datapackage")
if (dir == "") dir <- "../inst/tests/test01"

dp <- opendatapackage(dir)

res <- dpresource(dp, "fixed-width")
dta <- dpgetdata(res)
expect_equal(dta$foo, 1:4, attributes = FALSE)
expect_equal(dta$bar, c(12.34, 1.00, 5.66, 4.55), 
  attributes = FALSE)
expect_equal(dta$date, 
  as.Date(c("2023-10-23", "2023-09-05", "2020-06-10", "2022-12-12")), 
  attributes = FALSE)
expect_equal(dta$name, c("jan", "pier", "tjorrès", "cornee"), 
  attributes = FALSE)

res <- dpresource(dp, "fixed-width-latin1")
dta <- dpgetdata(res)
expect_equal(dta$foo, 1:4, attributes = FALSE)
expect_equal(dta$bar, c(12.34, 1.00, 5.66, 4.55), 
  attributes = FALSE)
expect_equal(dta$date, 
  as.Date(c("2023-10-23", "2023-09-05", "2020-06-10", "2022-12-12")), 
  attributes = FALSE)
expect_equal(dta$name, c("jan", "pier", "tjorrès", "cornee"), 
  attributes = FALSE)

# Alternative name for encoding
dpproperty(res, "encoding") <- "CP-1252"
expect_warning(dta <- dpgetdata(res))
expect_equal(dta$name, c("jan", "pier", "tjorrès", "cornee"), 
  attributes = FALSE)

# Alternative name for encoding
dpproperty(res, "encoding") <- "Windows-1252"
expect_warning(dta <- dpgetdata(res))
expect_equal(dta$name, c("jan", "pier", "tjorrès", "cornee"), 
  attributes = FALSE)

# Alternatice for format
res <- dpresource(dp, "fixed-width")
dpproperty(res, "format") <- "fwf"
dta <- dpgetdata(res)
expect_equal(dta$name, c("jan", "pier", "tjorrès", "cornee"), 
  attributes = FALSE)
dpproperty(res, "format") <- "asc"
dta <- dpgetdata(res)
expect_equal(dta$name, c("jan", "pier", "tjorrès", "cornee"), 
  attributes = FALSE)

# No format should also work and use mediatype
dpproperty(res, "format") <- NULL
dta <- dpgetdata(res)
expect_equal(dta$name, c("jan", "pier", "tjorrès", "cornee"), 
  attributes = FALSE)

# No format or mediatype should also work and use extension
dpproperty(res, "format") <- NULL
dpproperty(res, "mediatype") <- NULL
dta <- dpgetdata(res)
expect_equal(dta$name, c("jan", "pier", "tjorrès", "cornee"), 
  attributes = FALSE)

# Invalid format should give error
dpproperty(res, "format") <- "nonexistingformat"
expect_error(dta <- dpgetdata(res))

