#' Creating and Adding Contributors to a Data Package
#' 
#' @param title A length 1 character vector with the full name of the
#' contributor.
#'
#' @param roles A character vector of roles for the contributor. Recommended
#' roles include e.g. "creator", "contact", "rightsHolder", "dataCurator". 
#'
#' @param givenName A string containing the given name of the contributor (if a person).
#'
#' @param familyName A string containing the family name of the contributor (if a person).
#'
#' @param path A URL to e.g. a home page of the contributor.
#' 
#' @param email The email address of the contributor.
#'
#' @param organization The organization the contributor belongs to.
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
#'   list(title = "Jane Doe", roles = "maintainer")
#' )
#' dp_add_contributor(dp) <- new_contributor("Janet Doe")
#'
#' @export
#' @rdname contributor
new_contributor <- function(title = NULL,
                            roles = NULL,
                            givenName = NULL,
                            familyName = NULL,
                            path = NULL,
                            email = NULL,
                            organization = NULL) {
  
  stopifnot(is.null(title) || (is.character(title) && length(title) == 1))
  stopifnot(is.null(givenName) || (is.character(givenName) && length(givenName) == 1))
  stopifnot(is.null(familyName) || (is.character(familyName) && length(familyName) == 1))
  stopifnot(is.null(path) || isurl(path))
  stopifnot(is.null(email) || (is.character(email) && length(email) == 1))
  stopifnot(is.null(roles) || (is.character(roles) && length(roles) >= 1))
  stopifnot(is.null(organization) || (is.character(organization) && length(organization) == 1))
  
  res <- list()
  if (!is.null(title)) res$title <- title
  if (!is.null(givenName)) res$givenName <- givenName
  if (!is.null(familyName)) res$familyName <- familyName
  if (!is.null(path)) res$path <- path
  if (!is.null(email)) res$email <- email
  if (!is.null(roles)) res$roles <- unique(roles)
  if (!is.null(organization)) res$organization <- organization
  
  if (length(res) == 0) {
    stop("Contributor must have at least one property.")
  }
  
  res
}

is_contributor <- function(x) {
  is.list(x) &&
    (
      exists("title", x) ||
        exists("givenName", x) ||
        exists("familyName", x) ||
        exists("path", x) ||
        exists("email", x) ||
        exists("roles", x) ||
        exists("organization", x)
    ) &&
    (!exists("title", x) || isstring(x$title)) &&
    (!exists("givenName", x) || isstring(x$givenName)) &&
    (!exists("familyName", x) || isstring(x$familyName)) &&
    (!exists("path", x) || isurl(x$path)) &&
    (!exists("email", x) || isstring(x$email)) &&
    (!exists("organization", x) || isstring(x$organization)) &&
    (!exists("roles", x) || (is.character(x$roles) && length(x$roles) >= 1))
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
#' @name PropertiesDatapackage
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

