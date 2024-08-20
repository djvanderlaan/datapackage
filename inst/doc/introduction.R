# g1
library(datapackage, warn.conflicts = FALSE)
dir <- system.file("examples/iris", package = "datapackage")
dp <- opendatapackage(dir)
print(dp)

# g2
dpnresources(dp)

# g3
dpresourcenames(dp)

# g4
iris <- dpresource(dp, "iris")
print(iris)

# g5
print(iris, properties = NA)

# g6
dta <- dpgetdata(iris)
head(dta)

# g7
dta <- dpgetdata(dp, "iris")

# g8
dppath(iris)

# g9
attr(dp, "path")
attr(iris, "path")

# g10
fn <- dppath(iris, fullpath = TRUE)

# g11
dta <- read.csv(fn)
head(dta)

# g12
dta <- dpresource(dp, "inline") |> dpgetdata()
head(dta)

# r1
dpname(dp)
dpdescription(dp)
dpdescription(dp, firstparagraph = TRUE)
dptitle(dp)

# r2
dptitle(iris)
dpresource(dp, "inline") |> dptitle()

# r3
dppath(iris)
dppath(iris, fullpath = TRUE)

# r4
dpproperty(iris, "encoding")

# c1
complex <- dpresource(dp, "complex") |> dpgetdata()
print(complex)

# c2
dpcategorieslist(complex$factor1)

# c3
dptofactor(complex$factor1)

# c4
complex <- dpresource(dp, "complex") |> dpgetdata(to_factor = TRUE)
print(complex)

# q1
dir <- tempfile()
data(iris)
dpsaveasdatapackage(iris, dir)

# q2
dploadfromdatapackage(dir) |> head()

# q2
dploadfromdatapackage(dir, "iris", to_factor = TRUE, use_fread = TRUE)

# n5
file.remove(file.path(dir, "datapackage.json"))
file.remove(file.path(dir, "iris.csv"))
file.remove(dir)

