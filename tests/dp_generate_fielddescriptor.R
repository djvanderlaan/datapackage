library(datapackage)
source("helpers.R")

dir <- system.file("tests/test01", package = "datapackage")
if (dir == "") dir <- "../inst/tests/test01"

dp <- open_datapackage(dir)
dta <- dp |> dp_resource("complex") |> dp_get_data()

# ==================================================================
tmp <- dp_generate_fielddescriptor(dta$factor1, "f1")
expect_equal(dp_property(tmp, "name"), "f1")
expect_equal(dp_property(tmp, "type"), "integer")
expect_equal(dp_property(tmp, "categories"), list(resource="codelist-factor1"))

tmp <- dp_generate_fielddescriptor(dta$factor1, "f1", use_existing = FALSE)
expect_equal(dp_property(tmp, "name"), "f1")
expect_equal(dp_property(tmp, "type"), "integer")
expect_equal(
  dp_property(tmp, "categories"),
  list(
    list(value = 1L, label = "Purple"),
    list(value = 2L, label = "Red"),
    list(value = 3L, label = "Other"),
    list(value = 0L, label = "Not given")),
  attributes = FALSE)

tmp <- dp_generate_fielddescriptor(dta$factor1, "f1", use_existing = FALSE, 
  categories_type = "resource")
expect_equal(dp_property(tmp, "type"), "integer")
expect_equal(dp_property(tmp, "categories"), list(resource="f1-categories"))

tmp <- dp_generate_fielddescriptor(dta$factor1, "factor1", use_existing = FALSE, use_categories = FALSE)
expect_equal(dp_property(tmp, "type"), "integer")
expect_equal(dp_property(tmp, "codelist"), NULL)



# ==================================================================
tmp <- dp_generate_fielddescriptor(dta$string1, "s1")
expect_equal(dp_property(tmp, "name"), "s1")
expect_equal(dp_property(tmp, "type"), "string")
expect_equal(dp_property(tmp, "codelist"), NULL)

tmp <- dp_generate_fielddescriptor(dta$integer1, "i1")
expect_equal(dp_property(tmp, "name"), "i1")
expect_equal(dp_property(tmp, "type"), "integer")
expect_equal(dp_property(tmp, "codelist"), NULL)

tmp <- dp_generate_fielddescriptor(dta$boolean1, "b1")
expect_equal(dp_property(tmp, "name"), "b1")
expect_equal(dp_property(tmp, "type"), "boolean")
expect_equal(dp_property(tmp, "codelist"), NULL)
expect_equal(tmp$codelist, NULL)

tmp <- dp_generate_fielddescriptor(dta$number2, "b1")
expect_equal(dp_property(tmp, "name"), "b1")
expect_equal(dp_property(tmp, "decimalChar"), "$")
expect_equal(dp_property(tmp, "groupChar"), " ")
expect_equal(dp_property(tmp, "type"), "number")
expect_equal(dp_property(tmp, "codelist"), NULL)

tmp <- dp_generate_fielddescriptor(dta$number2, "b1", use_existing = FALSE)
expect_equal(dp_property(tmp, "name"), "b1")
expect_equal(dp_property(tmp, "decimalChar"), NULL)
expect_equal(dp_property(tmp, "groupChar"), NULL)
expect_equal(dp_property(tmp, "type"), "number")
expect_equal(dp_property(tmp, "codelist"), NULL)

tmp <- dp_generate_fielddescriptor(dta$date1, "d1")
expect_equal(dp_property(tmp, "name"), "d1")
expect_equal(dp_property(tmp, "type"), "date")
expect_equal(dp_property(tmp, "codelist"), NULL)


# ==================================================================
dta <- dp |> dp_resource("complex") |> dp_get_data(convert_categories = "to_factor")

tmp <- dp_generate_fielddescriptor(dta$factor1, "f1")
expect_equal(dp_property(tmp, "name"), "f1")
expect_equal(dp_property(tmp, "type"), "integer")
expect_equal(dp_property(tmp, "categories"), list(resource="codelist-factor1"))

tmp <- dp_generate_fielddescriptor(dta$factor1, "f1", use_existing = FALSE)
expect_equal(dp_property(tmp, "name"), "f1")
expect_equal(dp_property(tmp, "type"), "integer")
expect_equal(
  dp_property(tmp, "categories"),
  list(
    list(value = 1L, label = "Purple"),
    list(value = 2L, label = "Red"),
    list(value = 3L, label = "Other"),
    list(value = 0L, label = "Not given")),
  attributes = FALSE)

tmp <- dp_generate_fielddescriptor(dta$factor1, "f1", use_existing = FALSE, 
  categories_type = "resource")
expect_equal(dp_property(tmp, "name"), "f1")
expect_equal(dp_property(tmp, "type"), "integer")
expect_equal(dp_property(tmp, "categories"), list(resource = "f1-categories"))

tmp <- dp_generate_fielddescriptor(dta$factor1, "f1", use_existing = FALSE, use_categories = FALSE)
expect_equal(dp_property(tmp, "name"), "f1")
expect_equal(dp_property(tmp, "type"), "integer")
# Note that this one is different than the previous cases for this variable. factor1 is now a factor
# therefore a codelist is generated.
expect_equal(
  dp_property(tmp, "categories"),
  list(
    list(value = 1L, label = "Purple"),
    list(value = 2L, label = "Red"),
    list(value = 3L, label = "Other"),
    list(value = 4L, label = "Not given")),
  attributes = FALSE)

tmp <- dp_generate_fielddescriptor(dta$factor1, "f1", use_existing = FALSE, use_categories = FALSE,
  categories_type = "resource")
