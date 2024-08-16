# What type to use when reading this column from a CSV-file
#
# @param fielddescriptor the field descriptor
# @param ... passed on to other methods.
#
# @return 
# Returns a length one character vector with the name of the type
# \code{read.csv} or \code{fread} should use when reading the column.
#
# @rdname csv_colclass
# @export
csv_colclass <- function(fielddescriptor, ...) {
  type <- fielddescriptor$type
  fun <- paste0("csv_colclass_", type)
  if (!exists(fun)) stop(fun, " does not exist.")
  do.call(fun, c(list(fielddescriptor), list(...)))
}

