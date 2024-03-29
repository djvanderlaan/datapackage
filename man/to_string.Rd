% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/field_string.R
\name{to_string}
\alias{to_string}
\title{Convert a vector to 'string' using the specified schema}
\usage{
to_string(x, schema = list(), ...)
}
\arguments{
\item{x}{the vector to convert.}

\item{schema}{the table-schema for the field.}

\item{...}{passed on to other methods.}
}
\value{
Will return an \code{character} vector with \code{schema} added as the
'schema' attribute.
}
\description{
Convert a vector to 'string' using the specified schema
}
\details{
When \code{schema} is missing a default schema is generated using
\code{\link{complete_schema_string}}.
}
