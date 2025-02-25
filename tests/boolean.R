library(datapackage)
source("helpers.R")


fielddescriptor <- list(
  name = "boolean",
  title = "A boolean field",
  description = "A description",
  type = "boolean"
)

res <- datapackage:::dp_to_boolean.character(c("TRUE", "FALSE", ""), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c(TRUE, FALSE, NA), attributes = FALSE)
expect_attribute(res, "fielddescriptor", 
  c(fielddescriptor, list(trueValues = c("true", "TRUE", "True", "1"), 
    falseValues = c("false", "FALSE", "False", "0"))))

res <- datapackage:::dp_to_boolean.character(c("True", "False", ""), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c(TRUE, FALSE, NA), attributes = FALSE)

res <- datapackage:::dp_to_boolean.character(c("true", "false", ""), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c(TRUE, FALSE, NA), attributes = FALSE)

res <- datapackage:::dp_to_boolean.character(c("1", "0", ""), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c(TRUE, FALSE, NA), attributes = FALSE)

res <- datapackage:::dp_to_boolean.character(c(), 
  fielddescriptor = fielddescriptor)
expect_equal(res, logical(0), attributes = FALSE)

res <- datapackage:::dp_to_boolean.character(c(""), 
  fielddescriptor = fielddescriptor)
expect_equal(res, as.logical(NA), attributes = FALSE)

expect_error( datapackage:::dp_to_boolean.character(c("foo", ""), 
    fielddescriptor = fielddescriptor) )


# ==== Custom trueValues and falseValues
fielddescriptor <- list(
  name = "boolean",
  title = "A boolean field",
  description = "A description",
  type = "boolean",
  trueValues = "yes",
  falseValues = "no"
)

expect_error( datapackage:::dp_to_boolean.character(c("FALSE", "TRUE", ""), 
    fielddescriptor = fielddescriptor) )

res <- datapackage:::dp_to_boolean.character(c("yes", "no", "", "yes"), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c(TRUE, FALSE, NA, TRUE), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)

# ==== No fielddescriptor

res <- datapackage:::dp_to_boolean.character(c("true", "False", "FALSE", "0", "", NA, "TRUE"))
expect_equal(res, c(TRUE, FALSE, FALSE, FALSE, NA, NA, TRUE), attributes = FALSE)

fielddescriptor <- list(
  type = "boolean",
  trueValues = c("true", "TRUE", "True", "1"),
  falseValues = c("false", "FALSE", "False", "0")
)
expect_attribute(res, "fielddescriptor", fielddescriptor)

# =============================================================================
# dp_to_boolean.integer

fielddescriptor <- list(
  type = "boolean",
  trueValues = "1",
  falseValues = "0"
)
res <- datapackage:::dp_to_boolean.integer(c(1, 0, NA), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c(TRUE, FALSE, NA), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)

fielddescriptor <- list(
  type = "boolean",
  trueValues = "42",
  falseValues = "0"
)
res <- datapackage:::dp_to_boolean.integer(c(42, 0, NA), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c(TRUE, FALSE, NA), attributes = FALSE)

fielddescriptor <- list(
  type = "boolean",
  trueValues = "42",
  falseValues = "1"
)
res <- datapackage:::dp_to_boolean.integer(c(42, 1, NA), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c(TRUE, FALSE, NA), attributes = FALSE)

fielddescriptor <- list(
  type = "boolean",
  trueValues = c("1", "42"),
  falseValues = "0"
)
res <- datapackage:::dp_to_boolean.integer(c(42, 1, 0, NA), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c(TRUE, TRUE, FALSE, NA), attributes = FALSE)

fielddescriptor <- list(
  type = "boolean",
  trueValues = c("1", "one"),
  falseValues = "0"
)
expect_error(datapackage:::dp_to_boolean.integer(c(42, 1, 0, NA), 
    fielddescriptor = fielddescriptor))

fielddescriptor <- list(
  type = "boolean",
  trueValues = "1",
  falseValues = "0"
)
expect_warning(
  res <- datapackage:::dp_to_boolean.integer(c(42, 1, 0, NA, 0), 
    fielddescriptor = fielddescriptor)
)
expect_equal(res, c(TRUE, TRUE, FALSE, NA, FALSE), attributes = FALSE)

# === NA
fielddescriptor <- list(
  name = "boolean",
  missingValues = c("--")
)
res <- dp_to_boolean(c("TRUE","--", "FALSE", NA), fielddescriptor)
expect_equal(res, c(TRUE, NA, FALSE, NA), attributes = FALSE)
expect_error(res <- dp_to_boolean(c("TRUE","---", "FALSE", NA), fielddescriptor))

# =============================================================================
# csv_colclass

res <- datapackage:::csv_colclass_boolean(
  list(trueValues = "True", falseValues = "False"))
expect_equal(res, "logical")

res <- datapackage:::csv_colclass_boolean(
  list(trueValues = "true", falseValues = "false"))
expect_equal(res, "logical")

res <- datapackage:::csv_colclass_boolean(
  list(trueValues = "TRUE", falseValues = "FALSE"))
expect_equal(res, "logical")

res <- datapackage:::csv_colclass_boolean(
  list(trueValues = "1", falseValues = "0"))
expect_equal(res, "integer")

res <- datapackage:::csv_colclass_boolean()
expect_equal(res, "logical")

res <- datapackage:::csv_colclass_boolean(
  list(trueValues = "TRUE", falseValues = "false"))
expect_equal(res, "character")

res <- datapackage:::csv_colclass_boolean(
  list(trueValues = "TRUE"))
expect_equal(res, "character")

res <- datapackage:::csv_colclass_boolean(
  list(falseValues = "FALSE"))
expect_equal(res, "character")

res <- datapackage:::csv_colclass_boolean(
  list(trueValues = c("true", "TRUE"), falseValues = "FALSE"))
expect_equal(res, "character")

res <- datapackage:::csv_colclass_boolean(
  list(missingValues = c("--")))
expect_equal(res, "character")


# =============================================================================
# csv_format

res <- datapackage:::csv_format_boolean(c(TRUE, FALSE, NA))
expect_equal(res, c(TRUE, FALSE, NA))

res <- datapackage:::csv_format_boolean(c(TRUE, FALSE, NA), 
  fielddescriptor = list(missingValues = c("X", "-")))
expect_equal(res, c("TRUE", "FALSE", "X"))

res <- datapackage:::csv_format_boolean(c(TRUE, FALSE, NA), 
  fielddescriptor = list(trueValues = c("WAAR", "TRUE"),
    falseValues = c("ONWAAR", "FALSE")))
expect_equal(res, c(TRUE, FALSE, NA))

res <- datapackage:::csv_format_boolean(c(TRUE, FALSE, NA), 
  fielddescriptor = list(trueValues = c("WAAR"),
    falseValues = c("ONWAAR")))
expect_equal(res, c("WAAR", "ONWAAR", NA))



