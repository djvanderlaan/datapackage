
#' @export
print.datapackage <- function(x, properties = NA, ...) {
  printdescription(x)
  cat("\n", c2("Location"), ": <", attr(x, "path"), ">", sep="")
  if (dp_nresources(x) > 0) {
    cat("\n", c2("Resources"), ":\n\n", sep = "")
    resources <- dp_resource_names(x)
    for (resource in resources) {
      printdescription(dp_resource(x, resource), description = FALSE)
    }
  } else {
    cat(bd(c1("\n<NO RESOURCES>\n")))
  }
  attributes <- dp_properties(x)
  if (length(properties) == 1 && is.na(properties)) properties <- attributes
  properties  <- setdiff(properties, c("name", "title", "description", "resources"))
  toprint <- intersect(attributes, properties)
  if (length(toprint)) {
    tmp <- lapply(toprint, \(property) dp_property(x, property))
    names(tmp) <- toprint
    cat("\n", c2("Selected properties"), ":\n", sep = "")
    utils::str(tmp, max.level=1, give.attr=FALSE, no.list = TRUE, 
      comp.str="", indent.str="", give.head = FALSE)
  }
}

