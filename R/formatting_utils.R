
# Wrap string in ANSI code for bold
# Example: cat(bd(ul("Hello!")), c1("World"), "\n")
bd <- function(x) {
  paste0("\033[1m", x, "\033[0m")
}

# Wrap string in ANSI code for underline
ul <- function(x) {
  paste0("\033[4m", x, "\033[0m")
}

# Wrap string in ANSI code for Color 1
c1 <- function(x) {
  paste0("\033[31m", x, "\033[0m")
}

# Wrap string in ANSI code for Color 2
c2 <- function(x) {
  paste0("\033[32m", x, "\033[0m")
}

