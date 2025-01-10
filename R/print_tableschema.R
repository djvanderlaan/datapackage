

#' @export
print.tableschema <- function(x, properties = NA, ...) {
  if (length(properties) == 1 && is.na(properties)) properties <- dp_properties(x)
  toprint <- intersect(names(x), properties)
  toprint <- x[toprint]
  if (length(toprint)) {
    if (!missing(properties)) {
      cat("\nSelected properties:\n") 
    } else {
      cat("\nProperties:\n") 
    }
    utils::str(toprint, max.level=1, give.attr=FALSE, no.list = TRUE, 
      comp.str="", indent.str="", give.head = FALSE)
  }
}

