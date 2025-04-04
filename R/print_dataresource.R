
#' @export
print.dataresource <- function(x, properties = NA, ...) {
  printdescription(x)
  if (length(properties) == 1 && is.na(properties)) properties <- dp_properties(x)
  properties  <- setdiff(properties, c("name", "title", "description"))
  toprint <- intersect(names(x), properties)
  toprint <- x[toprint]
  if ("schema" %in% names(toprint)) class(toprint[["schema"]]) <- "tableschema"
  if (length(toprint)) {
    cat("\nSelected properties:\n")
    utils::str(toprint, max.level=1, give.attr=FALSE, no.list = TRUE, 
      comp.str="", indent.str="", give.head = FALSE)
  }
}

