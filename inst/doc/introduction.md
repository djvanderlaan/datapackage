<!--
%\VignetteEngine{simplermarkdown::mdweave_to_html}
%\VignetteIndexEntry{Introduction to datapackage}
-->

---
title: Introduction to working with Data Packages
author: Jan van der Laan
css: "style.css"
---

A [Data Package](https://datapackage.org) is collection of files and consists
of both data, which can be any type of information such as images and CSV
files, and meta data. These files are usually stored in one directory (possibly
with sub directories) although links to external data are possible.  Meta data
is data about data and consists of the information needed by software
programmes to use the data and information needed by users of the data such as
descriptions, names of authors, licences etc. The meta data is stored in a file
in the directory that is usually called `datapackage.json`. The information in
this file is what below will be called the Data Package. As mentioned, it
contains both information on the data package itself (title, description) and
information on a number of Data Resources. The Data Resources describe the data
files in the data package and also contains information like a title,
description, but also information needed by software to use the data such as
the path to the data (location of the data), and technical information such as
how the data is stored. This information makes it easier to use the data. Below
we will show how we can use the information in a Data Package to easily read in
the data and work with the data and we will show how we can create a Data
Package for our own data.

## Overview of terminology

Below an overview of some of the terminology associated with Data Packages.

**[Data Package](https://datapackage.org/standard/data-package/)**

- Contains one or more Data Resources.
- Has a number of properties like `title`, `name` and `description`.

**[Data Resource](https://datapackage.org/standard/data-resource/)**

- Contains data either as inline data in a `data` property or external data
  pointed to by a `path` property.
- Has a number of properties, like `title, `name`, `encoding`, ...

**[Tabular Data Resource](https://datapackage.org/standard/data-resource/#tabular)**

- Is a Data Resource with an additional set of properties and constraints.
- Has a Table Schema.

**[Table Schema](https://datapackage.org/standard/table-schema/)**

- Describes a tabular data set (a data set with rows an columns; as usually
  stored in a `data.frame` in R).
- Has one or more Field Descriptors.

**[Field Descriptor](https://datapackage.org/standard/table-schema/#field)**

- Describes a Field (a column) in a tabular data set.
- Has number of properties like, `name` and `type`.


## tl;dr

`open_datapackage()` reads the meta data from the `datapackage.json`. From the
output below you can see that the data package has three data resources.

```{.R #tldropen}
library(datapackage, warn.conflicts = FALSE)
dir <- system.file("examples/employ", package = "datapackage")
dp <- open_datapackage(dir)
dp
```

To read the data beloning to one of the data resources:

```{.R #tldrgetdata}
dta <- dp |> dp_resource("employment") |> dp_get_data()
dta
```

When the name of the data resource is known, the data can also be read directly
from the data package without explicitly opening the Data Package:

```{.R #tldrload}
dta <- dp_load_from_datapackage(dir, "employment")
dta
``` 

With the `convert_categories`  argument categorical variables can be converted
to factor:

```{.R #tldrloadfactor}
dta <- dp_load_from_datapackage(dir, "employment", 
  convert_categories = "to_factor")
dta
``` 

Or, they can be converted to the [`code` class from the `codelist`
package](https://cran.r-project.org/package=codelist). This
will preserve both the codes and the labels:

```{.R #tldrloadcode}
library(codelist)
dta <- dp_load_from_datapackage(dir, "employment", 
  convert_categories = "to_code")
dta
``` 

When the data resource name is omitted from `dp_load_from_datapackage()` either
the data resource with same name as the data package or the first data resource
is opened.



## Getting information from a Data Package

Below we open an example Data Package that comes with the package:

```{.R #g1}
library(datapackage, warn.conflicts = FALSE)
dir <- system.file("examples/employ", package = "datapackage")
dp <- open_datapackage(dir)
dp
```
The print statement shows the name of the package, `example`, the title, 
the first paragraph of the description, the location of the Data Package and
the Data Resources in the package. In this case there are three Data Resources:

```{.R #g2}
dp_nresources(dp)
```

The names are

```{.R #g3}
dp_resource_names(dp)
```

Using the `resource()` method on the Data Package can obtain the Data Resource

```{.R #g4}
employ <- dp_resource(dp, "employment")
employ
```

The `print` statement again shows the name, title and description. It also shows
that the data is in a CSV-file anmes `employ.csv`. Standard the `print` shows only
a few properties of the Data Resource. To show all properties:

```{.R #g5}
print(employ, properties = NA)
```

Using this information it should be possible to open the dataset. The data can
be opened in R using the `dp_get_data()` method. Based on the information in the
Data Resource this function will try to open the dataset using the correct
functions in R (in this case `read.csv()`):

```{.R #g6}
dta <- dp_get_data(employ)
head(dta)
```

It is also possible to import the data directly from the Data Package object by
specifying the resource for which the data needs to be imported.

```{.R #g7}
dta <- dp_get_data(dp, "employment")
```

The `dp_get_data()` method only supports a limited set of data formats.  It is
possible to also provide a custum function to read the data using the `reader`
argument of `dp_get_data()`. However, it is also possible to import the data
'manually' using the information in the Data Package. The path of the file in a
Data Resource can be obtained using the `dp_path()` method:

```{.R #g8}
dp_path(employ)
```

By default this will return the path as defined in the Data Package. This either
a path relative to the directory in which the Data Package is located or a URL.
To open a file inside the Data Package one also needs the location of the Data
Package.  Using the `full_path = TRUE` argument, `dp_path()` will return the full
path to the file:

```{.R #g10}
fn <- dp_path(employ, full_path = TRUE)
```

This path can be used to open the file manually:

```{.R #g11}
dta <- read.csv2(fn)
head(dta)
```

First, note that we had to 'know' that we had to use `read.csv2` since the file
uses the '`;`' as field separator. Information like this is stored in the
'dialect' property of a data resource:

```{.R #dialect}
dp_property(employ, "dialect")
```

Second, note that the field 'income' is not converted to numeric as this field
contains euro symbols and used a space as thousands separator. Information like
this is stored in the field descriptor:

```{.R #income}
dp_field(employ, "income")
```

`dp_get_data()` uses the information from the field descriptors and dialect to
automatically convert variables as much a possible to their most fitting R
types. This is done using the `dp_apply_schema()` function:

```{.R #dpapplyschema}
dp_apply_schema(dta, employ)
```

Finally, note that the `path` property of a Data Resource can be a vector of
paths in case a single data set is stored in a set of files. It is assumed then
that the files have the same format. Therefore, `rbind` should work on these
files.

Below is an alternative way of importing the data belonging to a Data Resource.
Here we use the pipe operator to chain the various commands to import the
data set. 

```{.R #g12}
dta <- dp_resource(dp, "employment") |> dp_get_data()
head(dta)
```

## Reading properties from Data Packages and Data Resources

For many of the standard fields of a Data Packages, methods are defined to
obtain the values of these fields:

```{.R #r1}
dp_name(dp)
dp_description(dp)
dp_description(dp, first_paragraph = TRUE)
dp_title(dp)
```

The same holds for Data Resources:

```{.R #r2}
dp_title(employ)
dp_resource(dp, "codelist-employ") |> dp_title()
```

For `datapackage` objects there are currently defined the following methods:
(this list can be obtained using `?PropertiesDatapackage`)

- `dp_contributors()`
- `dp_created()`
- `dp_description()`
- `dp_id()`
- `dp_keywords()`
- `dp_name()`
- `dp_title()`

For `dataresource` objects there are currently defined the following methods
(this list can be obtained using `?properties_dataresource`)

- `dp_bytes()`
- `dp_encoding()`
- `dp_description()`
- `dp_format()`
- `dp_hash()`
- `dp_name()`
- `dp_mediatype()`
- `dp_path()`
- `dp_schema()`
- `dp_title()`

The `dp_path()` method has a `full_path` argument that, when used, returns the full
path to the Data Resources data and not just the path relative to the Data
Package. The full path is needed when one wants to use the path to read the
data.

```{.R #r3}
dp_path(employ)
dp_path(employ, full_path = TRUE)
```

It is also possible to get other properties than the ones explicitly mentioned
above using the `dp_property()` method:

```{.R #r4}
dp_property(employ, "encoding")
```


## Working with categories

It is possible for fields to have a list of [categories associated with
them](https://datapackage.org/standard/table-schema/#categories). Categories are
usually stored inside the Field Descriptor. However, the `datapackage` package
also supports lists of categories stored in a seperate Data Resource (this is
not part of the datapackage standard).  

In the example resource, there is are 'gender' and 'employ' that have categories
associated with them:

```{.R #c1}
dta <- dp_resource(dp, "employment") |> dp_get_data()
dta
```

This is string column but it has an 'categories' property set which points
to a Data Resource in the Data Package. It is possible te get this list of

categories
```{.R #c2}
dp_categorieslist(dta$employ)
```

This list of categories can also be used to convert the field to factor:

```{.R #c3}
dp_to_factor(dta$employ)
```

Using the `convert_categories = "to_factor"` argument of `dp_apply_schema()`
(which is called by `dp_get_data()`) it is also possible to convert all fields
which have an associated 'categories' field to factor:

```{.R #c4}
dta <- dp_resource(dp, "employment") |> 
  dp_get_data(convert_categories = "to_factor")
dta
```

When the [`codelist` package](https://cran.r-project.org/package=codelist) is
installed, it is also possible to convert the column to a `code` vector:

```{.R #c4}
dta <- dp_resource(dp, "employment") |> 
  dp_get_data(convert_categories = "to_code")
dta
```

This has the advantage that both the values/codes and the labels are kept
together and it is possible to use both when coding which can make code safer
and more readable:

```{.R #codedemo}
library(codelist)
dta[dta$gender == "X", ]
dta[dta$gender == as.label("Other"), ]
```


## Creating a Data Package

This is shown in a seperate vignette `Creating a Data Package`

## Quickly saving to and reading from a Data Package

A quick way to create a Data Package from a given dataset is with the
`dp_save_as_datapackage()` function:

```{.R #q1}
dir <- tempfile()
data(iris)
dp_save_as_datapackage(iris, dir)
```

And for reading:

```{.R #q2}
dp_load_from_datapackage(dir) |> head()
```

This will either load the Data Resource with the same name as the Data Package
or the first resource in the Data Package.  It is also possible to specify the
name of the Data Resource that should be read. Additional arguments are passed
on to `dp_get_data())`:

```{.R #q2}
dp_load_from_datapackage(dir, "iris", convert_categories = "to_factor", 
  use_fread = TRUE)
```

```{.R #n5 echo=FALSE results=FALSE}
file.remove(file.path(dir, "datapackage.json"))
file.remove(file.path(dir, "iris.csv"))
file.remove(dir)
```
