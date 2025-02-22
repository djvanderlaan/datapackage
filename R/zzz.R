
readers <- new.env(parent = emptyenv())

readers$mediatypes  <- list()
readers$extensions <- list()
readers$readers <- list()
readers$writers <- list()

dp_add_reader("csv", csv_reader, 
  mediatypes = "text/csv",
  extensions = "csv")
dp_add_reader("asc", fwf_reader, 
  mediatypes = "text/x-fixedwidth",
  extensions = c("fwf", "asc"))
dp_add_reader("fwf", fwf_reader, 
  mediatypes = "text/x-fixedwidth",
  extensions = c("fwf", "asc"))
dp_add_reader("fixed", fwf_reader, 
  mediatypes = "text/x-fixedwidth",
  extensions = c("fwf", "asc"))


dp_add_writer("csv", csv_writer)

