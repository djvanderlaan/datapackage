library(datapackage)
source("helpers.R")

schema <- list(
  name = "string",
  title = "A string field",
  description = "A description",
  type = "string"
)
res <- datapackage:::to_string.character(c("a", "b", "", NA), schema = schema)
expect_equal(res, c("a", "b", "", NA), attributes = FALSE)
expect_attribute(res, "fielddescriptor", schema)

# === Method call
schema <- list(
  name = "string",
  title = "A string field",
  description = "A description",
  type = "string"
)
res <- to_string(c("a", "b", "", NA), schema = schema)
expect_equal(res, c("a", "b", "", NA), attributes = FALSE)
expect_attribute(res, "fielddescriptor", schema)

# === No Schema
schema <- list(
  type = "string"
)
res <- to_string(c("a", "b", "", NA), schema = schema)
expect_equal(res, c("a", "b", "", NA), attributes = FALSE)
expect_attribute(res, "fielddescriptor", schema)

# === Empty input
res <- to_string(character(0))
expect_equal(res, character(0), attributes = FALSE)

# === NA
schema <- list(
  type = "string",
  missingValues = c("NA", "<NA>")
)
res <- to_string(c("a", "NA", "<NA>", NA), schema)
expect_equal(res, c("a", NA, NA, NA), attributes = FALSE)

# =============================================================================
# csv_colclass

#res <- csv_colclass_string(list()) 
#expect_equal(res, "character")
#
## === NA
#schema <- list(
#  type = "string",
#  missingValues = c("NA", "<NA>")
#)
#res <- csv_colclass_string(schema)
#expect_equal(res, "character")

