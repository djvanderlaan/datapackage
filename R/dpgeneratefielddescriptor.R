

#' Generate a fielddescriptor for a given variable in a dataset
#'
#' @param x vector for which to generate the fielddescriptor
#' @param name name of the field in the dataset.
#' @param use_existing use existing field descriptor if present (assumes this is
#'   stored in the 'fielddescriptor' attribute).
#' @param use_categories do not generate a categories field except when \code{x}
#'   is a factor.
#' @param categories_type how should categories be stored. Note that type "resource"
#'   is not officially part of the standard. 
#' @param ... used to pass extra arguments to methods.
#'
#' @return
#' Returns a \code{fielddescriptor}. 
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
  fielddescriptor
}

#' @rdname dpgeneratefielddescriptor
#' @export
dpgeneratefielddescriptor.numeric <- function(x, name, use_existing = TRUE, 
    use_categories = TRUE, categories_type = c("regular", "resource"), ...) {
  fielddescriptor <- attr(x, "fielddescriptor")
  hasfielddescriptor <- !is.null(fielddescriptor)
  if (hasfielddescriptor && use_existing) {
    fielddescriptor$name <- name
  } else {
    fielddescriptor <- list(
      name = name,
      type = "number"
    )
  }
  fielddescriptor <- dpgeneratefielddescriptor_handle_categories(x, 
    fielddescriptor, use_existing & hasfielddescriptor, use_categories, categories_type)
  class(fielddescriptor) <- "fielddescriptor"
  fielddescriptor
}

#' @rdname dpgeneratefielddescriptor
#' @export
dpgeneratefielddescriptor.integer <- function(x, name, use_existing = TRUE, 
    use_categories = TRUE, categories_type = c("regular", "resource"), ...) {
  fielddescriptor <- attr(x, "fielddescriptor")
  hasfielddescriptor <- !is.null(fielddescriptor)
  if (hasfielddescriptor && use_existing) {
    fielddescriptor$name <- name
  } else {
    fielddescriptor <- list(
      name = name,
      type = "integer"
    )
  }
  fielddescriptor <- dpgeneratefielddescriptor_handle_categories(x, 
    fielddescriptor, use_existing & hasfielddescriptor, use_categories, categories_type)
  class(fielddescriptor) <- "fielddescriptor"
  fielddescriptor
}


#' @rdname dpgeneratefielddescriptor
#' @export
dpgeneratefielddescriptor.logical <- function(x, name, use_existing = TRUE, 
    use_categories = TRUE, categories_type = c("regular", "resource"), ...) {
  fielddescriptor <- attr(x, "fielddescriptor")
  hasfielddescriptor <- !is.null(fielddescriptor)
  if (hasfielddescriptor && use_existing) {
    fielddescriptor$name <- name
  } else {
    fielddescriptor <- list(
      name = name,
      type = "boolean",
      trueValues = "TRUE", 
      falseValues = "FALSE"
    )
  }
  fielddescriptor <- dpgeneratefielddescriptor_handle_categories(x, 
    fielddescriptor, use_existing & hasfielddescriptor, use_categories, categories_type)
  class(fielddescriptor) <- "fielddescriptor"
  fielddescriptor
}

#' @rdname dpgeneratefielddescriptor
#' @export
dpgeneratefielddescriptor.Date <- function(x, name, use_existing = TRUE, 
    use_categories = TRUE, categories_type = c("regular", "resource"), ...) {
  fielddescriptor <- attr(x, "fielddescriptor")
  hasfielddescriptor <- !is.null(fielddescriptor)
  if (hasfielddescriptor && use_existing) {
    fielddescriptor$name <- name
  } else {
    fielddescriptor <- list(
      name = name,
      type = "date"
    )
  }
  fielddescriptor <- dpgeneratefielddescriptor_handle_categories(x, 
    fielddescriptor, use_existing & hasfielddescriptor, use_categories, categories_type)
  class(fielddescriptor) <- "fielddescriptor"
  fielddescriptor
}

#' @rdname dpgeneratefielddescriptor
#' @export
dpgeneratefielddescriptor.character <- function(x, name, use_existing = TRUE, 
    use_categories = TRUE, categories_type = c("regular", "resource"), ...) {
  fielddescriptor <- attr(x, "fielddescriptor")
  hasfielddescriptor <- !is.null(fielddescriptor)
  if (hasfielddescriptor && use_existing) {
    fielddescriptor$name <- name
  } else {
    fielddescriptor <- list(
      name = name,
      type = "string"
    )
  }
  fielddescriptor <- dpgeneratefielddescriptor_handle_categories(x, 
    fielddescriptor, use_existing & hasfielddescriptor, use_categories, categories_type)
  class(fielddescriptor) <- "fielddescriptor"
  fielddescriptor
}


#' @rdname dpgeneratefielddescriptor
#' @export
dpgeneratefielddescriptor.factor <- function(x, name, use_existing = TRUE, 
    use_categories = TRUE, categories_type = c("regular", "resource"), ...) {
  fielddescriptor <- attr(x, "fielddescriptor")
  hasfielddescriptor <- !is.null(fielddescriptor)
  if (hasfielddescriptor && use_existing) {
    fielddescriptor$name <- name
  } else {
    fielddescriptor <- list(
      name = name,
      type = "integer"
    )
  }
  fielddescriptor <- dpgeneratefielddescriptor_handle_categories(x, 
    fielddescriptor, use_existing & hasfielddescriptor, use_categories, categories_type)
  class(fielddescriptor) <- "fielddescriptor"
  fielddescriptor
}


dpgeneratefielddescriptor_handle_categories <- function(x, fielddescriptor, use_existing, 
    use_categories, categories_type = c("regular", "resource")) {
  if (use_existing) return(fielddescriptor)
  categories_type <- match.arg(categories_type)
  categorieslist <- dpcategorieslist(x, normalise = TRUE)
  if (!use_categories && is.factor(x)) {
    categorieslist <- data.frame(
      value = seq_len(nlevels(x)),
      label = levels(x))
  } 
  if ((use_categories || is.factor(x)) && !is.null(categorieslist)) {
    if (categories_type == "resource") {
      fielddescriptor$categories <- list(resource = paste0(fielddescriptor$name, "-categories"))
    } else {
      fielddescriptor$categories <- categorieslisttolist(categorieslist)
    }
  } else {
    fielddescriptor$categories <- NULL
    fielddescriptor$categoriesOrdered <- NULL
  }
  fielddescriptor
}

