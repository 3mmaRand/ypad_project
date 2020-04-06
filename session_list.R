library(readxl)
library(tidyverse)
library(janitor)
file <- "data/timetable_bio_stage1.xlsx"
sessions <- read_excel(file) %>% clean_names()
# 394 sessions
# Tidy: many sessions are repeated
# therefore separate the activity reference from the repeat number, 
# then filter so we have just the first incidence, the non-17C modules
# and the non-optional sesions
sessions <- sessions %>% 
  separate(activity_reference, 
           into = c("activity", "rep"),
           sep = "/") %>% 
  filter(rep == "01") %>% 
  filter(module_code != "BIO00017C-A") %>%
  filter(type != "Optional Activity") %>%
  filter(type != "Presentation")
# this results in 167 sessions

# Number of sessions in each module

sessionssummary <- sessions %>% 
  group_by(module_code, type) %>% 
  summarise(n = length(type))

# write to file
file <- "data/sessions.xlsx"
write_excel_csv(sessions, path = file)
