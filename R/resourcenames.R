
resourcenames <- function(dp, resourcename) {
  resources <- sapply(dpattr(dp, "resources"), function(r) {
    if (!exists("name", r)) stop("Resource without name.")
    r$name
  })
  resources
}

