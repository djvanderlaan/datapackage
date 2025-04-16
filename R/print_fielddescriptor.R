#' @export 
print.fielddescriptor <- function(x, properties = NA, tiny = FALSE, ...) {
  if (tiny) {
    printdescription(x, description = FALSE)
  } else {
    printdescription(x)
    print_categories(x)
    attributes <- dp_properties(x)
    if (length(properties) == 1 && is.na(properties)) properties <- attributes
    properties  <- setdiff(properties, c("name", "title", "description", 
        "type", "categories"))
    toprint <- intersect(attributes, properties)
    if (length(toprint)) {
      tmp <- lapply(toprint, \(property) dp_property(x, property))
      names(tmp) <- toprint
      cat("\n", c2("Selected properties"), ":\n", sep = "")
      utils::str(tmp, max.level=1, give.attr=FALSE, no.list = TRUE, 
        comp.str="", indent.str="", give.head = FALSE)
    }
  }
}


print_categories <- function(x) {
  if (!is.null(categories <- dp_categorieslist(x))) {
    cat("\n", c2("Categories"), ":\n", sep = "")
    cols <- c("code", "label")
    if (nrow(categories) > 17) {
      categories <- format(categories[seq_len(16), cols, drop = FALSE])
      categories <- rbind(categories, c("\u22ee", "\u22ee"))
    }
    print.data.frame(categories[, cols, drop = FALSE], row.names = FALSE)
  }
  invisible(NULL)
}

