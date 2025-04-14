<!--
%\VignetteEngine{simplermarkdown::mdweave_to_html}
%\VignetteIndexEntry{Creating a Data Package}
-->

---
title: Creating a Data Package
author: Jan van der Laan
css: "style.css"
---

```{.R #setup echo=FALSE results=FALSE}
opar <- options("ANSI_OUTPUT"=FALSE)
```

This vignette will show how to create and edit Data Packages.

## Creating a Data Package

The `new_datapackage()` function creates a new Data Package


```{.R #n1}
library(datapackage)

dir <- tempfile()
dp <- new_datapackage(dir, name = "example", 
  title = "An Example Data Package")
dp
```
This will return an `editabledatapackage`. This means that any changes to the
Data Package are immediately saved to the `datapackage.json` file and when
reading any properties these are read from the file. It is, therefore, possible
to manually edit the `datapackage.json` file while working in R with the Data
Package. 

```{.R #n2}
list.files(dir)
```

Using methods such as `dp_title()` and `dp_description()` the properties of the Data
Package can be modified.

```{.R #n3}
dp_description(dp) <- "This is a description of the Data Package"
```

The `description<-()` method also accepts a character vector of length > 1. This
makes it easy to read the contents of the description from file as it can be
difficult to write long descriptions directly from R-code. It is possible to use
markdown in the description.

```{.R #n4 eval=FALSE}
dp_description(dp) <- readLines("description.md")
```

The following methods a currently (when writing the vignette) supported:

- `dp_title<-()`
- `dp_contributors<-()` and `dp_add_contributor<-()`
- `dp_description<-()`
- `dp_id<-()`
- `dp_name<-()`
- `dp_created<-()`
- `dp_keywords<-()`
- `dp_property<-()`: this function also allow custom properties.

For an up to data list run the following:

```[.R #n5}
methods(class = "datapackage") |> (\(x) x[grep("<-", x)])()
```

Below an example of adding a contributor to the package

```{.R #n6}
dp_add_contributor(dp) <- new_contributor("Jane Doe", role = "author",
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
specification of the Data Resource we need to save the actual dataset at the
location specified in the Data Resource.

It is possible to edit the `datapackage.json` file to create the new
Data Resource. The package also has a function `dp_generate_dataresource()` to
generate a skeleton Data Resource for a given dataset:

```{.R #a10}
res <- dp_generate_dataresource(iris, "iris") 
```

Again these can be further modified using methods such as `dp_title()` and
`dp_property()`:

```{.R #a30}
dp_title(res) <- "The Iris dataset"
```

Let's add the resources to the Data Package.

```{.R #a40}
dp_resources(dp) <- res
```

In this case the Data Package does not yet contain Data Resources. Should the
Data Package contain Data Resources with the same name, these will be overwritten
by the new Data Resource.

We are now ready to write the dataset. For this we can use the `dp_write_data()`
method:

```{.R #a50}
dp_write_data(dp, resource_name = "iris", data = iris)
```

When some of the field in the Data Resource have categories that are stored in
a separate Data Resource, this function will by default also write any
categories lists associated with the Data Resource.

```{.R #a60}
readLines(file.path(dir, "iris.csv"), n = 10) |> writeLines()
```

And of course we can open the Data Package and read the data back in:

```{.R #a70}
dp2 <- open_datapackage(dir)
iris2 <- dp2 |> dp_resource("iris") |> dp_get_data(convert_categories = "to_factor")
all.equal(iris, iris2, check.attributes = FALSE)
```


## More on categories

By default `dp_generate_dataresource()` will generate `categories` properties for
factor fields:

```{.R #c00}
data(chickwts)

res <- dp_generate_dataresource(chickwts, "chickwts") 
dp_resources(dp) <- res

(feed_name <- dp_resource(dp, "chickwts") |> 
  dp_field("feed") |> dp_property("categories"))
```

Here, the list of categories is stored directly in the `categories` property. It
is also possible to store the list of categories in a Data Resource

```{.R #c01}
res <- dp_generate_dataresource(chickwts, "chickwts", 
  categories_type = "resource") 
dp_resources(dp) <- res

(feed_name <- dp_resource(dp, "chickwts") |> 
  dp_field("feed") |> dp_property("categories"))
```
Here the `categories` property points to Data Resource. `dp_write_data()` will
automatically create this resource by default when writing the data:

```{.R #c02}
dp_write_data(dp_resource(dp, "chickwts"), data = chickwts, write_categories = TRUE)
list.files(dir)

dp_resource(dp, "feed-categories") |> dp_get_data()
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
res <- dp_generate_dataresource(codelist, "feed-categories")
res
dp_resources(dp) <- res

codelistres <- dp |> dp_resource("feed-categories")
dp_write_data(codelistres, data = codelist, write_categories = FALSE)
```
This creates the correct CSV-files:

```{.R #c20}
readLines(file.path(dir, "feed-categories.csv")) |> writeLines()
```

When we now write the dataset to file it will use this dataset - as long as we
don't overwrite it. Therefore, the `write_categories = FALSE`: 

```{.R #c30}
dp_write_data(dp, resource_name = "chickwts", data = chickwts, write_categories = FALSE)
```

We can see that the correct codes are used in the CSV-file:
```{.R #c40}
readLines(file.path(dir, "chickwts.csv"), n = 10) |> writeLines()
```


## Editing an existing Data Package

Editing of existing Data Packages is also possible. Use the `readonly = FALSE`
argument when opening the Data Package:

```{.R #e00}
edit <- open_datapackage(dir, readonly = FALSE)
 
dp_id(edit) <- "iris_chkwts"
dp_created(edit) <- Sys.time() |> as.Date()
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

```{.R #setup echo=FALSE results=FALSE}
options(opar)
```

