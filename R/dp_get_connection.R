#' Get a connection to the data belonging to a Data Resource
#'
#' @param x Can either be a Data Resource or Data Package. 
#' @param ... Extra arguments are passed on to \code{\link{dp_get_data}}. 
#'
#' @details
#' When \code{x} is a Data Package a additional argument \code{resource_name} is
#' needed to identify the correct Data Resource. See \code{\link{dp_get_data}}. 
#'
#' This function calls \code{dp_get_data} with an additional 
#' \code{as_connection = TRUE)} argument. 
#'
#' @return 
#' Depending on the type of Data Resource a connection to the data is returned.
#' Some readers will return the data set as a \code{data.frame}. 
#' 
#' @rdname dp_get_connection
#' @export
dp_get_connection <- function(x, ...) {
  dp_get_data(x, ..., as_connection = TRUE)
}

