library(readxl)
library(tidyverse)
library(janitor)
file <- "data/timetable_bio_stage1.xlsx"
sessions <- read_excel(file) %>% clean_names()
# 394 sessions
# Tidy: many sessions are repeated
# therefore separate the activity reference from the repeat number, 
# then filter so we have just the first incidence of Spring/summer
# sessions, the non-17C modules and the non-optional sessions
sessions <- sessions %>% 
  separate(activity_reference, 
           into = c("activity", "rep"),
           sep = "/") %>% 
  filter(rep == "01") %>% 
  filter(module_code != "BIO00017C-A") %>%
  filter(type != "Optional Activity") %>%
  filter(type != "Presentation") %>% 
  filter(type != "Field Trip") %>% 
  filter(str_detect(start_week, 'Spring|Summer'))
# this results in 92 sessions

# Number of sessions in each module

sessionssummary <- sessions %>% 
  group_by(module_code, type) %>% 
  summarise(n = length(type)) %>% 
  pivot_wider(names_from = type, values_from = n)

# module_code Lecture Practical Workshop
# BIO00004C        26         3        4
# BIO00007C         7         2        4
# BIO00009C        13         0        6
# BIO00010C        14         4        0
# BIO00011C        14         1        2
# BIO00012C        47         9        3

# write to file
file <- "data/sessions.csv"
write_excel_csv(sessions, path = file)
