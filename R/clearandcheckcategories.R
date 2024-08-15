
# Convert factor variabels back to original codes (if possible) and check if the values in
# x are valid when x has an associated code list
#
clearandcheckcategories <- function(x, fielddescriptor = attr(x, "fielddescriptor"),
    categorieslist = dpcategorieslist(fielddescriptor)) {
  if (!is.null(categorieslist)) {
    if (is.factor(x)) {
      # when x is a factor; we have to check the levels of the factor and see
      # if we can go back to the original codes
      labels <- as.character(x)
      m <- match(labels, categorieslist[[2]])
      ok <- is.na(labels) | !is.na(m)
      if (!all(ok)) {
        notok <- labels[!ok] |> unique()
        if (length(notok) > 10) notok <- c(utils::head(notok[1:10]), "...")
        stop("Not all levels of x could be matched to labels from the code list: ",
          paste0("'", notok, "'", collapse = ", "))
      }
      x <- categorieslist[[1]][m]
    } else {
      m <- match(x, categorieslist[[1]])
      ok <- is.na(x) | !is.na(m)
      if (!all(ok)) {
        notok <- x[!ok] |> unique()
        if (length(notok) > 10) notok <- c(utils::head(notok[1:10]), "...")
        stop("Not all values of x could be matched to codes from the code list: ",
          paste0("'", notok, "'", collapse = ", "))
      }
      x <- categorieslist[[1]][m]
    }
  }
  attr(x, "fielddescriptor") <- fielddescriptor
  x
}

