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

# All possible streetcar lines
lines <- c(501, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512)
# Generate times between 00:00 and 23:59
times <- sprintf("%02d:%02d", rep(0:23, each = 60), rep(0:59, 24))

# Simulate data with lines, times, and delay in minutes
simulated_data <-
  tibble(
    StreetcarLine = sample(lines,
      size = 100, replace = TRUE),
    Time = sample(times,
      size = 100, replace = TRUE),
    DelayMins = as.integer(rexp(n = 100, rate=0.1) + 3)
    # Delay simulated with exponential distribution, minimum 3 mins
  )

# Show 20 example entries
head(simulated_data, 20)

