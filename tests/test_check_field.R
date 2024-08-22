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
# INTEGER: Basic without constraints
fd <- list(name = "foo", type = "integer")
expect_istrue( check_integer(c(1,3,2,NA), fd))
expect_istrue( check_integer(NA, fd))
expect_istrue( check_integer(integer(0), fd))
expect_nistrue(check_integer(1.3, fd))
expect_nistrue(check_integer(0.7, fd))
expect_istrue( check_integer(1.3, fd, tolerance = 0.31))
expect_istrue( check_integer(0.7, fd, tolerance = 0.31))
expect_nistrue(check_integer("3", fd))
expect_istrue( check_integer(logical(0), fd))
expect_nistrue(check_integer(TRUE, fd))

# Check for correct type in fielddescriptor
fd <- list(name = "foo", type = "number")
expect_nistrue(check_integer(1:3, fd))

# INTEGER: Factor and categories
fx <- factor(c(2,1,NA), levels=1:2, labels=c("a","b"))
cat <- list(list(value = 1, label = "a"), list(value = 2, label = "b"))
fd <- list(name="foo", type="integer", categories = cat)
expect_istrue(check_integer(fx, fd))

fx2 <- factor(c(2,1,NA), levels=1:2, labels=c("c","b"))
expect_nistrue(check_integer(fx2, fd))

cat2 <- list(list(value = "1", label = "a"), list(value = "2", label = "b"))
fd2 <- list(name="foo", type="integer", categories = cat2)
expect_nistrue(check_integer(fx2, fd2))

fx2 <- factor(c(NA_integer_), levels=1:2, labels=c("a","b"))
expect_istrue(check_integer(fx2, fd))

fd2 <- list(name="foo", type="integer")
expect_nistrue(check_integer(fx, fd2))

# INTEGER: Constraints
x <- c(1,3,1,NA)
fd <- list(name="foo", type="integer", constraints = list(minimum = 2))
expect_nistrue(check_integer(x, fd))
expect_istrue(check_integer(x, fd, constraints = FALSE))

x <- c(1,3,1,NA)
fd <- list(name="foo", type="integer", constraints = list(maximum = 2))
expect_nistrue(check_integer(x, fd))
expect_istrue(check_integer(x, fd, constraints = FALSE))

x <- c(1,NA,3,1,NA)
fd <- list(name="foo", type="integer", constraints = list(unique = TRUE))
expect_nistrue(check_integer(x, fd))
expect_istrue(check_integer(x, fd, constraints = FALSE))

x <- c(1,NA,3,1,NA)
fd <- list(name="foo", type="integer", constraints = list(required = TRUE))
expect_nistrue(check_integer(x, fd))
expect_istrue(check_integer(x, fd, constraints = FALSE))

x <- c(1,NA,3,1,NA)
fd <- list(name="foo", type="integer", constraints = list(exclusiveMaximum = 3))
expect_nistrue(check_integer(x, fd))
expect_istrue(check_integer(x, fd, constraints = FALSE))

x <- c(1,NA,3,1,NA)
fd <- list(name="foo", type="integer", constraints = list(exclusiveMinimum = 1))
expect_nistrue(check_integer(x, fd))
expect_istrue(check_integer(x, fd, constraints = FALSE))

x <- c(1,NA,3,1,NA)
fd <- list(name="foo", type="integer", constraints = list(enum = c(2,3)))
expect_nistrue(check_integer(x, fd))
expect_istrue(check_integer(x, fd, constraints = FALSE))

x <- c(1,3,1,NA)
fd <- list(name="foo", type="integer", constraints = list(minimum = 2, maximum = 2))
y <- check_integer(x, fd)
expect_equal(is.character(y), TRUE)
expect_equal(length(y), 2)



# =============================================================================
# NUMBER: Basic without constraints
fd <- list(name = "foo", type = "number")
expect_istrue( check_number(c(1,3,2,NA), fd))
expect_istrue( check_number(NA, fd))
expect_istrue( check_number(numeric(0), fd))
expect_istrue(check_number(1.3, fd))
expect_istrue(check_number(0.7, fd))
expect_nistrue(check_number("3", fd))
expect_istrue( check_number(logical(0), fd))
expect_nistrue(check_number(TRUE, fd))

