#### Preamble ####
# Purpose: Tests the analysis data
# Author: Wen Han Zhao
# Date: 1 December 2024
# Contact: youna.zhao@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - The `tidyverse` and `arrow` package must be installed and loaded
  # - 03-clean_data.R must have been run


#### Workspace setup ####
library(tidyverse)
library(testthat)
library(arrow)

analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

# Test if the data was successfully loaded
if (exists("analysis_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}

#### Test data ####
# Test that the dataset has 22778 rows
test_that("dataset has 22778 rows", {
  expect_equal(nrow(analysis_data), 22778)
})

# Test that the dataset has 16 columns
test_that("dataset has 16 columns", {
  expect_equal(ncol(analysis_data), 16)
})

# Test that the 'Sex' column is character type
test_that("'sex' is character", {
  expect_type(analysis_data$Sex, "character")
})

# Test that the 'Education' column is character type
test_that("'Education' is character", {
  expect_type(analysis_data$Education, "character")
})

# Test that the 'Marital Status' column is character type
test_that("'Marital Status' is character", {
  expect_type(analysis_data$Marital_status, "character")
})

# Test that there are no missing values in the dataset
test_that("no missing values in dataset", {
  expect_true(all(!is.na(analysis_data)))
})

# Test that 'ID' contains unique values (no duplicates)
test_that("'ID' column contains unique values", {
  expect_equal(length(unique(analysis_data$ID)), 22778)
})

# Test that 'education' contains only valid Education level
valid_educ <- c("Less than 1st grade", "1st, 2nd, 3rd, or 4th grade", "5th or 6th grade", "7th or 8th grade",
                "9th grade", "10th grade", "11th grade", "12th grade, no diploma", 
                "High school graduate - high school diploma or equivalent", "Some college but no degree",
                "Associate degree in college - Occupation/vocation program", 
                "Associate degree in college - academic program", "Bachelor's degree", "Master's degree",
                "Professional school degree and Doctorate degree")
test_that("'educ' contains valid Education level", {
  expect_true(all(analysis_data$Education %in% valid_educ))
})

# Check if there are no empty strings in 'Education', 'Work_status', and 'Occupation' columns
if (all(analysis_data$Education != "" & analysis_data$Work_status_category != "" & analysis_data$Occupation_Classification != "")) {
  message("Test Passed: There are no empty strings in 'Education', 'Work_status', or 'Occupation'.")
} else {
  stop("Test Failed: There are empty strings in one or more columns.")
}

# Check if the 'Occupation' column has at least two unique values
if (n_distinct(analysis_data$Occupation_Classification) >= 2) {
  message("Test Passed: The 'Occupation' column contains at least two unique values.")
} else {
  stop("Test Failed: The 'Occupation' column contains less than two unique values.")
}

# Check the age is between 18 to 95 years old
if (min(analysis_data$Age) >= 18 & max(analysis_data$Age) <= 95) {
  message("Test Passed: The 'age' values are all between 18 and 95.")
} else {
  stop("Test Failed: The 'age' column contains at least one value <18 or >95.")
}
