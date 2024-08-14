
library(datapackage)
source("helpers.R")

dir <- tempfile()

dpsaveasdatapackage(iris, dir)

iris2 <- dploadfromdatapackage(dir, to_factor = TRUE)


expect_equal(iris,iris2, attributes = FALSE)

tmp <- iris[FALSE,]
expect_error(dpsaveasdatapackage(iris, dir))

ignore <- file.remove(list.files(dir, full.names = TRUE))

dpsaveasdatapackage(tmp, dir, categories_type = "resource")

tmp2 <- dploadfromdatapackage(dir, to_factor = TRUE)
expect_equal(tmp, tmp2, attributes = FALSE)
expect_equal(levels(tmp$Species), levels(tmp2$Species))

tmp <- dploadfromdatapackage(dir, "Species-categories")
expect_equal(names(tmp), c("value", "label"))
expect_equal(tmp$value, 1:3, attributes = FALSE)
expect_equal(tmp$label, c("setosa", "versicolor", "virginica"), attributes = FALSE)

ignore <- file.remove(list.files(dir, full.names = TRUE))
ignore <- file.remove(dir)
