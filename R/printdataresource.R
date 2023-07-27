
print.dataresource <- function(x, fields = c("path", "data", "format"), ...) {
  printdescription(x)
  if (length(fields) == 1 && is.na(fields)) fields <- names(x)
  fields  <- setdiff(fields, c("name", "title", "description"))
  toprint <- intersect(names(x), fields)
  toprint <- x[toprint]
  if (length(toprint)) {
    cat("\nSelected properties:\n")
    str(toprint, max.level=1, give.attr=FALSE, no.list = TRUE, 
      comp.str="", indent.str="", give.head = FALSE)
  }
}

