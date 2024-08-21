library(datapackage)

source("helpers.R")

# Some additional checks; we have functions returning a character in case of
# an error and TRUE otherwise.
expect_istrue <- function(x, ...) {
  expect_equal( isTRUE(x), TRUE)
}
expect_nistrue <- function(x, ...) {
  expect_equal( isTRUE(x), FALSE)
}


# =============================================================================
# MINIMUM

x <- c(1,3,1,NA)
fd <- list(name="foo", type="integer", constraints = list(minimum = 2))
expect_nistrue(datapackage:::check_constraint_minimum(x, fd))

x <- c(1,3,1,NA)
fd <- list(name="foo", type="integer", constraints = list(minimum = 1))
expect_istrue(datapackage:::check_constraint_minimum(x, fd))

x <- c(1,3,1,NA)
fd <- list(name="foo", type="integer", constraints = list(minimum = NA))
expect_nistrue(datapackage:::check_constraint_minimum(x, fd))

x <- c(1,3,1,NA)
fd <- list(name="foo", type="integer", constraints = list(minimum = 1:3))
expect_nistrue(datapackage:::check_constraint_minimum(x, fd))

x <- c(1,3,1,NA)
fd <- list(name="foo", type="integer")
expect_istrue(datapackage:::check_constraint_minimum(x, fd))

x <- c(NA_integer_, NA_integer_)
fd <- list(name="foo", type="integer")
expect_istrue(datapackage:::check_constraint_minimum(x, fd))

# =============================================================================
# MAXIMUM

x <- c(1,3,1,NA)
fd <- list(name="foo", type="integer", constraints = list(maximum = 2))
expect_nistrue(datapackage:::check_constraint_maximum(x, fd))

x <- c(1,3,1,NA)
fd <- list(name="foo", type="integer", constraints = list(maximum = 3))
expect_istrue(datapackage:::check_constraint_maximum(x, fd))

x <- c(1,3,1,NA)
fd <- list(name="foo", type="integer", constraints = list(maximum = NA))
expect_nistrue(datapackage:::check_constraint_maximum(x, fd))

x <- c(1,3,1,NA)
fd <- list(name="foo", type="integer", constraints = list(maximum = 1:3))
expect_nistrue(datapackage:::check_constraint_maximum(x, fd))

x <- c(1,3,1,NA)
fd <- list(name="foo", type="integer")
expect_istrue(datapackage:::check_constraint_maximum(x, fd))

x <- c(NA_integer_, NA_integer_)
fd <- list(name="foo", type="integer")
expect_istrue(datapackage:::check_constraint_maximum(x, fd))

# =============================================================================
# EXCLUSIVEMINIMUM

x <- c(1,3,1,NA)
fd <- list(name="foo", type="integer", constraints = list(exclusiveMinimum = 2))
expect_nistrue(datapackage:::check_constraint_exclusiveminimum(x, fd))

x <- c(1,3,1,NA)
fd <- list(name="foo", type="integer", constraints = list(exclusiveMinimum = 1))
expect_nistrue(datapackage:::check_constraint_exclusiveminimum(x, fd))

x <- c(1,3,1,NA)
fd <- list(name="foo", type="integer", constraints = list(exclusiveMinimum = 0))
expect_istrue(datapackage:::check_constraint_exclusiveminimum(x, fd))

x <- c(1,3,1,NA)
fd <- list(name="foo", type="integer", constraints = list(exclusiveMinimum = NA))
expect_nistrue(datapackage:::check_constraint_exclusiveminimum(x, fd))

x <- c(1,3,1,NA)
fd <- list(name="foo", type="integer", constraints = list(exclusiveMinimum = 1:3))
expect_nistrue(datapackage:::check_constraint_exclusiveminimum(x, fd))

x <- c(1,3,1,NA)
fd <- list(name="foo", type="integer")
expect_istrue(datapackage:::check_constraint_exclusiveminimum(x, fd))

x <- c(NA_integer_, NA_integer_)
fd <- list(name="foo", type="integer")
expect_istrue(datapackage:::check_constraint_exclusiveminimum(x, fd))

# =============================================================================
# EXCLUSIVEMAXIMIM

x <- c(1,3,1,NA)
fd <- list(name="foo", type="integer", constraints = list(exclusiveMaximum = 2))
expect_nistrue(datapackage:::check_constraint_exclusivemaximum(x, fd))

x <- c(1,3,1,NA)
fd <- list(name="foo", type="integer", constraints = list(exclusiveMaximum = 3))
expect_nistrue(datapackage:::check_constraint_exclusivemaximum(x, fd))

x <- c(1,3,1,NA)
fd <- list(name="foo", type="integer", constraints = list(exclusiveMaximum = 4))
expect_istrue(datapackage:::check_constraint_exclusivemaximum(x, fd))

x <- c(1,3,1,NA)
fd <- list(name="foo", type="integer", constraints = list(exclusiveMaximum = NA))
expect_nistrue(datapackage:::check_constraint_exclusivemaximum(x, fd))

x <- c(1,3,1,NA)
fd <- list(name="foo", type="integer", constraints = list(exclusiveMaximum = 1:3))
expect_nistrue(datapackage:::check_constraint_exclusivemaximum(x, fd))

x <- c(1,3,1,NA)
fd <- list(name="foo", type="integer")
expect_istrue(datapackage:::check_constraint_exclusivemaximum(x, fd))

x <- c(NA_integer_, NA_integer_)
fd <- list(name="foo", type="integer")
expect_istrue(datapackage:::check_constraint_exclusivemaximum(x, fd))

