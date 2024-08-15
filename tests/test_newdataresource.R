library(datapackage)

source("helpers.R")

r <- newdataresource(name = "foo")
expect_equal(r, list(name = "foo"), attributes = FALSE)

expect_error(r <- newdataresource())

r <- newdataresource(
  name = "foo",
  title = "foo",
  description = c("foo", "bar"),
  path = "foo",
  format = "foo",
  mediatype = "foo",
  encoding = "foo",
  bytes = 10,
  hash = "foo")
expect_equal(r, list(
  name = "foo",
  title = "foo",
  description = "foo\nbar",
  path = "foo",
  format = "foo",
  mediatype = "foo",
  encoding = "foo",
  bytes = 10,
  hash = "foo"), attributes = FALSE)

expect_error(
  r <- newdataresource(
    name = "foo",
    format = 10
  )
)
expect_error(
  r <- newdataresource(
    name = "foo",
    mediatype = 10
  )
)
expect_error(
  r <- newdataresource(
    name = "foo",
    encoding = 10
  )
)
expect_error(
  r <- newdataresource(
    name = "foo",
    bytes = 3.4
  )
)
expect_error(
  r <- newdataresource(
    name = "foo",
    hash = 3.4
  )
)


