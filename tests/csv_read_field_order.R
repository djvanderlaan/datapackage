library(datapackage)
source("helpers.R")

fn <- tempfile()



# =============================================================================
# fieldsMatch = <default>
# =============================================================================
resource <- list(
    name = "test",
    format = "csv",
    schema = list(
      fields = list(
          list(name = "a", type = "integer"),
          list(name = "b", type = "string"),
          list(name = "c", type = "number")
        )
      )
  ) |> structure(class = "dataresource")
dta <- data.frame(
    a = 1:4, 
    b = letters[1:4],
    c = c(0.1, -0.4, -10, 20)
  )
write.csv(dta, fn, row.names = FALSE)
res <- csv_reader(fn, resource)
expect_equal(dta, res, attributes = FALSE)

# =============================================================================
# fieldsMatch = equal
# =============================================================================
dta <- data.frame(
    b = letters[1:4],
    a = 1:4, 
    c = c(0.1, -0.4, -10, 20)
  )
write.csv(dta, fn, row.names = FALSE)
expect_error( res <- csv_reader(fn, resource) )

resource$schema$fieldsMatch <- "equal"
res <- csv_reader(fn, resource) 
expect_equal(names(res), c("a", "b", "c"))
expect_equal(res$a, dta$a, attributes = FALSE)
expect_equal(res$b, dta$b, attributes = FALSE)
expect_equal(res$c, dta$c, attributes = FALSE)

# =============================================================================
# fieldsMatch = subset
# =============================================================================
dta <- data.frame(
    b = letters[1:4],
    a = 1:4, 
    c = c(0.1, -0.4, -10, 20),
    d = 11:14
  )
resource$schema$fieldsMatch <- "equal"
write.csv(dta, fn, row.names = FALSE)
expect_error( res <- csv_reader(fn, resource) )

resource$schema$fieldsMatch <- "subset"
res <- csv_reader(fn, resource) 
expect_equal(names(res), c("a", "b", "c", "d"))
expect_equal(res$a, dta$a, attributes = FALSE)
expect_equal(res$b, dta$b, attributes = FALSE)
expect_equal(res$c, dta$c, attributes = FALSE)
expect_equal(res$d, as.character(dta$d), attributes = FALSE)

# =============================================================================
# fieldsMatch = superset
# =============================================================================
dta <- data.frame(
    b = letters[1:4],
    a = 1:4
  )
resource$schema$fieldsMatch <- "subset"
write.csv(dta, fn, row.names = FALSE)
expect_error( res <- csv_reader(fn, resource) )

resource$schema$fieldsMatch <- "superset"
res <- csv_reader(fn, resource) 
expect_equal(names(res), c("a", "b"))
expect_equal(res$a, dta$a, attributes = FALSE)
expect_equal(res$b, dta$b, attributes = FALSE)

# =============================================================================
# fieldsMatch = partial
# =============================================================================
dta <- data.frame(
    d = 11:14,
    b = letters[1:4],
    a = 1:4
  )
resource$schema$fieldsMatch <- "subset"
write.csv(dta, fn, row.names = FALSE)
expect_error( res <- csv_reader(fn, resource) )

resource$schema$fieldsMatch <- "partial"
res <- csv_reader(fn, resource) 
expect_equal(names(res), c("a", "b", "d"))
expect_equal(res$a, dta$a, attributes = FALSE)
expect_equal(res$b, dta$b, attributes = FALSE)
expect_equal(res$d, as.character(dta$d), attributes = FALSE)



# =============================================================================
# CLEANUP
# =============================================================================

.ignore <- file.remove(fn)

