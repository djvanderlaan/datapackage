library(datapackage)
source("helpers.R")


fielddescriptor <- list(
  name = "date",
  title = "A date field",
  description = "A description",
  type = "date"
)
res <- to_date(c("2020-01-01", "2022-12-31", "", NA), fielddescriptor = fielddescriptor)
expect_equal(res, as.Date(c("2020-01-01", "2022-12-31", NA, NA)), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
expect_error(
  to_date(c("20200101", "20221231", "", NA), fielddescriptor = fielddescriptor)
)

fielddescriptor <- list(
  name = "date",
  title = "A date field",
  description = "A description",
  type = "date",
  format = "default"
)
res <- to_date(c("2020-01-01", "2022-12-31", "", NA), fielddescriptor = fielddescriptor)
expect_equal(res, as.Date(c("2020-01-01", "2022-12-31", NA, NA)), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
expect_error(
  to_date(c("20200101", "20221231", "", NA), fielddescriptor = fielddescriptor)
)

fielddescriptor <- list(
  name = "date",
  title = "A date field",
  description = "A description",
  type = "date",
  format = "any"
)
res <- to_date(c("2020-01-01", "2022-12-31", "", NA), fielddescriptor = fielddescriptor)
expect_equal(res, as.Date(c("2020-01-01", "2022-12-31", NA, NA)), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
expect_error(
  to_date(c("20200101", "20221231", "", NA), fielddescriptor = fielddescriptor)
)

fielddescriptor <- list(
  name = "date",
  title = "A date field",
  description = "A description",
  type = "date",
  format = "%Y%m%d"
)
res <- to_date(c("20200101", "20221231", "", NA), fielddescriptor = fielddescriptor)
expect_equal(res, as.Date(c("2020-01-01", "2022-12-31", NA, NA)), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
expect_error(
  to_date(c("2020-01-01", "2022-12-31", "", NA), fielddescriptor = fielddescriptor)
)


# === No Schema
fielddescriptor <- list(
  type = "date"
)
res <- to_date(c("2020-01-01", "2022-12-31", "", NA))
expect_equal(res, as.Date(c("2020-01-01", "2022-12-31", NA, NA)), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
expect_error(
  to_date(c("20200101", "20221231", "", NA), fielddescriptor = fielddescriptor)
)

# === NA
fielddescriptor <- list(
  name = "date",
  missingValues = c("--")
)
res <- to_date(c("2020-01-01","--", "2022-12-31", NA), fielddescriptor)
expect_equal(res, as.Date(c("2020-01-01", NA, "2022-12-31", NA)), attributes = FALSE)
expect_error(res <- to_date(c("2020-01-01","---", "2022-12-31", NA), fielddescriptor))

# =============================================================================
# csv_colclass
#TODO
#res <- csv_colclass_date(list()) 
#expect_equal(res, "character")
#res <- csv_colclass_date(list(missingValues = "--")) 
#expect_equal(res, "character")

# =============================================================================
# csv_format
#res <- csv_format_date(as.Date(c("2020-01-01", "2022-12-21", NA, NA)))
#expect_equal(res, c("2020-01-01", "2022-12-21", NA, NA), attributes = FALSE)
#
#fielddescriptor <- list(
#  type = "date",
#  format = "%Y%m%d"
#)
#res <- csv_format_date(as.Date(c("2020-01-01", "2022-12-21", NA, NA)), fielddescriptor = fielddescriptor)
#expect_equal(res, c("20200101", "20221221", NA, NA), attributes = FALSE)
