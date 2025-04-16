
printdescription <- function(x, description = TRUE, all = FALSE, ...) {
  name <- dp_name(x)
  if (!is.null(name)) {
    cat("[", c1(bd(name)), "] ", sep = "")
  } else {
    cat("<NAME MISSING> ", sep = "")
  }
  if (methods::is(x, "fielddescriptor")) {
    type <- dp_type(x)
    categories <- if (!is.null(dp_categorieslist(x))) 
      c2("/categories") else ""
    if (!is.null(type)) {
      cat("<", c2(type), categories, "> ", sep = "")
    } else {
      cat("<", c2("TYPE MISSING"), "> ", sep = "")
    }
  }
  title <- dp_title(x)
  if (!is.null(title)) cat(ul(title), "\n", sep = "") else cat("\n")
  descr <- dp_description(x, first_paragraph = TRUE, dots = TRUE)
  if (description && !is.null(descr)) {
    cat("\n", sep = "")
    cat(descr, "\n", sep="")
  }
}
