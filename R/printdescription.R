
printdescription <- function(x, description = TRUE, all = FALSE, ...) {
  name <- dpname(x)
  if (!is.null(name)) {
    cat("[", name, "] ", sep = "")
  } else {
    cat("<NAME MISSING> ", sep = "")
  }
  title <- dptitle(x)
  if (!is.null(title)) cat(title, "\n", sep = "")
  descr <- dpdescription(x, firstparagraph = TRUE, dots = TRUE)
  if (description && !is.null(descr)) {
    cat("\n", sep = "")
    cat(descr, "\n", sep="")
  }
}
