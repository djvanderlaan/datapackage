library(datapackage)
source("helpers.R")

# === DEFAULT
fielddescriptor <- list(
  name = "year",
  title = "A year field",
  description = "A description",
  type = "year"
)
res <- dp_to_year(c("2020", "-4", "", NA), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c(2020, -4, NA, NA), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
suppressWarnings(expect_error(
  to_datetime(c("2022.25", "", NA), fielddescriptor = fielddescriptor)
))

# === NO FIELDDESCRIPTOR
fielddescriptor <- list(
  type = "year"
)
res <- dp_to_year(c("2020", "-4", "", NA))
expect_equal(res, c(2020, -4, NA, NA), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
suppressWarnings(expect_error(
  to_datetime(c("2022.25", "", NA), fielddescriptor = fielddescriptor)
))

# === MISSINGVALUES
fielddescriptor <- list(
  name = "year",
  title = "A year field",
  description = "A description",
  type = "year",
  missingValues = c("0", "-")
)
res <- dp_to_year(c("2020", "-4", "-", NA), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c(2020, -4, NA, NA), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
suppressWarnings(expect_error(
  to_datetime(c("2022.25", "", NA), fielddescriptor = fielddescriptor)
))


# === NUMERIC
res <- dp_to_year(1970)
expect_equal(res, 1970L, attributes = FALSE)
expect_attribute(res, "fielddescriptor", list(type = "year"))


# === DATE
res <- dp_to_year(as.Date("1980-01-06"))
expect_equal(res, 1980L, attributes = FALSE)
expect_attribute(res, "fielddescriptor", list(type = "year"))

# === TIME
res <- dp_to_year(as.POSIXct("1980-01-06 14:15"))
expect_equal(res, 1980L, attributes = FALSE)
expect_attribute(res, "fielddescriptor", list(type = "year"))
res <- dp_to_year(as.POSIXlt("1980-01-06 14:15"))
expect_equal(res, 1980L, attributes = FALSE)
expect_attribute(res, "fielddescriptor", list(type = "year"))


# =============================================================================
# csv_colclass
res <- datapackage:::csv_colclass_year() 
expect_equal(res, "integer")

res <- datapackage:::csv_colclass(list(type = "year")) 
expect_equal(res, "integer")

res <- datapackage:::csv_colclass(list(type = "year", missingValues = "X")) 
expect_equal(res, "character")



# =============================================================================
# csv_format

res <- datapackage:::csv_format_year(c(2020, NA))
expect_equal(res, c(2020, NA))

res <- datapackage:::csv_format_year(c(2020, NA),
  fielddescriptor = list(missingValues = c("X", "0")))
expect_equal(res, c("2020", "X"))