expect_equal(dp_property(tmp, "name"), "f1")
expect_equal(dp_property(tmp, "type"), "integer")
# Note that this one is different than the previous cases for this variable. factor1 is now a factor
# therefore a codelist is generated.
expect_equal(dp_property(tmp, "categories"), list(resource = "f1-categories"))


# ==================================================================
# And now test with a dataset where the columns not already have a fielddescriptor

data(iris)

tmp <- dp_generate_fielddescriptor(iris$Species, "sp")
expect_equal(dp_property(tmp, "name"), "sp")
expect_equal(dp_property(tmp, "type"), "integer")
expect_equal(
  dp_property(tmp, "categories"),
  list(
    list(value = 1L, label = "setosa"),
    list(value = 2L, label = "versicolor"),
    list(value = 3L, label = "virginica")),
  attributes = FALSE)

tmp <- dp_generate_fielddescriptor(iris$Species, "sp", use_existing = FALSE)
expect_equal(dp_property(tmp, "name"), "sp")
expect_equal(dp_property(tmp, "type"), "integer")
expect_equal(
  dp_property(tmp, "categories"),
  list(
    list(value = 1L, label = "setosa"),
    list(value = 2L, label = "versicolor"),
    list(value = 3L, label = "virginica")),
  attributes = FALSE)

tmp <- dp_generate_fielddescriptor(iris$Species, "sp", use_categories = TRUE, use_existing = FALSE)
expect_equal(dp_property(tmp, "name"), "sp")
expect_equal(dp_property(tmp, "type"), "integer")
expect_equal(
  dp_property(tmp, "categories"),
  list(
    list(value = 1L, label = "setosa"),
    list(value = 2L, label = "versicolor"),
    list(value = 3L, label = "virginica")),
  attributes = FALSE)

tmp <- dp_generate_fielddescriptor(iris$Species, "sp", use_categories = FALSE, use_existing = FALSE)
expect_equal(dp_property(tmp, "name"), "sp")
expect_equal(dp_property(tmp, "type"), "integer")
expect_equal(
  dp_property(tmp, "categories"),
  list(
    list(value = 1L, label = "setosa"),
    list(value = 2L, label = "versicolor"),
    list(value = 3L, label = "virginica")),
  attributes = FALSE)


tmp <- dp_generate_fielddescriptor(iris$Species, "sp", categories_type = "resource")
expect_equal(dp_property(tmp, "name"), "sp")
expect_equal(dp_property(tmp, "type"), "integer")
expect_equal(dp_property(tmp, "categories"), list(resource = "sp-categories"))


tmp <- dp_generate_fielddescriptor(iris$Species, "sp", use_existing = FALSE, categories_type = "resource")
expect_equal(dp_property(tmp, "name"), "sp")
expect_equal(dp_property(tmp, "type"), "integer")
expect_equal(dp_property(tmp, "categories"), list(resource = "sp-categories"))

tmp <- dp_generate_fielddescriptor(iris$Sepal.Width, "sw")
expect_equal(dp_property(tmp, "name"), "sw")
expect_equal(dp_property(tmp, "type"), "number")
expect_equal(dp_property(tmp, "categories"), NULL)

tmp <- dp_generate_fielddescriptor(iris$Sepal.Width, "sw", use_existing = FALSE)
expect_equal(dp_property(tmp, "name"), "sw")
expect_equal(dp_property(tmp, "type"), "number")
expect_equal(dp_property(tmp, "categories"), NULL)



# ==================================================================
# CODE OBJECT
library(codelist)

cl <- codelist(c("a", "b", "c"), c("A", "B", "C"))
x <- code(c("a", "c", "c"), cl)

res <- dp_categorieslist(x)
expect_equal(names(res), c("value", "label"))
expect_equal(res$value, cl$code)
expect_equal(res$label, cl$label)

res <- dp_generate_fielddescriptor(x, "foo")
expect_equal(dp_name(res), "foo")
expect_equal(dp_property(res, "type"), "string")
expect_equal(dp_property(res, "categories"), list(
      list(value = "a", label = "A"),
      list(value = "b", label = "B"),
      list(value = "c", label = "C")
    ))

res <- dp_generate_fielddescriptor(x, "foo", use_categories = FALSE)
expect_equal(dp_name(res), "foo")
expect_equal(dp_property(res, "type"), "string")
expect_equal(dp_property(res, "categories"), list(
      list(value = "a", label = "A"),
      list(value = "b", label = "B"),
      list(value = "c", label = "C")
    ))

res <- dp_generate_fielddescriptor(x, "foo", categories_type = "resource")
expect_equal(dp_name(res), "foo")
expect_equal(dp_property(res, "type"), "string")
expect_equal(dp_property(res, "categories"), list(
      resource = "foo-categories"
    ))

res <- dp_generate_fielddescriptor(x, "foo")
res$test <- 22
attr(x, "fielddescriptor") <- res
res <- dp_generate_fielddescriptor(x, "bar")
expect_equal(dp_name(res), "bar")
expect_equal(dp_property(res, "type"), "string")
expect_equal(dp_property(res, "test"), 22)
expect_equal(dp_property(res, "categories"), list(
      list(value = "a", label = "A"),
      list(value = "b", label = "B"),
      list(value = "c", label = "C")
    ))


cl <- codelist(c(11, 22, 33), c("A", "B", "C"))
x <- code(c(11, 22, 33), cl)
res <- dp_categorieslist(x)
expect_equal(names(res), c("value", "label"))
expect_equal(res$value, cl$code)
expect_equal(res$label, cl$label)


