# Convert existing dictionaries from excel (Sheet 1 and 2) to yaml.
# And add dictionary settings.
library(readxl)

dictionary_name <- "chemicals_ath"
dictionary_version <- "1_1"
dictionary_type <- "yearly_rep"

excel_file <- paste0(
  "./dictionaries/", dictionary_name, "/", dictionary_version, "/", 
  dictionary_version, "_", dictionary_type, ".xlsx")
yaml_file <- paste0(
  "./dictionaries-yaml/", dictionary_name, "/", dictionary_version,
  "/", dictionary_version, "_", dictionary_type, ".yml")

variables <- readxl::read_excel(
  path = excel_file,
  sheet = 1
)

categories <- readxl::read_excel(
  path = excel_file,
  sheet = 2,
  col_types = "text"
)

yaml::write_yaml(
  data.frame(
    dictionary = data.frame(
      name = dictionary_name,
      version = dictionary_version,
      type = dictionary_type
    ),
    Variables = yaml::as.yaml(
      x = variables,
      column.major = FALSE),
    Categories = yaml::as.yaml(
      x = categories,
      column.major = FALSE
    )
  ),
  file = yaml_file
)
