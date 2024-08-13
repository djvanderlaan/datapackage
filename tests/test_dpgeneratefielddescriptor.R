library(datapackage)
source("helpers.R")

dir <- system.file("tests/test01", package = "datapackage")
if (dir == "") dir <- "../inst/tests/test01"

dp <- opendatapackage(dir)
dta <- dp |> dpresource("complex") |> dpgetdata()

# ==================================================================
tmp <- dpgeneratefielddescriptor(dta$factor1, "f1")
expect_equal(dpproperty(tmp, "name"), "f1")
expect_equal(dpproperty(tmp, "type"), "integer")
expect_equal(dpproperty(tmp, "categories"), list(resource="codelist-factor1", valueField="code"))

tmp <- dpgeneratefielddescriptor(dta$factor1, "f1", use_existing = FALSE)
expect_equal(dpproperty(tmp, "name"), "f1")
expect_equal(dpproperty(tmp, "type"), "integer")
expect_equal(
  dpproperty(tmp, "categories"),
  list(
    list(value = 1L, label = "Purple"),
    list(value = 2L, label = "Red"),
    list(value = 3L, label = "Other"),
    list(value = 0L, label = "Not given")),
  attributes = FALSE)

tmp <- dpgeneratefielddescriptor(dta$factor1, "f1", use_existing = FALSE, 
  categories_type = "resource")
expect_equal(dpproperty(tmp, "type"), "integer")
expect_equal(dpproperty(tmp, "categories"), list(resource="f1-categories"))

tmp <- dpgeneratefielddescriptor(dta$factor1, "factor1", use_existing = FALSE, use_categories = FALSE)
expect_equal(dpproperty(tmp, "type"), "integer")
expect_equal(dpproperty(tmp, "codelist"), NULL)



# ==================================================================
tmp <- dpgeneratefielddescriptor(dta$string1, "s1")
expect_equal(dpproperty(tmp, "name"), "s1")
expect_equal(dpproperty(tmp, "type"), "string")
expect_equal(dpproperty(tmp, "codelist"), NULL)

tmp <- dpgeneratefielddescriptor(dta$integer1, "i1")
expect_equal(dpproperty(tmp, "name"), "i1")
expect_equal(dpproperty(tmp, "type"), "integer")
expect_equal(dpproperty(tmp, "codelist"), NULL)

tmp <- dpgeneratefielddescriptor(dta$boolean1, "b1")
expect_equal(dpproperty(tmp, "name"), "b1")
expect_equal(dpproperty(tmp, "type"), "boolean")
expect_equal(dpproperty(tmp, "codelist"), NULL)
expect_equal(tmp$codelist, NULL)

tmp <- dpgeneratefielddescriptor(dta$number2, "b1")
expect_equal(dpproperty(tmp, "name"), "b1")
expect_equal(dpproperty(tmp, "decimalChar"), "$")
expect_equal(dpproperty(tmp, "groupChar"), " ")
expect_equal(dpproperty(tmp, "type"), "number")
expect_equal(dpproperty(tmp, "codelist"), NULL)

tmp <- dpgeneratefielddescriptor(dta$number2, "b1", use_existing = FALSE)
expect_equal(dpproperty(tmp, "name"), "b1")
expect_equal(dpproperty(tmp, "decimalChar"), NULL)
expect_equal(dpproperty(tmp, "groupChar"), NULL)
expect_equal(dpproperty(tmp, "type"), "number")
expect_equal(dpproperty(tmp, "codelist"), NULL)

tmp <- dpgeneratefielddescriptor(dta$date1, "d1")
expect_equal(dpproperty(tmp, "name"), "d1")
expect_equal(dpproperty(tmp, "type"), "date")
expect_equal(dpproperty(tmp, "codelist"), NULL)


# ==================================================================
dta <- dp |> dpresource("complex") |> dpgetdata(to_factor = TRUE)

tmp <- dpgeneratefielddescriptor(dta$factor1, "f1")
expect_equal(dpproperty(tmp, "name"), "f1")
expect_equal(dpproperty(tmp, "type"), "integer")
expect_equal(dpproperty(tmp, "categories"), list(resource="codelist-factor1", valueField = "code"))

tmp <- dpgeneratefielddescriptor(dta$factor1, "f1", use_existing = FALSE)
expect_equal(dpproperty(tmp, "name"), "f1")
expect_equal(dpproperty(tmp, "type"), "integer")
expect_equal(
  dpproperty(tmp, "categories"),
  list(
    list(value = 1L, label = "Purple"),
    list(value = 2L, label = "Red"),
    list(value = 3L, label = "Other"),
    list(value = 0L, label = "Not given")),
  attributes = FALSE)

tmp <- dpgeneratefielddescriptor(dta$factor1, "f1", use_existing = FALSE, 
  categories_type = "resource")
expect_equal(dpproperty(tmp, "name"), "f1")
expect_equal(dpproperty(tmp, "type"), "integer")
expect_equal(dpproperty(tmp, "categories"), list(resource = "f1-categories"))

tmp <- dpgeneratefielddescriptor(dta$factor1, "f1", use_existing = FALSE, use_categories = FALSE)
expect_equal(dpproperty(tmp, "name"), "f1")
expect_equal(dpproperty(tmp, "type"), "integer")
# Note that this one is different than the previous cases for this variable. factor1 is now a factor
# therefore a codelist is generated.
expect_equal(
  dpproperty(tmp, "categories"),
  list(
    list(value = 1L, label = "Purple"),
    list(value = 2L, label = "Red"),
    list(value = 3L, label = "Other"),
    list(value = 4L, label = "Not given")),
  attributes = FALSE)

tmp <- dpgeneratefielddescriptor(dta$factor1, "f1", use_existing = FALSE, use_categories = FALSE,
  categories_type = "resource")
expect_equal(dpproperty(tmp, "name"), "f1")
expect_equal(dpproperty(tmp, "type"), "integer")
# Note that this one is different than the previous cases for this variable. factor1 is now a factor
# therefore a codelist is generated.
expect_equal(dpproperty(tmp, "categories"), list(resource = "f1-categories"))


