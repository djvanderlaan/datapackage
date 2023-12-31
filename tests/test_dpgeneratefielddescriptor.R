library(datapackage)
source("helpers.R")

dir <- system.file("tests/test01", package = "datapackage")
if (dir == "") dir <- "../inst/tests/test01"

dp <- opendatapackage(dir)

dta <- dp |> dpresource("complex") |> dpgetdata()
tmp <- dpgeneratefielddescriptor(dta$factor1, "factor1")
expect_equal(dpproperty(tmp$fielddescriptor, "type"), "integer")
expect_equal(dpproperty(tmp$fielddescriptor, "codelist"), "codelist-factor1")
expect_equal(tmp$codelist, data.frame(code = c(1,2,3,0), label = c("Purple", "Red", "Other", "Not given")),
  attributes = FALSE)

tmp <- dpgeneratefielddescriptor(dta$factor1, "factor1", use_existing = FALSE)
expect_equal(dpproperty(tmp$fielddescriptor, "type"), "integer")
expect_equal(dpproperty(tmp$fielddescriptor, "codelist"), "codelist-factor1")
expect_equal(tmp$codelist, data.frame(code = c(1,2,3,0), label = c("Purple", "Red", "Other", "Not given")),
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


dta <- dp |> dpresource("complex") |> dpgetdata(to_factor = TRUE)

tmp <- dpgeneratefielddescriptor(dta$factor1, "f1")
expect_equal(dpproperty(tmp$fielddescriptor, "name"), "f1")
expect_equal(dpproperty(tmp$fielddescriptor, "type"), "integer")
expect_equal(dpproperty(tmp$fielddescriptor, "codelist"), "codelist-factor1")
expect_equal(tmp$codelist, data.frame(code = c(1,2,3,0), label = c("Purple", "Red", "Other", "Not given")),
  attributes = FALSE)

tmp <- dpgeneratefielddescriptor(dta$factor1, "f1", use_existing = FALSE)
expect_equal(dpproperty(tmp$fielddescriptor, "name"), "f1")
expect_equal(dpproperty(tmp$fielddescriptor, "type"), "integer")
expect_equal(dpproperty(tmp$fielddescriptor, "codelist"), "codelist-factor1")
expect_equal(tmp$codelist, data.frame(code = c(1,2,3,0), label = c("Purple", "Red", "Other", "Not given")),
  attributes = FALSE)

tmp <- dpgeneratefielddescriptor(dta$factor1, "f1", use_existing = FALSE, use_codelist = FALSE)
expect_equal(dpproperty(tmp$fielddescriptor, "name"), "f1")
expect_equal(dpproperty(tmp$fielddescriptor, "type"), "integer")
expect_equal(dpproperty(tmp$fielddescriptor, "codelist"), "codelist-factor1")
# Note that this one is different than the previous cases for this variable. factor1 is now a factor
# therefore a codelist is generated.
expect_equal(tmp$codelist, data.frame(code = c(1:4), label = c("Purple", "Red", "Other", "Not given")),
  attributes = FALSE)


