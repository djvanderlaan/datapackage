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
dpnresources(dp)
```

The names are
```{.R}
dpresourcenames(dp)
```

Using the `resource` methode on can obtain the Data Resource
```{.R}
iris <- dpresource(dp, "iris")
print(iris)
```
The `print` statement again shows the name, title and description. It also shows
that the data is in a CSV-file anmes `iris.csv`. Standard the `print` shows only
a few properties of the Data Resource. To show all properties:

```{.R}
print(iris, properties = NA)
```
Using this information it should be possible to open the dataset. The data can
be opened in R using the `dpgetdata` method. Based on the information in the Data
Resource this function will try to open the dataset using the correct functions
in R (in this case `read.csv`):

```{.R}
dta <- dpgetdata(iris)
head(dta)
```

It is also possible to import the data directly from the Data Package object by
specifying the resource for which the data needs to be imported.

```{.R}
dta <- dpgetdata(dp, "iris")
```
The `dpgetdata` method only supports a limited set of data formats.  It is
possible to also provide a custum function to read the data using the `reader`
argument of `dpgetdata`. However, it is also possible to import the data
'manually' using the information in the Data Package. The path of the file in a
Data Resource can be obtained using the `path` method:

```{.R}
dppath(iris)
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
fn <- dppath(iris, fullpath = TRUE)
```
This path can be used to open the file manually:

```{.R}
dta <- read.csv(fn)
head(dta)
```
Note that the `path` property of a Data Resource can be a vector of paths in
case a single data set is stored in a set of files. It is assumed then that the
files have the same format. Therefore, `rbind` should work on these files.

Below is an alternative way of importing the data belonging to a Data Resource.
Here we use the pipe operator to chain the various commands to import the
'inline' data set. In this example data set the data is stored inside the Data
Package.

```{.R}
dta <- dpresource(dp, "inline") |> dpgetdata()
head(dta)
```

## Reading properties from Data Packages and Data Resources

For many of the standard fields of a Data Packages, methods are defined to
obtain the values of these fields:

```{.R}
dpname(dp)
dpdescription(dp)
dpdescription(dp, firstparagraph = TRUE)
dptitle(dp)
```

The same holds for Data Resources:

```{.R}
dptitle(iris)
dpresource(dp, "inline") |> dptitle()
```

For `datapackage` objects there are currently defined the following methods:
(this list can be obtained using `?properties_datapackage`)

- `dpname`
- `dptitle`
- `dpdescription`
- `dpkeywords`
- `dpcreated`
- `dpid`
- `dpcontributors`

For `dataresource` objects there are currently defined the following methods
(this list can be obtained using `?properties_dataresource`)

- `dpname`
- `dptitle`
- `dpdescription`
- `dppath`
- `dpformat`
- `dpmediatype`
- `dpencoding`
- `dpbytes`
- `dphash`


The `dppath` method has a `fullpath` argument that, when used, returns the full
path to the Data Resources data and not just the path relative to the Data
Package. The full path is needed when one wants to use the path to read the
data.

```{.R}
dppath(iris)
dppath(iris, fullpath = TRUE)
```

It is also possible to get other properties than the ones explicitly mentioned
above using the `dpproperty` method:

```{.R}
dpproperty(iris, "encoding")
```

## Working with Code Lists

It is possible for fields to have a Code List associated with them. For example
in the 'complex' example resource, there is a column 'factor1':

```{.R}
complex <- dpresource(dp, "complex") |> dpgetdata()
print(complex)
```

This is an integer column but it has an 'codelist' property set which points to
a Data Resource in the Data Package. It is possible te get this code list
```{.R}
dpcodelist(complex$factor1)
```
This Code List can also be used to convert the field to factor:
```{.R}
dptofactor(complex$factor1)
```
Using the `to_factor = TRUE` argument of the `csv_reader` it is also possible to
convert all fields which have an associated 'codelist' to factor:
```{.R}
complex <- dpresource(dp, "complex") |> dpgetdata(to_factor = TRUE)
print(complex)
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
dpdescription(dp) <- "This is a description of the Data Package"
```
The `description<-` also accepts a character vector of length > 1. This makes it
easy to read the contents of the description from file as it can be difficult to
write long descriptions directly from R-code. It is possible to use markdown in
the description.
```{.R eval=FALSE}
dpdescription(dp) <- readLines("description.md")
```
Note that anytime the Data Resoure is modified the file on disk is also


```{.R echo=FALSE results=FALSE}
file.remove(file.path(dir, "datapackage.json"))
```

