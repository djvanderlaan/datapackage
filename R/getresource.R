
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

