
print.datapackage <- function(x, fields = character(0), ...) {
  printdescription(x)
  cat("\nLocation: <", attr(x, "path"), ">", sep="")
  if (nresources(x) > 0) {
    cat("\nResources:\n")
    resources <- resourcenames(x)
    for (resource in resources) {
      printdescription(getresource(x, resource), description = FALSE)
    }
  } else {
    cat("<NO RESOURCES>\n")
  }
  attributes <- dpattributes(x)
  if (length(fields) == 1 && is.na(fields)) fields <- attributes
  fields  <- setdiff(fields, c("name", "title", "description", "resources"))
  toprint <- intersect(attributes, fields)
  if (length(toprint)) {
    cat("\nSelected properties:\n")
    str(dpattr(x, toprint), max.level=1, give.attr=FALSE, no.list = TRUE, 
      comp.str="", indent.str="", give.head = FALSE)
  }
}

