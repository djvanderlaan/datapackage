library(datapackage)

source("helpers.R")

f <- structure(list(
    name = "foo", title = "Foo", description = "Foo Bar\n\nFoo", 
    format = "bar"), class = "fielddescriptor")
expect_equal(dp_name(f), "foo")
expect_equal(dp_title(f), "Foo")
expect_equal(dp_description(f), "Foo Bar\n\nFoo")
expect_equal(dp_description(f, first_paragraph = TRUE), "Foo Bar")
expect_equal(dp_format(f), "bar")

# No properties set
f <- structure(list(), class = "fielddescriptor")
expect_error(dp_name(f))
expect_equal(dp_title(f), NULL)
expect_equal(dp_description(f), NULL)
expect_equal(dp_description(f, first_paragraph = TRUE), NULL)
expect_equal(dp_format(f), NULL)

# Setting properties
f <- structure(list(), class = "fielddescriptor")

dp_name(f) <- "foo"
expect_equal(dp_name(f), "foo")
expect_error(dp_name(f) <- "")
expect_error(dp_name(f) <- letters[1:2])

dp_title(f) <- "Foo"
expect_equal(dp_title(f), "Foo")
expect_error(dp_title(f) <- c("a", "B"))
dp_title(f) <- NULL
expect_equal(dp_title(f), NULL)

dp_description(f) <- "Foo Bar\n\nFoo"
expect_equal(dp_description(f), "Foo Bar\n\nFoo")
dp_description(f) <- c("Foo", "Bar")
expect_equal(dp_description(f), "Foo\nBar")
dp_description(f) <- NULL
expect_equal(dp_description(f), NULL)

dp_format(f) <- "bar"
expect_equal(dp_format(f), "bar")
dp_format(f) <- NULL
expect_equal(dp_format(f), NULL)

