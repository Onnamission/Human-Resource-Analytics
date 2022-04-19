# Code written by Aditya Kakde, owner of account @Onnamission

library(tidyverse)
library(janitor)
library(skimr)
library(lubridate)


# Setting working directory
print(getwd())
setwd("D:/Business Analytics/PROJECT 2")
print(getwd())

dff = read.csv('Dataset/Human_Resources.csv')

View(dff)


# Data Cleaning Pipeline
clean = dff %>%
  drop_na() %>%
  janitor::clean_names()
# Can't remove blank values right now
View(clean)


# Checking data types
sapply(clean, class)


# Converting ID from character to numeric
clean$i_id = as.numeric(as.factor(clean$i_id))

sapply(clean, class)

View(clean)


# Converting DATE/DATE-TIME from character to date

abis1 = strptime(as.character(clean$hire_date),format="%m/%d/%Y") # defining what is the original format of date
clean$hire_date = as.Date(abis1,format="%Y-%m-%d") # defining what is the desired format of date

abis2 = strptime(as.character(clean$birthdate),format="%m/%d/%Y") # defining what is the original format of date
clean$birthdate = as.Date(abis2,format="%Y-%m-%d") # defining what is the desired format of date

abis3 = strptime(as.character(clean$termdate),format="%Y-%m-%d") # defining what is the original format of date
clean$termdate = as.Date(abis3,format="%Y-%m-%d") # defining what is the desired format of date

sapply(clean, class)

View(clean)


# Fill blank in termdate with hire_date in place of NA(s)
clean$termdate[is.na(clean$termdate)] = clean$hire_date

View(clean)


# Adding age column
emp_age = time_length(difftime(clean$hire_date, clean$birthdate),"years")

age = c(emp_age)

clean$age = age  # putting calculated age

clean$age = round(clean$age) # putting rounded age

View(clean)


# Adding active employee column
act_emp = time_length(difftime(clean$termdate, clean$hire_date),"years")

active_emp = c(act_emp)

clean$active_emp = active_emp  # putting calculated active employee

clean$active_emp = round(clean$active_emp) # putting rounded active employee

clean$active_emp[clean$active_emp > 0] = 1
clean$active_emp[clean$active_emp <= 0] = 0

View(clean)


# Adding stay duration column
sty_dur = time_length(difftime(clean$termdate, clean$hire_date),"years")

stay_dur = c(sty_dur)

clean$stay_dur = stay_dur  # putting calculated stay duration

clean$stay_dur = round(clean$stay_dur) # putting rounded stay duration

clean$stay_dur[clean$stay_dur <= 0] = 0

View(clean)


# Replacing sales value with engineering as it makes more logic
clean$department[clean$jobtitle == "Solutions Engineer Manager"] = "Engineering"

View(clean)


# Renaming column name
colnames(clean) = c("id", 
                    "first_name", 
                    "last_name", 
                    "birth_date", 
                    "gender", 
                    "race", 
                    "department", 
                    "jobtitle", 
                    "location", 
                    "hire_date", 
                    "term_date",
                    "city", 
                    "state", 
                    "age",
                    "active_emp",
                    "stay_dur")


# Again cleaning process
na_if(clean, "")
aut_data = na.omit(clean)

View(aut_data)


sapply(aut_data, class)


write.csv(aut_data, "hr.csv", row.names = FALSE)
