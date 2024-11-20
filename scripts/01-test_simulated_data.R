#### Preamble ####
# Purpose: Tests the structure and validity of the simulated dataset
# Author: Wen Han Zhao
# Date: 1 December 2024
# Contact: youna.zhao@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - The `tidyverse` and `arrow` package must be installed and loaded
  # - 00-simulate_data.R must have been run

#### Workspace setup ####
library(tidyverse)
library(arrow)
library(testthat)

simulated_data <- read_parquet("data/00-simulated_data/simulated_data.parquet")

# Test if the data was successfully loaded
if (exists("simulated_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}

#### Test data ####

# Check if the dataset has 1000 rows
if (nrow(simulated_data) == 1000) {
  message("Test Passed: The simulated dataset has 1000 rows.")
} else {
  stop("Test Failed: The simulated dataset does not have 1000 rows.")
}

# Check if the dataset has 9 columns
if (ncol(simulated_data) == 9) {
  message("Test Passed: The dataset has 9 columns.")
} else {
  stop("Test Failed: The dataset does not have 9 columns.")
}

# Check if there are any missing values in the dataset
if (all(!is.na(simulated_data))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}

# Check if all values in the 'ID' column are unique
if (n_distinct(simulated_data$ID) == nrow(simulated_data)) {
  message("Test Passed: All values in 'ID' are unique.")
} else {
  stop("Test Failed: The 'ID' column contains duplicate values.")
}

# Check if the 'Education' column contains only valid education level
valid_educ <- c("Less than 1st grade", "1st, 2nd, 3rd, or 4th grade", "5th or 6th grade", "7th or 8th grade",
"9th grade", "10th grade", "11th grade", "12th grade, no diploma", 
"High school graduate - high school diploma or equivalent", "Some college but no degree",
"Associate degree in college - Occupation/vocation program", 
"Associate degree in college - academic program", "Bachelor's degree", "Master's degree",
"Professional school degree and Doctorate degree")

if (all(simulated_data$Education %in% valid_educ)) {
  message("Test Passed: The 'Education' column contains only valid Education Level.")
} else {
  stop("Test Failed: The 'Education' column contains invalid Education Level.")
}

# Check if the 'Work_status' column contains only valid work status
valid_work <- c("Work for someone else", "Self-employed/partnership", "Retired/Disabled", "Not working")

if (all(simulated_data$Work_status %in% valid_work)) {
  message("Test Passed: The 'Work_status' column contains only valid work status.")
} else {
  stop("Test Failed: The 'Work_status' column contains invalid work status.")
}

# Check if there are any missing values in the dataset
if (all(!is.na(simulated_data))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}

# Check if there are no empty strings in 'Education', 'Work_status', and 'Occupation' columns
if (all(simulated_data$Education != "" & simulated_data$Work_status != "" & simulated_data$Occupation != "")) {
  message("Test Passed: There are no empty strings in 'Education', 'Work_status', or 'Occupation'.")
} else {
  stop("Test Failed: There are empty strings in one or more columns.")
}

# Check if the 'Occupation' column has at least two unique values
if (n_distinct(simulated_data$Occupation) >= 2) {
  message("Test Passed: The 'Occupation' column contains at least two unique values.")
} else {
  stop("Test Failed: The 'Occupation' column contains less than two unique values.")
}

# Check the age is between 18 to 95 years old
if (min(simulated_data$age) >= 18 & max(simulated_data$age) <= 95) {
  message("Test Passed: The 'age' values are all between 18 and 95.")
} else {
  stop("Test Failed: The 'age' column contains at least one value <18 or >95.")
}

# Check Column Type 
test_that("Character columns are of type character", {
  expect_type(simulated_data$sex, "character")
  expect_type(simulated_data$Education, "character")
  expect_type(simulated_data$Marrital_status, "character")
  expect_type(simulated_data$Work_status, "character")
  expect_type(simulated_data$Occupation, "character")
})
