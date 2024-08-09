library(datapackage)
source("helpers.R")

dir <- system.file("tests/test01", package = "datapackage")
if (dir == "") dir <- "../inst/tests/test01"

dp <- opendatapackage(dir)

dta <- dp |> dpresource("complex") |> dpgetdata()
tmp <- dpgeneratefielddescriptor(dta$factor1, "factor1")
expect_equal(dpproperty(tmp$fielddescriptor, "type"), "integer")
expect_equal(dpproperty(tmp$fielddescriptor, "categories"), list(resource="codelist-factor1"))
expect_equal(tmp$codelist, 
  data.frame(value = c(1,2,3,0), label = c("Purple", "Red", "Other", "Not given")),
  attributes = FALSE)

tmp <- dpgeneratefielddescriptor(dta$factor1, "factor1", use_existing = FALSE)
expect_equal(dpproperty(tmp$fielddescriptor, "type"), "integer")
expect_equal(
  dpproperty(tmp$fielddescriptor, "categories"),
  list(
    list(value = 1L, label = "Purple"),
    list(value = 2L, label = "Red"),
    list(value = 3L, label = "Other"),
    list(value = 0L, label = "Not given")),
  attributes = FALSE)
expect_equal(tmp$codelist, NULL)

tmp <- dpgeneratefielddescriptor(dta$factor1, "factor1", use_existing = FALSE, 
  categories_type = "resource")
expect_equal(dpproperty(tmp$fielddescriptor, "type"), "integer")
expect_equal(dpproperty(tmp$fielddescriptor, "categories"), list(resource="factor1-codelist"))
expect_equal(tmp$codelist, 
  data.frame(value = c(1,2,3,0), label = c("Purple", "Red", "Other", "Not given")),
  attributes = FALSE)

tmp <- dpgeneratefielddescriptor(dta$factor1, "factor1", use_existing = FALSE, use_codelist = FALSE)
expect_equal(dpproperty(tmp$fielddescriptor, "type"), "integer")
expect_equal(dpproperty(tmp$fielddescriptor, "codelist"), NULL)
expect_equal(tmp$codelist, NULL)

tmp <- dpgeneratefielddescriptor(dta$string1, "s1")
expect_equal(dpproperty(tmp$fielddescriptor, "name"), "s1")
expect_equal(dpproperty(tmp$fielddescriptor, "type"), "string")
expect_equal(dpproperty(tmp$fielddescriptor, "codelist"), NULL)
expect_equal(tmp$codelist, NULL)

tmp <- dpgeneratefielddescriptor(dta$integer1, "i1")
expect_equal(dpproperty(tmp$fielddescriptor, "name"), "i1")
expect_equal(dpproperty(tmp$fielddescriptor, "type"), "integer")
expect_equal(dpproperty(tmp$fielddescriptor, "codelist"), NULL)
expect_equal(tmp$codelist, NULL)

tmp <- dpgeneratefielddescriptor(dta$boolean1, "b1")
expect_equal(dpproperty(tmp$fielddescriptor, "name"), "b1")
expect_equal(dpproperty(tmp$fielddescriptor, "type"), "boolean")
expect_equal(dpproperty(tmp$fielddescriptor, "codelist"), NULL)
expect_equal(tmp$codelist, NULL)

tmp <- dpgeneratefielddescriptor(dta$number2, "b1")
expect_equal(dpproperty(tmp$fielddescriptor, "name"), "b1")
expect_equal(dpproperty(tmp$fielddescriptor, "decimalChar"), "$")
expect_equal(dpproperty(tmp$fielddescriptor, "groupChar"), " ")
expect_equal(dpproperty(tmp$fielddescriptor, "type"), "number")
expect_equal(dpproperty(tmp$fielddescriptor, "codelist"), NULL)
expect_equal(tmp$codelist, NULL)

