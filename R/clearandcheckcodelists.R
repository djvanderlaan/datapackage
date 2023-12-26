
# Convert factor variabels back to original codes (if possible) and check if the values in
# x are valid when x has an associated code list
#
clearandcheckcodelists <- function(x, fielddescriptor = attr(x, "fielddescriptor"),
    codelist = dpcodelist(fielddescriptor)) {
  if (!is.null(codelist)) {
    if (is.factor(x)) {
      # when x is a factor; we have to check the levels of the factor and see
      # if we can go back to the original codes
      labels <- as.character(x)
      m <- match(labels, codelist[[2]])
      ok <- is.na(labels) | !is.na(m)
      if (!all(ok)) {
        notok <- labels[!ok] |> unique()
        if (length(notok) > 10) notok <- c(head(notok[1:10]), "...")
        stop("Not all levels of x could be matched to labels from the code list: ",
          paste0("'", notok, "'", collapse = ", "))
      }
      x <- codelist[[1]][m]
    } else {
      m <- match(x, codelist[[1]])
      ok <- is.na(x) | !is.na(m)
      if (!all(ok)) {
        notok <- x[!ok] |> unique()
        if (length(notok) > 10) notok <- c(head(notok[1:10]), "...")
        stop("Not all values of x could be matched to codes from the code list: ",
          paste0("'", notok, "'", collapse = ", "))
      }
      x <- codelist[[1]][m]
    }
  }
  attr(x, "fielddescriptor") <- fielddescriptor
  x
}

