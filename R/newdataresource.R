
#' @export
newdataresource <- function(name, title = NULL, description = NULL, ...) {
  # Build object
  res <- structure(list(), class = 'dataresource')
  name(res) <- name
  if (!missing(title) && !is.null(title)) 
    title(res) <- title
  if (!missing(description) && !is.null(description)) 
    description(res) <- description
  # Return
  res
}

