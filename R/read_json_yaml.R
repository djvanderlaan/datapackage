

# Utility function reading schema from a json/yaml file. Automatically tries
# to detect if the file is a yaml file or a json file using the extension. If
# that is not possible it is assumed the file is a json file.
read_json_yaml <- function(filename, type = c("detect", "json", "yaml")) {
  type <- match.arg(type)
  if (type == "detect") {
    ext <- tools::file_ext(filename) |> tolower()
    if (ext %in% c("yaml", "yml")) {
      type <- "yaml" 
    } else {
      type <- "json"
    }
  }
  if (type == "json") {
    jsonlite::read_json(filename, simplifyVector = TRUE, 
      simplifyDataFrame = FALSE, simplifyMatrix = FALSE)
  } else if (type == "yaml") {
    yaml::read_yaml(filename)
  }
}

