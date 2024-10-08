<!--
%\VignetteEngine{simplermarkdown::mdweave_to_html}
%\VignetteIndexEntry{Creating a Data Package}
-->

---
title: Creating a Data Package
author: Jan van der Laan
css: "style.css"
---

This vignette will show how to create and edit Data Packages.

## Creating a Data Package

The `newdatapackage` function creates a new Data Package

```{.R #n1}
library(datapackage)

dir <- tempfile()
dp <- newdatapackage(dir, name = "example", 
  title = "An Example Data Package")
print(dp)
```
This will return an `editabledatapackage`. This means that any changes to the
Data Package are immediately saved to the `datapackage.json` file and when
reading any properties these are read from the file. It is, therefore, possible
to manually edit the `datapackage.json` file while working in R with the Data
Package. 

```{.R #n2}
list.files(dir)
```

Using methods such as `dptitle` and `dpdescription` the properties of the Data
Package can be modified.

```{.R #n3}
dpdescription(dp) <- "This is a description of the Data Package"
```
The `description<-` also accepts a character vector of length > 1. This makes it
easy to read the contents of the description from file as it can be difficult to
write long descriptions directly from R-code. It is possible to use markdown in
the description.
```{.R #n4 eval=FALSE}
dpdescription(dp) <- readLines("description.md")
```

The following methods a currently (when writing the vignette) supported:

- `dptitle<-`
- `dpcontributors<-` and `dpaddcontributor<-`
- `dpdescription<-`
- `dpid<-`
- `dpname<-`
- `dpcreated<-`
- `dpkeywords<-`
- `dpproperty<-`: this function also allow custom properties.

For an up to data list run the following:

```[.R #n5}
methods(class = "datapackage") |> (\(x) x[grep("<-", x)])()
```
Below an example of adding a contributor to the package
```{.R #n6}
dpaddcontributor(dp) <- newcontributor("Jane Doe", role = "author",
  email = "j.doe@organisation.org")
```


## Adding a dataset to the datapackage

In this example we will save the `iris` dataset to a new datapackage.
```{.R #a1}
data(iris)
head(iris)
```

In order to store a new dataset in a Data Package we need to do two things.
First, we need to create a new Data Resource in the package. Second, using the
specifation of the Data Resource we need to save the actual dataset at the
location specified in the Data Resource.

It is possible to edit the `datapackage.json` file to create the new
Data Resource. The package also has a function `dpgeneratedataresource` to
generate a skeleton Data Resource for a given dataset:
```{.R #a10}
res <- dpgeneratedataresource(iris, "iris") 
```
Again these can be further modified using methods such as `dptitle` and
`dpproperty`:
```{.R #a30}
dptitle(res) <- "The Iris dataset"
```

Let's add the resources to the datapackage.
```{.R #a40}
dpresources(dp) <- res
```
In this case the datapackage does not yet contain dataresources. Should the
datapackage contain dataresources with the same name, these will be overwritten
by the new dataresources.

We are now ready to write the dataset. For this we can use the `dpwritedata`
method:
```{.R #a50}
dpwritedata(dp, resourcename = "iris", data = iris)
```
When some of the field in the Data Resource have categories that are stored in
a separate Data Resource, this function will by default also write any
codelists associated with the dataresource.

```{.R #a60}
readLines(file.path(dir, "iris.csv"), n = 10) |> writeLines()
```

And of course we can open the datapackage and read the data back in:
```{.R #a70}
dp2 <- opendatapackage(dir)
iris2 <- dp2 |> dpresource("iris") |> dpgetdata(to_factor = TRUE)
all.equal(iris, iris2, check.attributes = FALSE)
```


## More on categories

By default `dpgeneratedataresource` will generate `categories` properties for
factor fields:

```{.R #c00}
data(chickwts)

res <- dpgeneratedataresource(chickwts, "chickwts") 
dpresources(dp) <- res

(feed_name <- dpresource(dp, "chickwts") |> 
  dpfield("feed") |> dpproperty("categories"))
```

Here, the list of categories is stored directly in the `categories` property. It
is also possible to store the list of categories in a Data Resource

```{.R #c01}
res <- dpgeneratedataresource(chickwts, "chickwts", 
  categories_type = "resource") 
dpresources(dp) <- res

(feed_name <- dpresource(dp, "chickwts") |> 
  dpfield("feed") |> dpproperty("categories"))
```
Here the `categories` property points to Data Resource. `dpwritedata` will
automatically create this resource by default when writing the data:

```{.R #c02}
dpwritedata(dpresource(dp, "chickwts"), data = chickwts, write_categories = TRUE)
list.files(dir)

dpresource(dp, "feed-categories") |> dpgetdata()
```

By default the package will generate a list of categories for factor variables.
The levels will be numbered using sequential integers starting from 1. The
example below shows how different codes can be used. 

In order to write the correct codes we will also first have to generate the and
save the dataset with the correct codes. In the example below we do this using
R, but it is of course also possible to generate the CSV using other methods
(e.g. manual editing):
```{.R #c10}
codelist <- data.frame(
  value = c(101, 102, 103, 202, 203, 204),
  label = c("casein", "horsebean", "linseed", "meatmeal", 
    "soybean", "sunflower")
)
res <- dpgeneratedataresource(codelist, "feed-categories")
res
dpresources(dp) <- res

codelistres <- dp |> dpresource("feed-categories")
dpwritedata(codelistres, data = codelist, write_categories = FALSE)
```
This creates the correct CSV-files:

```{.R #c20}
readLines(file.path(dir, "feed-categories.csv")) |> writeLines()
```
When we now write the dataset to file it will use this dataset - as long as we
don't overwrite it. Therefore, the `write_categories = FALSE`: 
```{.R #c30}
dpwritedata(dp, resourcename = "chickwts", data = chickwts, write_categories = FALSE)
```
We can see that the correct codes are used in the CSV-file:
```{.R #c40}
readLines(file.path(dir, "chickwts.csv"), n = 10) |> writeLines()
```


## Editing an existing Data Package

Editing of existing Data Packages is also possible. Use the `readonly = TRUE`
argument when opening the Data Package:

```{.R #e00}
edit <- opendatapackage(dir, readonly = FALSE)
 
dpid(edit) <- "iris_chkwts"
dpcreated(edit) <- Sys.time() |> as.Date()
```

Showing the complete `datapackage.json` file after all of the edits in this
vignette:
```{.R #e10}
readLines(file.path(dir, "datapackage.json")) |> writeLines()
```


```{.R #cleanup echo=FALSE results=FALSE}
file.remove(list.files(dir, full.names = TRUE)) 
file.remove(dir)
```

