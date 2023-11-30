library(datapackage)
source("helpers.R")


schema <- list(
  name = "number",
  title = "A number field",
  description = "A description",
  type = "number"
)
res <- datapackage:::to_number.character(c("10", "-100.3", "Inf", "-Inf", "NaN", "", "-1.3E+6", 
    "+4.3E-5", NA), schema = schema)
expect_equal(res, c(10, -100.3, Inf, -Inf, NaN, NA, -1.3E6, 4.3E-5, NA), 
  attributes = FALSE)
expect_attribute(res, "fielddescriptor", schema)

# Case sensitivity
res <- datapackage:::to_number.character(c("10", "-100.3", "inf", "-inf", "nan", "", "-1.3E+6", 
    "+4.3E-5", NA), schema = schema)
expect_equal(res, c(10, -100.3, Inf, -Inf, NaN, NA, -1.3E6, 4.3E-5, NA), 
  attributes = FALSE)
res <- datapackage:::to_number.character(c("10", "-100.3", "INF", "-INF", "NAN", "", "-1.3E+6", 
    "+4.3E-5", NA), schema = schema)
expect_equal(res, c(10, -100.3, Inf, -Inf, NaN, NA, -1.3E6, 4.3E-5, NA), 
  attributes = FALSE)

# === numeric 
schema <- list(
  name = "number",
  title = "A number field",
  description = "A description",
  type = "number"
)
res <- datapackage:::to_number.numeric(c(10, -100.3, Inf, -Inf, NaN, NA, -1.3E+6, 
    +4.3E-5, NA), schema = schema)
expect_equal(res, c(10, -100.3, Inf, -Inf, NaN, NA, -1.3E6, 4.3E-5, NA), 
  attributes = FALSE)
expect_attribute(res, "fielddescriptor", schema)


# === Method call
schema <- list(
  name = "number",
  title = "A number field",
  description = "A description",
  type = "number"
)
res <- to_number(c("10", "-100.3", "Inf", "-Inf", "NaN", "", "-1.3E+6", 
    "+4.3E-5", NA), schema = schema)
expect_equal(res, c(10, -100.3, Inf, -Inf, NaN, NA, -1.3E6, 4.3E-5, NA), 
  attributes = FALSE)
expect_attribute(res, "fielddescriptor", schema)

# === No Schema
schema <- list(
  type = "number"
)
res <- to_number(c("10", "-100.3", "Inf", "-Inf", "NaN", "", "-1.3E+6", 
    "+4.3E-5", NA))
expect_equal(res, c(10, -100.3, Inf, -Inf, NaN, NA, -1.3E6, 4.3E-5, NA), 
  attributes = FALSE)
expect_attribute(res, "fielddescriptor", schema)


# === Empty input
res <- to_number(character(0))
expect_equal(res, numeric(0), attributes = FALSE)
res <- to_number(numeric(0))
expect_equal(res, numeric(0), attributes = FALSE)

# === Invalid characters
expect_error(res <- to_number(c("foo", "10", "10", NA)))

# === Other decimal signs 
schema <- list(
  name = "number",
  title = "A number field",
  description = "A description",
  type = "number",
  decimalChar = ","
)
res <- datapackage:::to_number.character(c("10", "-100,3", "Inf", "-Inf", "NaN", "", "-1,3E+6", 
    "+4,3E-5", NA), schema = schema)
expect_equal(res, c(10, -100.3, Inf, -Inf, NaN, NA, -1.3E6, 4.3E-5, NA), 
  attributes = FALSE)
expect_attribute(res, "fielddescriptor", schema)

# === Big mark
schema <- list(
  name = "number",
  title = "A number field",
  description = "A description",
  type = "number",
  decimalChar = ",",
  groupChar = "."
)
res <- datapackage:::to_number.character(c("10", "-100.000,3", "1.023,12", "-Inf", "NaN", "", "-1,3E+6", 
    "+4,3E-5", NA), schema = schema)
expect_equal(res, c(10, -100000.3, 1023.12, -Inf, NaN, NA, -1.3E6, 4.3E-5, NA), 
  attributes = FALSE)
expect_attribute(res, "fielddescriptor", schema)

# === NA
schema <- list(
  name = "number",
  missingValues = c("--")
)
res <- to_number(c("10","--", "11", NA), schema)
expect_equal(res, c(10, NA, 11, NA), attributes = FALSE)
expect_error(res <- to_number(c("10","---", "11", NA), schema))

# =============================================================================
# csv_colclass

# TODO
#res <- csv_colclass_number(list()) 
#expect_equal(res, "numeric")
#
#schema <- list(
#  name = "number",
#  title = "A number field",
#  description = "A description",
#  type = "number",
#  decimalChar = ",",
#  groupChar = "."
#)
#res <- csv_colclass_number(schema) 
#expect_equal(res, "character")
#
## === NA
#schema <- list(
#  name = "number",
#  missingValues = c("--")
#)
#res <- csv_colclass_number(schema)
#expect_equal(res, "character")
