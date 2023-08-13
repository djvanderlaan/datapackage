
#' @export
#' @rdname properties_datapackage
contributors <- function(x, ...) {
  UseMethod("contributors")
}

#' @export
#' @rdname properties_datapackage
`contributors<-` <- function(x, ...) {
  UseMethod("contributors<-")
}

#' @export
#' @rdname properties_datapackage
contributors.datapackage <- function(x, ...) {
  res <- property(x, "contributors")
  if (is.null(res)) res else structure(res, class = "contributors")
}

#' @export
#' @rdname properties_datapackage
`contributors<-.datapackage` <- function(x, value, ...) {
  if (!is.list(value) || !is.null(names(value)) || 
      !all(sapply(value, iscontributor))) {
    stop("value should be an unnamed list of contributors.")
  }
  value <- lapply(value, stripattributes)
  property(x, "contributors") <- stripattributes(value, keep = character(0L))
  x
}

#' Creating and Adding Contributors to a Data Package
#' 
#' @param title A length 1 character vector with the full nam of the
#' contributor.
#'
#' @param role The role of the contributor
#' 
#' @param path A URL to e.g. a home page of the contributor
#' 
#' @param email The email address of the contributor
#'
#' @param organisation The orgination the contributor belongs to.
#'
#' @param x The Data Package to which the contributor has to be added.
#'
#' @return
#' \code{newcontributor} returns a list with the given properties. This function
#' is meant to assist in creating valid contributors. 
#'
#' @examples
#' dp <- opendatapackage(system.file(package = "datapackage", "examples/iris")) 
#' contributors(dp)
#' contributors(dp) <- list(
#'   newcontributor("John Doe", email = "j.doe@somewhere.org"),
#'   list(title = "Jane Doe", role = "maintainer")
#' )
#' addcontributor(dp) <- newcontributor("Janet Doe")
#'
#' @export
#' @rdname contributor
newcontributor <- function(title, 
    role = c("contributor", "author", "publisher", "maintainer", "wrangler"), 
    path = NULL, email = NULL, organisation = NULL) {
  stopifnot(isstring(title))
  stopifnot(is.null(path) || isurl(path))
  stopifnot(is.null(email) || isstring(email))
  role <- match.arg(role)
  stopifnot(is.null(organisation) || isstring(organisation))
  res <- list(title = title, role = role)
  if (!missing(title) && !is.null(title)) res$title <- title
  if (!missing(path) && !is.null(path)) res$path <- path
  if (!missing(email) && !is.null(email)) res$email <- email
  if (!missing(organisation) && !is.null(organisation)) res$organisation <- organisation
  res
}

iscontributor <- function(x) {
  is.list(x) && exists("title", x) && isstring(x$title) &&
    (!exists("path", x) || isurl(x$path)) &&
    (!exists("email", x) || isstring(x$email)) &&
    (!exists("organisation", x) || isstring(x$organisation))
}

#' @export
print.contributor <- function(x, ...) {
  cat(x$title, "\n")
  toprint <- setdiff(names(x), "title")
  toprint <- x[toprint]
  if (length(toprint)) {
    str(toprint, max.level=1, give.attr=FALSE, no.list = TRUE, 
      comp.str="", indent.str="  ", give.head = FALSE)
  }
}

#' @export
print.contributors <- function(x, ...) {
  for (i in x) print.contributor(i)
}

#' @export
str.contributors <- function(x, ...) {
  c <- sapply(x, \(x) x$title)
  c <- if (length(c) == 1) {
    c
  } else if (length(c) <= 3) {
    paste0(c, c(rep(", ", length(c) - 2), " and ", ""), collapse = "")
  } else {
    paste0(c[1], ", ", c[2], " and others")
  }
  cat("", c, "\n")
}

#' @export
#' @rdname contributor
addcontributor <- function(x, contributor, ...) {
  if (!iscontributor(contributor)) stop("Invalid contributor.")
  contributors <- contributors(x)
  if (is.null(contributors)) {
    contributors <- list(contributor)
  } else {
    contributors[[length(contributors)+1]] <- contributor
  }
  property(x, "contributors") <- contributors
  x
}

#' @export
#' @rdname contributor
`addcontributor<-` <- function(x, value) {
  addcontributor(x, value)
}

