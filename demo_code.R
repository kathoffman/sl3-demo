########################## .
# A simple demo of sl3
# R-Ladies NYC Sept. 2019
# Kat Hoffman
########################## .

# Code modified from:
# https://tlverse.org/acic2019-workshop/ensemble-machine-learning.html

# Load libraries, set seed ----------------------------------------------------------

#devtools::install_github("tlverse/sl3")
library(sl3)
library(tidyverse)

set.seed(7)

# Load data, specify outcome and covariates -------------------------------

washb_data <- read.csv("https://raw.githubusercontent.com/tlverse/tlverse-data/master/wash-benefits/washb_data.csv")

outcome <- "whz"
covars <- washb_data %>%
  select(-whz) %>%
  names()

washb_task <- make_sl3_Task(
  data = washb_data,
  covariates = covars,
  outcome = outcome
)

sl3_list_properties()
sl3_list_learners("continuous")

sl_stack_simple <- make_learner_stack(
  "Lrnr_randomForest", 
  "Lrnr_xgboost",
  "Lrnr_glm"
)

metalearner <- make_learner(Lrnr_nnls)

sl <- make_learner(Lrnr_sl, 
                   sl_stack_simple,
                   metalearner = metalearner)

sl_fit <- sl$train(washb_task)
sl_fit

sl_fit$predict(washb_task)


