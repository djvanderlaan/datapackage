library(datapackage)
library(codelist)

fn <- system.file("examples/iris", package = "datapackage")
dp <- opendatapackage(fn)

dp


dta <- dp |> dpgetdata("complex", convert_categories = "to_factor")
dta

dta <- dp |> dpgetdata("complex", convert_categories = "no")
dta

dpcategorieslist(dta$factor1)

cl <- dpcategorieslist(dta$factor1) |> as.codelist()
cl

tmp <- coded(dta$factor1, codelist = cl)
tmp

dptofactor

dptocoded <- function(x, categorieslist = dpcategorieslist(x), ..., warn = FALSE) {
  if (is.null(categorieslist)) {
    if (warn) warning("Field does not have an associated code list. Returning original vector.")
    return(x)
  }
  stopifnot(is.data.frame(categorieslist))
  # Determine which columns from the categorieslist contain the 
  # codes and labels
  fields <- datapackage:::getfieldsofcategorieslist(categorieslist)
  codelist <- as.codelist(categorieslist, code = fields$value, label = fields$label, ...)
  coded(x, codelist = codelist)
}

dta <- dp |> dpresource("complex") |> dpgetdata(convert_categories = "dptocoded")

dta

dta$factor1 == 1
dta$factor1 == 10
dta$factor1 == "Purple"
dta$factor1 == as.label("Purple")


dta <- dploadfromdatapackage("work/employ", convert_categories = "dptocoded")


table(labels(dta$employmentstatus, FALSE), useNA = "ifany")


cl <- dpcategorieslist(dta$employmentstatus)
cl

as.codelist(cl, format = "wide")


dptocoded(dta$factor1)

for (col in names(dta)) dta[[col]] <- dptocoded(dta[[col]], warn = FALSE)

dta



