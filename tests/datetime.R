library(datapackage)
source("helpers.R")

# === NO FORMAT
fielddescriptor <- list(
  name = "datetime",
  title = "A datetime field",
  description = "A description",
  type = "datetime"
)
res <- dp_to_datetime(c("2020-01-01T12:13", "2022-12-31T12:13:14,15", "", NA), 
  fielddescriptor = fielddescriptor)
expect_equal(res, as.POSIXct(c("2020-01-01 12:13:00", "2022-12-31 12:13:14.15", NA, NA)), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
suppressWarnings(expect_error(
  dp_to_datetime(c("2022/01/01 14:12", "2024/01/31 12:23:12", "", NA), fielddescriptor = fielddescriptor)
))

# === DEFAULT FORMAT
fielddescriptor <- list(
  name = "datetime",
  title = "A datetime field",
  description = "A description",
  type = "datetime",
  format = "default"
)
res <- dp_to_datetime(c("2020-01-01T12:13", "2022-12-31T12:13:14,15", "", NA), 
  fielddescriptor = fielddescriptor)
expect_equal(res, as.POSIXct(c("2020-01-01 12:13:00", "2022-12-31 12:13:14.15", NA, NA)), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
suppressWarnings(expect_error(
  dp_to_datetime(c("2022/01/01 14:12", "2024/01/31 12:23:12", "", NA), fielddescriptor = fielddescriptor)
))

# === ANY FORMAT
fielddescriptor <- list(
  name = "datetime",
  title = "A datetime field",
  description = "A description",
  type = "datetime",
  format = "any"
)
res <- dp_to_datetime(c("2020/01/01 12:13", "2022/12/31 12:13:14,15", "", NA), 
  fielddescriptor = fielddescriptor)
expect_equal(res, as.POSIXct(c("2020-01-01 12:13:00", "2022-12-31 12:13:14.15", NA, NA)), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)

# === %Y%M.. FORMAT
fielddescriptor <- list(
  name = "datetime",
  title = "A datetime field",
  description = "A description",
  type = "datetime",
  format = "%m/%d/%Y %H:%M:%S"
)
res <- dp_to_datetime(c("01/01/2020 12:13:00", "12/31/2022 12:13:14.15", "", NA), 
  fielddescriptor = fielddescriptor)
expect_equal(res, as.POSIXct(c("2020-01-01 12:13:00", "2022-12-31 12:13:14.15", NA, NA)), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
suppressWarnings(expect_error(
  dp_to_datetime(c("2022/01/01 14:12", "2024/01/31 12:23:12", "", NA), fielddescriptor = fielddescriptor)
))

# === NO FIELDDESCRIPTOR
fielddescriptor <- list(
  type = "datetime"
)
res <- dp_to_datetime(c("2020-01-01T12:13", "2022-12-31T12:13:14,15", "", NA))
expect_equal(res, as.POSIXct(c("2020-01-01 12:13:00", "2022-12-31 12:13:14.15", NA, NA)), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
suppressWarnings(expect_error(
  dp_to_datetime(c("2022/01/01 14:12", "2024/01/31 12:23:12", "", NA), fielddescriptor = fielddescriptor)
))


# === MISSINGVALUES
fielddescriptor <- list(
  name = "datetime",
  title = "A datetime field",
  description = "A description",
  type = "datetime",
  missingValues = "--"
)
res <- dp_to_datetime(c("2020-01-01T12:13", "2022-12-31T12:13:14,15", "--", NA), 
  fielddescriptor = fielddescriptor)
expect_equal(res, as.POSIXct(c("2020-01-01 12:13:00", "2022-12-31 12:13:14.15", NA, NA)), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
suppressWarnings(expect_error(
  res <- dp_to_datetime(c("2020-01-01T12:13", "2022-12-31T12:13:14,15", "", NA), 
    fielddescriptor = fielddescriptor)
))
suppressWarnings(expect_error(
  res <- dp_to_datetime(c("2020-01-01T12:13", "2022-12-31T12:13:14,15", "---", NA), 
    fielddescriptor = fielddescriptor)
))


# === NUMERIC
res <- dp_to_datetime(0)
expect_equal(res, as.POSIXct("1970-01-01 00:00:00", tz = "GMT"), attributes = FALSE)
expect_attribute(res, "fielddescriptor", list(type = "datetime"))

# === DATE
res <- dp_to_datetime(as.POSIXlt("1970-01-01 00:00"))
expect_equal(res, as.POSIXct("1970-01-01 00:00:00"), attributes = FALSE)
expect_attribute(res, "fielddescriptor", list(type = "datetime"))


# =============================================================================
# csv_colclass
res <- datapackage:::csv_colclass_datetime() 
expect_equal(res, "character")

res <- datapackage:::csv_colclass(list(type = "datetime")) 
expect_equal(res, "character")


# =============================================================================
# csv_format

res <- datapackage:::csv_format_datetime(as.POSIXct("2020-01-01 12:30", tz = "CET"))
expect_equal(res, "2020-01-01T12:30:00+01:00")

res <- datapackage:::csv_format_datetime(as.POSIXct("2020-01-01 12:30", tz = "GMT"))
expect_equal(res, "2020-01-01T12:30:00Z")

fielddescriptor <- list(
    type = "datetime",
    format = "default"
  )
res <- datapackage:::csv_format(as.POSIXct(c("2020-01-01 12:30", NA), tz = "GMT"), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c("2020-01-01T12:30:00Z", NA))

fielddescriptor <- list(
    type = "datetime",
    format = "any"
  )
res <- datapackage:::csv_format(as.POSIXct(c("2020-01-01 12:30", NA), tz = "GMT"), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c("2020-01-01T12:30:00Z", NA))

fielddescriptor <- list(
    type = "datetime",
    format = "%Y %M"
  )
res <- datapackage:::csv_format(as.POSIXct(c("2020-01-01 12:30", NA), tz = "GMT"), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c("2020 30", NA))

fielddescriptor <- list(
    type = "datetime",
    format = "default",
    missingValues = ""
  )
res <- datapackage:::csv_format(as.POSIXct(c("2020-01-01 12:30", NA), tz = "GMT"), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c("2020-01-01T12:30:00Z", ""))



