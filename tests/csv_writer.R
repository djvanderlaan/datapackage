library(datapackage)
source("helpers.R")


fn <- tempfile()
dir.create(fn, recursive = TRUE, showWarnings = FALSE)


# We are going to reuse the datapackage for different
# variations of the resources
datapackage <- list(
    name = "test",
    resources = list()
  )
datapackage <- structure(datapackage, 
  class = c("readonlydatapackage", "datapackage"),
  filename = "datapackage.json",
  path = fn)



# === SIMPLE EXAMPLE
data <- data.frame(
  col1 = c(1L, 2L),
  col2 = c("A", "B")
)
resource <- list(
    name = "test",
    path = "test.csv",
    schema = list(
        fields = list(
            list(name = "col1", type = "integer"),
            list(name = "col2", type = "string")
          )
      ),
    dialect = list( 
        delimiter = ";",
        decimalChar = ","
      )
  )
expected <- c('"col1";"col2"', '1;"A"', '2;"B"')
resource <- structure(resource, class = "dataresource")
datapackage$resources[[1]] <- resource
csv_write(data, "test", datapackage)
res <- readLines(file.path(fn, "test.csv")) 
expect_equal(res, expected)
csv_write(data, "test", datapackage, use_fwrite = TRUE)
res <- readLines(file.path(fn, "test.csv")) 
expect_equal(res, expected)

# === DECIMALCHAR IN FIELD
data <- data.frame(
  col1 = c(1.22, -2.33),
  col2 = c(1000.10, NA)
)
resource <- list(
    name = "test",
    path = "test.csv",
    schema = list(
        fields = list(
            list(name = "col1", type = "number", decimalChar = ","),
            list(name = "col2", type = "number", decimalChar = ",")
          )
      ),
    dialect = list( 
        delimiter = ";"
      )
  )
expected <- c('"col1";"col2"', '1,22;1000,1', '-2,33;')
resource <- structure(resource, class = "dataresource")
datapackage$resources[[1]] <- resource
csv_write(data, "test", datapackage)
res <- readLines(file.path(fn, "test.csv")) 
expect_equal(res, expected)

csv_write(data, "test", datapackage, use_fwrite = TRUE)
res <- readLines(file.path(fn, "test.csv")) 
expect_equal(res, expected)

# === DECIMALCHAR IN DIALECT
data <- data.frame(
  col1 = c(1.22, -2.33),
  col2 = c(1000.10, NA)
)
resource <- list(
    name = "test",
    path = "test.csv",
    schema = list(
        fields = list(
            list(name = "col1", type = "number"),
            list(name = "col2", type = "number")
          )
      ),
    dialect = list( 
        delimiter = ";",
        decimalChar = ","
      )
  )
expected <- c('"col1";"col2"', '1,22;1000,1', '-2,33;')
resource <- structure(resource, class = "dataresource")
datapackage$resources[[1]] <- resource
csv_write(data, "test", datapackage)
res <- readLines(file.path(fn, "test.csv")) 
expect_equal(res, expected)

csv_write(data, "test", datapackage, use_fwrite = TRUE)
res <- readLines(file.path(fn, "test.csv")) 
expect_equal(res, expected)

# === GROUPCHAR
data <- data.frame(
  col1 = c(1.22, -2.33),
  col2 = c(1000.10, NA)
)
resource <- list(
    name = "test",
    path = "test.csv",
    schema = list(
        fields = list(
            list(name = "col1", type = "number", groupChar = " "),
            list(name = "col2", type = "number", groupChar = " ")
          )
      ),
    dialect = list( 
        delimiter = ";",
        decimalChar = ","
      )
  )
expected <- c('"col1";"col2"', '"1,22";"1 000,1"', '"-2,33";')
resource <- structure(resource, class = "dataresource")
datapackage$resources[[1]] <- resource
csv_write(data, "test", datapackage)
res <- readLines(file.path(fn, "test.csv")) 
expect_equal(res, expected)

