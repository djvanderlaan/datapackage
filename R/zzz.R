
readers <- new.env(parent = emptyenv())

readers$mediatypes  <- list()
readers$extensions <- list()
readers$readers <- list()

dpaddreader("csv", csv_reader, 
  mediatypes = "text/csv",
  extensions = "csv")
dpaddreader("fwf", fwf_reader, 
  mediatypes = "text/x-fixedwidth",
  extensions = c("fwf", "asc"))


# TODO: add dpaddwriter

