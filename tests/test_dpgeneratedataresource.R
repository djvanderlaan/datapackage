library(datapackage)
source("helpers.R")


# =============================================================================
# Check generation of categorylists

dta <- data.frame(value = 1:3, label = letters[1:3])
res <- dpgeneratedataresource(dta, "foo")
expect_equal(res$path, "foo.csv")
expect_equal(res$format, "csv")
expect_equal(res$mediatype, "text/csv")
expect_equal(res$encoding, "utf-8")
tst1 <- list(fields = list(
      list(name = "value", type = "integer"),
      list(name = "label", type = "string")
    ))
tst2 <- res$schema
attr(tst2$fields[[1]], "class") <- NULL
attr(tst2$fields[[2]], "class") <- NULL
expect_equal(tst1, tst2)
expect_equal(res$categoriesFieldMap, NULL)

dta <- data.frame(value = 1:3, label = letters[1:3])
res <- dpgeneratedataresource(dta, "foo", categorieslist = TRUE)
expect_equal(res$path, "foo.csv")
expect_equal(res$format, "csv")
expect_equal(res$mediatype, "text/csv")
expect_equal(res$encoding, "utf-8")
tst1 <- list(fields = list(
      list(name = "value", type = "integer"),
      list(name = "label", type = "string")
    ))
tst2 <- res$schema
attr(tst2$fields[[1]], "class") <- NULL
attr(tst2$fields[[2]], "class") <- NULL
expect_equal(tst1, tst2)
expect_equal(res$categoriesFieldMap, list(
    value = "value", label = "label"))

dta <- data.frame(value = 1:3)
res <- dpgeneratedataresource(dta, "foo", categorieslist = TRUE)
expect_equal(res$path, "foo.csv")
expect_equal(res$format, "csv")
expect_equal(res$mediatype, "text/csv")
expect_equal(res$encoding, "utf-8")
tst1 <- list(fields = list(
      list(name = "value", type = "integer")
    ))
tst2 <- res$schema
attr(tst2$fields[[1]], "class") <- NULL
expect_equal(tst1, tst2)
expect_equal(res$categoriesFieldMap, list(
    value = "value", label = "value"))

dta <- data.frame(codes = 1:3, labels = letters[1:3])
attr(dta, "resource") <- structure(list(
  categoriesFieldMap = list(value = "codes", label = "labels")),
  class = "dataresource")
res <- dpgeneratedataresource(dta, "foo", categorieslist = TRUE)
expect_equal(res$path, "foo.csv")
expect_equal(res$format, "csv")
expect_equal(res$mediatype, "text/csv")
expect_equal(res$encoding, "utf-8")
tst1 <- list(fields = list(
      list(name = "codes", type = "integer"),
      list(name = "labels", type = "string")
    ))
tst2 <- res$schema
attr(tst2$fields[[1]], "class") <- NULL
attr(tst2$fields[[2]], "class") <- NULL
expect_equal(tst1, tst2)
expect_equal(res$categoriesFieldMap, list(
    value = "codes", label = "labels"))


dta <- data.frame(codes = 1:3, labels = letters[1:3])
res <- dpgeneratedataresource(dta, "foo", categorieslist = TRUE)
expect_equal(res$path, "foo.csv")
expect_equal(res$format, "csv")
expect_equal(res$mediatype, "text/csv")
expect_equal(res$encoding, "utf-8")
tst1 <- list(fields = list(
      list(name = "codes", type = "integer"),
      list(name = "labels", type = "string")
    ))
tst2 <- res$schema
attr(tst2$fields[[1]], "class") <- NULL
attr(tst2$fields[[2]], "class") <- NULL
expect_equal(tst1, tst2)
expect_equal(res$categoriesFieldMap, list(
    value = "codes", label = "labels"))


dta <- data.frame(codes = 1:3, labels = letters[1:3])
attr(dta, "resource") <- structure(list(
  categoriesFieldMap = list(value = "foo", label = "labels")),
  class = "dataresource")
expect_error(res <- dpgeneratedataresource(dta, "foo", categorieslist = TRUE))

dta <- data.frame(codes = 1:3, labels = letters[1:3])
attr(dta, "resource") <- structure(list(
  categoriesFieldMap = list(value = "codes", label = "foo")),
  class = "dataresource")
expect_error(res <- dpgeneratedataresource(dta, "foo", categorieslist = TRUE))


