library(datapackage)
source("helpers.R")

# === NO FORMAT
fielddescriptor <- list(
  name = "time",
  title = "A time field",
  description = "A description",
  type = "time"
)
res <- dp_to_time(c("12:13", "12:13:14,15", "", NA), 
  fielddescriptor = fielddescriptor)
expect_equal(res, as.POSIXct(c("1970-01-01 12:13:00", "1970-01-01 12:13:14.15", 
      NA, NA), tz = "GMT"), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
suppressWarnings(expect_error(
  dp_to_time(c("1970-01-01 14:12", "", NA), fielddescriptor = fielddescriptor)
))

# === DEFAULT FORMAT
fielddescriptor <- list(
  name = "time",
  title = "A time field",
  description = "A description",
  type = "time",
  format = "default"
)
res <- dp_to_time(c("12:13", "12:13:14,15", "", NA), 
  fielddescriptor = fielddescriptor)
expect_equal(res, as.POSIXct(c("1970-01-01 12:13:00", "1970-01-01 12:13:14.15", 
      NA, NA), tz = "GMT"), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
suppressWarnings(expect_error(
  dp_to_time(c("1970-01-01 14:12", "", NA), fielddescriptor = fielddescriptor)
))

# === ANY FORMAT
fielddescriptor <- list(
  name = "time",
  title = "A time field",
  description = "A description",
  type = "time",
  format = "any"
)
res <- dp_to_time(c("T12:13", "T12:13:14,15", "", NA), 
  fielddescriptor = fielddescriptor)
expect_equal(res, as.POSIXct(c("1970-01-01 12:13:00", "1970-01-01 12:13:14.15", 
      NA, NA), tz = "GMT"), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)

# === %Y%M.. FORMAT
fielddescriptor <- list(
  name = "time",
  title = "A time field",
  description = "A description",
  type = "time",
  format = "%H-%M-%S"
)
res <- dp_to_time(c("12-13-00", "12-13-14", "", NA), 
  fielddescriptor = fielddescriptor)
expect_equal(res, as.POSIXct(c("1970-01-01 12:13:00", "1970-01-01 12:13:14", 
      NA, NA), tz = "GMT"), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
suppressWarnings(expect_error(
  dp_to_time(c("12:13:14", "", NA), fielddescriptor = fielddescriptor)
))


# === NO FIELDDESCRIPTOR
fielddescriptor <- list(
  type = "time"
)
res <- dp_to_time(c("12:13", "12:13:14,15", "", NA))
expect_equal(res, as.POSIXct(c("1970-01-01 12:13:00", "1970-01-01 12:13:14.15", 
      NA, NA), tz = "GMT"), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)


# === MISSINGVALUES
fielddescriptor <- list(
  name = "time",
  title = "A time field",
  description = "A description",
  type = "time",
  missingValues = "--"
)
res <- dp_to_time(c("12:13", "12:13:14,15", "--", NA), 
  fielddescriptor = fielddescriptor)
expect_equal(res, as.POSIXct(c("1970-01-01 12:13:00", "1970-01-01 12:13:14.15", 
      NA, NA), tz = "GMT"), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
suppressWarnings(expect_error(
  dp_to_time(c("14:12", "", NA), fielddescriptor = fielddescriptor)
))


# === NUMERIC
res <- dp_to_time(0)
expect_equal(res, as.POSIXct("1970-01-01 00:00:00", tz = "GMT"), attributes = FALSE)
expect_attribute(res, "fielddescriptor", list(type = "time"))

# === TIME
res <- dp_to_time(as.POSIXlt("1980-12-01 00:00", tz = "GMT"))
expect_equal(res, as.POSIXct("1970-01-01 00:00:00", tz = "GMT"), attributes = FALSE)
expect_attribute(res, "fielddescriptor", list(type = "time"))


# =============================================================================
# csv_colclass
res <- datapackage:::csv_colclass_time() 
expect_equal(res, "character")

res <- datapackage:::csv_colclass(list(type = "time")) 
expect_equal(res, "character")


# =============================================================================
# csv_format

res <- datapackage:::csv_format_time(iso8601::iso8601totime(c("T12:13:14", NA)))
expect_equal(res, c("12:13:14", NA))

fielddescriptor <- list(
    type = "time",
    format = "default"
  )
res <- datapackage:::csv_format_time(iso8601::iso8601totime(c("T12:13:14", NA)), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c("12:13:14", NA))

fielddescriptor <- list(
    type = "time",
    format = "any"
  )
res <- datapackage:::csv_format_time(iso8601::iso8601totime(c("T12:13:14", NA)), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c("12:13:14", NA))

fielddescriptor <- list(
    type = "time",
    format = "%H %M"
  )
res <- datapackage:::csv_format_time(iso8601::iso8601totime(c("T12:13:14", NA)), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c("12 13", NA))

fielddescriptor <- list(
    type = "time",
    format = "default",
    missingValues = "XX"
  )
res <- datapackage:::csv_format_time(iso8601::iso8601totime(c("T12:13:14", NA)), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c("12:13:14", "XX"))


