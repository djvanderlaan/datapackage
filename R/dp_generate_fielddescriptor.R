

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
#' @rdname dp_generate_fielddescriptor
#' @export
dp_generate_fielddescriptor <- function(x, name, ...) {
  UseMethod("dp_generate_fielddescriptor")
}

#' @rdname dp_generate_fielddescriptor
#' @export
dp_generate_fielddescriptor.default <- function(x, name, ...) {
  fielddescriptor <- list(
    name = name,
    type = "string"
  )
  fielddescriptor
}

#' @rdname dp_generate_fielddescriptor
#' @export
dp_generate_fielddescriptor.numeric <- function(x, name, use_existing = TRUE, 
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
  fielddescriptor <- dp_generate_fielddescriptor_handle_categories(x, 
    fielddescriptor, use_existing & hasfielddescriptor, use_categories, categories_type)
  class(fielddescriptor) <- "fielddescriptor"
  fielddescriptor
}

#' @rdname dp_generate_fielddescriptor
#' @export
dp_generate_fielddescriptor.integer <- function(x, name, use_existing = TRUE, 
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
  fielddescriptor <- dp_generate_fielddescriptor_handle_categories(x, 
    fielddescriptor, use_existing & hasfielddescriptor, use_categories, categories_type)
  class(fielddescriptor) <- "fielddescriptor"
  fielddescriptor
}


#' @rdname dp_generate_fielddescriptor
#' @export
dp_generate_fielddescriptor.logical <- function(x, name, use_existing = TRUE, 
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
  fielddescriptor <- dp_generate_fielddescriptor_handle_categories(x, 
    fielddescriptor, use_existing & hasfielddescriptor, use_categories, categories_type)
  class(fielddescriptor) <- "fielddescriptor"
  fielddescriptor
}

#' @rdname dp_generate_fielddescriptor
#' @export
dp_generate_fielddescriptor.Date <- function(x, name, use_existing = TRUE, 
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
  fielddescriptor <- dp_generate_fielddescriptor_handle_categories(x, 
    fielddescriptor, use_existing & hasfielddescriptor, use_categories, categories_type)
  class(fielddescriptor) <- "fielddescriptor"
  fielddescriptor
}

#' @rdname dp_generate_fielddescriptor
#' @export
dp_generate_fielddescriptor.character <- function(x, name, use_existing = TRUE, 
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
  fielddescriptor <- dp_generate_fielddescriptor_handle_categories(x, 
    fielddescriptor, use_existing & hasfielddescriptor, use_categories, categories_type)
  class(fielddescriptor) <- "fielddescriptor"
  fielddescriptor
}


#' @rdname dp_generate_fielddescriptor
#' @export
dp_generate_fielddescriptor.factor <- function(x, name, use_existing = TRUE, 
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
  fielddescriptor <- dp_generate_fielddescriptor_handle_categories(x, 
    fielddescriptor, use_existing & hasfielddescriptor, use_categories, categories_type)
  class(fielddescriptor) <- "fielddescriptor"
  fielddescriptor
}


#' @rdname dp_generate_fielddescriptor
#' @export
dp_generate_fielddescriptor.code <- function(x, name, use_existing = TRUE,
    use_categories = TRUE, categories_type = c("regular", "resource"), ...) {
  fielddescriptor <- attr(x, "fielddescriptor")
  hasfielddescriptor <- !is.null(fielddescriptor)
  # Generate base fielddescriptor
  oldclass <- class(x)
  class(x) <- setdiff(class(x), c("code", "factor"))
  fielddescriptor <- dp_generate_fielddescriptor(x, name, 
    use_existing = use_existing, use_categories = FALSE)
  class(x) <- oldclass
  # Handle categories
  fielddescriptor <- dp_generate_fielddescriptor_handle_categories(x, 
    fielddescriptor, use_existing & hasfielddescriptor, use_categories, categories_type)
  class(fielddescriptor) <- "fielddescriptor"
  fielddescriptor
}

dp_generate_fielddescriptor_handle_categories <- function(x, fielddescriptor, use_existing, 
    use_categories, categories_type = c("regular", "resource")) {
  if (use_existing) return(fielddescriptor)
  categories_type <- match.arg(categories_type)
  categorieslist <- dp_categorieslist(x, normalise = TRUE)
  if (!use_categories && is.factor(x)) {
    categorieslist <- data.frame(
      value = seq_len(nlevels(x)),
      label = levels(x))
  } 
  if ((use_categories || is.factor(x) || methods::is(x, "code")) && !is.null(categorieslist)) {
    if (categories_type == "resource") {
      fielddescriptor$categories <- list(resource = 
        paste0(tolower(fielddescriptor$name), "-categories"))
    } else {
      fielddescriptor$categories <- categorieslisttolist(categorieslist)
    }
  } else {
    fielddescriptor$categories <- NULL
    fielddescriptor$categoriesOrdered <- NULL
  }
  fielddescriptor
}

