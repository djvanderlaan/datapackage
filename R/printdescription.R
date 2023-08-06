
printdescription <- function(x, description = TRUE, all = FALSE, ...) {
  name <- name(x)
  if (!is.null(name)) {
    cat("[", name, "] ", sep = "")
  } else {
    cat("<NAME MISSING> ", sep = "")
  }
  title <- title(x)
  if (!is.null(title)) cat(title, "\n", sep = "") else cat("\n")
  descr <- description(x, firstparagraph = TRUE, dots = TRUE)
  if (description && !is.null(descr)) {
    cat("\n", sep = "")
    cat(descr, "\n", sep="")
  }
}
