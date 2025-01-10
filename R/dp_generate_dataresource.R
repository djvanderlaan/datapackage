# TODO: allow for addtional properties using ...

#' Generate Data Resource for a dataset
#'
#' @param x \code{data.frame} for which to generate the Data Resources.
#' 
#' @param name name of the Data Resource
#' 
#' @param path name of the file in which to store the dataset. This should be a
#' path relative to the location of the directory in which the Data Package in
#' which the Data Resource will be stored. 
#' 
#' @param format the data format in which the data is stored.
#' 
#' @param mediatype mediatype of the data
#' 
#' @param use_existing use existing field descriptors if present.
#' 
#' @param categories_type how should categories be stored. See 
#'   \code{\link{dp_generate_fielddescriptor}}.
#' 
#' @param categorieslist does the data resource function as a categories list
#' for fields in another data resource
#' 
#' @param ... Currently ignored
#' 
#'
#' @return
#' Returns a Data Resource object. 
#'
#' Note that this function does not create the file at \code{path}. The export
#' of the Data Resource is automatically set to CSV.
#'
#' @examples
#' # generate an example dataset
#' dta <- data.frame(a = 1:3, b = factor(letters[1:3]))
#' resource <- dp_generate_dataresource(dta, "example")
#' print(resource)
#' 
#' @export
dp_generate_dataresource <- function(x, name, path = paste0(name, getextension(format)), 
    format = "csv", mediatype = getmediatype(format), 
    use_existing = FALSE, categories_type = c("regular", "resource"),
    categorieslist = iscategorieslist(x), ...) {
  stopifnot(is.data.frame(x))
  # Generate the table schema
  fields <- vector("list", ncol(x))
  for (i in seq_along(x)) {
    fd <- dp_generate_fielddescriptor(x[[i]], names(x)[i], use_existing = use_existing, 
      categories_type = categories_type)
    fields[[i]] <- fd
  }
  res <- new_dataresource(name = name, format = format, mediatype = mediatype, 
    path = path, encoding = "utf-8", schema = list(fields = fields))
  # Generate categoriesFieldMap
  if (categorieslist) {
    res$categoriesFieldMap <- generatecategoriesfieldmap(x)
  }
  res
}

iscategorieslist <- function(x) {
  if (!is.null(res <- attr(x, "resource"))) {
    fieldmap <- dp_property(res, "categoriesFieldMap")
    !is.null(fieldmap) 
  } else {
    FALSE
  }
}

getextension <- function(format, withdot = TRUE) {
  extensions <- readers$extensions
  result <- format
  for (extension in names(extensions)) {
    if (format %in% extensions[[extension]]) {
      result <- extension
      break
    }
  }
  if (withdot) paste0(".", result) else result
}

getmediatype <- function(format) {
  mediatypes <- readers$mediatypes
  result <- NULL
  for (mediatype in names(mediatypes)) {
    if (format %in% mediatypes[[mediatype]]) {
      result <- mediatype
      break
    }
  }
  result
}

generatecategoriesfieldmap <- function(x) {
  if (!is.null(res <- attr(x, "resource"))) {
    fieldmap <- dp_property(res, "categoriesFieldMap")
    if (!is.null(fieldmap)) { 
      if (utils::hasName(fieldmap, "value") && !utils::hasName(x, fieldmap$value))
        stop("Dataresource does not have a column '", fieldmap$value, 
          "' which should contain the values of a categorieslist.")
      if (utils::hasName(fieldmap, "label") && !utils::hasName(x, fieldmap$label))
        stop("Dataresource does not have a column '", fieldmap$value, 
          "' which should contain the labels of a categorieslist.")
      return(fieldmap)
    }
  }
  stopifnot(ncol(x) > 0)
  value <- names(x)[1]
  if (utils::hasName(x, "value")) value <- "value"
  label <- names(x)[max(1, length(x))]
  if (utils::hasName(x, "label")) label <- "label"
  list(value = value, label = label)
}

