#' @export
str.tableschema <- function(object, ...) {
  fields <- dpfieldnames(object)
  cat("Table Schema [", length(fields), "] ", sep = "")
  str(fields, give.attr = FALSE, comp.str ="", give.head = FALSE)
}
