
library(datapackage)
source("helpers.R")

dir <- tempfile()

dp_save_as_datapackage(iris, dir)

iris2 <- dp_load_from_datapackage(dir, convert_categories = "to_factor")


expect_equal(iris,iris2, attributes = FALSE)

tmp <- iris[FALSE,]
expect_error(dp_save_as_datapackage(iris, dir))

ignore <- file.remove(list.files(dir, full.names = TRUE))

dp_save_as_datapackage(tmp, dir, categories_type = "resource")

tmp2 <- dp_load_from_datapackage(dir, convert_categories = "to_factor")
expect_equal(tmp, tmp2, attributes = FALSE)
expect_equal(levels(tmp$Species), levels(tmp2$Species))

tmp <- dp_load_from_datapackage(dir, "species-categories")
expect_equal(names(tmp), c("value", "label"))
expect_equal(tmp$value, 1:3, attributes = FALSE)
expect_equal(tmp$label, c("setosa", "versicolor", "virginica"), attributes = FALSE)

ignore <- file.remove(list.files(dir, full.names = TRUE))
ignore <- file.remove(dir)
