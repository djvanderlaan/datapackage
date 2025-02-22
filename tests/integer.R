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

# TODO
#res <- csv_colclass_integer(list()) 
#expect_equal(res, "integer")
#
## === NA
#fielddescriptor <- list(
#  name = "integer",
#  missingValues = c("--")
#)
#res <- csv_colclass_integer(fielddescriptor)
#expect_equal(res, "character")

