
library(datapackage)
source("helpers.R")

dir <- tempfile()

dpsaveasdatapackage(iris, dir)

iris2 <- dploadfromdatapackage(dir, to_factor = TRUE)


expect_equal(iris,iris2, attributes = FALSE)

tmp <- iris[FALSE,]
expect_error(dpsaveasdatapackage(iris, dir))

file.remove(list.files(dir, full.names = TRUE))

dpsaveasdatapackage(tmp, dir)

tmp2 <- dploadfromdatapackage(dir, to_factor = TRUE)
expect_equal(tmp, tmp2, attributes = FALSE)
expect_equal(levels(tmp$Species), levels(tmp2$Species))

tmp <- dploadfromdatapackage(dir, "Species-codelist")
expect_equal(names(tmp), c("code", "label"))
expect_equal(tmp$code, 1:3, attributes = FALSE)
expect_equal(tmp$label, c("setosa", "versicolor", "virginica"), attributes = FALSE)

file.remove(list.files(dir, full.names = TRUE))
file.remove(dir)
