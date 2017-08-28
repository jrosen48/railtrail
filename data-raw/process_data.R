library(readr)
library(purrr)
library(stringr)
library(dplyr)

railtrails <- map_df(list.files("data-raw/rds_files", full.names = TRUE), read_rds)

railtrails <- mutate(railtrails,
                     name = str_sub(name, end = -7L),
                     distance = str_sub(distance, end = -7L))

devtools::use_data(railtrails, overwrite = T)
