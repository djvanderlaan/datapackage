library(datapackage)
source("helpers.R")

# In this script we write the iris dataset to a datapackage, then read it back
# in and check if the dataset read in is the same as the original dataset

# =============================================================================
# First we use the default generated codelist for factors
dir <- tempdir()

data(iris)

# Create the datapackage
dp <- newdatapackage(dir, name = "iris")
res <- dpgeneratedataresources(iris, "iris") 
dpresources(dp) <- res
dpwritedata(dp, resourcename = "iris", data = iris, write_codelists = TRUE)

# OPen the new datapacakge, read the data and check
dp2 <- opendatapackage(dir)
iris2 <- dp2 |> dpresource("iris") |> dpgetdata(to_factor = TRUE)
expect_equal(iris, iris2, attributes = FALSE)

# Clean up
for (f in list.files(dir, full.names = TRUE)) file.remove(f)
file.remove(dir)


# ==========================================================
# Use a custom codelist
dir <- tempdir()

# Create the datapackage
dp <- newdatapackage(dir, name = "iris")
res <- dpgeneratedataresources(iris, "iris") 
dpresources(dp) <- res

# SAve the custom code list
codelistres <- dp |> dpresource("Species-codelist")
codelist <- data.frame(
  code = c(101, 102, 103),
  label = c("setosa", "virginica", "versicolor"))
dpwritedata(codelistres, data = codelist, write_codelists = FALSE)

# Write the dtaset
dpwritedata(dp, resourcename = "iris", data = iris, write_codelists = FALSE)

# Open the new datapacakge, read the data and check
dp2 <- opendatapackage(dir)
iris2 <- dp2 |> dpresource("iris") |> dpgetdata(to_factor = TRUE)
# Check the levels
expect_equal(levels(iris2$Species), c("setosa", "virginica", "versicolor"))
# We need to convert to character as the levels are in a differnet order
# as specified
iris$Species <- as.character(iris$Species)
iris2$Species <- as.character(iris2$Species)
expect_equal(iris, iris2, attributes = FALSE)

# Check if the file has the correct codes
iris2 <- dp2 |> dpresource("iris") |> dpgetdata(to_factor = FALSE)
expect_equal(unique(iris2$Species), c(101, 103, 102))

for (f in list.files(dir, full.names = TRUE)) file.remove(f)
file.remove(dir)


# =============================================================================
# Missing values coded as NA
dir <- tempdir()

data(iris)
for (col in names(iris)) iris[[col]][sample(nrow(iris), 10)] <- NA

# Create the datapackage
dp <- newdatapackage(dir, name = "iris")
res <- dpgeneratedataresources(iris, "iris") 
dpproperty(res[[1]], "dialect") <- list(nullSequence = "FOO")
dpresources(dp) <- res
dpwritedata(dp, resourcename = "iris", data = iris, write_codelists = TRUE)
# OPen the new datapacakge, read the data and check
dp2 <- opendatapackage(dir)
iris2 <- dp2 |> dpresource("iris") |> dpgetdata(to_factor = TRUE)
expect_equal(iris, iris2, attributes = FALSE)
# Clean up
for (f in list.files(dir, full.names = TRUE)) file.remove(f)
file.remove(dir)
