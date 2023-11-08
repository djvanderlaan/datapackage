#' Modifying the resources of a Data Package
#'
#' @param x a \code{datapackage} object.
#'
#' @param resourcename the name of a resource.
#'
#' @param value a \code{dataresource} object.
#'
#' @details
#' When a resource with the name already exists this resource is
#' overwritten. Therefore, the assignment operator can also be used to modify
#' existing resources.
#'
#' @return 
#' Either returns a Data Resource object or modifies the Data Package.
#'
#' @rdname dpresource
#' @export
dpresource <- function(x, resourcename) {
  UseMethod("dpresource")
}

#' @rdname dpresource
#' @export
dpresource.datapackage <- function(x, resourcename) {
  resources <- dpproperty(x, "resources")
  index <- getresourceindex(x, resourcename, resources = resources)
  r <- resources[[index]]
  structure(r, class="dataresource", path=attr(x, "path"), datapackage = x)
}

#' @rdname dpresource
#' @export
`dpresource<-` <- function(x, resourcename, value) {
  UseMethod("dpresource<-")
}

#' @rdname dpresource
#' @export
`dpresource<-.readonlydatapackage` <- function(x, resourcename, value) {
  index <- getresourceindex(x, resourcename, stop = FALSE)
  # If not found add a new resource
  if (is.null(index)) {
    index <- dpnresources(x)+1L
  }
  # TODO: check if valid resource
  if (dpname(value) != resourcename) {
    warning("Name of data resource does not match the value of the ", 
      "resourcename argument. Updating the name of the data resource.")
    dpname(value) <- resourcename
  }
  # Remove all attributes from the dataresource
  attr(value, "path") <- NULL
  attr(value, "class") <- NULL
  x$resources[[index]] <- value
  x
}

#' @rdname dpresource
#' @export
`dpresource<-.editabledatapackage` <- function(x, resourcename, value) {
  dp <- readdatapackage(attr(x, "path"), attr(x, "filename"))
  dpresource(dp, resourcename) <- value
  writedatapackage(dp) 
  x
}

getresourceindex <- function(dp, resourcename, resources = NULL, stop = TRUE) {
  if (missing(resources) || is.null(resources))
    resources <- dpproperty(dp, "resources")
  for (i in seq_len(dpnresources(dp))) {
    r <- resources[[i]]
    if (exists("name", r)) {
      if (r$name == resourcename) {
        return (i)
      }
    } else {
      warning("Resource without name.")
    }
  }
  if (stop) stop("Resource '", resourcename, "' not found.") else NULL
}

