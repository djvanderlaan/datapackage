% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dploadfromdatapackage.R
\name{dploadfromdatapackage}
\alias{dploadfromdatapackage}
\title{Quickly read a dataset from a Data Package}
\usage{
dploadfromdatapackage(path, name, ...)
}
\arguments{
\item{path}{the directory with the Data Package}

\item{name}{the name of the Data Resource. When omitted the Data Resource
with the same name as the Data Package is read in and when no such resource
exists the first Data Resource is read in.}

\item{...}{passed on to \code{\link{dpgetdata}}.}
}
\value{
Returns a dataset. Usually a \code{data.frame}.
}
\description{
Quickly read a dataset from a Data Package
}
\details{
This function is a wrapper around \code{\link{opendatapackage}} and
\code{\link{dpgetdata}}. It offers a quick way to read in a dataset from a
Data Package.
}
