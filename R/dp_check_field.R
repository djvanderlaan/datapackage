
#' Check if a vector is valid given a field descriptor
#'
#' @param x vector to test
#' @param fielddescriptor field descriptor to test the vector against
#' @param constraints also check relevant constraints in the field descriptor. 
#' @param tolerance numerical tolerance used in some of the tests
#'
#' @return
#' Returns \code{TRUE} when the field is valid. Returns a character vector with
#' length >= 1 if the field is not valid. The text in the character values 
#' indicates why the field is not valid.
#'
#' @seealso
#' Use \code{\link{isTRUE}} to check if the test was successful. 
#' See \code{\link{dp_check_dataresource}} for a function that checks a complete data set.
#'
#' @export
dp_check_field <- function(x, fielddescriptor, constraints = TRUE, tolerance = sqrt(.Machine$double.eps))  {
  type <- dp_property.fielddescriptor(fielddescriptor, "type")
  name <- dp_property.fielddescriptor(fielddescriptor, "name")
  if (is.null(type))
    stop("Type missing from fielddescriptor of field '", name, "'.")
  if (type == "boolean") {
    check_boolean(x, fielddescriptor, constraints)
  } else if (type == "date") {
    check_date(x, fielddescriptor, constraints)
  } else if (type == "integer") {
    check_integer(x, fielddescriptor, constraints, tolerance = tolerance)
  } else if (type == "number") {
    check_number(x, fielddescriptor, constraints)
  } else if (type == "string") {
    check_string(x, fielddescriptor, constraints)
  } else if (type == "datetime") {
    check_datetime(x, fielddescriptor, constraints)
  } else if (type == "year") {
    check_year(x, fielddescriptor, constraints, tolerance = tolerance)
  } else {
    warning("Field '", name, "' has a type that cannot be checked.")
    TRUE
  }
}


