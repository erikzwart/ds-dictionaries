

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

yaml_variable <- yaml::yaml.load(dict$Variables)

library(purrr)
vars2 <- purrr::map_dfr(yaml_variable, bind_rows)

all.equal(vars, vars2)

# catagories
cats <- read_xlsx(path = excel_file, sheet = 2) %>% as_tibble()
cats <- cats %>%
  rename(value = name, name = variable) %>%
  mutate(
    name = as.character(name),label = as.character(label))
vars <- nest_join(vars, cats, by = "name")

vars <- vars %>% bind_rows()

yaml_categories <- yaml::yaml.load(dict$Categories)

cats2 <- purrr::map_dfr(yaml_categories, bind_rows)

cats2 <- cats2 %>%
  rename(value = name, name = variable) %>%
  mutate(
    name = as.character(name),
    value = as.numeric(value),
    isMissing = as.logical(isMissing),
    label = as.character(label)
  )
vars2 <- nest_join(vars2, cats2, by = "name")

vars2 <- vars2 %>% bind_rows()

all.equal(vars, vars2)
