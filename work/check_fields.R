library(datapackage)

check_integer <- function(x, fielddescriptor, tolerance = sqrt(.Machine$double.eps))  {
  has_categories <- !is.null(datapackage:::dpproperty.fielddescriptor(fielddescriptor, "categories") )
  name <- fielddescriptor$name
  # Convert factor back to integer for further tests
  if (is.factor(x) && has_categories) {
    categorieslist <- dpcategorieslist(fielddescriptor)
    if (is.null(categorieslist)) 
      return(paste0("categories of '", name, "' not found."))
    # TODO: get correct column using labelColumn
    if (length(intersect(levels(x), categorieslist$label)) != nlevels(x))
      return(paste0("Levels of '", name, "' do not match categorieslist."))
    x <- categorieslist$value[match(x, categorieslist$label)]
  }
  # We expect numeric
  is_numeric <- is.numeric(x)
  # handle the case of all NA; which by default gets converted to logical by R
  all_na <- is.logical(x) && all(is.na(x))
  # check if x correct type
  if (!is_numeric && !all_na) 
    return(paste0("field '", name, "' is of wrong type."))
  if (is_numeric && !is.integer(x) && any( abs(x - round(x)) > tolerance, na.rm = TRUE) )
    return(paste0("field '", name, "' has non integer values."))
  TRUE
}

check_constraint_required <- function(x, fielddescriptor) {
  constraints <- datapackage:::dpproperty.fielddescriptor(fielddescriptor, "constraints"))
  if (!is.null(constraints)) {
  }
  TRUE
}

check_constraint_minimum <- function(x, fielddescriptor) {
}

check_constraint_maximum <- function(x, fielddescriptor) {
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

fx <- factor(c(2,1,NA), levels=1:2, labels=c("a","b"))
cat <- list(list(value = 1, label = "a"), list(value = 2, label = "b"))
fd <- list(name="foo", type="integer", categories = cat)
check_integer(fx, fd)
fx2 <- factor(c(2,1,NA), levels=1:2, labels=c("c","b"))
check_integer(fx2, fd)
cat2 <- list(list(value = "1", label = "a"), list(value = "2", label = "b"))
fd2 <- list(name="foo", type="integer", categories = cat2)
check_integer(fx, fd2)
fx2 <- factor(c(NA_integer_), levels=1:2, labels=c("a","b"))
check_integer(fx2, fd)
fd2 <- list(name="foo", type="integer")
check_integer(fx, fd2)


