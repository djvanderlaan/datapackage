library(datapackage)
source("helpers.R")

dir <- system.file("tests/test01", package = "datapackage")
if (dir == "") dir <- "../inst/tests/test01"

dp <- opendatapackage(dir)

dta <- dp |> dp_resource("complex") |> dp_get_data()

newdir <- tempdir()

newdp <- newdatapackage(newdir)
dpname(newdp) <- "test"

res <- dp_generate_dataresource(dta, "complex")
# We expect one resource
expect_equal(dpname(res), "complex")

# Needed because we have "" in a string field which by default will not
# be recognized as missing value;
res$schema$fields[[9]]$missingValues <- list("")

dp_resources(newdp) <- res
expect_equal(dp_resource_names(newdp), c("complex"))

# We only expect the datapackage.json file in dir
expect_equal(list.files(newdir), "datapackage.json")

dp_write_data(newdp, "complex", data = dta)
expect_equal(list.files(newdir), sort(c("datapackage.json", "complex.csv")))

# Check each of the CSV-files
# complex.csv
csv <- readLines(file.path(newdir, "complex.csv")) 
expected <- c("\"string1\",\"integer1\",\"boolean1\",\"number1\",\"number2\",\"boolean2\",\"date1\",\"factor1\",\"factor2\"", 
  "\"a\",1,TRUE,1.2,1.2,TRUE,2020-01-01,1,\"101\"", "\"b\",-100,FALSE,-1e-04,-0.001,FALSE,2022-01-12,2,\"102\"", 
  "\"c\",,TRUE,Inf,1100,TRUE,,1,\"101\"", "\"\",100,TRUE,10000,-11000.4,,1950-10-10,3,\"103\"", 
  "\"f\",0,,,,FALSE,1920-12-10,,\"102\"", "\"g\",0,FALSE,,0,TRUE,2002-02-20,3,")
expect_equal(csv, expected)

# When we read the data back in again from the new datapackage we should get the
# same data as from the original package
# without to_factor
dp2 <- opendatapackage(newdir)
dta <- dp |> dp_resource("complex") |> dp_get_data()
dta2 <- dp2 |> dp_resource("complex") |> dp_get_data(convert_categories = "no")
expect_equal(dta, dta2, attributes = FALSE)
# with to_factor
dta <- dp_get_data(dp, "complex", convert_categories = "to_factor")
dta2 <- dp2 |> dp_resource("complex") |> dp_get_data(convert_categories = "to_factor")
expect_equal(dta, dta2, attributes = FALSE)


# Cleanup
files <- list.files(newdir, full.names = TRUE)
for (file in files) file.remove(file)
ignore <- file.remove(newdir)


# =======================================================================================
# Keep old meta

dp <- opendatapackage(dir)

dta <- dp |> dp_resource("complex") |> dp_get_data()

newdir <- tempdir()


newdp <- newdatapackage(newdir)
dpname(newdp) <- "test"

res <- dp_generate_dataresource(dta, "complex", use_existing = TRUE)
# We expect one resource
expect_equal(dpname(res), "complex")

# Needed because we have "" in a string field which by default will not
# be recognized as missing value;

dp_resources(newdp) <- res
expect_equal(dp_resource_names(newdp), c("complex"))

# We only expect the datapackage.json file in dir
expect_equal(list.files(newdir), "datapackage.json")

dp_write_data(newdp, "complex", data = dta)

expect_equal(list.files(newdir), sort(c("codelist-factor1.csv", 
      "codelist-factor2.csv", "datapackage.json", "complex.csv")))

# Check each of the CSV-files
# factor1
csv <- readLines(file.path(newdir, "codelist-factor1.csv")) 
expected <- c("\"code\",\"label\"", "1,\"Purple\"", "2,\"Red\"", "3,\"Other\"", 
  "0,\"Not given\"")
expect_equal(csv, expected)
# factor2
csv <- readLines(file.path(newdir, "codelist-factor2.csv")) 
expected <- c("\"code\",\"label\"", "\"101\",\"circle\"", "\"102\",\"square\"", 
  "\"103\",\"triangle\"")
expect_equal(csv, expected)
# complex.csv
csv <- readLines(file.path(newdir, "complex.csv")) 
expected <- c("\"string1\",\"integer1\",\"boolean1\",\"number1\",\"number2\",\"boolean2\",\"date1\",\"factor1\",\"factor2\"", 
  "\"a\",1,TRUE,1.2,1$2,TRUE,2020-01-01,1,\"101\"", "\"b\",-100,FALSE,-1e-04,-0$001,FALSE,2022-01-12,2,\"102\"", 
  "\"c\",,TRUE,Inf,1 100,TRUE,,1,\"101\"", "\"\",100,TRUE,10000,-11 000$4,,1950-10-10,3,\"103\"", 
  "\"f\",0,,,,FALSE,1920-12-10,,\"102\"", "\"g\",0,FALSE,,0,TRUE,2002-02-20,3,")
expect_equal(csv, expected)


# When we read the data back in again from the new datapackage we should get the
# same data as from the original package
# without to_factor
dp2 <- opendatapackage(newdir)
dta <- dp |> dp_resource("complex") |> dp_get_data()
dta2 <- dp2 |> dp_resource("complex") |> dp_get_data(convert_categories = "no")
expect_equal(dta, dta2, attributes = FALSE)
# with to_factor
dta <- dp_get_data(dp, "complex", convert_categories = "to_factor")
dta2 <- dp2 |> dp_resource("complex") |> dp_get_data(convert_categories = "to_factor")
expect_equal(dta, dta2, attributes = FALSE)


# Cleanup
files <- list.files(newdir, full.names = TRUE)
for (file in files) file.remove(file)
ignore <- file.remove(newdir)


