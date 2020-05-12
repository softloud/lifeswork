# update data

library(googlesheets)
library(tidyverse)
library(janitor)


# measures ----------------------------------------------------------------

measures <- gs_key("1hv7pkBGu8XQQOIBbBt1_1LvKGBR7zTdQYCzogrv3hz0")

get_measures <- function(worksheet) {
  gs_read(measures, worksheet) 
}

get_quaver <- function(text) {
  str_replace_all(text, "quaver", "\U1D160")
}

get_quavers <- function(text) {
  str_replace_all(text, "quavers", "\U266B")
}

lifeswork_text <- function(text) {
  get_quavers(text) %>% 
    get_quaver()
}

instantiate <-  
  get_measures("instantiate") 

write_rds(instantiate, "data/instantiate.rds")

tasks <-  
  get_measures("daily_tasks") %>% 
  mutate(description = map_chr(description, lifeswork_text),
         task = map_chr(task, lifeswork_text)) %>% 
  mutate(
    p = priority,
    p = fct_relevel(p, "star", "sim", "varnothing"),
    c = category,
    c = fct_relevel(c, "theta", "psi", "pi"),
    priority = paste0("$\\", priority, "$"),
    category = paste0("$\\", category, "$")) %>% 
  arrange(c,p) 
  

write_rds(tasks, "data/tasks.rds")

review <-  get_measures("review")

write_rds(review, "data/review.rds")

dp <- gs_key("1FBzrWdlRX0IjiQSoamwx6-Ib22FUMEUmxvaSwfIj0Gg")

keybindings <- dp %>% gs_read("keybindings")

write_rds(keybindings, "data/keybindings.rds")

commands <- dp %>% gs_read("commands")

write_rds(commands, "data/commands.rds")

writing_tracker <- get_measures("tracker_template") %>% 
  clean_names()

write_rds(writing_tracker, "data/writing_tracker.rds")
