

#' Generate a fielddescriptor for a given variable in a dataset
#'
#' @param x vector for which to generate the fielddescriptor
#' @param name name of the field in the dataset.
#' @param use_existing use existing field descriptor of present (assumed this is
#'   stored in the 'fielddescriptor' attribute.
#' @param use_codelist use existing code list of \code{x} if available. The
#'   code list is obtained using \code{\link{dpcodelist}}.
#' @param categories_type how should categories be stored. Note that type "resource"
#'   is not officially part of the standard. 
#' @param ... used to pass extra arguments to methods.
#'
#' @return
#' Returns a \code{list} with two fields: \code{fielddescriptor} and optionally
#' \code{codelist}. The first contains the \code{fielddescriptor} object and the
#' second the optional code list for the field.
#'
#' @rdname dpgeneratefielddescriptor
#' @export
dpgeneratefielddescriptor <- function(x, name, ...) {
  UseMethod("dpgeneratefielddescriptor")
}

#' @rdname dpgeneratefielddescriptor
#' @export
dpgeneratefielddescriptor.default <- function(x, name, ...) {
  fielddescriptor <- list(
    name = name,
    type = "string"
  )
  list(fielddescriptor = fielddescriptor)
}

#' @rdname dpgeneratefielddescriptor
#' @export
dpgeneratefielddescriptor.numeric <- function(x, name, use_existing = TRUE, 
    use_codelist = TRUE, categories_type = c("regular", "resource"), ...) {
  categories_type <- match.arg(categories_type)
  fielddescriptor <- attr(x, "fielddescriptor")
  categories <- if (is.null(fielddescriptor)) NULL else 
    dpproperty(fielddescriptor, "categories")
  categorieslist <- dpcodelist(x)
  if (!is.null(fielddescriptor) && use_existing) {
    fielddescriptor$name <- name
  } else {
    fielddescriptor <- list(
      name = name,
      type = "number"
    )
    if (!is.null(categories) && use_codelist) {
      # TODO: for now always store categories in fielddescriptor
      fielddescriptor$categories <- categorieslisttolist(categorieslist)
      categorieslist <- NULL
    } else categorieslist <- NULL
  }
  class(fielddescriptor) <- "fielddescriptor"
  list(fielddescriptor = fielddescriptor, codelist = categorieslist)
}

#' @rdname dpgeneratefielddescriptor
#' @export
dpgeneratefielddescriptor.integer <- function(x, name, use_existing = TRUE, 
    use_codelist = TRUE, categories_type = c("regular", "resource"), ...) {
  categories_type <- match.arg(categories_type)
  fielddescriptor <- attr(x, "fielddescriptor")
  categories <- if (is.null(fielddescriptor)) NULL else 
    dpproperty(fielddescriptor, "categories")
  categorieslist <- dpcodelist(x)
  if (!is.null(fielddescriptor) && use_existing) {
    fielddescriptor$name <- name
  } else {
    fielddescriptor <- list(
      name = name,
      type = "integer"
    )
    if (!is.null(categories) && use_codelist) {
      # TODO: for now always store categories in fielddescriptor
      fielddescriptor$categories <- categorieslisttolist(categorieslist)
      categorieslist <- NULL
    } else categorieslist <- NULL
  }
  class(fielddescriptor) <- "fielddescriptor"
  list(fielddescriptor = fielddescriptor, codelist = categorieslist)
}


