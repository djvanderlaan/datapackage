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

## Overview of terminology

Below an overview of some of the terminology associated with Data
Packages.

**Data Package**

  - Contains one or more Data Resources.
  - Has a number of properties like `title`, `name` and `description`.

**Data Resource**

  - Contains data either as inline data in a `data` property or external
    data pointed to by a `path` property.
  - Has a number of properties, like `title,`name`,`encoding\`, …

**Tabular Data Resource**

  - Is a Data Resource with an additional set of properties and
    constraints.
  - Has a Table Schema.

**Table Schema**

  - Describes a tabular data set (a data set with rows an columns; as
    usually stored in a `data.frame` in R).
  - Has one or more Field Descriptors.

**Field Descriptor**

  - Describes a Field (a column) in a tabular data set.
  - Has number of properties like, `name` and `type`.

## Getting information from a Data Package

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
[complex] A complex example dataset
[codelist-factor1] Codelist for the factor1 field in the complex resource
[codelist-factor2] 
[inline] An inline data set
[fixed-width] A Fixed Width Example
```

The print statement shows the name of the package, `iris-example`, the
title, the first paragraph of the description, the location of the Data
Package and the Data Resources in the package. In this case there are
two Data Resources:

``` R
> dpnresources(dp)
[1] 6
```

The names are

``` R
> dpresourcenames(dp)
[1] "iris"             "complex"          "codelist-factor1" "codelist-factor2"
[5] "inline"           "fixed-width"     
```

Using the `resource` methode on can obtain the Data Resource

``` R
> iris <- dpresource(dp, "iris")
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
data can be opened in R using the `dpgetdata` method. Based on the
information in the Data Resource this function will try to open the
dataset using the correct functions in R (in this case `read.csv`):

``` R
> dta <- dpgetdata(iris)
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
> dta <- dpgetdata(dp, "iris")
```

The `dpgetdata` method only supports a limited set of data formats. It
is possible to also provide a custum function to read the data using the
`reader` argument of `dpgetdata`. However, it is also possible to import
the data ‘manually’ using the information in the Data Package. The path
of the file in a Data Resource can be obtained using the `path` method:

``` R
> dppath(iris)
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
> fn <- dppath(iris, fullpath = TRUE)
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

Below is an alternative way of importing the data belonging to a Data
Resource. Here we use the pipe operator to chain the various commands to
import the ‘inline’ data set. In this example data set the data is
stored inside the Data Package.

``` R
> dta <- dpresource(dp, "inline") |> dpgetdata()
> head(dta)
  field1 field2
1     10     20
2     20     21
3     30     22
```

## Reading properties from Data Packages and Data Resources

For many of the standard fields of a Data Packages, methods are defined
to obtain the values of these fields:

``` R
> dpname(dp)
[1] "iris-example"
> dpdescription(dp)
[1] "A description\n\nThe second paragraph of the description"
> dpdescription(dp, firstparagraph = TRUE)
[1] "A description"
> dptitle(dp)
[1] "An example data package with the iris data set"
```

The same holds for Data Resources:

``` R
> dptitle(iris)
[1] "The iris data set"
> dpresource(dp, "inline") |> dptitle()
[1] "An inline data set"
```

For `datapackage` objects there are currently defined the following
methods: (this list can be obtained using `?properties_datapackage`)

  - `dpname`
  - `dptitle`
  - `dpdescription`
  - `dpkeywords`
  - `dpcreated`
  - `dpid`
  - `dpcontributors`

For `dataresource` objects there are currently defined the following
methods (this list can be obtained using `?properties_dataresource`)

  - `dpname`
  - `dptitle`
  - `dpdescription`
  - `dppath`
  - `dpformat`
  - `dpmediatype`
  - `dpencoding`
  - `dpbytes`
  - `dphash`

The `dppath` method has a `fullpath` argument that, when used, returns
the full path to the Data Resources data and not just the path relative
to the Data Package. The full path is needed when one wants to use the
path to read the data.

``` R
> dppath(iris)
[1] "iris.csv"
> dppath(iris, fullpath = TRUE)
[1] "/home/eoos/R/x86_64-pc-linux-gnu-library/4.3/datapackage/examples/iris/iris.csv"
```

It is also possible to get other properties than the ones explicitly
mentioned above using the `dpproperty` method:

``` R
> dpproperty(iris, "encoding")
[1] "utf-8"
```

## Working with Code Lists

It is possible for fields to have a Code List associated with them. For
example in the ‘complex’ example resource, there is a column ‘factor1’:

``` R
> complex <- dpresource(dp, "complex") |> dpgetdata()
> print(complex)
  string1 integer1 boolean1  number1    number2 boolean2      date1 factor1
1       a        1     TRUE  1.2e+00      1.200     TRUE 2020-01-01       1
2       b     -100    FALSE -1.0e-04     -0.001    FALSE 2022-01-12       2
3       c       NA     TRUE      Inf   1100.000     TRUE       <NA>       1
4              100     TRUE  1.0e+04 -11000.400       NA 1950-10-10       3
5       f        0       NA      NaN         NA    FALSE 1920-12-10      NA
6       g        0    FALSE       NA      0.000     TRUE 2002-02-20       3
  factor2
1     101
2     102
3     101
4     103
5     102
6    <NA>
```

This is an integer column but it has an ‘codelist’ property set which
points to a Data Resource in the Data Package. It is possible te get
this code list

``` R
> dpcodelist(complex$factor1)
  code     label
1    1    Purple
2    2       Red
3    3     Other
4    0 Not given
```

This Code List can also be used to convert the field to factor:

``` R
> dptofactor(complex$factor1)
[1] Purple Red    Purple Other  <NA>   Other 
attr(,"fielddescriptor")
Field Descriptor:
name    :"factor1"
type    :"integer"
codelist:"codelist-factor1"
Levels: Purple Red Other Not given
```

Using the `to_factor = TRUE` argument of the `csv_reader` it is also
possible to convert all fields which have an associated ‘codelist’ to
factor:

``` R
> complex <- dpresource(dp, "complex") |> dpgetdata(to_factor = TRUE)
> print(complex)
  string1 integer1 boolean1  number1    number2 boolean2      date1 factor1
1       a        1     TRUE  1.2e+00      1.200     TRUE 2020-01-01  Purple
2       b     -100    FALSE -1.0e-04     -0.001    FALSE 2022-01-12     Red
3       c       NA     TRUE      Inf   1100.000     TRUE       <NA>  Purple
4              100     TRUE  1.0e+04 -11000.400       NA 1950-10-10   Other
5       f        0       NA      NaN         NA    FALSE 1920-12-10    <NA>
6       g        0    FALSE       NA      0.000     TRUE 2002-02-20   Other
   factor2
1   circle
2   square
3   circle
4 triangle
5   square
6     <NA>
```

## Creating a Data Package

This is shown in a seperate vignette `Creating a Data Package`
