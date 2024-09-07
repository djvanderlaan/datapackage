
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