tmp <- dpgeneratefielddescriptor(dta$number2, "b1", use_existing = FALSE)
expect_equal(dpproperty(tmp$fielddescriptor, "name"), "b1")
expect_equal(dpproperty(tmp$fielddescriptor, "decimalChar"), NULL)
expect_equal(dpproperty(tmp$fielddescriptor, "groupChar"), NULL)
expect_equal(dpproperty(tmp$fielddescriptor, "type"), "number")
expect_equal(dpproperty(tmp$fielddescriptor, "codelist"), NULL)
expect_equal(tmp$codelist, NULL)

tmp <- dpgeneratefielddescriptor(dta$date1, "d1")
expect_equal(dpproperty(tmp$fielddescriptor, "name"), "d1")
expect_equal(dpproperty(tmp$fielddescriptor, "type"), "date")
expect_equal(dpproperty(tmp$fielddescriptor, "codelist"), NULL)
expect_equal(tmp$codelist, NULL)


dta <- dp |> dpresource("complex") |> dpgetdata(to_factor = TRUE)

tmp <- dpgeneratefielddescriptor(dta$factor1, "f1")
expect_equal(dpproperty(tmp$fielddescriptor, "name"), "f1")
expect_equal(dpproperty(tmp$fielddescriptor, "type"), "integer")
expect_equal(dpproperty(tmp$fielddescriptor, "categories"), list(resource="codelist-factor1"))
expect_equal(tmp$codelist, 
  data.frame(value = c(1,2,3,0), label = c("Purple", "Red", "Other", "Not given")),
  attributes = FALSE)

tmp <- dpgeneratefielddescriptor(dta$factor1, "f1", use_existing = FALSE)
expect_equal(dpproperty(tmp$fielddescriptor, "name"), "f1")
expect_equal(dpproperty(tmp$fielddescriptor, "type"), "integer")
expect_equal(
  dpproperty(tmp$fielddescriptor, "categories"),
  list(
    list(value = 1L, label = "Purple"),
    list(value = 2L, label = "Red"),
    list(value = 3L, label = "Other"),
    list(value = 0L, label = "Not given")),
  attributes = FALSE)
expect_equal(tmp$codelist, NULL)

tmp <- dpgeneratefielddescriptor(dta$factor1, "f1", use_existing = FALSE, 
  categories_type = "resource")
expect_equal(dpproperty(tmp$fielddescriptor, "name"), "f1")
expect_equal(dpproperty(tmp$fielddescriptor, "type"), "integer")
expect_equal(dpproperty(tmp$fielddescriptor, "categories"), list(resource = "f1-codelist"))
expect_equal(tmp$codelist, 
  data.frame(value = c(1,2,3,0), label = c("Purple", "Red", "Other", "Not given")),
  attributes = FALSE)

tmp <- dpgeneratefielddescriptor(dta$factor1, "f1", use_existing = FALSE, use_codelist = FALSE)
expect_equal(dpproperty(tmp$fielddescriptor, "name"), "f1")
expect_equal(dpproperty(tmp$fielddescriptor, "type"), "integer")
# Note that this one is different than the previous cases for this variable. factor1 is now a factor
# therefore a codelist is generated.
expect_equal(
  dpproperty(tmp$fielddescriptor, "categories"),
  list(
    list(value = 1L, label = "Purple"),
    list(value = 2L, label = "Red"),
    list(value = 3L, label = "Other"),
    list(value = 4L, label = "Not given")),
  attributes = FALSE)
expect_equal(tmp$codelist, NULL)

tmp <- dpgeneratefielddescriptor(dta$factor1, "f1", use_existing = FALSE, use_codelist = FALSE,
  categories_type = "resource")
expect_equal(dpproperty(tmp$fielddescriptor, "name"), "f1")
expect_equal(dpproperty(tmp$fielddescriptor, "type"), "integer")
# Note that this one is different than the previous cases for this variable. factor1 is now a factor
# therefore a codelist is generated.
expect_equal(dpproperty(tmp$fielddescriptor, "categories"), list(resource = "f1-codelist"))
expect_equal(tmp$codelist, 
  data.frame(value = c(1,2,3,4), label = c("Purple", "Red", "Other", "Not given")),
  attributes = FALSE)