#' @rdname dpgeneratefielddescriptor
#' @export
dpgeneratefielddescriptor.logical <- function(x, name, use_existing = TRUE, 
    use_codelist = TRUE, categories_type = c("regular", "resource"), ...) {
  categories_type <- match.arg(categories_type)
  fielddescriptor <- attr(x, "fielddescriptor")
  categories <- if (is.null(fielddescriptor)) NULL else 
    dpproperty(fielddescriptor, "categories")
  categorieslist <- dpcodelist(x)
  if (!is.null(fielddescriptor) && use_existing) {
    fielddescriptor$name <- name
  } else {
    fielddescriptor <- list(
      name = name,
      type = "boolean",
      trueValues = "TRUE", 
      falseValues = "FALSE"
    )
    if (!is.null(categories) && use_codelist) {
      # TODO: for now always store categories in fielddescriptor
      fielddescriptor$categories <- categorieslisttolist(categorieslist)
      categorieslist <- NULL
    } else categorieslist <- NULL
  }
  class(fielddescriptor) <- "fielddescriptor"
  list(fielddescriptor = fielddescriptor, codelist = categorieslist)
}

#' @rdname dpgeneratefielddescriptor
#' @export
dpgeneratefielddescriptor.Date <- function(x, name, use_existing = TRUE, 
    use_codelist = TRUE, categories_type = c("regular", "resource"), ...) {
  categories_type <- match.arg(categories_type)
  fielddescriptor <- attr(x, "fielddescriptor")
  categories <- if (is.null(fielddescriptor)) NULL else 
    dpproperty(fielddescriptor, "categories")
  categorieslist <- dpcodelist(x)
  if (!is.null(fielddescriptor) && use_existing) {
    fielddescriptor$name <- name
  } else {
    fielddescriptor <- list(
      name = name,
      type = "date"
    )
    if (!is.null(categories) && use_codelist) {
      # TODO: for now always store categories in fielddescriptor
      fielddescriptor$categories <- categorieslisttolist(categorieslist)
      categorieslist <- NULL
    } else categorieslist <- NULL
  }
  class(fielddescriptor) <- "fielddescriptor"
  list(fielddescriptor = fielddescriptor, codelist = categorieslist)
}

#' @rdname dpgeneratefielddescriptor
#' @export
dpgeneratefielddescriptor.character <- function(x, name, use_existing = TRUE, 
    use_codelist = TRUE, categories_type = c("regular", "resource"), ...) {
  categories_type <- match.arg(categories_type)
  fielddescriptor <- attr(x, "fielddescriptor")
  categories <- if (is.null(fielddescriptor)) NULL else 
    dpproperty(fielddescriptor, "categories")
  categorieslist <- dpcodelist(x)
  if (!is.null(fielddescriptor) && use_existing) {
    fielddescriptor$name <- name
  } else {
    fielddescriptor <- list(
      name = name,
      type = "string"
    )
    if (!is.null(categories) && use_codelist) {
      # TODO: for now always store categories in fielddescriptor
      fielddescriptor$categories <- categorieslisttolist(categorieslist)
      categorieslist <- NULL
    } else categorieslist <- NULL
  }
  class(fielddescriptor) <- "fielddescriptor"
  list(fielddescriptor = fielddescriptor, codelist = categorieslist)
}


#' @rdname dpgeneratefielddescriptor
#' @export
dpgeneratefielddescriptor.factor <- function(x, name, use_existing = TRUE, 
    use_codelist = TRUE, categories_type = c("regular", "resource"), ...) {
  categories_type <- match.arg(categories_type)
  fielddescriptor <- attr(x, "fielddescriptor")
  categories <- if (is.null(fielddescriptor)) NULL else 
    dpproperty(fielddescriptor, "categories")
  categorieslist <- dpcodelist(x)
  if (!is.null(fielddescriptor) && use_existing) {
    fielddescriptor$name <- name
  } else {
    fielddescriptor <- list(
      name = name,
      type = "integer"
    )
    if (!use_codelist) {
      categorieslist <- data.frame(
        value = seq_len(nlevels(x)),
        label = levels(x))
    }
    # TODO: for now always store categories in fielddescriptor
    fielddescriptor$categories <- categorieslisttolist(categorieslist)
    categorieslist <- NULL
  }
  class(fielddescriptor) <- "fielddescriptor"
  list(fielddescriptor = fielddescriptor, codelist = categorieslist)
}

