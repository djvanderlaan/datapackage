library(datapackage)
source("helpers.R")


dta <- data.frame(
  a = 1:4,
  b =  letters[1:4],
  c = 1:4/10
)
dta_txt <- dta
dta_txt$a <- as.character(dta$a)
dta_txt$c <- as.character(dta$c)


# =============================================================================
# DEFAULT
# =============================================================================
resource <- list(
    name = "dta",
    encoding = "utf-8",
    schema = list(
      fields = list(
        list(name = "a", type = "integer"),
        list(name = "b", type = "string"),
        list(name = "c", type = "number")
      )
    )
  )
resource <- structure(resource, class = "dataresource")
res <- dp_apply_schema(dta_txt, resource)
expect_equal(res, dta, attributes = FALSE)

# =============================================================================
# ORDER OF FIELDS DIFFERENT
# =============================================================================
resource <- list(
    name = "dta",
    encoding = "utf-8",
    schema = list(
      fields = list(
        list(name = "a", type = "integer"),
        list(name = "c", type = "number"),
        list(name = "b", type = "string")
      )
    )
  )
resource <- structure(resource, class = "dataresource")
expect_error(res <- dp_apply_schema(dta_txt, resource))

resource <- list(
    name = "dta",
    encoding = "utf-8",
    schema = list(
      fields = list(
        list(name = "a", type = "integer"),
        list(name = "c", type = "number"),
        list(name = "b", type = "string")
      ),
      fieldsMatch = "equal"
    )
  )
resource <- structure(resource, class = "dataresource")
res <- dp_apply_schema(dta_txt, resource)
expect_equal(res, dta[c("a", "c", "b")], attributes = FALSE)


# =============================================================================
# MORE FIELDS 
# =============================================================================
resource <- list(
    name = "dta",
    encoding = "utf-8",
    schema = list(
      fields = list(
        list(name = "a", type = "integer"),
        list(name = "b", type = "string")
      )
    )
  )
resource <- structure(resource, class = "dataresource")
expect_error(res <- dp_apply_schema(dta_txt, resource))

resource <- list(
    name = "dta",
    encoding = "utf-8",
    schema = list(
      fields = list(
        list(name = "a", type = "integer"),
        list(name = "b", type = "string")
      ),
      fieldsMatch = "equal"
    )
  )
resource <- structure(resource, class = "dataresource")
expect_error(res <- dp_apply_schema(dta_txt, resource))

resource <- list(
    name = "dta",
    encoding = "utf-8",
    schema = list(
      fields = list(
        list(name = "a", type = "integer"),
        list(name = "b", type = "string")
      ),
      fieldsMatch = "subset"
    )
  )
resource <- structure(resource, class = "dataresource")
res <- dp_apply_schema(dta_txt, resource)
expect_equal(names(res), c("a", "b", "c"))
expect_equal(res$a, dta$a, attributes = FALSE)
expect_equal(res$b, dta$b, attributes = FALSE)
# Column c will not be converted
expect_equal(res$c, dta_txt$c, attributes = FALSE)


# =============================================================================
# LESS FIELDS
# =============================================================================
resource <- list(
    name = "dta",
    encoding = "utf-8",
    schema = list(
      fields = list(
        list(name = "a", type = "integer"),
        list(name = "b", type = "string"),
        list(name = "c", type = "number"),
        list(name = "d", type = "string")
      )
    )
  )
resource <- structure(resource, class = "dataresource")
expect_error(res <- dp_apply_schema(dta_txt, resource))

resource$schema$fieldsMatch <- "equal"
resource <- structure(resource, class = "dataresource")
expect_error(res <- dp_apply_schema(dta_txt, resource))

resource$schema$fieldsMatch <- "subset"
resource <- structure(resource, class = "dataresource")
expect_error(res <- dp_apply_schema(dta_txt, resource))

resource$schema$fieldsMatch <- "superset"
resource <- structure(resource, class = "dataresource")
res <- dp_apply_schema(dta_txt, resource)
expect_equal(res, dta, attributes = FALSE)

# =============================================================================
# PARTIAL FIELDS
# =============================================================================
resource <- list(
    name = "dta",
    encoding = "utf-8",
    schema = list(
      fields = list(
        list(name = "b", type = "string"),
        list(name = "d", type = "string")
      )
    )
  )
resource <- structure(resource, class = "dataresource")
expect_error(res <- dp_apply_schema(dta_txt, resource))

resource$schema$fieldsMatch <- "equal"
resource <- structure(resource, class = "dataresource")
expect_error(res <- dp_apply_schema(dta_txt, resource))

resource$schema$fieldsMatch <- "subset"
resource <- structure(resource, class = "dataresource")
expect_error(res <- dp_apply_schema(dta_txt, resource))

resource$schema$fieldsMatch <- "superset"
resource <- structure(resource, class = "dataresource")
expect_error(res <- dp_apply_schema(dta_txt, resource))

resource$schema$fieldsMatch <- "partial"
resource <- structure(resource, class = "dataresource")
res <- dp_apply_schema(dta_txt, resource)
expect_equal(names(res), c("b", "a", "c"))
expect_equal(res$a, dta_txt$a, attributes = FALSE)
expect_equal(res$b, dta$b, attributes = FALSE)
expect_equal(res$c, dta_txt$c, attributes = FALSE)

# =============================================================================
# NO FIELDS MATCH
# =============================================================================
resource <- list(
    name = "dta",
    encoding = "utf-8",
    schema = list(
      fields = list(
        list(name = "d", type = "string"),
        list(name = "e", type = "string")
      )
    )
  )
resource <- structure(resource, class = "dataresource")
expect_error(res <- dp_apply_schema(dta_txt, resource))

resource$schema$fieldsMatch <- "equal"
resource <- structure(resource, class = "dataresource")
expect_error(res <- dp_apply_schema(dta_txt, resource))

resource$schema$fieldsMatch <- "subset"
resource <- structure(resource, class = "dataresource")
expect_error(res <- dp_apply_schema(dta_txt, resource))

resource$schema$fieldsMatch <- "superset"
resource <- structure(resource, class = "dataresource")
expect_error(res <- dp_apply_schema(dta_txt, resource))

resource$schema$fieldsMatch <- "partial"
resource <- structure(resource, class = "dataresource")
expect_error(res <- dp_apply_schema(dta_txt, resource))

