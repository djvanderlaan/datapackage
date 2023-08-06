
nresources <- function(dp, ...) {
  # If resources does not exist dp$resources will return NULL which has a 
  # length of 0
  length(property(dp, "resources"))
}
