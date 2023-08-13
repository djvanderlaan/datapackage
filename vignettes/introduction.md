<!--
%\VignetteEngine{simplermarkdown::mdweave_to_html}
%\VignetteIndexEntry{Introduction to datapackage}
-->

---
title: Introduction to working with Data Packages
author: Jan van der Laan
css: "style.css"
---

A Data Package is collection of files and consists of both data, which can be
any type of information such as images and CSV files, and meta data. These files
are usually stored in one directory (possibly with sub directories) although
links to external data are possible. Meta data is data about data and consists
of the information needed by software programmes to use the data and information
needed by users of the data such as descriptions, names of authors, licences
etc. The meta data is stored in a file in the directory that is usually called
`datapackage.json`. The information in this file is what below will be called
the Data Package. As mentioned, it contains both information on the data package
itself (title, description) and information on a number of Data Resources. The
Data Resources describe the data files in the data package and also consist of
information like a title, description, but also information needed by software
to use the data such as the path to the data (location of the data), and
technical information such as how the data is stored. This information makes it
easier to use the data. Below we will show how we can use the information in a
Data Package to easily read in the data and work with the data and we will show
how we can create a Data Package for our own data.

# Getting information from a Data Package

Below we open an example Data Package that comes with the package:

```{.R}
library(datapackage, warn.conflicts = FALSE)
dir <- system.file("examples/iris", package = "datapackage")
dp <- opendatapackage(dir)
print(dp)
```
The print statement shows the name of the package, `iris-example`, the title, 
the first paragraph of the description, the location of the Data Package and
the Data Resources in the package. In this case there are two Data Resources:

```{.R}
nresources(dp)
```

The names are
```{.R}
resourcenames(dp)
```

Using the `resource` methode on can obtain the Data Resource
```{.R}
iris <- resource(dp, "iris")
print(iris)
```
The `print` statement again shows the name, title and description. It also shows
that the data is in a CSV-file anmes `iris.csv`. Standard the `print` shows only
a few properties of the Data Resource. To show all properties:

```{.R}
print(iris, properties = NA)
```
Using this information it should be possible to open the dataset. The data can
be opened in R using the `getdata` method. Based on the information in the Data
Resource this function will try to open the dataset using the correct functions
in R (in this case `read.csv`):

```{.R}
dta <- getdata(iris)
head(dta)
```

It is also possible to import the data directly from the Data Package object by
specifying the resource for which the data needs to be imported.

```{.R}
dta <- getdata(dp, "iris")
```
The `getdata` method only supports a limited set of data formats.  It is
possible to also provide a custum function to read the data using the `reader`
argument of `getdata`. However, it is also possible to import the data
'manually' using the information in the Data Package. The path of the file in a
Data Resource can be obtained using the `path` method:

```{.R}
path(iris)
```
By default this will return the path as defined in the Data Package. This either
a path relative to the directory in which the Data Package is located or a URL.
To open a file inside the Data Package one also needs the location of the Data
Package. This is stored in the `path` attribute of the Data Package and
Resource:

```{.R}
attr(dp, "path")
attr(iris, "path")
```
Using the `fullpath = TRUE` argument, `path` will return the full path to the
file:

```{.R}
fn <- path(iris, fullpath = TRUE)
```
This path can be used to open the file manually:

```{.R}
dta <- read.csv(fn)
head(dta)
```
Note that the `path` property of a Data Resource can be a vector of paths in
case a single data set is stored in a set of files. It is assumed then that the
files have the same format. Therefore, `rbind` should work on these files.

Below an alternative way of importing the data belonging to a Data Resource. In
this case we open the other Data Resource. In the Data Resource the data is
stored inside the Data Package:

```{.R}
dta <- resource(dp, "inline") |> getdata()
head(dta)
```

## Reading properties from Data Packages and Data Resources

For many of the standard fields of a Data Packages, methods are defined to
obtain the values of these fields:

```{.R}
name(dp)
description(dp)
description(dp, firstparagraph = TRUE)
title(dp)
```

The same holds for Data Resources:

```{.R}
title(iris)
resource(dp, "inline") |> title()
```

For `datapackage` objects there are currently defined the following methods:
(this list can be obtained using `?properties_datapackage`)

- `name`
- `title`
- `description`
- `keywords`
- `created`
- `id`
- `contributors`

For `dataresource` objects there are currently defined the following methods
(this list can be obtained using `?properties_dataresource`)

- `name`
- `title`
- `description`
- `path`
- `format`
- `mediatype`
- `encoding`
- `bytes`
- `hash`


The last method has a `fullpath` argument that, when used, returns the full
path to the Data Resources data and not just the path relative to the Data
Package. The full path is needed when one wants to use the path to read the
data.

```{.R}
path(iris)
path(iris, fullpath = TRUE)
```

It is also possible to get other properties than the ones explicitly mentioned
above using the `property` method:

```{.R}
property(iris, "encoding")
```

## Creating a Data Package

```{.R}
dir <- tempdir()
dp <- newdatapackage(dir, name = "example", 
  title = "An Example Data Package")
print(dp)
```

```{.R}
list.files(dir)
```

```{.R}
description(dp) <- "This is a description of the Data Package"
```
The `description<-` also accepts a character vector of length > 1. This makes it
easy to read the contents of the description from file as it can be difficult to
write long descriptions directly from R-code. It is possible to use markdown in
the description.
```{.R eval=FALSE}
description(dp) <- readLines("description.md")
```
Note that anytime the Data Resoure is modified the file on disk is also


```{.R echo=FALSE results=FALSE}
file.remove(file.path(dir, "datapackage.json"))
```
