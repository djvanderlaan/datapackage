library(datapackage)
source("helpers.R")


schema <- list(
  name = "date",
  title = "A date field",
  description = "A description",
  type = "date"
)
res <- to_date(c("2020-01-01", "2022-12-31", "", NA), schema = schema)
expect_equal(res, as.Date(c("2020-01-01", "2022-12-31", NA, NA)), attributes = FALSE)
expect_attribute(res, "fielddescriptor", schema)
expect_error(
  to_date(c("20200101", "20221231", "", NA), schema = schema)
)

schema <- list(
  name = "date",
  title = "A date field",
  description = "A description",
  type = "date",
  format = "default"
)
res <- to_date(c("2020-01-01", "2022-12-31", "", NA), schema = schema)
expect_equal(res, as.Date(c("2020-01-01", "2022-12-31", NA, NA)), attributes = FALSE)
expect_attribute(res, "fielddescriptor", schema)
expect_error(
  to_date(c("20200101", "20221231", "", NA), schema = schema)
)

schema <- list(
  name = "date",
  title = "A date field",
  description = "A description",
  type = "date",
  format = "any"
)
res <- to_date(c("2020-01-01", "2022-12-31", "", NA), schema = schema)
expect_equal(res, as.Date(c("2020-01-01", "2022-12-31", NA, NA)), attributes = FALSE)
expect_attribute(res, "fielddescriptor", schema)
expect_error(
  to_date(c("20200101", "20221231", "", NA), schema = schema)
)

schema <- list(
  name = "date",
  title = "A date field",
  description = "A description",
  type = "date",
  format = "%Y%m%d"
)
res <- to_date(c("20200101", "20221231", "", NA), schema = schema)
expect_equal(res, as.Date(c("2020-01-01", "2022-12-31", NA, NA)), attributes = FALSE)
expect_attribute(res, "fielddescriptor", schema)
expect_error(
  to_date(c("2020-01-01", "2022-12-31", "", NA), schema = schema)
)


# === No Schema
schema <- list(
  type = "date"
)
res <- to_date(c("2020-01-01", "2022-12-31", "", NA))
expect_equal(res, as.Date(c("2020-01-01", "2022-12-31", NA, NA)), attributes = FALSE)
expect_attribute(res, "fielddescriptor", schema)
expect_error(
  to_date(c("20200101", "20221231", "", NA), schema = schema)
)

# === NA
schema <- list(
  name = "date",
  missingValues = c("--")
)
res <- to_date(c("2020-01-01","--", "2022-12-31", NA), schema)
expect_equal(res, as.Date(c("2020-01-01", NA, "2022-12-31", NA)), attributes = FALSE)
expect_error(res <- to_date(c("2020-01-01","---", "2022-12-31", NA), schema))

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
#schema <- list(
#  type = "date",
#  format = "%Y%m%d"
#)
#res <- csv_format_date(as.Date(c("2020-01-01", "2022-12-21", NA, NA)), schema = schema)
#expect_equal(res, c("20200101", "20221221", NA, NA), attributes = FALSE)
