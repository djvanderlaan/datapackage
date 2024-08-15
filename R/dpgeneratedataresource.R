# TODO: specify format
# TODO: allow for addtional properties using ...

#' Generate Data Resource for a dataset
#'
#' @param x \code{data.frame} for which to generate the Data Resources.
#' @param name name of the Data Resource
#' @param path name of the file in which to store the dataset. This should be a
#' path relative to the location of the directory in which the Data Package in
#' which the Data Resource will be stored. 
#' @param format the data format in which the data is stored.
#' @param mediatype mediatype of the data
#' @param use_existing use existing field descriptors if present.
#' @param categories_type how should categories be stored. See 
#'   \code{\link{dpgeneratefielddescriptor}}.
#' @param ... Currently ignored
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
#' resource <- dpgeneratedataresource(dta, "example")
#' print(resource)
#' 
#' @export
dpgeneratedataresource <- function(x, name, path = paste0(name, getextension(format)), 
    format = "csv", mediatype = getmediatype(format), 
    use_existing = FALSE, categories_type = c("regular", "resource"),
    ...) {
  stopifnot(is.data.frame(x))
  # Generate the table schema
  fields <- vector("list", ncol(x))
  for (i in seq_along(x)) {
    fd <- dpgeneratefielddescriptor(x[[i]], names(x)[i], use_existing = use_existing, 
      categories_type = categories_type)
    fields[[i]] <- fd
  }
  res <- newdataresource(name = name, format = format, mediatype = mediatype, 
    path = path, encoding = "utf-8", schema = list(fields = fields))
  res
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

