
## Creating a datapackage and adding a dataset to the datapackage

In this example we will save the `iris` dataset to a new datapackage.
```{.R}
library(datapackage)
data(iris)
head(iris)
```

First, we create a new datapackage the directory `dir`:
```{.R}
dir <- tempdir()
dp <- newdatapackage(dir, name = "iris")
```
Besides name it is also possible to specify the title and description of the
datapackage. It is also possible to change and add other properties, e.g.
```{.R}
dpaddcontributor(dp) <- newcontributor("Jane Doe", role = "author",
  email = "j.doe@organisation.org")
```

In order to store a new dataset in a datapackage we need to do two things.
First, we need to create a new dataresource in the package. Second, using the
specifation of the dataresource we need to save the actual dataset at the
location specified in the dataresource.

It is possible to add the `datapackage.json` file to create the new
dataresource. The package also has a function `dpgeneratedataresources` to
generate skeleton dataresources for a given dataset:
```{.R}
res <- dpgeneratedataresources(iris, "iris") 
```
Note the plural in the function names. This is because it is possible that
mulitple dataresources are needed for one given dataset. This is the case when
the dataset contains factor variables. The levels of a factor are stored in a
seperate dataresource. The `iris` dataset contains one factor variable.
Therefore, `res` will contain two dataresources:
```{.R}
print(res)
```
Again these can be further modified using methods such as `dptitle` and
`dpproperty`:
```{.R}
dptitle(res[[1]]) <- "The Iris dataset"
```

Let's add these resources to the datapackage.
```{.R}
dpresources(dp) <- res
```
In this case the datapackage does not yet contain dataresources. Should the
datapackage contain dataresources with the same name, these will be overwritten
by the new dataresources.

We are now ready to write the dataset. For this we can use the `dpwritedata`
method:
```{.R}
dpwritedata(dp, resourcename = "iris", data = iris, write_codelists = TRUE)
```
With `write_codelists = TRUE` this function will also write any codelists
associated with the dataresource.

```{.R}
readLines(file.path(dir, "iris.csv"), n = 10) |> writeLines()
readLines(file.path(dir, "Species-codelist.csv")) |> writeLines()
```

And of course we can open the datapackage and read the data back in:
```{.R}
dp2 <- opendatapackage(dir)
iris2 <- dp2 |> dpresource("iris") |> dpgetdata(to_factor = TRUE)
all.equal(iris, iris2, check.attributes = FALSE)
```

```{.R echo=FALSE results=FALSE}
for (f in list.files(dir, full.names = TRUE)) file.remove(f)
file.remove(dir)
```

## Custom codelists


```{.R}

res <- dpgeneratedataresources(iris, "iris2") 
dpresources(dp) <- res

dpname(res[[2]]) <- "species-codelist2"
dppath(res[[2]]) <- "species-codelist2.csv"

dpproperty(dpfield(res[[1]], "Species"), "codelist") <- "species-codelist2"

codelistres <- dp |> dpresource("Species-codelist")
codelistres

codelist <- data.frame(
  code = c(101, 102, 103),
  label = c("setosa", "virginica", "versicolor"))

dpwritedata(codelistres, data = codelist, write_codelists = FALSE)

readLines(file.path(dir, "Species-codelist.csv")) |> writeLines()

dpwritedata(dp, resourcename = "iris", data = iris, write_codelists = FALSE)

readLines(file.path(dir, "iris.csv"), n = 10) |> writeLines()


dp2 <- opendatapackage(dir)

iris2 <- dp2 |> dpresource("iris") |> dpgetdata(to_factor = TRUE)

head(iris2)

source("tests/helpers.R")
iris$Species <- as.character(iris$Species)
iris2$Species <- as.character(iris2$Species)
expect_equal(iris, iris2, attributes = FALSE)

for (f in list.files(dir, full.names = TRUE)) file.remove(f)
file.remove(dir)

```

