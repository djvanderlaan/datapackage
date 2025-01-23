library(datapackage)

dp_to_code <- function(x, categorieslist = dp_categorieslist(x), ..., 
    warn = FALSE) {
  if (!requireNamespace("codelist")) {
    stop("In order to use 'dp_to_code' the 'codelist' package needs ",
      "to be installed.")
  }
  if (is.null(categorieslist)) {
    if (warn) warning("Field does not have an associated code list. ", 
      "Returning original vector.")
    return(x)
  }
  stopifnot(is.data.frame(categorieslist))
  # Determine which columns from the categorieslist contain the 
  # codes and labels
  fields <- datapackage:::getfieldsofcategorieslist(categorieslist)
  codelist <- codelist::as.codelist(categorieslist, code = fields$value, 
    label = fields$label, ...)
  res <- codelist::code(x, codelist = codelist)
  structure(res, fielddescriptor = attr(x, "fielddescriptor"))
}

fn <- system.file("examples/iris", package = "datapackage")
dp <- open_datapackage(fn)
dp


dta <- dp |> dp_get_data("complex", convert_categories = "to_factor")
dta

dta <- dp |> dp_get_data("complex", convert_categories = "no")
dta

dta <- dp |> dp_get_data("complex", convert_categories = "dp_to_coded")
dta


dta$factor1 == 1
dta$factor1 == 10
dta$factor1 == "Purple"
dta$factor1 == as.label("Purple")


dta <- dp_load_from_datapackage("work/employ", 
  convert_categories = "dp_to_coded")
dta

table(labels(dta$employmentstatus, FALSE), useNA = "ifany")

table(labels(dta$employmentstatus), useNA = "ifany")

