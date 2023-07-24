

csv_reader <- function(path, resourcemeta) {
  # TODO: do something with the meta
  dta <- read.csv(path)
  structure(dta, resource = x)
}
