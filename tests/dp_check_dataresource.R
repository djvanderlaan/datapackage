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
# Check is all columns are present and not too many columns are present 

dr <- list(
    name = "test",
    schema = list(
      fields = list(
          list(name = "a", type = "integer"),
          list(name = "b", type = "string")
        )
      )
  ) |> structure(class = "dataresource")
dta <- data.frame(a = 1:3, b = letters[1:3])
expect_istrue(dp_check_dataresource(dta, dr))

dr <- list(
    name = "test",
    schema = list(
      fieldsMatch = "exact",
      fields = list(
          list(name = "a", type = "integer"),
          list(name = "b", type = "string")
        )
      )
  ) |> structure(class = "dataresource")
dta <- data.frame(a = 1:3, b = letters[1:3])
expect_istrue(dp_check_dataresource(dta, dr))

dr <- list(
    name = "test",
    schema = list(
      fieldsMatch = "exact",
      fields = list(
          list(name = "b", type = "string"),
          list(name = "a", type = "integer")
        )
      )
  ) |> structure(class = "dataresource")
dta <- data.frame(a = 1:3, b = letters[1:3])
expect_nistrue(dp_check_dataresource(dta, dr))

dr <- list(
    name = "test",
    schema = list(
      fieldsMatch = "equal",
      fields = list(
          list(name = "b", type = "string"),
          list(name = "a", type = "integer")
        )
      )
  ) |> structure(class = "dataresource")
dta <- data.frame(a = 1:3, b = letters[1:3])
expect_istrue(dp_check_dataresource(dta, dr))

dr <- list(
    name = "test",
    schema = list(
      fieldsMatch = "equal",
      fields = list(
          list(name = "a", type = "integer"),
          list(name = "b", type = "string")
        )
      )
  ) |> structure(class = "dataresource")
dta <- data.frame(a = 1:3)
expect_nistrue(dp_check_dataresource(dta, dr))

dr <- list(
    name = "test",
    schema = list(
      fieldsMatch = "superset",
      fields = list(
          list(name = "a", type = "integer"),
          list(name = "b", type = "string")
        )
      )
  ) |> structure(class = "dataresource")
dta <- data.frame(a = 1:3)
expect_istrue(dp_check_dataresource(dta, dr))

dr <- list(
    name = "test",
    schema = list(
      fieldsMatch = "equal",
      fields = list(
          list(name = "a", type = "integer"),
          list(name = "b", type = "string")
        )
      )
  ) |> structure(class = "dataresource")
dta <- data.frame(a = 1:3, b = letters[1:3], c = letters[1:3])
expect_nistrue(dp_check_dataresource(dta, dr))

dr <- list(
    name = "test",
    schema = list(
      fieldsMatch = "subset",
      fields = list(
          list(name = "a", type = "integer"),
          list(name = "b", type = "string")
        )
      )
  ) |> structure(class = "dataresource")
dta <- data.frame(a = 1:3, b = letters[1:3], c = letters[1:3])
expect_istrue(dp_check_dataresource(dta, dr))


dr <- list(
    name = "test",
    schema = list(
      fieldsMatch = "subset",
      fields = list(
          list(name = "a", type = "integer"),
          list(name = "b", type = "string")
        )
      )
  ) |> structure(class = "dataresource")
dta <- data.frame(a = 1:3, c = letters[1:3])
expect_nistrue(dp_check_dataresource(dta, dr))

dr <- list(
    name = "test",
    schema = list(
      fieldsMatch = "partial",
      fields = list(
          list(name = "a", type = "integer"),
          list(name = "b", type = "string")
        )
      )
  ) |> structure(class = "dataresource")
dta <- data.frame(a = 1:3, c = letters[1:3])
expect_istrue(dp_check_dataresource(dta, dr))

dr <- list(
    name = "test",
    schema = list(
      fieldsMatch = "partial",
      fields = list(
          list(name = "a", type = "integer"),
          list(name = "b", type = "string")
        )
      )
  ) |> structure(class = "dataresource")
dta <- data.frame(d = 1:3, c = letters[1:3])
expect_nistrue(dp_check_dataresource(dta, dr))

# =============================================================================
# Check if dp_check_fields is called correctly; we will not check all option of
# dp_check_fields as this function is tested seperately

dr <- list(
    name = "test",
    schema = list(
      fields = list(
          list(name = "a", type = "string"),
          list(name = "b", type = "string")
        )
      )
  ) |> structure(class = "dataresource")
dta <- data.frame(a = 1:3, b = letters[1:3])
expect_nistrue(dp_check_dataresource(dta, dr))

dr <- list(
    name = "test",
    schema = list(
      fields = list(
          list(name = "a", type = "integer", constraints = list(required = TRUE)),
          list(name = "b", type = "string", constraints = list(required = TRUE))
        )
      )
  ) |> structure(class = "dataresource")
dta <- data.frame(a = c(1:3,NA), b = c(letters[1:3], NA))
expect_nistrue(dp_check_dataresource(dta, dr))

expect_error(dp_check_dataresource(dta, dr, throw = TRUE))


