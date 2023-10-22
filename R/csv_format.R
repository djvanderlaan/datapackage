
# Format the field before writing to CSV
# 
# @param x the field
# @param schema the field schema
#
# @return
# Returns a formatted version of the column that can be used by
# \code{write.csv} to write the column.
# 
# @rdname csv_format
# @export
csv_format <- function(x, schema = datapackage::schema(x)) {
  type <- schema$type
  format_fun <- paste0("csv_format_", type)
  format_fun <- get(format_fun)
  format_fun(x, schema)
}

