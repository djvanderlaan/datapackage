
print.datapackage <- function(x, fields = character(0), ...) {
  printdescription(x)
  cat("\nLocation: <", attr(x, "path"), ">", sep="")
  if (nresources(x) > 0) {
    cat("\nResources:\n")
    for (i in seq_along(dp$resources)) {
      printdescription(dp$resources[[i]], description = FALSE)
    }
  } else {
    cat("<NO RESOURCES>\n")
  }
  if (length(fields) == 1 && is.na(fields)) fields <- names(x)
  fields  <- setdiff(fields, c("name", "title", "description", "resources"))
  toprint <- intersect(names(x), fields)
  toprint <- x[toprint]
  if (length(toprint)) {
    cat("\nSelected properties:\n")
    str(toprint, max.level=1, give.attr=FALSE, no.list = TRUE, 
      comp.str="", indent.str="", give.head = FALSE)
  }
}

