
getfirstparagraph <- function(x) {
  x <- dp$description
  x <- strsplit(x, split = "\n", fixed = TRUE)[[1]]
  first_empty_line <- head(grep("^[[:blank:]]*$", x), 1)
  if (length(first_empty_line) && first_empty_line > 1) {
    x <- x[seq(1, first_empty_line-1)]
  }
  x
}


