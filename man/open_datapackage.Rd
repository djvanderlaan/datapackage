% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/open_datapackage.R
\name{open_datapackage}
\alias{open_datapackage}
\title{Open a data package}
\usage{
open_datapackage(path, readonly = TRUE)
}
\arguments{
\item{path}{The filename or the data package description or the directory in
which the data package is located.}

\item{readonly}{Open the data package as a read-only data package or not. See
'details'}
}
\value{
Returns a list with the contents of the data package when 
\code{readonly = TRUE}. Otherwise an empty list is returned. In both cases
the filename of the data package description (typically 'datapackage.json')
and the director in which the data package is located are stored in
attributes of the result.
}
\description{
Open a data package
}
\details{
When \code{path} is a directory name, the function looks for the files
'datapackage.json' or 'datapackage.yaml' in the directory. Otherwise, the
function assumes the file contains the description of the data package.

When the data package is read with \code{readonly = FALSE}, any operations
reading properties from the data package read those properties directly from
the file on disk. And setting the properties will change the file on disk.
This ensures the file is always consistent.
}
