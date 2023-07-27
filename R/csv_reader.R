

csv_reader <- function(path, resource) {
  # TODO: do something with the meta
  dta <- read.csv(path)
  structure(dta, resource = resource)
}
