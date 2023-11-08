#' @export
str.tableschema <- function(object, ...) {
  fields <- dpfieldnames(object)
  cat("Table Schema [", length(fields), "] ", sep = "")
  utils::str(fields, give.attr = FALSE, comp.str ="", give.head = FALSE)
}
