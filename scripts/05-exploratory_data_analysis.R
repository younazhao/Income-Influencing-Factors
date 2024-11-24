#### Preamble ####
# Purpose: Explore the analysis dataset 
# Author: Wen Han Zhao
# Date: 1 December 2024
# Contact: youna.zhao@mail.utoronto.ca
# License: MIT
# Pre-requisites: Download the analysis data


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(glmnet)
library(ggplot2)

#### Read data ####
analysis_data <- read_parquet("data/analysis_data/analysis_data.parquet")

### Model data ####

lm_model <- lm(formula = income ~ Sex + educ + married + lf + num_work + num_occu, data = analysis_data)
prediction_1<- predict(lm_model, analysis_data)
summary(lm_model)

ggplot(analysis_data, aes(x = income, y = prediction_1)) +
  geom_point(color = 'blue') +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "red") +
  labs(title = "Actual vs Predicted Values",
       x = "Actual pct",
       y = "Predicted pct") +
  theme_minimal()

# Log transformation Model

analysis_data$log_income <- log(analysis_data$income)  # Add 1 to avoid log(0)
lm_model2 <- lm(log_income ~ Sex + educ + married + lf + num_work + num_occu, data = analysis_data)
prediction_2 <- predict(lm_model2, analysis_data)
summary(lm_model2)

ggplot(analysis_data, aes(x = log_income, y = prediction_2)) +
  geom_point(color = 'blue') +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "red") +
  labs(title = "Actual vs Predicted Values",
       x = "Actual pct",
       y = "Predicted pct") +
  theme_minimal()


#### Save model ####
saveRDS(
  lm_model2,
  file = "models/lm_model.rds"
)


