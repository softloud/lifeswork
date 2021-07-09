# update data

library(googlesheets4)
library(tidyverse)
library(janitor)


# measures ----------------------------------------------------------------

# function to get 

get_measures <- function(worksheet) {
  read_sheet(Sys.getenv("MEASURES"), sheet = worksheet) 
}

# replace quaver with html symbol

get_quaver <- function(text) {
  str_replace_all(text, "quaver", "\U1D160")
}

# replace quavers with html symbol

get_quavers <- function(text) {
  str_replace_all(text, "quavers", "\U266B")
}

lifeswork_text <- function(text) {
  get_quavers(text) %>% 
    get_quaver()
}

# instantiate 

instantiate <-  
  get_measures("instantiate") 

write_rds(instantiate, "data/instantiate.rds")

# tasks

tasks <-  
  get_measures("daily_tasks") %>% 
  mutate(description = map_chr(description, lifeswork_text),
         task = map_chr(task, lifeswork_text)) %>% 
  mutate(
    p = status,
    p = fct_relevel(p, "star", "sim", "varnothing"),
    c = category,
    c = fct_relevel(c, "phi", "pi", "theta", "psi", )
    # gt doesn't currently support TeX
    # status = paste0("$\\", status, "$"),
    # category = paste0("$\\", category, "$")
    ) %>% 
  arrange(c,p) %>% 
  select(-c, -p)
  

write_rds(tasks, "data/tasks.rds")

# review

review <-  get_measures("review")

write_rds(review, "data/review.rds")


# dontpanic ---------------------------------------------------------------

keybindings <- read_sheet(Sys.getenv("DONTPANIC"), "keybindings")

write_rds(keybindings, "data/keybindings.rds")

commands <- read_sheet(Sys.getenv("DONTPANIC"), "commands")

write_rds(commands, "data/commands.rds")
