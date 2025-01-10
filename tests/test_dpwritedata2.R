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
res <- dp_generate_dataresource(iris, "iris") 
dp_resources(dp) <- res
dp_write_data(dp, resourcename = "iris", data = iris, write_categories = TRUE)

# OPen the new datapacakge, read the data and check
dp2 <- opendatapackage(dir)
iris2 <- dp2 |> dp_resource("iris") |> dp_get_data(convert_categories = "to_factor")
expect_equal(iris, iris2, attributes = FALSE)

# Clean up
for (f in list.files(dir, full.names = TRUE)) file.remove(f)
ignore <- file.remove(dir)


# ==========================================================
# Use a custom codelist
dir <- tempdir()

# Create the datapackage
dp <- newdatapackage(dir, name = "iris")
res <- dp_generate_dataresource(iris, "iris", categories_type = "resource") 
dp_resources(dp) <- res

# SAve the custom code list
#codelistres <- dp |> dp_resource("Species-codelist")
codelist <- data.frame(
  value = c(101, 102, 103),
  label = c("setosa", "virginica", "versicolor"))
codelistres <- dp_generate_dataresource(codelist, "species-categories")
dp_resources(dp) <- codelistres
dp_write_data(dp, "species-categories", data = codelist, write_categories = FALSE)

# Write the dtaset
dp_write_data(dp, resourcename = "iris", data = iris, write_categories = FALSE)

# Open the new datapacakge, read the data and check
dp2 <- opendatapackage(dir)
iris2 <- dp2 |> dp_resource("iris") |> dp_get_data(convert_categories = "to_factor")
# Check the levels
expect_equal(levels(iris2$Species), c("setosa", "virginica", "versicolor"))
# We need to convert to character as the levels are in a differnet order
# as specified
iris$Species <- as.character(iris$Species)
iris2$Species <- as.character(iris2$Species)
expect_equal(iris, iris2, attributes = FALSE)

# Check if the file has the correct codes
iris2 <- dp2 |> dp_resource("iris") |> dp_get_data(convert_categories = "no")
expect_equal(unique(iris2$Species), c(101, 103, 102))

for (f in list.files(dir, full.names = TRUE)) file.remove(f)
ignore <- file.remove(dir)


# =============================================================================
# Missing values coded as NA
dir <- tempdir()

data(iris)
for (col in names(iris)) iris[[col]][sample(nrow(iris), 10)] <- NA

# Create the datapackage
dp <- newdatapackage(dir, name = "iris")
res <- dp_generate_dataresource(iris, "iris") 
dp_property(res, "dialect") <- list(nullSequence = "FOO")
dp_resources(dp) <- res
dp_write_data(dp, resourcename = "iris", data = iris, write_categories = TRUE)
# OPen the new datapacakge, read the data and check
dp2 <- opendatapackage(dir)
iris2 <- dp2 |> dp_resource("iris") |> dp_get_data(convert_categories = "to_factor")
expect_equal(iris, iris2, attributes = FALSE)
# Clean up
for (f in list.files(dir, full.names = TRUE)) file.remove(f)
ignore <- file.remove(dir)
