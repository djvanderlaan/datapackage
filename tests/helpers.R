expect_equal <- function(x, y, attributes = TRUE) {
  if (is.data.frame(x) && !attributes) 
    return(expect_equal_data.frame(x, y, attributes))
  if (is.factor(x) && !attributes) 
    return(expect_equal_factor(x, y, attributes))
  if (!attributes) attributes(x) <- NULL
  if (!attributes) attributes(y) <- NULL
  #stopifnot(isTRUE(all.equal(x, y)))
  if (!isTRUE(all.equal(x, y))) {
    n <- 5
    fx <- paste0("'", utils::head(x, n), "'", collapse = ",")
    if (length(x) > n) fx <- paste0(fx, ",...")
    fx <- paste0("[", fx, "]")
    fy <- paste0("'", utils::head(y, n), "'", collapse = ",")
    if (length(y) > n) fy <- paste0(fy, ",...")
    fy <- paste0("[", fy, "]")
    stop("x and y are not equal: ", fx, " != ", fy)
  }
}

expect_equal_factor <- function(x, y, attributes = TRUE) {
  if (attributes) {
    expect_equal(x, y, attributes = attributes)
  } else {
    expect_equal(as.integer(x), as.integer(y), attributes = FALSE)
    expect_equal(levels(x), levels(y), attributes = FALSE)
  }
}

expect_equal_data.frame <- function(x, y, attributes = TRUE) {
  if (!attributes) {
    expect_equal(class(x), class(y))
    expect_equal(names(x), names(y))
    for (col in names(x)) 
      expect_equal(x[[col]], y[[col]], attributes = FALSE)
  } else expect_equal(x, y, attributes)
}

expect_attribute <- function(x, name, value) {
  v <- attr(x, name)
  stopifnot(!is.null(v))
  expect_equal(v, value)
}

expect_error <- function(expr) {
  expect_error.error <- TRUE
  try({
    expr
    expect_error.error <- FALSE
  }, silent = TRUE)
  if (!expect_error.error) stop("Expression did not throw an error.")
}

expect_warning <- function(expr) {
  messages <- list()
  warnings <- list()  
  errors   <- list()
  #tryCatch(
    withCallingHandlers(
      expr, 
      warning = function(w) { 
        warnings <<- append(warnings, list(w))
        invokeRestart("muffleWarning")
      }#,
      #message = function(m) {
      #  messages <<- append(messages, list(m))
      #  invokeRestart("muffleMessage")
      #}
    )#, 
    #error  = function(e) errors <<- append(errors, list(e))
  #)
  stopifnot(length(warnings) > 0)
}
 
