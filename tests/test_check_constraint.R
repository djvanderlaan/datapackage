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
# REQUIRED

x <- c(1,2,3)
fd <- list(name="foo", type="integer", constraints = list(required = TRUE))
expect_istrue(datapackage:::check_constraint_required(x, fd))

x <- c(1,2,NA, 3)
fd <- list(name="foo", type="integer", constraints = list(required = TRUE))
expect_nistrue(datapackage:::check_constraint_required(x, fd))

x <- c(1,2,NA, 3)
fd <- list(name="foo", type="integer", constraints = list(required = FALSE))
expect_istrue(datapackage:::check_constraint_required(x, fd))

x <- c(1,2,NA, 3)
fd <- list(name="foo", type="integer", constraints = list())
expect_istrue(datapackage:::check_constraint_required(x, fd))

x <- c(1,2,NA, 3)
fd <- list(name="foo", type="integer")
expect_istrue(datapackage:::check_constraint_required(x, fd))

x <- c(NA)
fd <- list(name="foo", type="integer", constraints = list(required = TRUE))
expect_nistrue(datapackage:::check_constraint_required(x, fd))

x <- integer(0)
fd <- list(name="foo", type="integer", constraints = list(required = TRUE))
expect_istrue(datapackage:::check_constraint_required(x, fd))

x <- c(Inf)
fd <- list(name="foo", type="integer", constraints = list(required = TRUE))
expect_istrue(datapackage:::check_constraint_required(x, fd))

x <- c(NaN)
fd <- list(name="foo", type="integer", constraints = list(required = TRUE))
expect_nistrue(datapackage:::check_constraint_required(x, fd))

# =============================================================================
# UNIQUE

x <- c(1,2,NA,3)
fd <- list(name="foo", type="integer", constraints = list(unique = TRUE))
expect_istrue(datapackage:::check_constraint_unique(x, fd))

x <- c(1,2,NA,3,2)
fd <- list(name="foo", type="integer", constraints = list(unique = TRUE))
expect_nistrue(datapackage:::check_constraint_unique(x, fd))

x <- c(1,2,NA,3,2)
fd <- list(name="foo", type="integer", constraints = list(unique = FALSE))
expect_istrue(datapackage:::check_constraint_unique(x, fd))

x <- c(1,2,NA,3,NA)
fd <- list(name="foo", type="integer", constraints = list(unique = TRUE))
expect_nistrue(datapackage:::check_constraint_unique(x, fd))

x <- integer(0)
fd <- list(name="foo", type="integer", constraints = list(unique = TRUE))
expect_istrue(datapackage:::check_constraint_unique(x, fd))

x <- NA
fd <- list(name="foo", type="integer", constraints = list(unique = TRUE))
expect_istrue(datapackage:::check_constraint_unique(x, fd))

x <- NaN
fd <- list(name="foo", type="integer", constraints = list(unique = TRUE))
expect_istrue(datapackage:::check_constraint_unique(x, fd))

x <- Inf
fd <- list(name="foo", type="integer", constraints = list(unique = TRUE))
expect_istrue(datapackage:::check_constraint_unique(x, fd))

x <- c(NaN, NA)
fd <- list(name="foo", type="integer", constraints = list(unique = TRUE))
expect_istrue(datapackage:::check_constraint_unique(x, fd))

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


