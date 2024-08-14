#' Save a dataset as a Data Package
#'
#' @param data the data.frame with the data to save 
#' @param path directory in which to create the datapackage
#' @param name name of the Data Resource. When omitted a name is generated.
#' @param categories_type how should categories be stored. See 
#'   \code{\link{dpgeneratefielddescriptor}}.
#'
#' @details
#' This function is a wrapper function around \code{\link{newdatapackage}},
#' \code{\link{dpgeneratedataresources}} and \code{\link{dpwritedata}}. These
#' functions are called with the default arguments. This allows for a quick way
#' to save a data set with any necessary data needed to read the dataset. 
#'
#' @return
#' Does not return anything. Called for the side effect of creating a directory
#' and creating a number of files in this directory. Together these form a
#' complete Data Package.
#'
#' @export
dpsaveasdatapackage <- function(data, path, name, categories_type = c("regular", "resource")) {
  if (missing(name))
    name <- deparse(substitute(data)) |> 
      gsub(pattern = "[^[:alnum:].-]", replacement = ".")
  dp <- newdatapackage(path, name)
  res <- dpgeneratedataresources(data, name, categories_type = categories_type)
  dpresources(dp) <- res
  dp |> dpresource(name) |> dpwritedata(data)
}
