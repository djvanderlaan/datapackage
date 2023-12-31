

#' Generate a fielddescriptor for a given variable in a dataset
#'
#' @param x vector for which to generate the fielddescriptor
#' @param name name of the field in the dataset.
#' @param use_existing use existing field descriptor of present (assumed this is
#'   stored in the 'fielddescriptor' attribute.
#' @param use_codelist use existing code list of \code{x} if available. The
#'   code list is obtained using \code{\link{dpcodelist}}.
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
dpgeneratefielddescriptor.numeric <- function(x, name, use_existing = TRUE, 
    use_codelist = TRUE, ...) {
  fielddescriptor <- attr(x, "fielddescriptor")
  codelistname <- if (is.null(fielddescriptor)) NULL else 
    dpproperty(fielddescriptor, "codelist")
  codelist <- dpcodelist(x)
  if (!is.null(fielddescriptor) && use_existing) {
    fielddescriptor$name <- name
  } else {
    fielddescriptor <- list(
      name = name,
      type = "number"
    )
    if (!is.null(codelist) && use_codelist) {
      if (is.null(codelistname)) codelistname <- paste0(name, "-codelist")
      fielddescriptor$codelist <- codelistname
    } else codelist <- NULL
  }
  class(fielddescriptor) <- "fielddescriptor"
  list(fielddescriptor = fielddescriptor, codelist = codelist)
}

#' @export
dpgeneratefielddescriptor.integer <- function(x, name, use_existing = TRUE, 
    use_codelist = TRUE, ...) {
  fielddescriptor <- attr(x, "fielddescriptor")
  codelistname <- if (is.null(fielddescriptor)) NULL else 
    dpproperty(fielddescriptor, "codelist")
  codelist <- dpcodelist(x)
  if (!is.null(fielddescriptor) && use_existing) {
    fielddescriptor$name <- name
  } else {
    fielddescriptor <- list(
      name = name,
      type = "integer"
    )
    if (!is.null(codelist) && use_codelist) {
      if (is.null(codelistname)) codelistname <- past0(name, "-codelist")
      fielddescriptor$codelist <- codelistname
    } else codelist <- NULL
  }
  class(fielddescriptor) <- "fielddescriptor"
  list(fielddescriptor = fielddescriptor, codelist = codelist)
}

#' @export
dpgeneratefielddescriptor.logical <- function(x, name, use_existing = TRUE, 
    use_codelist = TRUE, ...) {
  fielddescriptor <- attr(x, "fielddescriptor")
  codelistname <- if (is.null(fielddescriptor)) NULL else 
    dpproperty(fielddescriptor, "codelist")
  codelist <- dpcodelist(x)
  if (!is.null(fielddescriptor) && use_existing) {
    fielddescriptor$name <- name
  } else {
    fielddescriptor <- list(
      name = name,
      type = "boolean",
      trueValues = "TRUE", 
      falseValues = "FALSE"
    )
    if (!is.null(codelist) && use_codelist) {
      if (is.null(codelistname)) codelistname <- past0(name, "-codelist")
      fielddescriptor$codelist <- codelistname
    } else codelist <- NULL
  }
  class(fielddescriptor) <- "fielddescriptor"
  list(fielddescriptor = fielddescriptor, codelist = codelist)
}

#' @export
dpgeneratefielddescriptor.Date <- function(x, name, use_existing = TRUE, 
    use_codelist = TRUE, ...) {
  fielddescriptor <- attr(x, "fielddescriptor")
  codelistname <- if (is.null(fielddescriptor)) NULL else 
    dpproperty(fielddescriptor, "codelist")
  codelist <- dpcodelist(x)
  if (!is.null(fielddescriptor) && use_existing) {
    fielddescriptor$name <- name
  } else {
    fielddescriptor <- list(
      name = name,
      type = "date"
    )
    if (!is.null(codelist) && use_codelist) {
      if (is.null(codelistname)) codelistname <- past0(name, "-codelist")
      fielddescriptor$codelist <- codelistname
    } else codelist <- NULL
  }
  class(fielddescriptor) <- "fielddescriptor"
  list(fielddescriptor = fielddescriptor, codelist = codelist)
}

#' @export
dpgeneratefielddescriptor.character <- function(x, name, use_existing = TRUE, 
    use_codelist = TRUE, ...) {
  fielddescriptor <- attr(x, "fielddescriptor")
  codelistname <- if (is.null(fielddescriptor)) NULL else 
    dpproperty(fielddescriptor, "codelist")
  codelist <- dpcodelist(x)
  if (!is.null(fielddescriptor) && use_existing) {
    fielddescriptor$name <- name
  } else {
    fielddescriptor <- list(
      name = name,
      type = "string"
    )
    if (!is.null(codelist) && use_codelist) {
      if (is.null(codelistname)) codelistname <- past0(name, "-codelist")
      fielddescriptor$codelist <- codelistname
    } else codelist <- NULL
  }
  class(fielddescriptor) <- "fielddescriptor"
  list(fielddescriptor = fielddescriptor, codelist = codelist)
}


#' @export
dpgeneratefielddescriptor.factor <- function(x, name, use_existing = TRUE, 
    use_codelist = TRUE, ...) {
  fielddescriptor <- attr(x, "fielddescriptor")
  codelistname <- if (is.null(fielddescriptor)) NULL else 
    dpproperty(fielddescriptor, "codelist")
  codelist <- dpcodelist(x)
  if (!is.null(fielddescriptor) && use_existing) {
    fielddescriptor$name <- name
  } else {
    fielddescriptor <- list(
      name = name,
      type = "integer"
    )
    if (!use_codelist) {
      codelist <- data.frame(
        code = seq_len(nlevels(x)),
        label = levels(x))
    }
    if (is.null(codelistname)) codelistname <- paste0(name, "-codelist")
    fielddescriptor$codelist <- codelistname
  }
  class(fielddescriptor) <- "fielddescriptor"
  list(fielddescriptor = fielddescriptor, codelist = codelist)
}

