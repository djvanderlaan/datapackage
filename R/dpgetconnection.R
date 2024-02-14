#' Get a connection to the data belonging to a Data Resource
#'
#' @param x Can either be a Data Resource or Data Package. 
#' @param ... Extra arguments are passed on to \code{\link{dpgetdata}}. 
#'
#' @details
#' When \code{x} is a Data Package a additional argument \code{resourcename} is
#' needed to identify the correct Data Resource. See \code{\link{dpgetdata}}. 
#'
#' This function calls \code{dpgetdata} with an additional 
#' \code{as_connection = TRUE)} argument. 
#'
#' @return 
#' Depending on the type of Data Resource a connection to the data is returned.
#' Some readers will return the data set as a \code{data.frame}. 
#' 
#' @rdname dpgetconnection
#' @export
dpgetconnection <- function(x, ...) {
  dpgetdata(x, ..., as_connection = TRUE)
}

