
isabsolutepath <- function(path) {
  # Starts with text followed by : (eg http: or c:)
  grepl("^[[:alpha:]]*[:]", path) || 
  # Starts with \ or /
    grepl("^[/\\\\]", path)
}

isstring <- function(x) {
  is.character(x) && length(x) == 1
}
