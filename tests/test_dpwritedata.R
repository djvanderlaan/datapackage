library(datapackage)
source("helpers.R")

dir <- system.file("tests/test01", package = "datapackage")
if (dir == "") dir <- "../inst/tests/test01"

dp <- opendatapackage(dir)

dta <- dp |> dpresource("complex") |> dpgetdata()

dir <- tempdir()


newdp <- newdatapackage(dir)
dpname(newdp) <- "test"

res <- dpgeneratedataresources(dta, "complex")
# We expect one resource
expect_equal(length(res), 1)
expect_equal(dpname(res[[1]]), "complex")

dpresources(newdp) <- res
expect_equal(dpresourcenames(newdp), c("complex"))

# We only expect the datapackage.json file in dir
expect_equal(list.files(dir), "datapackage.json")

dpwritedata(newdp, "complex", data = dta)
expect_equal(list.files(dir), sort(c("datapackage.json", "complex.csv")))

# Check each of the CSV-files
# complex.csv
csv <- readLines(file.path(dir, "complex.csv")) 
expected <- c("\"string1\",\"integer1\",\"boolean1\",\"number1\",\"number2\",\"boolean2\",\"date1\",\"factor1\",\"factor2\"", 
  "\"a\",1,TRUE,1.2,1.2,TRUE,2020-01-01,1,\"101\"", "\"b\",-100,FALSE,-1e-04,-0.001,FALSE,2022-01-12,2,\"102\"", 
  "\"c\",,TRUE,Inf,1100,TRUE,,1,\"101\"", "\"\",100,TRUE,10000,-11000.4,,1950-10-10,3,\"103\"", 
  "\"f\",0,,,,FALSE,1920-12-10,,\"102\"", "\"g\",0,FALSE,,0,TRUE,2002-02-20,3,")
expect_equal(csv, expected)

# When we read the data back in again from the new datapackage we should get the
# same data as from the original package
# without to_factor
dp2 <- opendatapackage(dir)
dta2 <- dp2 |> dpresource("complex") |> dpgetdata(to_factor = FALSE)
expect_equal(dta, dta2, attributes = FALSE)
# with to_factor
dta <- dpgetdata(dp, "complex", to_factor = TRUE)
dta2 <- dp2 |> dpresource("complex") |> dpgetdata(to_factor = TRUE)
expect_equal(dta, dta2, attributes = FALSE)


# Cleanup
files <- list.files(dir, full.names = TRUE)
for (file in files) file.remove(file)
ignore <- file.remove(dir)




# =======================================================================================
# Old version generating multiple resources; we will have to see how to handle this
#
#res <- dpgeneratedataresources(dta, "complex")
## We expect three resources: the dataset + 2xcodelist
#expect_equal(length(res), 3)
#expect_equal(dpname(res[[1]]), "complex")
#expect_equal(dpname(res[[2]]), "codelist-factor1")
#expect_equal(dpname(res[[3]]), "codelist-factor2")
#
#dpresources(newdp) <- res
#expect_equal(dpresourcenames(newdp), c("complex", "codelist-factor1", "codelist-factor2"))
#
## We only expect the datapackage.json file in dir
#expect_equal(list.files(dir), "datapackage.json")
#
#
#dpwritedata(newdp, "complex", data = dta)
#
## Check each of the CSV-files
## factor1
#csv <- readLines(file.path(dir, "codelist-factor1.csv")) 
#expected <- c("\"code\",\"label\"", "1,\"Purple\"", "2,\"Red\"", "3,\"Other\"", 
#  "0,\"Not given\"")
#expect_equal(csv, expected)
## factor2
#csv <- readLines(file.path(dir, "codelist-factor2.csv")) 
#expected <- c("\"code\",\"label\"", "\"101\",\"circle\"", "\"102\",\"square\"", 
#  "\"103\",\"triangle\"")
#expect_equal(csv, expected)
## complex.csv
#csv <- readLines(file.path(dir, "complex.csv")) 
#expected <- c("\"string1\",\"integer1\",\"boolean1\",\"number1\",\"number2\",\"boolean2\",\"date1\",\"factor1\",\"factor2\"", 
#  "\"a\",1,TRUE,1.2,1$2,TRUE,2020-01-01,1,\"101\"", "\"b\",-100,FALSE,-1e-04,-0$001,FALSE,2022-01-12,2,\"102\"", 
#  "\"c\",,TRUE,Inf,1 100,TRUE,,1,\"101\"", "\"\",100,TRUE,10000,-11 000$4,,1950-10-10,3,\"103\"", 
#  "\"f\",0,,,,FALSE,1920-12-10,,\"102\"", "\"g\",0,FALSE,,0,TRUE,2002-02-20,3,")
#expect_equal(csv, expected)
#
#
## When we read the data back in again from the new datapackage we should get the
## same data as from the original package
## without to_factor
#dp2 <- opendatapackage(dir)
#dta2 <- dp2 |> dpresource("complex") |> dpgetdata(to_factor = FALSE)
#expect_equal(dta, dta2, attributes = FALSE)
## with to_factor
#dta <- dpgetdata(dp, "complex", to_factor = TRUE)
#dta2 <- dp2 |> dpresource("complex") |> dpgetdata(to_factor = TRUE)
#expect_equal(dta, dta2, attributes = FALSE)
#
## Cleanup
#files <- list.files(dir, full.names = TRUE)
#for (file in files) file.remove(file)
#ignore <- file.remove(dir)