csv_write(data, "test", datapackage, use_fwrite = TRUE)
res <- readLines(file.path(fn, "test.csv")) 
expect_equal(res, expected)


# === NUULSEQUENCE
data <- data.frame(
  col1 = c(1.22, -2.33),
  col2 = c(1000.10, NA)
)
resource <- list(
    name = "test",
    path = "test.csv",
    schema = list(
        fields = list(
            list(name = "col1", type = "number"),
            list(name = "col2", type = "number")
          )
      ),
    dialect = list( 
        nullSequence = "FOO"
      )
  )
expected <- c('"col1","col2"', '1.22,1000.1', '-2.33,FOO')
resource <- structure(resource, class = "dataresource")
datapackage$resources[[1]] <- resource
csv_write(data, "test", datapackage)
res <- readLines(file.path(fn, "test.csv")) 
expect_equal(res, expected)

csv_write(data, "test", datapackage, use_fwrite = TRUE)
res <- readLines(file.path(fn, "test.csv")) 
expect_equal(res, expected)

# === LOGICAL
data <- data.frame(
  col1 = c(TRUE, FALSE),
  col2 = c(TRUE, NA)
)
resource <- list(
    name = "test",
    path = "test.csv",
    schema = list(
        fields = list(
            list(name = "col1", type = "boolean"),
            list(name = "col2", type = "boolean")
          )
      ),
    dialect = list( 
        delimiter = ";",
        decimalChar = ","
      )
  )
expected <- c('"col1";"col2"', 'TRUE;TRUE', 'FALSE;')
resource <- structure(resource, class = "dataresource")
datapackage$resources[[1]] <- resource
csv_write(data, "test", datapackage)
res <- readLines(file.path(fn, "test.csv")) 
expect_equal(res, expected)

csv_write(data, "test", datapackage, use_fwrite = TRUE)
res <- readLines(file.path(fn, "test.csv")) 
expect_equal(res, expected)



# === LOGICAL
data <- data.frame(
  col1 = c(TRUE, FALSE),
  col2 = c(TRUE, NA)
)
resource <- list(
    name = "test",
    path = "test.csv",
    schema = list(
        fields = list(
            list(name = "col1", type = "boolean", 
              trueValues = c("RIGHT", "right"), 
              falseValues = c("NOT RIGHT")),
            list(name = "col2", type = "boolean")
          )
      ),
    dialect = list( 
        delimiter = ";",
        decimalChar = ","
      )
  )
expected <- c('"col1";"col2"', '"RIGHT";TRUE', '"NOT RIGHT";')
resource <- structure(resource, class = "dataresource")
datapackage$resources[[1]] <- resource
csv_write(data, "test", datapackage)
res <- readLines(file.path(fn, "test.csv")) 
expect_equal(res, expected)

csv_write(data, "test", datapackage, use_fwrite = TRUE)
res <- readLines(file.path(fn, "test.csv")) 
expect_equal(res, expected)


# === DATE
data <- data.frame(
  col1 = as.Date(c("2025-01-01", "2024-12-31")),
  col2 = as.Date(c("2000-06-10", NA))
)
resource <- list(
    name = "test",
    path = "test.csv",
    schema = list(
        fields = list(
            list(name = "col1", type = "date"),
            list(name = "col2", type = "date", format = "%d-%m-%Y")
          )
      ),
    dialect = list( 
        delimiter = ";",
        decimalChar = ","
      )
  )
expected <- c('"col1";"col2"', '"2025-01-01";"10-06-2000"', '"2024-12-31";')
resource <- structure(resource, class = "dataresource")
datapackage$resources[[1]] <- resource
csv_write(data, "test", datapackage)
res <- readLines(file.path(fn, "test.csv")) 
expect_equal(res, expected)

csv_write(data, "test", datapackage, use_fwrite = TRUE)
res <- readLines(file.path(fn, "test.csv")) 
expect_equal(res, expected)


files <- list.files(fn, full.names = TRUE)
ignore <- file.remove(files)
ignore <- file.remove(fn)

