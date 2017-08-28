library(readr)
library(purrr)
library(stringr)
library(dplyr)

railtrails <- map_df(list.files("data-raw/rds_files", full.names = TRUE), read_rds, .id = "state")

# this is a clunky way of adding the state to the data for all of the states, and there is probably a better way using purrr::map2_df()
state_names <- list.files("data-raw/rds_files") %>%
    str_sub(end = -5L) %>%
    toupper()

state_names_df <- data_frame(state = seq(state_names),
                             state_name = state_names)

state_names_df <- mutate(state_names_df, state = as.character(state))

railtrails <- left_join(railtrails, state_names_df, by = "state")

railtrails <- select(railtrails, state = state_name, everything(), -state)

railtrails <- mutate(railtrails,
                     name = str_sub(name, end = -7L),
                     distance = str_sub(distance, end = -7L),
                     distance = as.numeric(distance))

devtools::use_data(railtrails, overwrite = T)
