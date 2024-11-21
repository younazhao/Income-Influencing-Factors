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

# Test that 'state' contains only valid Australian state or territory names
valid_states <- c("New South Wales", "Victoria", "Queensland", "South Australia", "Western Australia", 
                  "Tasmania", "Northern Territory", "Australian Capital Territory")
test_that("'state' contains valid Australian state names", {
  expect_true(all(analysis_data$state %in% valid_states))
})

# Test that there are no empty strings in 'division', 'party', or 'state' columns
test_that("no empty strings in 'division', 'party', or 'state' columns", {
  expect_false(any(analysis_data$division == "" | analysis_data$party == "" | analysis_data$state == ""))
})

# Test that the 'party' column contains at least 2 unique values
test_that("'party' column contains at least 2 unique values", {
  expect_true(length(unique(analysis_data$party)) >= 2)
})