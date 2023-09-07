<!--
%\VignetteEngine{simplermarkdown::mdweave_to_html}
%\VignetteIndexEntry{Introduction to datapackage}
-->

A Data Package is collection of files and consists of both data, which
can be any type of information such as images and CSV files, and meta
data. These files are usually stored in one directory (possibly with sub
directories) although links to external data are possible. Meta data is
data about data and consists of the information needed by software
programmes to use the data and information needed by users of the data
such as descriptions, names of authors, licences etc. The meta data is
stored in a file in the directory that is usually called
`datapackage.json`. The information in this file is what below will be
called the Data Package. As mentioned, it contains both information on
the data package itself (title, description) and information on a number
of Data Resources. The Data Resources describe the data files in the
data package and also consist of information like a title, description,
but also information needed by software to use the data such as the path
to the data (location of the data), and technical information such as
how the data is stored. This information makes it easier to use the
data. Below we will show how we can use the information in a Data
Package to easily read in the data and work with the data and we will
show how we can create a Data Package for our own data.

# Getting information from a Data Package

Below we open an example Data Package that comes with the package:

``` R
> library(datapackage, warn.conflicts = FALSE)
> dir <- system.file("examples/iris", package = "datapackage")
> dp <- opendatapackage(dir)
> print(dp)
[iris-example] An example data package with the iris data set

A description
...

Location: </home/eoos/R/x86_64-pc-linux-gnu-library/4.3/datapackage/examples/iris>
Resources:
[iris] The iris data set
[inline] An inline data set
```

The print statement shows the name of the package, `iris-example`, the
title, the first paragraph of the description, the location of the Data
Package and the Data Resources in the package. In this case there are
two Data Resources:

``` R
> nresources(dp)
[1] 2
```

The names are

``` R
> resourcenames(dp)
[1] "iris"   "inline"
```

Using the `resource` methode on can obtain the Data Resource

``` R
> iris <- resource(dp, "iris")
> print(iris)
[iris] The iris data set

A description of the iris data set
...

Selected properties:
path     :"iris.csv"
format   :"csv"
mediatype:"text/csv"
encoding :"utf-8"
```

The `print` statement again shows the name, title and description. It
also shows that the data is in a CSV-file anmes `iris.csv`. Standard the
`print` shows only a few properties of the Data Resource. To show all
properties:

``` R
> print(iris, properties = NA)
[iris] The iris data set

A description of the iris data set
...

Selected properties:
path     :"iris.csv"
format   :"csv"
mediatype:"text/csv"
encoding :"utf-8"
```

Using this information it should be possible to open the dataset. The
data can be opened in R using the `getdata` method. Based on the
information in the Data Resource this function will try to open the
dataset using the correct functions in R (in this case `read.csv`):

``` R
> dta <- getdata(iris)
> head(dta)
  Sepal.Length Sepal.Width Petal.Length Petal.Width Species
1          5.1         3.5          1.4         0.2  setosa
2          4.9         3.0          1.4         0.2  setosa
3          4.7         3.2          1.3         0.2  setosa
4          4.6         3.1          1.5         0.2  setosa
5          5.0         3.6          1.4         0.2  setosa
6          5.4         3.9          1.7         0.4  setosa
```

It is also possible to import the data directly from the Data Package
object by specifying the resource for which the data needs to be
imported.

``` R
> dta <- getdata(dp, "iris")
```

The `getdata` method only supports a limited set of data formats. It is
possible to also provide a custum function to read the data using the
`reader` argument of `getdata`. However, it is also possible to import
the data ‘manually’ using the information in the Data Package. The path
of the file in a Data Resource can be obtained using the `path` method:

``` R
> path(iris)
[1] "iris.csv"
```

By default this will return the path as defined in the Data Package.
This either a path relative to the directory in which the Data Package
is located or a URL. To open a file inside the Data Package one also
needs the location of the Data Package. This is stored in the `path`
attribute of the Data Package and Resource:

