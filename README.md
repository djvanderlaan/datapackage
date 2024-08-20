
datapackage
============================================================

`datapackage` is an R-package to work with [Data
Packages](https://datapackage.org). Data Packages are a combination of
data and meta data. The meta data contains a description of the data and
contains information like a title, description of the data set and a
description of the fields in each of the datasets in the Data Package. The
`datapackage` R-package offers methods for reading and inspecting Data Packages
as well as creating and modifying Data Packages. More information can be found
in the vignettes of the package:

- [Introduction to `datapackage`](https://htmlpreview.github.io/?https://github.com/djvanderlaan/datapackage/blob/main/inst/doc/introduction.html)
- [Creating a Data Package](https://htmlpreview.github.io/?https://github.com/djvanderlaan/datapackage/blob/main/inst/doc/creating_a_datapackage.html)

The package supports CSV-files out of the box. Other file formats are supported
through plugins. 

- [parquet](https://github.com/djvanderlaan/datapackage.parquet). This package
  also functions as an example implementation for implementing a plugin for a
  data format.


