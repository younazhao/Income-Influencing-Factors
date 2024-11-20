#### Preamble ####
# Purpose: Simulates a dataset of Survey of Consumer Finances
# Author: Wen Han Zhao
# Date: 1 December 2024
# Contact: youna.zhao@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` and `arrow` package must be installed

#### Workspace setup ####

library(tidyverse)
library(arrow)
set.seed(853)
num_simulated_data <- 1000

#### Simulate data ####

# Sex 
sex <- c("Female", "Male")

# Age
age <- sample(18:95, size = num_simulated_data, replace = TRUE)

# Weight 
weight <- runif(num_simulated_data, min = 2.754882, max = 28265.28)

# Education
Education <- c("Less than 1st grade", "1st, 2nd, 3rd, or 4th grade", "5th or 6th grade", "7th or 8th grade",
               "9th grade", "10th grade", "11th grade", "12th grade, no diploma", 
               "High school graduate - high school diploma or equivalent", "Some college but no degree",
               "Associate degree in college - Occupation/vocation program", 
               "Associate degree in college - academic program", "Bachelor's degree", "Master's degree",
               "Professional school degree and Doctorate degree")

# Marrital Status
Marrital_status <- c("Married", "Not Married")

# Work Status
Work_status <- c("Work for someone else", "Self-employed/partnership", "Retired/Disabled", "Not working")

# Occupation Classification
Occupation <- c("Managerial/Professional", "Technical/Sales/Services", "Other (production workers,farmers)",
                "Not working")

# Income (Actual mean and sd from the dataset)
Income <- rnorm(num_simulated_data, mean = 1606631, sd = 12495518)
Income <- pmax(Income, 0) 

# Create a dataset by randomly assigning states and parties to divisions
simulated_data <- tibble(
  ID = sample(11:46035, size = num_simulated_data),
  sex = sample(sex, size = num_simulated_data, replace = TRUE, prob = c(0.4, 0.6)),
  age = age,
  weight = weight, 
  Education = sample(Education, size = num_simulated_data, replace = TRUE),
  Marrital_status = sample(Marrital_status, size = num_simulated_data, replace = TRUE),
  Work_status = sample(Work_status, size = num_simulated_data, replace = TRUE),
  Occupation = sample(Occupation, size = num_simulated_data, replace = TRUE),
  Income = Income
)

# arrange the simulated data by ID 
simulated_data <- simulated_data %>%
  arrange(ID)

#### Save data ####
write_parquet(simulated_data, "data/00-simulated_data/simulated_data.parquet")
