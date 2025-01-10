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
#' @param contributor a contributor object
#'
#' @param value a contributor object
#'
#' @return
#' \code{new_contributor} returns a list with the given properties. This function
#' is meant to assist in creating valid contributors. 
#'
#' @examples
#' dp <- open_datapackage(system.file(package = "datapackage", "examples/iris")) 
#' dp_contributors(dp)
#' dp_contributors(dp) <- list(
#'   new_contributor("John Doe", email = "j.doe@somewhere.org"),
#'   list(title = "Jane Doe", role = "maintainer")
#' )
#' dp_add_contributor(dp) <- new_contributor("Janet Doe")
#'
#' @export
#' @rdname contributor
new_contributor <- function(title, 
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

is_contributor <- function(x) {
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
    utils::str(toprint, max.level=1, give.attr=FALSE, no.list = TRUE, 
      comp.str="", indent.str="  ", give.head = FALSE)
  }
}

#' @export
print.contributors <- function(x, ...) {
  for (i in x) print.contributor(i)
}

#' @export
str.contributors <- function(object, ...) {
  c <- sapply(object, \(x) x$title)
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
dp_add_contributor <- function(x, contributor) {
  if (!is_contributor(contributor)) stop("Invalid contributor.")
  contributors <- dp_contributors(x)
  if (is.null(contributors)) {
    contributors <- list(contributor)
  } else {
    contributors[[length(contributors)+1]] <- contributor
  }
  dp_property(x, "contributors") <- contributors
  x
}

#' @export
#' @rdname contributor
`dp_add_contributor<-` <- function(x, value) {
  dp_add_contributor(x, value)
}


#' @export
#' @rdname properties_datapackage
dp_contributors <- function(x, ...) {
  UseMethod("dp_contributors")
}

#' @export
#' @rdname properties_datapackage
`dp_contributors<-` <- function(x, value) {
  UseMethod("dp_contributors<-")
}

#' @export
#' @rdname properties_datapackage
dp_contributors.datapackage <- function(x, ...) {
  res <- dp_property(x, "contributors")
  if (is.null(res)) res else structure(res, class = "contributors")
}

#' @export
#' @rdname properties_datapackage
`dp_contributors<-.datapackage` <- function(x, value) {
  if (!is.list(value) || !is.null(names(value)) || 
      !all(sapply(value, is_contributor))) {
    stop("value should be an unnamed list of contributors.")
  }
  value <- lapply(value, stripattributes)
  dp_property(x, "contributors") <- stripattributes(value, keep = character(0L))
  x
}

