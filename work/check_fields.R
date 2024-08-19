library(datapackage)






check_integer <- function(x, fielddescriptor, tolerance = sqrt(.Machine$double.eps))  {
  # We expect numeric
  is_numeric <- is.numeric(x)
  # handle the case of all NA; which by default gets converted to logical by R
  all_na <- is.logical(x) && all(is.na(x))
  # check if x correct type
  if (!is_numeric && !all_na) 
    return(paste0("field '", fielddescriptor$name, "' is of wrong type."))
  if (is_numeric && !is.integer(x) && any( abs(x - round(x)) > tolerance) )
    return(paste0("field '", fielddescriptor$name, "' has non integer values."))
  TRUE
}

fd <- list(name = "foo", type = "integer")
check_integer(c(1,3,2,NA), fd)
check_integer(NA, fd)
check_integer(integer(0), fd)
check_integer(1.3, fd)
check_integer(0.7, fd)
check_integer(1.3, fd, tolerance = 0.31)
check_integer(0.7, fd, tolerance = 0.31)
check_integer("3", fd)
check_integer(logical(0), fd)
check_integer(TRUE, fd)


