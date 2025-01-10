# g1
library(datapackage, warn.conflicts = FALSE)
dir <- system.file("examples/iris", package = "datapackage")
dp <- open_datapackage(dir)
print(dp)

# g2
dp_nresources(dp)

# g3
dp_resource_names(dp)

# g4
iris <- dp_resource(dp, "iris")
print(iris)

# g5
print(iris, properties = NA)

# g6
dta <- dp_get_data(iris)
head(dta)

# g7
dta <- dp_get_data(dp, "iris")

# g8
dp_path(iris)

# g9
attr(dp, "path")
attr(iris, "path")

# g10
fn <- dp_path(iris, fullpath = TRUE)

# g11
dta <- read.csv(fn)
head(dta)

# g12
dta <- dp_resource(dp, "inline") |> dp_get_data()
head(dta)

# r1
dp_name(dp)
dp_description(dp)
dp_description(dp, firstparagraph = TRUE)
dp_title(dp)

# r2
dp_title(iris)
dp_resource(dp, "inline") |> dp_title()

# r3
dp_path(iris)
dp_path(iris, fullpath = TRUE)

# r4
dp_property(iris, "encoding")

# c1
complex <- dp_resource(dp, "complex") |> dp_get_data()
print(complex)

# c2
dp_categorieslist(complex$factor1)

# c3
dp_to_factor(complex$factor1)

# c4
complex <- dp_resource(dp, "complex") |> 
  dp_get_data(convert_categories = "to_factor")
print(complex)

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

