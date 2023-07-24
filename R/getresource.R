
getresource <- function(dp, resourcename) {
  for (i in seq_len(nresources(dp))) {
    r <- dp$resources[[i]]
    if (exists("name", r)) {
      if (r$name == resourcename) {
        return(structure(r, class="resource", path=attr(dp, "path")))
      }
    } else {
      warning("Resource without name.")
    }
  }
  warning("Resource not found.")
  NULL
}
