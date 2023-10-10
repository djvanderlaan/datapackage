#' Try guess the best variable meta data for a variable
#'
#' @param x the variable for which the meta data has to be generated.
#' @param name the name of the variable.
#' @param ... passed on to other methods.
#' 
#' @details
#' When \code{x} has a 'schema' attribute, that is used. 
#' 
#' @export
generate_schema <- function(x, name = NULL, ...) {
  UseMethod("generate_schema")
}

#' @export
generate_schema.numeric <- function(x, name = NULL, ...) {
  res <- attr(x, "schema")
  if (!is.null(res)) {
    if (!missing(name)) res[["name"]] <- name
  } else {
    res <- list(
      type = "number"
    )
    if (!missing(name) && !is.null(name)) res[["name"]] <- name
  }
  res
}

#' @export
generate_schema.integer <- function(x, name = NULL, ...) {
  res <- attr(x, "schema")
  if (!is.null(res)) {
    if (!missing(name)) res[["name"]] <- name
  } else {
    res <- list(
      type = "integer"
    )
    if (!missing(name) && !is.null(name)) res[["name"]] <- name
  }
  res
}

#' @export
generate_schema.logical <- function(x, name = NULL, ...) {
  res <- attr(x, "schema")
  if (!is.null(res)) {
    if (!missing(name)) res[["name"]] <- name
  } else {
    res <- list(
      type = "boolean",
      trueValues = "TRUE",
      falseValues = "FALSE"
    )
    if (!missing(name) && !is.null(name)) res[["name"]] <- name
  }
  res
}

#' @export
generate_schema.character <- function(x, name = NULL, ...) {
  res <- attr(x, "schema")
  if (!is.null(res)) {
    if (!missing(name)) res[["name"]] <- name
  } else {
    res <- list(
      type = "string"
    )
    if (!missing(name) && !is.null(name)) res[["name"]] <- name
  }
  res
}

#' @export
generate_schema.factor <- function(x, name = NULL, as_integer = TRUE, ...) {
  res <- attr(x, "schema")
  if (!is.null(res)) {
    if (!missing(name) && !is.null(name)) res[["name"]] <- name
    # TODO: check if categories matches the levels
  } else if (as_integer) {
    res <- list(
      type = "integer"
    )
    if (!missing(name) && !is.null(name)) res[["name"]] <- name
    res$categories <- lapply(seq_len(nlevels(x)), function(i, levels) {
      list(value = i, label = levels[i])
    }, levels = levels(x))
  } else {
    res <- list(
      type = "character"
    )
    if (!missing(name) && !is.null(name)) res[["name"]] <- name
    res$categories <- lapply(levels(x), function(x) {
      list(value = x, label = x)
    })
  }
  res
}

#' @export
generate_schema.Date <- function(x, name = NULL, ...) {
  res <- attr(x, "schema")
  if (!is.null(res)) {
    if (!missing(name)) res[["name"]] <- name
  } else {
    res <- complete_schema_date(list())
    if (!missing(name) && !is.null(name)) res[["name"]] <- name
  }
  res
}

#' @export
generate_schema.default <- function(x, name = NULL, ...) {
  res <- attr(x, "schema")
  if (!is.null(res)) {
    if (!missing(name)) res[["name"]] <- name
  } else {
    res <- list(
      type = "string"
    )
    if (!missing(name) && !is.null(name)) res[["name"]] <- name
  }
  res
}

#' @export
generate_schema.data.frame <- function(x, name = NULL, ...) {
  schema <- attr(x, "schema")
  if (is.null(schema)) schema <- list(name = name)
  fields <- vector("list", ncol(x))
  for (i in seq_along(x)) {
    fields[[i]] <- generate_schema(x[[i]], names(x)[i])
  }
  schema$fields <- fields
  if (is.null(schema$missingValues)) schema$missingValues <- ""
  schema
}

