
to_json <- function(x, as_array = character(0), ...) {
  # Traverse x and check which objects need to be converted to array
  recurse_tree <- function(tree, as_array = character(0), path = character(0)) {
    if (is.data.frame(tree)) {
      # do nothing
    } else if (is.list(tree)) {
      if (is.null(names(tree))) {
        tree <- lapply(tree, recurse_tree, as_array = as_array, 
          path = path)
      } else {
        for (n in names(tree)) {
          tree[[n]] <- recurse_tree(tree[[n]], as_array = as_array, 
            path = c(path, n))
        }
      }
    } else {
      path <- paste0(path, collapse = "/")
      if ((length(tree) == 1) && (path %in% as_array)) {
        tree <- list(tree)
      }
    }
    tree
  }
  tmp <- recurse_tree(x, as_array)
  jsonlite::toJSON(tmp, auto_unbox = TRUE, ...)
}
