#### Preamble ####
# Purpose: Test data
# Author: Daniel Du
# Date: 24 September 2024
# Contact: danielc.du@mail.utoronto.ca
# License: MIT
# Pre-requisites: Need to have simulated data
# Any other information needed? Once data has been acquired and cleaned, adjust and update tests accordingly.


#### Workspace setup ####
library(tidyverse)
# [...UPDATE THIS...]

#### Test data ####
# Checks if Streetcar line numbers are valid
setequal(unique(simulated_data$StreetcarLine), 
         c(501, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512))

# Checks if all 11 lines are within dataset
simulated_data$StreetcarLine |>
  unique() |>
  length() == 11

# Checks constraints of delay time and delay minutes
# note in actual data the time format will be in datetime, not strings.
simulated_data$Time |> min() == "00:00"
simulated_data$Time |> max() == "23:59" 
simulated_data$DelayMins |> min() >= 3

# Checks classes:
is.numeric(simulated_data$StreetcarLine)
# Check if the 'Time' column is in datetime format
inherits(simulated_data$Time, c("POSIXct", "POSIXlt"))
is.numeric(simulated_data$DelayMins)

