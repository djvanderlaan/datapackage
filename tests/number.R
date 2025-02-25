library(datapackage)
source("helpers.R")


fielddescriptor <- list(
  name = "number",
  title = "A number field",
  description = "A description",
  type = "number"
)
res <- datapackage:::dp_to_number.character(c("10", "-100.3", "Inf", "-Inf", "NaN", "", "-1.3E+6", 
    "+4.3E-5", NA), fielddescriptor = fielddescriptor)
expect_equal(res, c(10, -100.3, Inf, -Inf, NaN, NA, -1.3E6, 4.3E-5, NA), 
  attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)

# Case sensitivity
res <- datapackage:::dp_to_number.character(c("10", "-100.3", "inf", "-inf", "nan", "", "-1.3E+6", 
    "+4.3E-5", NA), fielddescriptor = fielddescriptor)
expect_equal(res, c(10, -100.3, Inf, -Inf, NaN, NA, -1.3E6, 4.3E-5, NA), 
  attributes = FALSE)
res <- datapackage:::dp_to_number.character(c("10", "-100.3", "INF", "-INF", "NAN", "", "-1.3E+6", 
    "+4.3E-5", NA), fielddescriptor = fielddescriptor)
expect_equal(res, c(10, -100.3, Inf, -Inf, NaN, NA, -1.3E6, 4.3E-5, NA), 
  attributes = FALSE)

# === numeric 
fielddescriptor <- list(
  name = "number",
  title = "A number field",
  description = "A description",
  type = "number"
)
res <- datapackage:::dp_to_number.numeric(c(10, -100.3, Inf, -Inf, NaN, NA, -1.3E+6, 
    +4.3E-5, NA), fielddescriptor = fielddescriptor)
expect_equal(res, c(10, -100.3, Inf, -Inf, NaN, NA, -1.3E6, 4.3E-5, NA), 
  attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)


# === Method call
fielddescriptor <- list(
  name = "number",
  title = "A number field",
  description = "A description",
  type = "number"
)
res <- dp_to_number(c("10", "-100.3", "Inf", "-Inf", "NaN", "", "-1.3E+6", 
    "+4.3E-5", NA), fielddescriptor = fielddescriptor)
expect_equal(res, c(10, -100.3, Inf, -Inf, NaN, NA, -1.3E6, 4.3E-5, NA), 
  attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)

# === No Schema
fielddescriptor <- list(
  type = "number"
)
res <- dp_to_number(c("10", "-100.3", "Inf", "-Inf", "NaN", "", "-1.3E+6", 
    "+4.3E-5", NA))
expect_equal(res, c(10, -100.3, Inf, -Inf, NaN, NA, -1.3E6, 4.3E-5, NA), 
  attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)


# === Empty input
res <- dp_to_number(character(0))
expect_equal(res, numeric(0), attributes = FALSE)
res <- dp_to_number(numeric(0))
expect_equal(res, numeric(0), attributes = FALSE)

# === Invalid characters
expect_error(res <- dp_to_number(c("foo", "10", "10", NA)))

# === Other decimal signs 
fielddescriptor <- list(
  name = "number",
  title = "A number field",
  description = "A description",
  type = "number",
  decimalChar = ","
)
res <- datapackage:::dp_to_number.character(c("10", "-100,3", "Inf", "-Inf", "NaN", "", "-1,3E+6", 
    "+4,3E-5", NA), fielddescriptor = fielddescriptor)
expect_equal(res, c(10, -100.3, Inf, -Inf, NaN, NA, -1.3E6, 4.3E-5, NA), 
  attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)

# === Big mark
fielddescriptor <- list(
  name = "number",
  title = "A number field",
  description = "A description",
  type = "number",
  decimalChar = ",",
  groupChar = "."
)
res <- datapackage:::dp_to_number.character(c("10", "-100.000,3", "1.023,12", "-Inf", "NaN", "", "-1,3E+6", 
    "+4,3E-5", NA), fielddescriptor = fielddescriptor)
expect_equal(res, c(10, -100000.3, 1023.12, -Inf, NaN, NA, -1.3E6, 4.3E-5, NA), 
  attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)

# === NA
fielddescriptor <- list(
  name = "number",
  missingValues = c("--")
)
res <- dp_to_number(c("10","--", "11", NA), fielddescriptor)
expect_equal(res, c(10, NA, 11, NA), attributes = FALSE)
expect_error(res <- dp_to_number(c("10","---", "11", NA), fielddescriptor))

# === BareNumber
fielddescriptor <- list(
  name = "number",
  title = "A number field",
  description = "A description",
  type = "number",
  bareNumber = FALSE
)
res <- dp_to_number(c("10%", "EUR -100.3", "Inf", "-Inf", "NaN", "", "€-1.3E+6", 
    "+4.3E-5", NA), fielddescriptor = fielddescriptor)
expect_equal(res, c(10, -100.3, Inf, -Inf, NaN, NA, -1.3E6, 4.3E-5, NA), 
  attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)

# =============================================================================
# csv_colclass

res <- datapackage:::csv_colclass_number(list()) 
expect_equal(res, "numeric")

fielddescriptor <- list(
  name = "number",
  missingValues = c("--")
)
res <- datapackage:::csv_colclass_number(fielddescriptor)
expect_equal(res, "character")

fielddescriptor <- list(
  name = "number",
  bareNumber = FALSE
)
res <- datapackage:::csv_colclass_number(fielddescriptor)
expect_equal(res, "character")

fielddescriptor <- list(
  name = "number",
  bareNumber = TRUE
)
res <- datapackage:::csv_colclass_number(fielddescriptor)
expect_equal(res, "numeric")

fielddescriptor <- list(
  name = "number",
  decimalChar = ","
)
res <- datapackage:::csv_colclass_number(fielddescriptor)
expect_equal(res, "character")

fielddescriptor <- list(
  name = "number",
  groupChar = " "
)
res <- datapackage:::csv_colclass_number(fielddescriptor)
expect_equal(res, "character")

# =============================================================================
# csv_format

res <- datapackage:::csv_format_number(c(12, NA))
expect_equal(res, c(12, NA))

res <- datapackage:::csv_format_number(c(12.12, NA), 
  fielddescriptor = list(bareNumber = FALSE))
expect_equal(res, c(12.12, NA))

res <- datapackage:::csv_format_number(c(12.12, NA), 
  fielddescriptor = list(decimalChar = ","))
expect_equal(res, c("12,12", NA))

res <- datapackage:::csv_format_number(c(12.12, NA), 
  fielddescriptor = list(decimalChar = ","), decimalChar = ",")
expect_equal(res, c(12.12, NA))

res <- datapackage:::csv_format_number(c(1200.12, NA), 
  fielddescriptor = list(groupChar = " "))
expect_equal(res, c("1 200.12", NA))

res <- datapackage:::csv_format_number(c(1200.12, NA), 
  fielddescriptor = list(groupChar = " ", decimalChar = "," ))
expect_equal(res, c("1 200,12", NA))

res <- datapackage:::csv_format_number(c(12.12, NA), 
  fielddescriptor = list(missingValues = c("X", "0")))
expect_equal(res, c("12.12", "X"))

