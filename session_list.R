library(readxl)
library(tidyverse)
library(janitor)
file <- "data/timetable_bio_stage1.xlsx"
sessions <- read_excel(file) %>% clean_names()
# 394 sessions
sessions <- sessions %>% 
  separate(activity_reference, 
           into = c("activity", "rep"),
           sep = "/")
sessions <- sessions %>% 
  separate(duration, 
           into = c("hours", "mins"),
           sep = ":")
sessions$hours <- as.numeric(sessions$hours)


sessions <- sessions %>% 
  filter(rep == "01")
# 239 sessions
# 

nums <- str_count(sessions$staff_member_s, pattern = fixed("("))
hist(nums)
