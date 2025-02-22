library(datapackage)
source("helpers.R")

fielddescriptor <- list(
  name = "string",
  title = "A string field",
  description = "A description",
  type = "string"
)
res <- datapackage:::dp_to_string.character(c("a", "b", "", NA), 
  fielddescriptor = fielddescriptor)
expect_equal(res, c("a", "b", "", NA), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)

# === Method call
fielddescriptor <- list(
  name = "string",
  title = "A string field",
  description = "A description",
  type = "string"
)
res <- dp_to_string(c("a", "b", "", NA), fielddescriptor = fielddescriptor)
expect_equal(res, c("a", "b", "", NA), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)

# === No Schema
fielddescriptor <- list(
  type = "string"
)
res <- dp_to_string(c("a", "b", "", NA), fielddescriptor = fielddescriptor)
expect_equal(res, c("a", "b", "", NA), attributes = FALSE)
expect_attribute(res, "fielddescriptor", fielddescriptor)

# === Empty input
res <- dp_to_string(character(0))
expect_equal(res, character(0), attributes = FALSE)

# === NA
fielddescriptor <- list(
  type = "string",
  missingValues = c("NA", "<NA>")
)
res <- dp_to_string(c("a", "NA", "<NA>", NA), fielddescriptor)
expect_equal(res, c("a", NA, NA, NA), attributes = FALSE)

# =============================================================================
# csv_colclass

#res <- csv_colclass_string(list()) 
#expect_equal(res, "character")
#
## === NA
#fielddescriptor <- list(
#  type = "string",
#  missingValues = c("NA", "<NA>")
#)
#res <- csv_colclass_string(fielddescriptor)
#expect_equal(res, "character")

