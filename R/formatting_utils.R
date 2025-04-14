
# Wrap string in ANSI code for bold
# Example: cat(bd(ul("Hello!")), c1("World"), "\n")
bd <- function(x) {
  if (ansi_ok()) {
    paste0("\033[1m", x, "\033[0m")
  } else {
    paste0(x)
  }
}

# Wrap string in ANSI code for underline
ul <- function(x) {
  if (ansi_ok()) {
    paste0("\033[4m", x, "\033[0m")
  } else {
    paste0(x)
  }
}

# Wrap string in ANSI code for Color 1
c1 <- function(x) {
  if (ansi_ok()) {
    paste0("\033[31m", x, "\033[0m")
  } else {
    paste0(x)
  }
}

# Wrap string in ANSI code for Color 2
c2 <- function(x) {
  if (ansi_ok()) {
    paste0("\033[32m", x, "\033[0m")
  } else {
    paste0(x)
  }
}


ansi_ok <- function() {
  # check if we already checked this
  if (!is.null(getOption("ANSI_OUTPUT"))) {
    return(getOption("ANSI_OUTPUT"))
  }
  # if not try to determine if console supports ansi codes
  if (.Platform$GUI == "AQUA" || 
    .Platform$GUI == "Rgui" || 
    Sys.getenv("NO_COLOR") != "" || 
    identical(tolower(trimws(Sys.getenv("TERM"))), "dumb")
  ) {
    options("ANSI_OUTPUT" = FALSE)
    FALSE
  } else {
    options("ANSI_OUTPUT" = TRUE)
    TRUE
  }
}

