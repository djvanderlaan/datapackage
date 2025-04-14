
getfirstparagraph <- function(x, dots = FALSE) {
  stopifnot(isstring(x))
  x <- strsplit(x, split = "\n", fixed = TRUE)[[1]]
  empty_lines <-grep("^[[:blank:]]*$", x)
  first_empty_line <- utils::head(empty_lines[empty_lines > 1], 1)
  if (length(first_empty_line) && first_empty_line > 1) {
    x <- x[seq(1, first_empty_line-1)]
    if (dots) x <- c(x, "[...]")
  }
  paste0(x, collapse = " ")
}