``` R
> attr(dp, "path")
[1] "/home/eoos/R/x86_64-pc-linux-gnu-library/4.3/datapackage/examples/iris"
> attr(iris, "path")
[1] "/home/eoos/R/x86_64-pc-linux-gnu-library/4.3/datapackage/examples/iris"
```

Using the `fullpath = TRUE` argument, `path` will return the full path
to the file:

``` R
> fn <- path(iris, fullpath = TRUE)
```

This path can be used to open the file manually:

``` R
> dta <- read.csv(fn)
> head(dta)
  Sepal.Length Sepal.Width Petal.Length Petal.Width Species
1          5.1         3.5          1.4         0.2  setosa
2          4.9         3.0          1.4         0.2  setosa
3          4.7         3.2          1.3         0.2  setosa
4          4.6         3.1          1.5         0.2  setosa
5          5.0         3.6          1.4         0.2  setosa
6          5.4         3.9          1.7         0.4  setosa
```

Note that the `path` property of a Data Resource can be a vector of
paths in case a single data set is stored in a set of files. It is
assumed then that the files have the same format. Therefore, `rbind`
should work on these files.

Below an alternative way of importing the data belonging to a Data
Resource. In this case we open the other Data Resource. In the Data
Resource the data is stored inside the Data Package:

``` R
> dta <- resource(dp, "inline") |> getdata()
> head(dta)
[[1]]
[[1]]$field1
[1] 10

[[1]]$field2
[1] "20"


[[2]]
[[2]]$field1
[1] 20

[[2]]$field2
[1] "21"


[[3]]
[[3]]$field1
[1] 30

[[3]]$field2
[1] "22"
```

## Reading properties from Data Packages and Data Resources

For many of the standard fields of a Data Packages, methods are defined
to obtain the values of these fields:

``` R
> name(dp)
[1] "iris-example"
> description(dp)
[1] "A description\n\nThe second paragraph of the description"
> description(dp, firstparagraph = TRUE)
[1] "A description"
> title(dp)
[1] "An example data package with the iris data set"
```

The same holds for Data Resources:

``` R
> title(iris)
[1] "The iris data set"
> resource(dp, "inline") |> title()
[1] "An inline data set"
```

For `datapackage` objects there are currently defined the following
methods: (this list can be obtained using `?properties_datapackage`)

  - `name`
  - `title`
  - `description`
  - `keywords`
  - `created`
  - `id`
  - `contributors`

For `dataresource` objects there are currently defined the following
methods (this list can be obtained using `?properties_dataresource`)

  - `name`
  - `title`
  - `description`
  - `path`
  - `format`
  - `mediatype`
  - `encoding`
  - `bytes`
  - `hash`

The last method has a `fullpath` argument that, when used, returns the
full path to the Data Resources data and not just the path relative to
the Data Package. The full path is needed when one wants to use the path
to read the data.

``` R
> path(iris)
[1] "iris.csv"
> path(iris, fullpath = TRUE)
[1] "/home/eoos/R/x86_64-pc-linux-gnu-library/4.3/datapackage/examples/iris/iris.csv"
```

It is also possible to get other properties than the ones explicitly
mentioned above using the `property` method:

``` R
> property(iris, "encoding")
[1] "utf-8"
```

## Creating a Data Package

``` R
> dir <- tempdir()
> dp <- newdatapackage(dir, name = "example", 
+   title = "An Example Data Package")
> print(dp)
[example] An Example Data Package

Location: </tmp/Rtmp4shz7d>
<NO RESOURCES>
```

``` R
> list.files(dir)
[1] "datapackage.json"     "file80262659bf4.json"
```

``` R
> description(dp) <- "This is a description of the Data Package"
```

The `description<-` also accepts a character vector of length \> 1. This
makes it easy to read the contents of the description from file as it
can be difficult to write long descriptions directly from R-code. It is
possible to use markdown in the description.

``` R
description(dp) <- readLines("description.md")
```

Note that anytime the Data Resoure is modified the file on disk is also
