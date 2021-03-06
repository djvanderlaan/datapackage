library(testthat)
library(datapackage)

expect_that(datapackage:::cast_column_date("2010-10-12"), 
  equals(as.Date("2010-10-12")))
expect_that(datapackage:::cast_column_date("12-10-2010", list(format="dd-mm-yyyy")), 
  equals(as.Date("2010-10-12")))
expect_that(datapackage:::cast_column_date("20101012", list(format="yyyymmdd")), 
  equals(as.Date("2010-10-12")))
expect_that(datapackage:::cast_column_date("10/12/2010", list(format="mm/dd/yyyy")), 
  equals(as.Date("2010-10-12")))
expect_that(datapackage:::cast_column_date("2010-10", list(format="yyyy-mm")), 
  equals(as.Date("2010-10-01")))
expect_that(datapackage:::cast_column_date("2010", list(format="yyyy")), 
  equals(as.Date("2010-01-01")))
expect_that(datapackage:::cast_column_date(c("2010-10-12", NA)), 
  equals(as.Date(c("2010-10-12", NA))))

date <- as.Date(c("2010-10-12", NA))
expect_that(datapackage:::format_column_date(date, list()), equals(c("\"2010-10-12\"", "")))
expect_that(datapackage:::format_column_date(date, list(format="yyyy")), equals(c("\"2010\"", "")))
expect_that(datapackage:::format_column_date(date, list(format="dd/mm/yyyy")), equals(c("\"12/10/2010\"", "")))
expect_that(datapackage:::format_column_date(date, list(format="yyyymmdd")), equals(c("\"20101012\"", "")))

expect_that(datapackage:::ft_is_date(date),equals(list(type="date")))
expect_that(datapackage:::ft_is_date(c(0,0)),equals(NULL))

# regression test: error when first date is an empty string
d <- datapackage:::cast_column_date(c("", "2010-11-12"), list(format=""))
# regression test: error when format missing from meta
d <- datapackage:::cast_column_date(c("", "2010-11-12"), list())

