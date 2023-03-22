

# du.retrieve.full.dict <- function(dict_table, dict_kind) {
#   name <- variable <- label <- NULL
#   
#   dict_file_list <- list.files(paste0(getwd(), "/", dict_kind))
#   filename <- dict_file_list[grep(dict_table, dict_file_list)]
#   
#   filepath <- paste0(getwd(), "/", dict_kind, "/", filename)
#   vars <- read_xlsx(path = filepath, sheet = 1) %>% as_tibble()
#   if (length(excel_sheets(filepath)) == 2) {
#     cats <- read_xlsx(path = filepath, sheet = 2) %>% as_tibble()
#     cats <- cats %>%
#       rename(value = name, name = variable) %>%
#       mutate(name = as.character(name), label = as.character(label))
#     vars <- nest_join(vars, cats, by = "name")
#   } 
#   vars %>% bind_rows()
# }

library(readxl)
library(dplyr)

dictionary_project <- "athlete-project"
dictionary_name <- "chemicals_ath"
dictionary_version <- "1_1"
dictionary_type <- "non_rep"

excel_file <- paste0(
  "./dictionaries/", dictionary_name, "/", dictionary_version, "/", 
  dictionary_version, "_", dictionary_type, ".xlsx")

yaml_file <- paste0(
  "./dictionaries-yaml/", dictionary_name, "/", dictionary_version,
  "/", dictionary_version, "_", dictionary_type, ".yml")

filepath <- excel_file
vars <- read_xlsx(path = filepath, sheet = 1) %>% as_tibble()

dict <- yaml::yaml.load_file(yaml_file)
dict <- as_tibble(dict$Variables)
