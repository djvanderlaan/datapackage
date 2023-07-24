
printdescription <- function(x, description = TRUE, all = FALSE, ...) {
  if (exists("name", x)) {
    cat("[", x$name, "] ", sep = "")
  } else {
    cat("<NAME MISSING> ", sep = "")
  }
  if (exists("title", x)) cat(x$title, "\n", sep = "")
  if (description && exists("description", x)) {
    cat("\n", sep = "")
    cat(getfirstparagraph(x$description), "\n", sep="")
  }
}
