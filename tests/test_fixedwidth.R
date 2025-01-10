library(datapackage)
source("helpers.R")

dir <- system.file("tests/test01", package = "datapackage")
if (dir == "") dir <- "../inst/tests/test01"

dp <- opendatapackage(dir)

res <- dp_resource(dp, "fixed-width")
dta <- dp_get_data(res)
expect_equal(dta$foo, 1:4, attributes = FALSE)
expect_equal(dta$bar, c(12.34, 1.00, 5.66, 4.55), 
  attributes = FALSE)
expect_equal(dta$date, 
  as.Date(c("2023-10-23", "2023-09-05", "2020-06-10", "2022-12-12")), 
  attributes = FALSE)
expect_equal(dta$name, c("jan", "pier", "tjorrès", "cornee"), 
  attributes = FALSE)

res <- dp_resource(dp, "fixed-width-latin1")
dta <- dp_get_data(res)
expect_equal(dta$foo, 1:4, attributes = FALSE)
expect_equal(dta$bar, c(12.34, 1.00, 5.66, 4.55), 
  attributes = FALSE)
expect_equal(dta$date, 
  as.Date(c("2023-10-23", "2023-09-05", "2020-06-10", "2022-12-12")), 
  attributes = FALSE)
expect_equal(dta$name, c("jan", "pier", "tjorrès", "cornee"), 
  attributes = FALSE)

# Alternative name for encoding
dp_property(res, "encoding") <- "CP-1252"
expect_warning(dta <- dp_get_data(res))
expect_equal(dta$name, c("jan", "pier", "tjorrès", "cornee"), 
  attributes = FALSE)

# Alternative name for encoding
dp_property(res, "encoding") <- "Windows-1252"
expect_warning(dta <- dp_get_data(res))
expect_equal(dta$name, c("jan", "pier", "tjorrès", "cornee"), 
  attributes = FALSE)

# Alternatice for format
res <- dp_resource(dp, "fixed-width")
dp_property(res, "format") <- "fwf"
dta <- dp_get_data(res)
expect_equal(dta$name, c("jan", "pier", "tjorrès", "cornee"), 
  attributes = FALSE)
dp_property(res, "format") <- "asc"
dta <- dp_get_data(res)
expect_equal(dta$name, c("jan", "pier", "tjorrès", "cornee"), 
  attributes = FALSE)

# No format should also work and use mediatype
dp_property(res, "format") <- NULL
dta <- dp_get_data(res)
expect_equal(dta$name, c("jan", "pier", "tjorrès", "cornee"), 
  attributes = FALSE)

# No format or mediatype should also work and use extension
dp_property(res, "format") <- NULL
dp_property(res, "mediatype") <- NULL
dta <- dp_get_data(res)
expect_equal(dta$name, c("jan", "pier", "tjorrès", "cornee"), 
  attributes = FALSE)

# Invalid format should give error
dp_property(res, "format") <- "nonexistingformat"
expect_error(dta <- dp_get_data(res))