# Check for correct type in fielddescriptor
fd <- list(name = "foo", type = "integer")
expect_nistrue(check_number(1:3, fd))

# NUMBER: Constraints
x <- c(1,3,1,NA)
fd <- list(name="foo", type="number", constraints = list(minimum = 2))
expect_nistrue(check_number(x, fd))
expect_istrue(check_number(x, fd, constraints = FALSE))

x <- c(1,3,1,NA)
fd <- list(name="foo", type="number", constraints = list(maximum = 2))
expect_nistrue(check_number(x, fd))
expect_istrue(check_number(x, fd, constraints = FALSE))

x <- c(1,NA,3,1,NA)
fd <- list(name="foo", type="number", constraints = list(unique = TRUE))
expect_nistrue(check_number(x, fd))
expect_istrue(check_number(x, fd, constraints = FALSE))

x <- c(1,NA,3,1,NA)
fd <- list(name="foo", type="number", constraints = list(required = TRUE))
expect_nistrue(check_number(x, fd))
expect_istrue(check_number(x, fd, constraints = FALSE))

x <- c(1,NA,3,1,NA)
fd <- list(name="foo", type="number", constraints = list(exclusiveMaximum = 3))
expect_nistrue(check_number(x, fd))
expect_istrue(check_number(x, fd, constraints = FALSE))

x <- c(1,NA,3,1,NA)
fd <- list(name="foo", type="number", constraints = list(exclusiveMinimum = 1))
expect_nistrue(check_number(x, fd))
expect_istrue(check_number(x, fd, constraints = FALSE))

x <- c(1,NA,3,1,NA)
fd <- list(name="foo", type="number", constraints = list(enum = c(2,3)))
expect_nistrue(check_number(x, fd))
expect_istrue(check_number(x, fd, constraints = FALSE))

x <- c(1,3,1,NA)
fd <- list(name="foo", type="number", constraints = list(minimum = 2, maximum = 2))
y <- check_number(x, fd)
expect_equal(is.character(y), TRUE)
expect_equal(length(y), 2)


# =============================================================================
# STRING: Basic without constraints
fd <- list(name = "foo", type = "string")
expect_istrue( check_string(c("a", "c", "b", NA), fd))
expect_istrue( check_string(NA, fd))
expect_istrue( check_string(character(0), fd))
expect_istrue( check_string(logical(0), fd))
expect_nistrue(check_string(TRUE, fd))

# Check for correct type in fielddescriptor
fd <- list(name = "foo", type = "number")
expect_nistrue(check_string(c("a", "c", "b", NA), fd))

# STRING: Constraints
x <- c("a",NA,"c","a",NA)
fd <- list(name="foo", type="string", constraints = list(unique = TRUE))
expect_nistrue(check_string(x, fd))
expect_istrue(check_string(x, fd, constraints = FALSE))

x <- c("a",NA,"c","a",NA)
fd <- list(name="foo", type="string", constraints = list(required = TRUE))
expect_nistrue(check_string(x, fd))
expect_istrue(check_string(x, fd, constraints = FALSE))

x <- c("a",NA,"c","a",NA)
fd <- list(name="foo", type="string", constraints = list(enum = c("b", "c")))
expect_nistrue(check_string(x, fd))
expect_istrue(check_string(x, fd, constraints = FALSE))

x <- c("a",NA,"c","a",NA)
fd <- list(name="foo", type="string", constraints = list(unique = TRUE, enum = c("b", "c")))
y <- check_string(x, fd)
expect_equal(is.character(y), TRUE)
expect_equal(length(y), 2)


# =============================================================================
# BOOLEAN: Basic without constraints
fd <- list(name = "foo", type = "boolean")
expect_istrue( check_boolean(c(TRUE, FALSE, FALSE, NA), fd))
expect_istrue( check_boolean(NA, fd))
expect_istrue( check_boolean(logical(0), fd))
expect_nistrue(check_boolean(c(1, 0, 0), fd))

# Check for correct type in fielddescriptor
fd <- list(name = "foo", type = "number")
expect_nistrue(check_boolean(c("a", "c", "b", NA), fd))

