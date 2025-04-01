library(datapackage)
source("helpers.R")

fn <- tempfile()
dir.create(fn, recursive = TRUE, showWarnings = FALSE)


# =============================================================================
# Regression test for issue #23. A warning is generated when the yaml file
# contains integer values to large for regular integer
writeLines("name: test
resources:
- name: test
  bytes: 9876543219", file.path(fn, "datapackage.yaml"))
res <- open_datapackage(fn)
expect_equal(res$resources[[1]]$bytes, 9876543219)

writeLines("name: test
resources:
- name: test
  bytes: -9876543219", file.path(fn, "datapackage.yaml"))
res <- open_datapackage(fn)
expect_equal(res$resources[[1]]$bytes, -9876543219)

writeLines("name: test
resources:
- name: test
  bytes: 9", file.path(fn, "datapackage.yaml"))
res <- open_datapackage(fn)
expect_equal(res$resources[[1]]$bytes, 9)
expect_equal(is.integer(res$resources[[1]]$bytes), TRUE)



.ignore <- file.remove(list.files(fn, full.names = TRUE))
.ignore <- file.remove(fn)

