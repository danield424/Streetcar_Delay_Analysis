#### Preamble ####
# Purpose: Simulates streetcar delay time data.
# Author: Daniel Du
# Date: September 24, 2024
# Contact: danielc.du@mail.utoronto.ca
# License: MIT
# Pre-requisites: None
# Any other information needed? None


#### Workspace setup ####
library(tidyverse)

#### Simulate data ####
set.seed(424)

times <- sprintf("%02d:%02d", rep(0:23, each = 60), rep(0:59, 24))

simulated_data <-
  tibble(
    StreetcarLine = sample(lines = c("501", "503", "504", "505", "506", "507", 
                                     "508", "509", "510", "511", "512"),
      size = 100, replace = TRUE),
    Time = sample(times,
      size = 100, replace = TRUE),
    DelayMins = as.integer(rexp(n = 100, rate=0.1))
  )

head(simulated_data)




