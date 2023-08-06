

resource <- function(x, resourcename) {
  UseMethod("resource")
}

resource.datapackage <- function(x, resourcename) {
  resources <- property(x, "resources")
  index <- getresourceindex(x, resourcename, resources = resources)
  r <- resources[[index]]
  structure(r, class="dataresource", path=attr(dp, "path"))
}

`resource<-` <- function(x, resourcename, value) {
  UseMethod("resource<-")
}

`resource<-.readonlydatapackage` <- function(x, resourcename, value) {
  index <- getresourceindex(x, resourcename)
  # TODO: check if valid resource
  # Remove all attributes from the dataresource
  attr(value, "path") <- NULL
  attr(value, "class") <- NULL
  x$resources[[index]] <- value
  x
}

`resource<-.editabledatapackage` <- function(x, resourcename, value) {
  dp <- readdatapackage(attr(x, "path"), attr(x, "filename"))
  resource(dp, resourcename) <- value
  writedatapackage(dp) 
  x
}

getresource <- function(dp, resourcename) {
  resources <- property(dp, "resources")
  for (i in seq_len(nresources(dp))) {
    r <- resources[[i]]
    if (exists("name", r)) {
      if (r$name == resourcename) {
        return(structure(r, class="dataresource", path=attr(dp, "path")))
      }
    } else {
      warning("Resource without name.")
    }
  }
  NULL
}

getresourceindex <- function(dp, resourcename, resources = NULL, stop = TRUE) {
  if (missing(resources) || is.null(resources))
    resources <- property(dp, "resources")
  for (i in seq_len(nresources(dp))) {
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

