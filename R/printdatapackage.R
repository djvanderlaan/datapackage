
#' @export
print.datapackage <- function(x, properties = character(0), ...) {
  printdescription(x)
  cat("\nLocation: <", attr(x, "path"), ">", sep="")
  if (nresources(x) > 0) {
    cat("\nResources:\n")
    resources <- resourcenames(x)
    for (resource in resources) {
      printdescription(resource(x, resource), description = FALSE)
    }
  } else {
    cat("\n<NO RESOURCES>\n")
  }
  attributes <- properties(x)
  if (length(properties) == 1 && is.na(properties)) properties <- attributes
  properties  <- setdiff(properties, c("name", "title", "description", "resources"))
  toprint <- intersect(attributes, properties)
  if (length(toprint)) {
    cat("\nSelected properties:\n")
    str(property(x, toprint), max.level=1, give.attr=FALSE, no.list = TRUE, 
      comp.str="", indent.str="", give.head = FALSE)
  }
}

