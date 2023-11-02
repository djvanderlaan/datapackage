
library(datapackage)

dp <- opendatapackage("work/codelist.json")

dta <- dp |> dpresource("codelist") |> dpgetdata()

dp |> dpresource("codelist-gender") |> dpgetdata()

dta$gender

datapackage <- dp
x <- dta$gender
schema <- attr(x, "schema")


recode_to_factor <- function(x, schema = attr(x, "schema"), datapackage) {
  codelist <- schema$codelist
  if (is.character(codelist)) {
    stopifnot(is.character(codelist), length(codelist) == 1)
    codelist <- dpgetdata(datapackage, codelist)
  }
  stopifnot(is.data.frame(codelist))
  # TODO: more intelligence in determining which column to use as codes and
  # labels
  codes  <- codelist[[1]]
  labels <- codelist[[2]]
  # TODO: check if codes are valid
  factor(x, levels = codes, labels = labels)
}

recode_to_factor(dta$gender, datapackage = dp)




x <- c(3,1,2,1,1,2)
attr(x, "codes") <- c(1,2,3)
attr(x, "labels") <- c("A", "B", "C")
x
x+1 # Ze zijn er nog, maar de codes kloppen niet meer
x[1:2] # Ze zijn weg, maar de codes kloppen nog wel
c(x, 1) # Ze zijn weg

