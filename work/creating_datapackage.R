


Welke use cases:
- Dataset opslaan; alle metadata wordt automatisch gegenereerd; resource voor de
dataset zelf moet aangemaakt worden en ook de dataresources voor eventuele
codelijsten.
- Dataset opslaan; maak gebruik van bestaande metadata. Opslaan moet voldoen aan
deze bestaande metadata.
- Metadata genereren en opslaan. Deze kan vervolgens handmatig geedit worden. 


# =============================================================================
# Create data resources from a dataset.
# This can generate multiple resources in case a dataset contains variables 
# with a codelist
# TODO: use existing fielddescriptors of variables if available
# TODO: option to store codelist in the metadata
# TODO: option to not store any codelist at all an store factor as character
# TODO: other types such as integer, boolean, date

pkgload::load_all()

dpgeneratedataresources <- function(x, name, ...) {
  stopifnot(is.data.frame(x))
  resources <- vector("list", 1)
  # Generate the table schema
  fields <- vector("list", ncol(x))
  for (i in seq_along(x)) {
    fd <- generatefielddescriptor(x[[i]], names(x)[i])
    codelist <- fd$codelist
    if (!is.null(codelist)) {
      # WE have a codelist and need to generate a dataresource for the codelist
      codelistname <- sprintf("%s-%s-codelist", 
         name, names(x)[i])
      fd$fielddescriptor$codelist <- codelistname
      codelist_res <- dpgeneratedataresources(codelist, codelistname)
      resources[[length(resources)+1L]] <- codelist_res[[1]]
    }
    fields[[i]] <- fd$fielddescriptor
  }
  res <- structure(list(name = name, format = "csv", mediatype = "text/csv", 
    encoding = "utf-8", schema = list(fields = fields)), class = "dataresource")
  resources[[1L]] <- res
  resources
}

generatefielddescriptor <- function(x, name, ...) {
  UseMethod("generatefielddescriptor")
}
generatefielddescriptor.default <- function(x, name, ...) {
  fielddescriptor <- list(
    name = name,
    type = "string"
  )
  list(fielddescriptor = fielddescriptor)
}
generatefielddescriptor.numeric <- function(x, name, ...) {
  fielddescriptor <- list(
    name = name,
    type = "number"
  )
  list(fielddescriptor = fielddescriptor)
}
generatefielddescriptor.factor <- function(x, name, ...) {
  fielddescriptor <- list(
    name = name,
    type = "integer"
  )
  codelist <- data.frame(
    code = seq_len(nlevels(x)),
    label = levels(x)
  )
  list(fielddescriptor = fielddescriptor, codelist = codelist)
}

dpgeneratedataresources(iris, "iris") |> lapply(unclass) |> jsonlite::toJSON(pretty = TRUE, auto_unbox = TRUE)


system("rm -f -r work/test")

dp <- newdatapackage("work/test")

dpname(dp) <- "test"


res <- dpgeneratedataresources(iris, "iris") 

`dpresources<-` <- function(x, value) {
  for (i in seq_along(value)) {
    r <- value[[i]]
    name <- dpname(r)
    if (is.null(name)) name <- paste0("resource", i)
    dpresource(x, name) <- r
  }
  x
}

dpresources(dp) <- res


dp

csv_write <- function(x, resourcename, datapackage, ...) {
  dataresource <- dpresource(datapackage, resourcename)
  if (is.null(dataresource)) 
    stop("Data resource '", resourcename, "' does not exist in data package")
  decimalChar <- decimalchar(dataresource)
  delimiter <- "," # TODO: check csv specs in resource

  delimiter_ok <- sapply(schema$fields, function(x) x$type != "number" || 
    is.null(x$decimalChar) || x$decimalChar != delimiter)
  delimiter_ok <- all(delimiter_ok)
  if (delimiter == decimalChar || !delimiter_ok)
    stop("There are fields for which the decimalChar equals the field ", 
      "delimiter. This is not allowed.")
  # Keep track of the fields that were originally character field and should
  # be quoted in the output
  quote <- which(sapply(x, is.character))
  # Format the fields (if necessary)
  for (i in seq_along(x)) 
    x[[i]] <- csv_format(x[[i]], schema$fields[[i]])
  # How to write missing values
  nastrings <- if (!is.null(schema$missingValues)) schema$missingValues else ""
  na <- if (length(nastrings) > 0) nastrings[1] else ""
  # Write
  utils::write.table(x, file = filename, na = na, row.names = FALSE, 
    fileEncoding = "UTF-8", quote = quote, sep = delimiter, dec = ".", 
    qmethod = "double")
  # TODO
  #write_schema(schema, filename_schema, pretty = TRUE)
}

decimalchar <- function(x, default = ".") {
  decimalChars <- sapply(dpfieldnames(x), \(fn) {
    char <- dpfield(x, fn) |> dpproperty("decimalChar")
    ifelse(is.null(char), ".", char)
  }) |> table() |> sort(decreasing = TRUE)
  if(length(decimalChars) == 0) default else names(decimalChars)[1]
}

decimalchar(res[[1]])

