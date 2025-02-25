library(datapackage)
source("helpers.R")


fielddescriptor <- list(
  name = "date",
  title = "A date field",
  description = "A description",
  type = "date"
)
res <- dp_to_date(c("2020-01-01", "2022-12-31", "", NA), fielddescriptor = fielddescriptor)
expect_equal(res, as.Date(c("2020-01-01", "2022-12-31", NA, NA)), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
expect_error(
  dp_to_date(c("20200101", "20221231", "", NA), fielddescriptor = fielddescriptor)
)

fielddescriptor <- list(
  name = "date",
  title = "A date field",
  description = "A description",
  type = "date",
  format = "default"
)
res <- dp_to_date(c("2020-01-01", "2022-12-31", "", NA), fielddescriptor = fielddescriptor)
expect_equal(res, as.Date(c("2020-01-01", "2022-12-31", NA, NA)), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
expect_error(
  dp_to_date(c("20200101", "20221231", "", NA), fielddescriptor = fielddescriptor)
)

fielddescriptor <- list(
  name = "date",
  title = "A date field",
  description = "A description",
  type = "date",
  format = "any"
)
res <- dp_to_date(c("2020-01-01", "2022-12-31", "", NA), fielddescriptor = fielddescriptor)
expect_equal(res, as.Date(c("2020-01-01", "2022-12-31", NA, NA)), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
expect_error(
  dp_to_date(c("20200101", "20221231", "", NA), fielddescriptor = fielddescriptor)
)

fielddescriptor <- list(
  name = "date",
  title = "A date field",
  description = "A description",
  type = "date",
  format = "%Y%m%d"
)
res <- dp_to_date(c("20200101", "20221231", "", NA), fielddescriptor = fielddescriptor)
expect_equal(res, as.Date(c("2020-01-01", "2022-12-31", NA, NA)), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
expect_error(
  dp_to_date(c("2020-01-01", "2022-12-31", "", NA), fielddescriptor = fielddescriptor)
)


# === No Schema
fielddescriptor <- list(
  type = "date"
)
res <- dp_to_date(c("2020-01-01", "2022-12-31", "", NA))
expect_equal(res, as.Date(c("2020-01-01", "2022-12-31", NA, NA)), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
expect_error(
  dp_to_date(c("20200101", "20221231", "", NA), fielddescriptor = fielddescriptor)
)

# === NA
fielddescriptor <- list(
  name = "date",
  missingValues = c("--")
)
res <- dp_to_date(c("2020-01-01","--", "2022-12-31", NA), fielddescriptor)
expect_equal(res, as.Date(c("2020-01-01", NA, "2022-12-31", NA)), attributes = FALSE)
expect_error(res <- dp_to_date(c("2020-01-01","---", "2022-12-31", NA), fielddescriptor))

# =============================================================================
# csv_colclass

res <- datapackage:::csv_colclass_date(list()) 
expect_equal(res, "character")

res <- datapackage:::csv_colclass_date(list(missingValues = "--")) 
expect_equal(res, "character")

# =============================================================================
# csv_format

res <- datapackage:::csv_format_date(
  as.Date(c("2020-01-01", "2022-12-21", NA, NA)))
expect_equal(res, c("2020-01-01", "2022-12-21", NA, NA))

fielddescriptor <- list(
  type = "date",
  format = "%Y%m%d"
)
res <- datapackage:::csv_format_date(
  as.Date(c("2020-01-01", "2022-12-21", NA, NA)), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c("20200101", "20221221", NA, NA))

fielddescriptor <- list(
  type = "date",
  format = "any"
)
res <- datapackage:::csv_format_date(
  as.Date(c("2020-01-01", "2022-12-21", NA, NA)), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c("2020-01-01", "2022-12-21", NA, NA))

fielddescriptor <- list(
  type = "date",
  format = "default",
  missingValues = c("--")
)
res <- datapackage:::csv_format_date(
  as.Date(c("2020-01-01", "2022-12-21", NA, NA)), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c("2020-01-01", "2022-12-21", "--", "--"))


