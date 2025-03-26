pkgload::load_all()
source("tests/helpers.R")

fn <- tempfile()

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

dta <- data.frame(
    b = letters[1:4],
    a = 1:4, 
    c = c(0.1, -0.4, -10, 20)
  )
write.csv(dta, fn, row.names = FALSE)
expect_error( res <- csv_reader(fn, resource) )

resource$schema$fieldsMatch <- "equal"
res <- csv_reader(fn, resource) 
res


use_fread <- FALSE
dec <- "."
path <- fn
dialect <- list()

determine_colclasses <- function(path, resource, dialect, 
    use_fread = FALSE) {
  # Read part of the file to get the column names and the 
  # order of the columns
  tmp <- csv_read_base(path, colClasses = character(), 
    use_fread = use_fread, csv_dialect = dialect, nrows = 5)
  names <- names(tmp)
  # Check if the column names match with those from the 
  # data resource
  fieldnames <- dp_field_names(resource)
  fieldsMatch <- NULL
  if (!is.null(schema <- dp_schema(resource)))
    fieldsMatch <- dp_property(schema, "fieldsMatch")
  res <- check_fields(names, fieldnames, fieldsMatch)
  if (!isTRUE(res)) stop(res)
  # Get the colclasses based on the data resource 
  schema <- dp_schema(resource)
  colclasses <- sapply(schema$fields, csv_colclass, 
    decimalChar = dec)

  names
  m <- match(names, fieldnames)

  colclasses <- colclasses[m]
  colclasses[is.na(colclasses)] <- "character"



    dta <- csv_read_base(path, decimalChar = dec, colClasses = colclasses, 
      use_fread = use_fread, csv_dialect = dialect)



.ignore <- file.remove(fn)

