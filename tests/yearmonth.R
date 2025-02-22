
library(datapackage)
source("helpers.R")

# === NO FORMAT
fielddescriptor <- list(
  name = "yearmonth",
  title = "A yearmonth field",
  description = "A description",
  type = "yearmonth"
)
res <- to_yearmonth(c("2020-01", "202212", "", NA), 
  fielddescriptor = fielddescriptor)
expect_equal(res, as.Date(c("2020-01-01", "2022-12-01", NA, NA)), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
suppressWarnings(expect_error(
  to_datetime(c("2022 01", "2024 01", "", NA), fielddescriptor = fielddescriptor)
))

# === NO FIELDDESCRIPTOR
fielddescriptor <- list(
  type = "yearmonth"
)
res <- to_yearmonth(c("2020-01", "202212", "", NA))
expect_equal(res, as.Date(c("2020-01-01", "2022-12-01", NA, NA)), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
suppressWarnings(expect_error(
  to_datetime(c("2022 01", "2024 01", "", NA), fielddescriptor = fielddescriptor)
))

# === MISSINGVALUES
fielddescriptor <- list(
  name = "yearmonth",
  title = "A yearmonth field",
  description = "A description",
  type = "yearmonth",
  missingValues = "0000-00"
)
res <- to_yearmonth(c("2020-01", "202212", "0000-00", NA), 
  fielddescriptor = fielddescriptor)
expect_equal(res, as.Date(c("2020-01-01", "2022-12-01", NA, NA)), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
suppressWarnings(expect_error(
  res <- to_yearmonth(c("2020-01", "202212", "-------", NA), 
    fielddescriptor = fielddescriptor)
))




# === NUMERIC
res <- to_yearmonth(197001)
expect_equal(res, as.Date("1970-01-01"), attributes = FALSE)
expect_attribute(res, "fielddescriptor", list(type = "yearmonth"))


# === DATE
res <- to_yearmonth(as.Date("1980-01-06"))
expect_equal(res, as.Date("1980-01-01"), attributes = FALSE)
expect_attribute(res, "fielddescriptor", list(type = "yearmonth"))

# === TIME
res <- to_yearmonth(as.POSIXct("1980-01-06 14:15"))
expect_equal(res, as.Date("1980-01-01"), attributes = FALSE)
expect_attribute(res, "fielddescriptor", list(type = "yearmonth"))
res <- to_yearmonth(as.POSIXlt("1980-01-06 14:15"))
expect_equal(res, as.Date("1980-01-01"), attributes = FALSE)
expect_attribute(res, "fielddescriptor", list(type = "yearmonth"))


# =============================================================================
# csv_colclass
res <- datapackage:::csv_colclass_yearmonth() 
expect_equal(res, "character")

res <- datapackage:::csv_colclass(list(type = "yearmonth")) 
expect_equal(res, "character")


# =============================================================================
# csv_format

res <- datapackage:::csv_format_yearmonth(as.Date("2020-01-01"))
expect_equal(res, "2020-01")

res <- datapackage:::csv_format_yearmonth(as.Date("2020-01-05"))
expect_equal(res, "2020-01")

fielddescriptor <- list(
    type = "yearmonth",
    missingValues = c("0000-00", "-------")
  )
res <- datapackage:::csv_format_yearmonth(as.Date(c("2020-01-01", NA)), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c("2020-01", "0000-00"))

