# TODO: specify format
# TODO: allow for addtional properties using ...

#' Generate Data Resources for a dataset
#'
#' @param x \code{data.frame} for which to generate the Data Resources.
#' @param name name of the Data Resource
#' @param path name of the file in which to store the dataset. This should be a
#' path relative to the location of the directory in which the Data Package in
#' which the Data Resource will be stored. 
#' @param ... Currently ignored
#'
#' @return
#' Returns a \code{list} with Data Resource objects. The first Data Resource is
#' that of the dataset \code{x} itself. Additional Data Resources are for the
#' code lists of the variables. Code lists are generated for fields that have a
#' code list and for \code{factor} variables.
#'
#' Note that this function does not create the file at \code{path}. The export
#' of the Data Resource is automatically set to CSV.
#'
#' @examples
#' # generate an example dataset
#' dta <- data.frame(a = 1:3, b = factor(letters[1:3]))
#' resources <- dpgenerateresources(dta, "example")
#' print(resources)
#' 
#' @export
dpgeneratedataresources <- function(x, name, path = paste0(name, ".csv"), ...) {
  stopifnot(is.data.frame(x))
  resources <- vector("list", 1)
  # Generate the table schema
  fields <- vector("list", ncol(x))
  for (i in seq_along(x)) {
    fd <- dpgeneratefielddescriptor(x[[i]], names(x)[i])
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
    path = path, encoding = "utf-8", schema = list(fields = fields)), 
    class = "dataresource")
  resources[[1L]] <- res
  resources
}

