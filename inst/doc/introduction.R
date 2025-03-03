# tldropen
library(datapackage, warn.conflicts = FALSE)
dir <- system.file("examples/employ", package = "datapackage")
dp <- open_datapackage(dir)
dp

# tldrgetdata
dta <- dp |> dp_resource("employment") |> dp_get_data()
dta

# tldrload
dta <- dp_load_from_datapackage(dir, "employment")
dta

# tldrloadfactor
dta <- dp_load_from_datapackage(dir, "employment", 
  convert_categories = "to_factor")
dta

# tldrloadcode
library(codelist)
dta <- dp_load_from_datapackage(dir, "employment", 
  convert_categories = "to_code")
dta

# g1
library(datapackage, warn.conflicts = FALSE)
dir <- system.file("examples/employ", package = "datapackage")
dp <- open_datapackage(dir)
dp

# g2
dp_nresources(dp)

# g3
dp_resource_names(dp)

# g4
employ <- dp_resource(dp, "employment")
employ

# g5
print(employ, properties = NA)

# g6
dta <- dp_get_data(employ)
head(dta)

# g7
dta <- dp_get_data(dp, "employment")

# g8
dp_path(employ)

# g10
fn <- dp_path(employ, full_path = TRUE)

# g11
dta <- read.csv2(fn)
head(dta)

# dialect
dp_property(employ, "dialect")

# income
dp_field(employ, "income")

# dpapplyschema
dp_apply_schema(dta, employ)

# g12
dta <- dp_resource(dp, "employment") |> dp_get_data()
head(dta)

# r1
dp_name(dp)
dp_description(dp)
dp_description(dp, first_paragraph = TRUE)
dp_title(dp)

# r2
dp_title(employ)
dp_resource(dp, "codelist-employ") |> dp_title()

# r3
dp_path(employ)
dp_path(employ, full_path = TRUE)

# r4
dp_property(employ, "encoding")

# c1
dta <- dp_resource(dp, "employment") |> dp_get_data()
dta

# c2
dp_categorieslist(dta$employ)

# c3
dp_to_factor(dta$employ)

# c4
dta <- dp_resource(dp, "employment") |> 
  dp_get_data(convert_categories = "to_factor")
dta

# c4
dta <- dp_resource(dp, "employment") |> 
  dp_get_data(convert_categories = "to_code")
dta

# codedemo
library(codelist)
dta[dta$gender == "X", ]
dta[dta$gender == as.label("Other"), ]

# q1
dir <- tempfile()
data(iris)
dp_save_as_datapackage(iris, dir)

# q2
dp_load_from_datapackage(dir) |> head()

# q2
dp_load_from_datapackage(dir, "iris", convert_categories = "to_factor", 
  use_fread = TRUE)

# n5
file.remove(file.path(dir, "datapackage.json"))
file.remove(file.path(dir, "iris.csv"))
file.remove(dir)

