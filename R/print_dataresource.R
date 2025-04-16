
#' @export
print.dataresource <- function(x, properties = NA, tiny = FALSE, ...) {
  if (tiny) {
    printdescription(x, description = FALSE)
  } else {
    printdescription(x)
    # Print fields
    if (!is.null(dp_schema(x))) {
      cat("\n", c2("Fields:"), "\n", sep = "")
      for (field in dp_field_names(x)) {
        print(dp_field(x, field), tiny = TRUE)
      }
    }
    # Print other propeties
    if (length(properties) == 1 && is.na(properties)) properties <- dp_properties(x)
    properties  <- setdiff(properties, c("name", "title", "description",
        "schema"))
    toprint <- intersect(names(x), properties)
    toprint <- x[toprint]
    if ("schema" %in% names(toprint)) class(toprint[["schema"]]) <- "tableschema"
    if (length(toprint)) {
      cat("\n", c2("Selected properties"), ":\n", sep = "")
      utils::str(toprint, max.level=1, give.attr=FALSE, no.list = TRUE, 
        comp.str="", indent.str="", give.head = FALSE)
    }
  }
}

