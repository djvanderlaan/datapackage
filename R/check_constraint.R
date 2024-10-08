

check_constraint_required <- function(x, fielddescriptor) {
  constraints <- dpproperty.fielddescriptor(fielddescriptor, "constraints")
  name <- fielddescriptor$name
  if (!is.null(constraints) && !is.null(constraints$required) && constraints$required && anyNA(x)) {
    paste0("'", name, "' contains missing values.")
  } else TRUE
}

check_constraint_unique <- function(x, fielddescriptor) {
  constraints <- dpproperty.fielddescriptor(fielddescriptor, "constraints")
  name <- fielddescriptor$name
  if (!is.null(constraints) && !is.null(constraints$unique) && constraints$unique && anyDuplicated(x)) {
    paste0("'", name, "' contains duplicated values.")
  } else TRUE
}


check_constraint_minimum <- function(x, fielddescriptor) {
  constraints <- dpproperty.fielddescriptor(fielddescriptor, "constraints")
  name <- fielddescriptor$name
  if (!is.null(constraints) && !is.null(constraints$minimum)) {
    minimum <- constraints$minimum
    if (!is.numeric(minimum) || length(minimum) != 1 || is.na(minimum)) {
      paste0("Constraint minimum for '", name, "' is not a numeric of length  1.")
    } else if (!all(x >= minimum, na.rm = TRUE)) {
      paste0("'", name, "' contains values smaller than minimum.")
    } else TRUE
  } else TRUE
}

check_constraint_maximum <- function(x, fielddescriptor) {
  constraints <- dpproperty.fielddescriptor(fielddescriptor, "constraints")
  name <- fielddescriptor$name
  if (!is.null(constraints) && !is.null(constraints$maximum)) {
    maximum <- constraints$maximum
    if (!is.numeric(maximum) || length(maximum) != 1 || is.na(maximum)) {
      paste0("Constraint maximum for '", name, "' is not a numeric of length  1.")
    } else if (!all(x <= maximum, na.rm = TRUE)) {
      paste0("'", name, "' contains values larger than maximum.")
    } else TRUE
  } else TRUE
}

check_constraint_exclusiveminimum <- function(x, fielddescriptor) {
  constraints <- dpproperty.fielddescriptor(fielddescriptor, "constraints")
  name <- fielddescriptor$name
  if (!is.null(constraints) && !is.null(constraints$exclusiveMinimum)) {
    minimum <- constraints$exclusiveMinimum
    if (!is.numeric(minimum) || length(minimum) != 1 || is.na(minimum)) {
      paste0("Constraint exclusiveMinimum for '", name, "' is not a numeric of length  1.")
    } else if (!all(x > minimum, na.rm = TRUE)) {
      paste0("'", name, "' contains values smaller than exclusiveMinimum.")
    } else TRUE
  } else TRUE
}

check_constraint_exclusivemaximum <- function(x, fielddescriptor) {
  constraints <- dpproperty.fielddescriptor(fielddescriptor, "constraints")
  name <- fielddescriptor$name
  if (!is.null(constraints) && !is.null(constraints$exclusiveMaximum)) {
    maximum <- constraints$exclusiveMaximum
    if (!is.numeric(maximum) || length(maximum) != 1 || is.na(maximum)) {
      paste0("Constraint exclusiveMaximum for '", name, "' is not a numeric of length  1.")
    } else if (!all(x < maximum, na.rm = TRUE)) {
      paste0("'", name, "' contains values larger than exclusiveMaximum.")
    } else TRUE
  } else TRUE
}

check_constraint_enum <- function(x, fielddescriptor) {
  constraints <- dpproperty.fielddescriptor(fielddescriptor, "constraints")
  name <- fielddescriptor$name
  if (!is.null(constraints) && !is.null(constraints$enum)) {
    enum <- constraints$enum
    if (any(is.na(match(x, enum)) & !is.na(x))) {
    #if (!all(x %in% enum)) {
      paste0("'", name, "' contains values not specified in the enum constraint.")
    } else TRUE
  } else TRUE
}

