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

## Overview of terminology

Below an overview of some of the terminology associated with Data Packages.

**Data Package**

- Contains one or more Data Resources.
- Has a number of properties like `title`, `name` and `description`.

**Data Resource**

- Contains data either as inline data in a `data` property or external data
  pointed to by a `path` property.
- Has a number of properties, like `title, `name`, `encoding`, ...

**Tabular Data Resource**

- Is a Data Resource with an additional set of properties and constraints.
- Has a Table Schema.

**Table Schema**

- Describes a tabular data set (a data set with rows an columns; as usually
  stored in a `data.frame` in R).
- Has one or more Field Descriptors.

**Field Descriptor**

- Describes a Field (a column) in a tabular data set.
- Has number of properties like, `name` and `type`.


## Getting information from a Data Package

Below we open an example Data Package that comes with the package:

```{.R #g1}
library(datapackage, warn.conflicts = FALSE)
dir <- system.file("examples/iris", package = "datapackage")
dp <- opendatapackage(dir)
print(dp)
```
The print statement shows the name of the package, `iris-example`, the title, 
the first paragraph of the description, the location of the Data Package and
the Data Resources in the package. In this case there are two Data Resources:

```{.R #g2}
dpnresources(dp)
```

The names are
```{.R #g3}
dpresourcenames(dp)
```

Using the `resource` methode on can obtain the Data Resource
```{.R #g4}
iris <- dpresource(dp, "iris")
print(iris)
```
The `print` statement again shows the name, title and description. It also shows
that the data is in a CSV-file anmes `iris.csv`. Standard the `print` shows only
a few properties of the Data Resource. To show all properties:

```{.R #g5}
print(iris, properties = NA)
```
Using this information it should be possible to open the dataset. The data can
be opened in R using the `dpgetdata` method. Based on the information in the Data
Resource this function will try to open the dataset using the correct functions
in R (in this case `read.csv`):

```{.R #g6}
dta <- dpgetdata(iris)
head(dta)
```

It is also possible to import the data directly from the Data Package object by
specifying the resource for which the data needs to be imported.

```{.R #g7}
dta <- dpgetdata(dp, "iris")
```
The `dpgetdata` method only supports a limited set of data formats.  It is
possible to also provide a custum function to read the data using the `reader`
argument of `dpgetdata`. However, it is also possible to import the data
'manually' using the information in the Data Package. The path of the file in a
Data Resource can be obtained using the `path` method:

```{.R #g8}
dppath(iris)
```
By default this will return the path as defined in the Data Package. This either
a path relative to the directory in which the Data Package is located or a URL.
To open a file inside the Data Package one also needs the location of the Data
Package. This is stored in the `path` attribute of the Data Package and
Resource:

```{.R #g9}
attr(dp, "path")
attr(iris, "path")
```
Using the `fullpath = TRUE` argument, `path` will return the full path to the
file:

```{.R #g10}
fn <- dppath(iris, fullpath = TRUE)
```
This path can be used to open the file manually:

```{.R #g11}
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

```{.R #g12}
dta <- dpresource(dp, "inline") |> dpgetdata()
head(dta)
```

## Reading properties from Data Packages and Data Resources

For many of the standard fields of a Data Packages, methods are defined to
obtain the values of these fields:

```{.R #r1}
dpname(dp)
dpdescription(dp)
dpdescription(dp, firstparagraph = TRUE)
dptitle(dp)
```

The same holds for Data Resources:

```{.R #r2}
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

```{.R #r3}
dppath(iris)
dppath(iris, fullpath = TRUE)
```

It is also possible to get other properties than the ones explicitly mentioned
above using the `dpproperty` method:

```{.R #r4}
dpproperty(iris, "encoding")
```

## Working with Code Lists

It is possible for fields to have a Code List associated with them. For example
in the 'complex' example resource, there is a column 'factor1':

```{.R #c1}
complex <- dpresource(dp, "complex") |> dpgetdata()
print(complex)
```

This is an integer column but it has an 'codelist' property set which points to
a Data Resource in the Data Package. It is possible te get this code list
```{.R #c2}
dpcodelist(complex$factor1)
```
This Code List can also be used to convert the field to factor:
```{.R #c3}
dptofactor(complex$factor1)
```
Using the `to_factor = TRUE` argument of the `csv_reader` it is also possible to
convert all fields which have an associated 'codelist' to factor:
```{.R #c4}
complex <- dpresource(dp, "complex") |> dpgetdata(to_factor = TRUE)
print(complex)
```
```{.R #n5 echo=FALSE results=FALSE}
file.remove(file.path(dir, "datapackage.json"))
```

## Creating a Data Package

This is shown in a seperate vignette `Creating a Data Package`

## Quickly saving to and reading from a Data Package

A quick way to create a Data Package from a given dataset is with the
`dpsaveasdatapackage` function:

```{.R #q1}
dir <- tempfile()
data(iris)
dpsaveasdatapackage(iris, dir)
```

And for reading:

```{.R #q2}
dploadfromdatapackage(dir) |> head()
```

This will either load the Data Resource with the same name as the Data Package
or the first resource in the Data Package.  It is also possible to specify the
name of the Data Resource that should be read. Additional arguments are passed
on to `dpgetdata`:

```{.R #q2}
dploadfromdatapackage(dir, "iris", to_factor = TRUE, use_fread = TRUE)
```

