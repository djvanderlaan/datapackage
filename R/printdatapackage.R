
#' @export
print.datapackage <- function(x, properties = NA, ...) {
  printdescription(x)
  cat("\nLocation: <", attr(x, "path"), ">", sep="")
  if (dpnresources(x) > 0) {
    cat("\nResources:\n")
    resources <- dpresourcenames(x)
    for (resource in resources) {
      printdescription(dpresource(x, resource), description = FALSE)
    }
  } else {
    cat("\n<NO RESOURCES>\n")
  }
  attributes <- dpproperties(x)
  if (length(properties) == 1 && is.na(properties)) properties <- attributes
  properties  <- setdiff(properties, c("name", "title", "description", "resources"))
  toprint <- intersect(attributes, properties)
  if (length(toprint)) {
    tmp <- lapply(toprint, \(property) dpproperty(x, property))
    names(tmp) <- toprint
    cat("\nSelected properties:\n")
    utils::str(tmp, max.level=1, give.attr=FALSE, no.list = TRUE, 
      comp.str="", indent.str="", give.head = FALSE)
  }
}

