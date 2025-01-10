
#library(datapackage)

pkgload::load_all()

dp <- opendatapackage("work/employ")
dp

dta <- dp |> dpresource("employment") |> dpgetdata()
dta

cl <- dpcategorieslist(dta$employmentstatus)
cl

res <- attr(cl, "resource")

dpproperty(res, "categoriesFieldMap")

dptofactor(dta$employmentstatus)