check_integer <- function(x, fielddescriptor, constraints = TRUE, tolerance = sqrt(.Machine$double.eps))  {
  has_categories <- !is.null(dp_property.fielddescriptor(fielddescriptor, "categories") )
  name <- fielddescriptor$name
  if (!is.null(dp_property.fielddescriptor(fielddescriptor, "type")) && 
      dp_property.fielddescriptor(fielddescriptor, "type") != "integer") {
    return(paste0("Invalid type in fielddescriptor for field '", name, "'."))
  }
  # Convert factor back to integer for further tests
  if (is.factor(x) && has_categories) {
    categorieslist <- dp_categorieslist.fielddescriptor(fielddescriptor)
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
  if (constraints) {
    res <- list(
      check_constraint_unique(x, fielddescriptor),
      check_constraint_required(x, fielddescriptor),
      check_constraint_minimum(x, fielddescriptor),
      check_constraint_maximum(x, fielddescriptor),
      check_constraint_exclusiveminimum(x, fielddescriptor),
      check_constraint_exclusivemaximum(x, fielddescriptor),
      check_constraint_enum(x, fielddescriptor)
    )
    fail <- sapply(res, \(x) !isTRUE(x)) 
    if (any(fail)) return(unlist(res[fail]))
  }
  TRUE
}

check_number <- function(x, fielddescriptor, constraints = TRUE)  {
  name <- fielddescriptor$name
  if (!is.null(dp_property.fielddescriptor(fielddescriptor, "type")) && 
      dp_property.fielddescriptor(fielddescriptor, "type") != "number") {
    return(paste0("Invalid type in fielddescriptor for field '", name, "'."))
  }
  # We expect numeric
  is_numeric <- is.numeric(x)
  # handle the case of all NA; which by default gets converted to logical by R
  all_na <- is.logical(x) && all(is.na(x))
  # check if x correct type
  if (!is_numeric && !all_na) 
    return(paste0("field '", name, "' is of wrong type."))
  if (constraints) {
    res <- list(
      check_constraint_unique(x, fielddescriptor),
      check_constraint_required(x, fielddescriptor),
      check_constraint_minimum(x, fielddescriptor),
      check_constraint_maximum(x, fielddescriptor),
      check_constraint_exclusiveminimum(x, fielddescriptor),
      check_constraint_exclusivemaximum(x, fielddescriptor),
      check_constraint_enum(x, fielddescriptor)
    )
    fail <- sapply(res, \(x) !isTRUE(x)) 
    if (any(fail)) return(unlist(res[fail]))
  }
  TRUE
}

check_string <- function(x, fielddescriptor, constraints = TRUE)  {
  has_categories <- !is.null(dp_property.fielddescriptor(fielddescriptor, "categories") )
  name <- fielddescriptor$name
  if (!is.null(dp_property.fielddescriptor(fielddescriptor, "type")) && 
      dp_property.fielddescriptor(fielddescriptor, "type") != "string") {
    return(paste0("Invalid type in fielddescriptor for field '", name, "'."))
  }
  # Convert factor back to integer for further tests
  if (is.factor(x) && has_categories) {
    categorieslist <- dp_categorieslist.fielddescriptor(fielddescriptor)
    if (is.null(categorieslist)) 
      return(paste0("categories of '", name, "' not found."))
    # TODO: get correct column using labelColumn
    if (length(intersect(levels(x), categorieslist$label)) != nlevels(x))
      return(paste0("Levels of '", name, "' do not match categorieslist."))
    x <- categorieslist$value[match(x, categorieslist$label)]
  }
  # We expect numeric
  is_character <- is.character(x)
  # handle the case of all NA; which by default gets converted to logical by R
  all_na <- is.logical(x) && all(is.na(x))
  # check if x correct type
  if (!is_character && !all_na) 
    return(paste0("field '", name, "' is of wrong type."))
  if (constraints) {
    res <- list(
      check_constraint_unique(x, fielddescriptor),
      check_constraint_required(x, fielddescriptor),
      check_constraint_enum(x, fielddescriptor)
    )
    fail <- sapply(res, \(x) !isTRUE(x)) 
    if (any(fail)) return(unlist(res[fail]))
  }
  TRUE
}

check_boolean <- function(x, fielddescriptor, constraints = TRUE)  {
  name <- fielddescriptor$name
  if (!is.null(dp_property.fielddescriptor(fielddescriptor, "type")) && 
      dp_property.fielddescriptor(fielddescriptor, "type") != "boolean") {
    return(paste0("Invalid type in fielddescriptor for field '", name, "'."))
  }
  # check if x correct type
  if (!is.logical(x))
    return(paste0("field '", name, "' is of wrong type."))
  if (constraints) {
    res <- list(
      check_constraint_unique(x, fielddescriptor),
      check_constraint_required(x, fielddescriptor),
      check_constraint_enum(x, fielddescriptor)
    )
    fail <- sapply(res, \(x) !isTRUE(x)) 
    if (any(fail)) return(unlist(res[fail]))
  }
  TRUE
}

check_date <- function(x, fielddescriptor, constraints = TRUE)  {
  name <- fielddescriptor$name
  if (!is.null(dp_property.fielddescriptor(fielddescriptor, "type")) && 
      dp_property.fielddescriptor(fielddescriptor, "type") != "date") {
    return(paste0("Invalid type in fielddescriptor for field '", name, "'."))
  }
  # We expect Date
  is_date <- methods::is(x, "Date") || methods::is(x, "POSIXt")
  # handle the case of all NA; which by default gets converted to logical by R
  all_na <- is.logical(x) && all(is.na(x))
  # check if x correct type
  if (!is_date && !all_na) 
    return(paste0("field '", name, "' is of wrong type."))
  if (constraints) {
    # For testing we convert to integer dates; otherwise tests like
    # > might give weird results 
    # d <- as.Date("2024-01-01")
    # (d+0.2) > d # while d+0.2 is the same date as d
    if (methods::is(x, "POSIXt")) x <- as.Date(x) else x <- trunc(x)
    res <- list(
      check_constraint_unique(x, fielddescriptor),
      check_constraint_required(x, fielddescriptor),
      check_constraint_minimum(x, fielddescriptor),
      check_constraint_maximum(x, fielddescriptor),
      check_constraint_exclusiveminimum(x, fielddescriptor),
      check_constraint_exclusivemaximum(x, fielddescriptor),
      check_constraint_enum(x, fielddescriptor)
    )
    fail <- sapply(res, \(x) !isTRUE(x)) 
    if (any(fail)) return(unlist(res[fail]))
  }
  TRUE
}

check_datetime <- function(x, fielddescriptor, constraints = TRUE)  {
  name <- fielddescriptor$name
  if (!is.null(dp_property.fielddescriptor(fielddescriptor, "type")) && 
      dp_property.fielddescriptor(fielddescriptor, "type") != "datetime") {
    return(paste0("Invalid type in fielddescriptor for field '", name, "'."))
  }
  # We expect time
  is_datetime <- methods::is(x, "POSIXt")
  # handle the case of all NA; which by default gets converted to logical by R
  all_na <- is.logical(x) && all(is.na(x))
  # check if x correct type
  if (!is_datetime && !all_na) 
    return(paste0("field '", name, "' is of wrong type."))
  if (constraints) {
    res <- list(
      check_constraint_unique(x, fielddescriptor),
      check_constraint_required(x, fielddescriptor),
      check_constraint_minimum(x, fielddescriptor),
      check_constraint_maximum(x, fielddescriptor),
      check_constraint_exclusiveminimum(x, fielddescriptor),
      check_constraint_exclusivemaximum(x, fielddescriptor),
      check_constraint_enum(x, fielddescriptor)
    )
    fail <- sapply(res, \(x) !isTRUE(x)) 
    if (any(fail)) return(unlist(res[fail]))
  }
  TRUE
}

check_year <- function(x, fielddescriptor, constraints = TRUE, tolerance = sqrt(.Machine$double.eps))  {
  name <- fielddescriptor$name
  if (!is.null(dp_property.fielddescriptor(fielddescriptor, "type")) && 
      dp_property.fielddescriptor(fielddescriptor, "type") != "year") {
    return(paste0("Invalid type in fielddescriptor for field '", name, "'."))
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
  if (constraints) {
    res <- list(
      check_constraint_unique(x, fielddescriptor),
      check_constraint_required(x, fielddescriptor),
      check_constraint_minimum(x, fielddescriptor),
      check_constraint_maximum(x, fielddescriptor),
      check_constraint_exclusiveminimum(x, fielddescriptor),
      check_constraint_exclusivemaximum(x, fielddescriptor),
      check_constraint_enum(x, fielddescriptor)
    )
    fail <- sapply(res, \(x) !isTRUE(x)) 
    if (any(fail)) return(unlist(res[fail]))
  }
  TRUE
}

