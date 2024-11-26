#### Preamble ####
# Purpose: Create a bayesian glm model to predict the Income
# Author: Wen Han Zhao
# Date: 1 December 2024
# Contact: youna.zhao@mail.utoronto.ca
# License: MIT
# Pre-requisites: Download the analysis data


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(arrow)
library(dplyr)

#### Read data ####
analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

#### Model data ####
first_model <- stan_glm(
  formula = income ~ Sex + educ + married + lf + num_work + num_occu,
  data = analysis_data,
  family = gaussian(),
  prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_intercept = normal(location = 500, scale = 100, autoscale = TRUE),
  prior_aux = exponential(rate = 1, autoscale = TRUE),
  seed = 853
)
summary(first_model)

# Second model
second_model <- stan_glm(
  formula = log(income) ~ Sex + educ + married + lf + num_work + num_occu,
  data = analysis_data,
  family = gaussian(),
  prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_intercept = normal(location = 10, scale = 5, autoscale = TRUE),
  prior_aux = exponential(rate = 1, autoscale = TRUE),
  seed = 853
)
summary(second_model)

# Save the model 1 in rds form
saveRDS(
  first_model,
  file = "models/bayesian_model_1.rds"
)

# Save the model 2 in rds form
saveRDS(
  second_model,
  file = "models/bayesian_model_2.rds"
)

# Create training and testing dataset
train_indice <- sample(seq_len(nrow(analysis_data)), size = 0.7 * nrow(analysis_data))
train_dataset <- analysis_data[train_indice, ]
test_dataset <- analysis_data[-train_indice, ]

# Save the training and testing dataset
write_parquet(train_dataset, "./data/02-analysis_data/train_dataset.parquet")
write_parquet(test_dataset, "data/02-analysis_data/test_dataset.parquet")

# Fit the model on the training dataset
bayesian_model_train <- stan_glm(
  formula = log(income) ~ Sex + educ + married + lf + num_work + num_occu,
  data = train_dataset,
  family = gaussian(),
  prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_intercept = normal(location = 10, scale = 5, autoscale = TRUE),
  seed = 853,
  cores = 4,
  adapt_delta = 0.95)

#### Save model ####
saveRDS(
  bayesian_model_train,
  file = "models/bayesian_model_train.rds"
)


