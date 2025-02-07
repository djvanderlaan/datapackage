
isabsolutepath <- function(path) {
  # Starts with text followed by : (eg http: or c:)
  grepl("^[[:alpha:]]*[:]", path) | 
  # Starts with \ or /
    grepl("^[/\\\\]", path) |
  # Has a ../ somewhere
    grepl("\\.\\.[/\\\\]", path)
}

isrelativepath <- function(path) {
  !isabsolutepath(path)
}

isurl <- function(path) {
  grepl("^(http|https):\\/\\/", path)
}

isstring <- function(x) {
  is.character(x) && length(x) == 1
}

isname <- function(x) {
  isstring(x) && grepl("^[a-z0-9_.-]+$", x)
}

isinteger <- function(x) {
  is.numeric(x) && (length(x) == 1) && (round(x) == x)
}

stripattributes <- function(x, keep = c("names")) {
  attr <- attributes(x)
  to_keep <- intersect(names(attr), keep)
  attr <- attr[to_keep]
  attributes(x) <- attr
  x
}

stripwhite <- function(x) {
  stopifnot(is.character(x))
  x <- gsub("^[[:space:]]*", "", x) 
  gsub("[[:space:]]*$", "", x) 
}

bareNumber <- function(x, warn = TRUE) {
  stopifnot(is.character(x))
  has_digit <- grepl("[[:digit:]]", x)
  has_digit[is.na(x)] <- NA
  if (warn && any(!has_digit, na.rm = TRUE)) {
    warning("Some elements of x do not contain digits. There are ignored")
  }
  regexp <- "(^[^[:digit:]+-]*)([[:digit:]+-].*)"
  prefix <- gsub(regexp, "\\1", x)
  remainder <- gsub(regexp, "\\2", x)
  prefix <- stripwhite(prefix)
  prefix[!has_digit | prefix == ""] <- NA
  regexp <- "(.*[[:digit:]+-])([^[:digit:]+-]*$)"
  postfix <- gsub(regexp, "\\2", remainder)
  remainder <- gsub(regexp, "\\1", remainder)
  postfix <- stripwhite(postfix)
  postfix[!has_digit | postfix == ""] <- NA
  remainder[!has_digit & !is.na(has_digit)] <- x[!has_digit & !is.na(has_digit)]
  data.frame(prefix = prefix, remainder = remainder, postfix = postfix)
}

