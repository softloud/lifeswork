# update data

library(googlesheets)
library(tidyverse)

measures <- gs_key("1hv7pkBGu8XQQOIBbBt1_1LvKGBR7zTdQYCzogrv3hz0")

instantiate <- measures %>% 
  gs_read("instantiate") 

write_rds(instantiate, "data/instantiate.rds")

tasks <- measures %>% gs_read("daily_tasks") %>% 
  mutate(
    p = priority,
    p = fct_relevel(p, "star", "sim", "varnothing"),
    c = category,
    c = fct_relevel(c, "theta", "psi", "pi"),
    priority = paste0("$\\", priority, "$"),
    category = paste0("$\\", category, "$")) %>% 
  arrange(c,p)
  

write_rds(tasks, "data/tasks.rds")

review <- measures %>% gs_read("review")

write_rds(review, "data/review.rds")

dp <- gs_key("1FBzrWdlRX0IjiQSoamwx6-Ib22FUMEUmxvaSwfIj0Gg")

keybindings <- dp %>% gs_read("keybindings")

write_rds(keybindings, "data/keybindings.rds")

commands <- dp %>% gs_read("commands")

write_rds(commands, "data/commands.rds")