library(datapackage)
source("../tests/helpers.R")

# Basic
dta <- list(a = 1, b = 1, c = list(a = 1, b = 1))
res <- datapackage:::to_json(dta, as_array = c("a", "c/b"))
expect_equal(res, "{\"a\":[1],\"b\":1,\"c\":{\"a\":1,\"b\":[1]}}", 
  attributes = FALSE)

# Unnamed list
dta <- list(a = 1, b = 1, c = list(list(a = 1, b = 1)))
res <- datapackage:::to_json(dta, as_array = c("a", "c/b"))
expect_equal(res, "{\"a\":[1],\"b\":1,\"c\":[{\"a\":1,\"b\":[1]}]}", 
  attributes = FALSE)

# Ignore elements length > 1
dta <- list(a = 1:2, b = 1, c = list(a = 1, b = 1))
res <- datapackage:::to_json(dta, as_array = c("a", "c/b"))
expect_equal(res, "{\"a\":[1,2],\"b\":1,\"c\":{\"a\":1,\"b\":[1]}}", 
  attributes = FALSE)

# Ignore elements length > 1
dta <- list(a = 1:2, b = 1, c = list(a = 1, b = 1))
res <- datapackage:::to_json(dta, as_array = c("a", "c/b"))
expect_equal(res, "{\"a\":[1,2],\"b\":1,\"c\":{\"a\":1,\"b\":[1]}}", 
  attributes = FALSE)

# as_array contains elements not in object
dta <- list(a = 1, b = 1, c = list(a = 1, b = 1))
res <- datapackage:::to_json(dta, as_array = c("a", "c/b", "b/a"))
expect_equal(res, "{\"a\":[1],\"b\":1,\"c\":{\"a\":1,\"b\":[1]}}", 
  attributes = FALSE)

# Empty as_array
dta <- list(a = 1, b = 1, c = list(a = 1, b = 1))
res <- datapackage:::to_json(dta)
expect_equal(res, "{\"a\":1,\"b\":1,\"c\":{\"a\":1,\"b\":1}}", 
  attributes = FALSE)

# Zero length elements: stored as empty array
dta <- list(a = 1, b = numeric(0), c = list(a = 1, b = numeric(0)))
res <- datapackage:::to_json(dta, as_array = c("a", "c/b"))
expect_equal(res, "{\"a\":[1],\"b\":[],\"c\":{\"a\":1,\"b\":[]}}", 
  attributes = FALSE)

# Data frame
dta <- list(c = data.frame(b = 1))
res <- datapackage:::to_json(dta, as_array = c("a", "c/b"))
expect_equal(res, "{\"c\":[{\"b\":1}]}", 
  attributes = FALSE)


