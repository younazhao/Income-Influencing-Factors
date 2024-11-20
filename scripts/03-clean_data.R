#### Preamble ####
# Purpose: Cleans the raw dataset from Federal Reserve of US Government 
# Author: Wen Han Zhao
# Date: 1 December 2024
# Contact: youna.zhao@mail.utoronto.ca
# License: MIT
# Pre-requisites: Need to downloaded libraries needed

#### Workspace setup ####
library(tidyverse)
library(arrow)
library(dplyr)

#### Clean data ####
raw_data <- read_parquet("data/01-raw_data/raw_data.parquet")

# Rename and select variables
clean_data <- raw_data %>% 
  mutate(
    Sex = ifelse(hhsex == 1, "male", 
                 ifelse(hhsex == 2, "female", NA)),
    ID = y1,
    Weight = wgt,
    Age = age,
    Education = case_when(educ == -1 ~ "Less than 1st grade",
                          educ == 1 ~ "1st, 2nd, 3rd, or 4th grade",
                          educ == 2 ~ "5th or 6th grade",
                          educ == 3 ~ "7th or 8th grade",
                          educ == 4 ~ "9th grade",
                          educ == 5 ~ "10th grade",
                          educ == 6 ~ "11th grade",
                          educ == 7 ~ "12th grade, no diploma",
                          educ == 8 ~ "High school graduate - high school diploma or equivalent",
                          educ == 9 ~ "Some college but no degree",
                          educ == 10 ~ "Associate degree in college - Occupation/vocation program",
                          educ == 11 ~ "Associate degree in college - academic program",
                          educ == 12 ~ "Bachelor's degree",
                          educ == 13 ~ "Master's degree",
                          educ == 14 ~ "Professional school degree and Doctorate degree"),
    Marital_status = ifelse(married == 1, "Married",
                            ifelse(married  == 2, "Not Married", NA)),
    Labor_force = ifelse(lf == 1, "Working in some way",
                         ifelse(lf == 0, "Not working at all", NA)),
    Work_status_category = case_when(occat1 == 1 ~ "Work for someone else",
                                     occat1 == 2 ~ "Self-employed/partnership", 
                                     occat1 == 3 ~ "Retired/Disabled", 
                                     occat1 == 4 ~ "Not working"),
    Occupation_Classification = case_when(occat2 == 1 ~ "Managerial/Professional",
                                          occat2 == 2 ~ "Technical/Sales/Services",
                                          occat2 == 3 ~ "other (production workers,farmers)",
                                          occat2 == 4 ~ "Not working")
  ) %>% 
  rename(num_sex = hhsex,
         num_work = occat1,
         num_occu = occat2) %>% 
  select(num_sex, Sex, ID, Weight, Age, Education, educ, Marital_status, married, Labor_force, lf, Work_status_category,
         num_work, Occupation_Classification, num_occu, income)

# Want positive income
clean_data <- clean_data |>
  filter(
    income > 0
  )

#### Save data ####
write_parquet(clean_data, "data/02-analysis_data/analysis_data.parquet")
