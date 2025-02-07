
library(datapackage)
source("helpers.R")

x <- c("EUR 500", "EUR -1.25", "25%", "+40", "€40", "10E4 km", NA)
res <- datapackage:::bareNumber(x)
expect_equal(res$prefix, c("EUR", "EUR", NA, NA, "€", NA, NA))
expect_equal(res$postfix, c(NA, NA, "%", NA, NA, "km", NA))
expect_equal(res$remainder, c("500", "-1.25", "25", "+40", "40", "10E4", NA))

expect_warning(res <- datapackage:::bareNumber(""))
expect_equal(res$prefix, c(NA_character_))
expect_equal(res$remainder, c(""))
expect_equal(res$postfix, c(NA_character_))

res <- datapackage:::bareNumber("F5U")
expect_equal(res$prefix, c("F"))
expect_equal(res$remainder, c("5"))
expect_equal(res$postfix, c("U"))

expect_warning(res <- datapackage:::bareNumber(c("FOO", "40")))
expect_equal(res$prefix, c(NA_character_, NA_character_))
expect_equal(res$remainder, c("FOO", "40"))
expect_equal(res$postfix, c(NA_character_, NA_character_))

expect_warning(res <- datapackage:::bareNumber(c("-Inf", "NaN")))
expect_equal(res$prefix, c(NA_character_, NA_character_))
expect_equal(res$remainder, c("-Inf", "NaN"))
expect_equal(res$postfix, c(NA_character_, NA_character_))

