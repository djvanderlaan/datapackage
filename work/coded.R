library(datapackage)
library(codelist)

fn <- system.file("examples/iris", package = "datapackage")
dp <- opendatapackage(fn)

dp

dta <- dp |> dpgetdata("complex", to_factor = FALSE)

dp |> dpgetdata("complex", to_factor = TRUE)


dta$factor1



x <- dta$factor1

cl <- dpcategorieslist(dta$factor1) |> codelist()

tmp <- coded(dta$factor1, codelist = cl)

dptofactor

dptocoded <- function(x, categorieslist = dpcategorieslist(x), ..., warn = FALSE) {
  if (is.null(categorieslist)) {
    if (warn) warning("Field does not have an associated code list. Returning original vector.")
    return(x)
  }
  stopifnot(is.data.frame(categorieslist))
  codelist <- codelist(categorieslist, code = "value", label = "label", ...)
  coded(x, codelist = codelist)
}

dptocoded(dta$factor1)

for (col in names(dta)) dta[[col]] <- dptocoded(dta[[col]], warn = FALSE)

dta

dta$factor1 == 1
dta$factor1 == 10
dta$factor1 == "Purple"



