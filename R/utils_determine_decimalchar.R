

determine_decimalchar <- function(fields, default = ".") {
  if (is.null(fields)) return(default)
  dec <- sapply(fields, function(x, default = default) {
      if (x$type == "number") {
        if (exists("decimalChar", x)) x$decimalChar else default
      } else character(0)
    }, default = default) |> Reduce(f = c) |> unique() 
  if (length(dec) >= 1) dec[1] else default
}

