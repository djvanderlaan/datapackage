

# Convert a data.frame with categories to a list of lists with elements value 
# and label. 
categorieslisttolist <- function(categorieslist) {
  res <- vector("list", nrow(categorieslist))
  for (i in seq_len(nrow(categorieslist))) {
    res[[i]] <- list(value = categorieslist$value[i], label = categorieslist$label[i])
  }
  res
}

# Categories can be stored in multiple formats:
# simple:
#   "categories" : ["apple", "pear"]
# or regular:
#   "categories" : [
#     {"value": 1, "label": "apple"},
#     {"value": 2, "label": "pear"}
#   ] 
# or dataresource
#   "categories" : {
#     "resource": "fruittypes",
#     "valueField": "value",
#     "labelField": "label"
#   }
# Determine the type. Returns a character with one of the type names above. 
# Generates an error when invalid. 
categoriestype <- function(categories) {
  if (is.data.frame(categories)) {
    stop("Unsupported format for categories: 'data.frame'.")
  } else if (is.list(categories)) {
    if (is.null(names(categories))) {
      "regular"
    } else {
      "dataresource"
    }
  } else if (is.numeric(categories) || is.character(categories) || is.logical(categories)) {
    "simple"
  } else {
    stop("Unsupported format for categories: '", 
      paste0(class(categories), collapse ="', '"), "'.")
  }
}

