

#' Generate a fielddescriptor for a given variable in a dataset
#'
#' @param x vector for which to generate the fielddescriptor
#' @param name name of the field in the dataset.
#' @param ... used to pass extra arguments to methods.
#'
#' @return
#' Returns a \code{list} with two fields: \code{fielddescriptor} and optionally
#' \code{codelist}. The first contains the \code{fielddescriptor} object and the
#' second the optional code list for the field.
#'
#' @export
dpgeneratefielddescriptor <- function(x, name, ...) {
  UseMethod("dpgeneratefielddescriptor")
}

#' @export
dpgeneratefielddescriptor.default <- function(x, name, ...) {
  fielddescriptor <- list(
    name = name,
    type = "string"
  )
  list(fielddescriptor = fielddescriptor)
}

#' @export
dpgeneratefielddescriptor.numeric <- function(x, name, ...) {
  fielddescriptor <- list(
    name = name,
    type = "number"
  )
  list(fielddescriptor = fielddescriptor)
}

#' @export
dpgeneratefielddescriptor.factor <- function(x, name, ...) {
  fielddescriptor <- list(
    name = name,
    type = "integer",
    codelist = sprintf("%s-codelist", name)
  )
  codelist <- data.frame(
    code = seq_len(nlevels(x)),
    label = levels(x)
  )
  list(fielddescriptor = fielddescriptor, codelist = codelist)
}

# TODO: reuse existing fielddescriptor
