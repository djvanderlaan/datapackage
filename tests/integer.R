library(datapackage)
source("helpers.R")


fielddescriptor <- list(
  name = "integer",
  title = "A integer field",
  description = "A description",
  type = "integer"
)
res <- datapackage:::dp_to_integer.character(c("10", "-100", "", NA), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c(10L, -100L, NA_integer_, NA_integer_), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
res <- datapackage:::dp_to_integer.integer(c(10, -100, NA), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c(10L, -100L, NA_integer_), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)

# === Method call
fielddescriptor <- list(
  name = "integer",
  title = "A integer field",
  description = "A description",
  type = "integer"
)
res <- dp_to_integer(c("10", "-100", "", NA), fielddescriptor = fielddescriptor)
expect_equal(res, c(10L, -100L, NA_integer_, NA_integer_), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
res <- dp_to_integer(c(10, -100, NA), fielddescriptor = fielddescriptor)
expect_equal(res, c(10L, -100L, NA_integer_), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
res <- dp_to_integer(c(10L, -100L, NA_integer_), fielddescriptor = fielddescriptor)
expect_equal(res, c(10L, -100L, NA_integer_), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)

# === No Schema
fielddescriptor <- list(
  type = "integer"
)
res <- datapackage:::dp_to_integer.character(c("10", "-100", "", NA))
expect_equal(res, c(10L, -100L, NA_integer_, NA_integer_), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
res <- datapackage:::dp_to_integer.integer(c(10, -100, NA))
expect_equal(res, c(10L, -100L, NA_integer_), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)

# === Empty input
res <- dp_to_integer(character(0))
expect_equal(res, integer(0), attributes = FALSE)
res <- dp_to_integer(character(0))
expect_equal(res, integer(0), attributes = FALSE)

# === Invalid characters
expect_error(res <- dp_to_integer(c("foo", "10", "10", NA)))

# === NA
fielddescriptor <- list(
  name = "integer",
  missingValues = c("--")
)
res <- dp_to_integer(c("10","--", "11", NA), fielddescriptor)
expect_equal(res, c(10, NA, 11, NA), attributes = FALSE)
expect_error(res <- dp_to_integer(c("10","---", "11", NA), fielddescriptor))

# === BareNumber
fielddescriptor <- list(
  name = "integer",
  title = "A integer field",
  description = "A description",
  type = "integer",
  bareNumber = FALSE
)
res <- datapackage:::dp_to_integer.character(c("€10", "-100%", "", NA), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c(10L, -100L, NA_integer_, NA_integer_), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)
res <- datapackage:::dp_to_integer.integer(c(10, -100, NA), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c(10L, -100L, NA_integer_), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)

# === Big mark
fielddescriptor <- list(
  name = "integer",
  title = "A integer field",
  description = "A description",
  type = "integer",
  groupChar = "."
)
res <- datapackage:::dp_to_integer.character(c("1.234", "-100.123.123", "", NA), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c(1234L, -100123123L, NA_integer_, NA_integer_), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)

# true -> €10 = error
fielddescriptor <- list(
  name = "integer",
  title = "A integer field",
  description = "A description",
  type = "integer",
  bareNumber = TRUE
)
expect_error(datapackage:::dp_to_integer.character(c("€10", "-100%", "", NA), 
  fielddescriptor = fielddescriptor))


# =============================================================================
# csv_colclass

res <- datapackage:::csv_colclass_integer(list()) 
expect_equal(res, "integer")

fielddescriptor <- list(
  name = "integer",
  missingValues = c("--")
)
res <- datapackage:::csv_colclass_integer(fielddescriptor)
expect_equal(res, "character")

fielddescriptor <- list(
  name = "integer",
  bareNumber = FALSE
)
res <- datapackage:::csv_colclass_integer(fielddescriptor)
expect_equal(res, "character")

fielddescriptor <- list(
  name = "integer",
  bareNumber = TRUE
)
res <- datapackage:::csv_colclass_integer(fielddescriptor)
expect_equal(res, "integer")

fielddescriptor <- list(
  name = "integer",
  groupChar = " "
)
res <- datapackage:::csv_colclass_integer(fielddescriptor)
expect_equal(res, "character")

fielddescriptor <- list(
  name = "integer",
  groupChar = ""
)
res <- datapackage:::csv_colclass_integer(fielddescriptor)
expect_equal(res, "integer")


# =============================================================================
# csv_format

res <- datapackage:::csv_format_integer(c(12, NA))
expect_equal(res, c(12L, NA_integer_))

res <- datapackage:::csv_format_integer(c(12, NA), 
  fielddescriptor = list(missingValues = c("X", "0")))
expect_equal(res, c("12", "X"))

res <- datapackage:::csv_format_integer(c(12, NA), 
  fielddescriptor = list(bareNumber = FALSE))
expect_equal(res, c(12L, NA_integer_))

res <- datapackage:::csv_format_integer(c(12, 12345, NA), 
  fielddescriptor = list(groupChar = "."))
expect_equal(res, c("12", "12.345", NA))


