#' @export 
print.fielddescriptor <- function(x, ...) {
  cat("Field Descriptor:\n")
  utils::str(x, max.level=1, give.attr=FALSE, no.list = TRUE, 
    comp.str="", indent.str="", give.head = FALSE)
}

