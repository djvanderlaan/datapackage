
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

