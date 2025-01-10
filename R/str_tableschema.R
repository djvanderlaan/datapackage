#' @export
str.tableschema <- function(object, ...) {
  fields <- dp_field_names(object)
  cat("Table Schema [", length(fields), "] ", sep = "")
  utils::str(fields, give.attr = FALSE, comp.str ="", give.head = FALSE)
}