# BOOLEAN: Constraints
x <- c(TRUE, NA, FALSE, TRUE, NA)
fd <- list(name="foo", type="boolean", constraints = list(unique = TRUE))
expect_nistrue(check_boolean(x, fd))
expect_istrue(check_boolean(x, fd, constraints = FALSE))

x <- c(TRUE, NA, FALSE, TRUE, NA)
fd <- list(name="foo", type="boolean", constraints = list(required = TRUE))
expect_nistrue(check_boolean(x, fd))
expect_istrue(check_boolean(x, fd, constraints = FALSE))

x <- c(TRUE, NA, FALSE, TRUE, NA)
fd <- list(name="foo", type="boolean", constraints = list(enum = c("b", "c")))
expect_nistrue(check_boolean(x, fd))
expect_istrue(check_boolean(x, fd, constraints = FALSE))

x <- c(TRUE, NA, FALSE, TRUE, NA)
fd <- list(name="foo", type="boolean", constraints = list(unique = TRUE, enum = c("b", "c")))
y <- check_boolean(x, fd)
expect_equal(is.character(y), TRUE)
expect_equal(length(y), 2)

# =============================================================================
# DATE: Basic without constraints
fd <- list(name = "foo", type = "date")
expect_istrue( check_date(as.Date("2024-01-01", "2024-03-01", "2024-02-01", NA), fd))
expect_istrue( check_date(NA, fd))
expect_istrue( check_date(as.Date(character(0)), fd))
expect_istrue(check_date(as.POSIXct("2024-01-01 16:45"), fd))
expect_istrue(check_date(as.POSIXlt("2024-01-01 16:45"), fd))
expect_nistrue(check_date("3", fd))
expect_istrue( check_date(logical(0), fd))
expect_nistrue(check_date(TRUE, fd))

# Check for correct type in fielddescriptor
fd <- list(name = "foo", type = "integer")
expect_nistrue(check_date(1:3, fd))

# DATE: Constraints
x <- as.Date(c("2024-01-02","2024-03-23","2024-01-02",NA))
fd <- list(name="foo", type="date", constraints = list(minimum = as.Date("2024-01-04")))
expect_nistrue(check_date(x, fd))
expect_istrue(check_date(x, fd, constraints = FALSE))

x <- as.Date(c("2024-01-02","2024-03-23","2024-01-02",NA))
fd <- list(name="foo", type="date", constraints = list(maximum = as.Date("2024-01-02")))
expect_nistrue(check_date(x, fd))
expect_istrue(check_date(x, fd, constraints = FALSE))

x <- as.Date(c("2024-01-02","2024-03-23","2024-01-02",NA))
fd <- list(name="foo", type="date", constraints = list(unique = TRUE))
expect_nistrue(check_date(x, fd))
expect_istrue(check_date(x, fd, constraints = FALSE))

x <- as.Date(c("2024-01-02","2024-03-23","2024-01-02",NA))
fd <- list(name="foo", type="date", constraints = list(required = TRUE))
expect_nistrue(check_date(x, fd))
expect_istrue(check_date(x, fd, constraints = FALSE))

x <- as.Date(c("2024-01-02","2024-03-23","2024-01-02",NA))
fd <- list(name="foo", type="date", constraints = list(exclusiveMaximum = as.Date("2024-03-23")))
expect_nistrue(check_date(x, fd))
expect_istrue(check_date(x, fd, constraints = FALSE))

x <- as.Date(c("2024-01-02","2024-03-23","2024-01-02",NA))
fd <- list(name="foo", type="date", constraints = list(exclusiveMinimum = as.Date("2024-01-02")))
expect_nistrue(check_date(x, fd))
expect_istrue(check_date(x, fd, constraints = FALSE))

x <- as.Date(c("2024-01-02","2024-03-23","2024-01-02",NA))
fd <- list(name="foo", type="date", constraints = list(enum = as.Date(c("2024-02-01", "2024-01-02"))))
expect_nistrue(check_date(x, fd))
expect_istrue(check_date(x, fd, constraints = FALSE))

x <- as.Date(c("2024-01-02","2024-03-23","2024-01-02",NA))
fd <- list(name="foo", type="date", constraints = list(required = TRUE, unique = TRUE))
y <- check_date(x, fd)
expect_equal(is.character(y), TRUE)
expect_equal(length(y), 2)

