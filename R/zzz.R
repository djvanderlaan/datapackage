
readers <- new.env(parent = emptyenv())

readers$mediatypes  <- list()
readers$extensions <- list()
readers$readers <- list()
readers$writers <- list()

dpaddreader("csv", csv_reader, 
  mediatypes = "text/csv",
  extensions = "csv")
dpaddreader("asc", fwf_reader, 
  mediatypes = "text/x-fixedwidth",
  extensions = c("fwf", "asc"))
dpaddreader("fwf", fwf_reader, 
  mediatypes = "text/x-fixedwidth",
  extensions = c("fwf", "asc"))
dpaddreader("fixed", fwf_reader, 
  mediatypes = "text/x-fixedwidth",
  extensions = c("fwf", "asc"))


dpaddwriter("csv", csv_write)

