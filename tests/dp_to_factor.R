library(datapackage)
source("helpers.R")


orig_options <- options("DP_TRIM_CODES", "DP_TRIM_HYPHEN")


# Default ok
options("DP_TRIM_CODES" = NULL, "DP_TRIM_HYPHEN" = NULL)
codelist <- data.frame(
  value = c("1", "2" , "3"),
  label = letters[1:3]
)
x <- c("3", "3", NA, "1", "2")
res <- dp_to_factor(x, codelist)
expect_equal(res, factor(c(3,3,NA,1,2), 
    levels=1:3, labels = c("a", "b", "c")))

# Default ok; but with whitespace in code
options("DP_TRIM_CODES" = NULL, "DP_TRIM_HYPHEN" = NULL)
codelist <- data.frame(
  value = c(" 1", " 2" , " 3"),
  label = letters[1:3]
)
x <- c("3", "3", NA, "1", "2")
expect_error(dp_to_factor(x, codelist))

# trim ok; but with whitespace in code
options("DP_TRIM_CODES" = TRUE, "DP_TRIM_HYPHEN" = NULL)
codelist <- data.frame(
  value = c(" 1", " 2" , " 3"),
  label = letters[1:3]
)
x <- c("3", "3", NA, "1", "2")
res <- dp_to_factor(x, codelist)
expect_equal(res, factor(c(3,3,NA,1,2), 
    levels=1:3, labels = c("a", "b", "c")))

# trim ok; but with whitespace in x
options("DP_TRIM_CODES" = TRUE, "DP_TRIM_HYPHEN" = NULL)
codelist <- data.frame(
  value = c("1", "2" , "3"),
  label = letters[1:3]
)
x <- c("  3", "  3", NA, "  1", "--2")
res <- dp_to_factor(x, codelist)
expect_equal(res, factor(c(3,3,NA,1,2), 
    levels=1:3, labels = c("a", "b", "c")))


# trim ok; but with whitespace and hyphen in code
# note we have 1 hypen in "-3" which is not trimmed
options("DP_TRIM_CODES" = TRUE, "DP_TRIM_HYPHEN" = NULL)
codelist <- data.frame(
  value = c("--1", "--2" , "-3"),
  label = letters[1:3]
)
x <- c("-3", "-3", NA, "1", "2")
res <- dp_to_factor(x, codelist)
expect_equal(res, factor(c(3,3,NA,1,2), 
    levels=1:3, labels = c("a", "b", "c")))

# trim not ok; but with whitespace and hyphen in code
# note we have 1 hypen in "-3" which is not trimmed
options("DP_TRIM_CODES" = TRUE, "DP_TRIM_HYPHEN" = FALSE)
codelist <- data.frame(
  value = c("--1", "--2" , "-3"),
  label = letters[1:3]
)
x <- c("-3", "-3", NA, "1", "2")
expect_error(res <- dp_to_factor(x, codelist))

# edge case; empy
options("DP_TRIM_CODES" = TRUE, "DP_TRIM_HYPHEN" = NULL)
codelist <- data.frame(
  value = c("--1", "--2" , "-3"),
  label = letters[1:3]
)
x <- character(0)
res <- dp_to_factor(x, codelist)
expect_equal(res, factor(integer(0), 
    levels=1:3, labels = c("a", "b", "c")))

# edge case; empy
options("DP_TRIM_CODES" = FALSE, "DP_TRIM_HYPHEN" = NULL)
codelist <- data.frame(
  value = c("--1", "--2" , "-3"),
  label = letters[1:3]
)
x <- character(0)
res <- dp_to_factor(x, codelist)
expect_equal(res, factor(integer(0), 
    levels=1:3, labels = c("a", "b", "c")))

# edge case; na
options("DP_TRIM_CODES" = TRUE, "DP_TRIM_HYPHEN" = NULL)
codelist <- data.frame(
  value = c("--1", "--2" , "-3"),
  label = letters[1:3]
)
x <- c(NA_character_, NA_character_)
res <- dp_to_factor(x, codelist)
expect_equal(res, factor(c(NA, NA), 
    levels=1:3, labels = c("a", "b", "c")))


# Set options back to original values
options(orig_options)

