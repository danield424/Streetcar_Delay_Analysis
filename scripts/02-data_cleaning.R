#### Preamble ####
# Purpose: Cleans the raw streetcar data into an analyzable dataset 
# Author: Daniel Du
# Date: 24 September 2024
# Contact: danielc.du@mail.utoronto.ca
# License: MIT
# Pre-requisites: Need to have downloaded the data
# Any other information needed? Knowledge of existing streetcar lines

#### Workspace setup ####
library(tidyverse)
library(dplyr)

#### Clean data ####
raw_data2022 <- read_csv("data/raw_data/streetcar_delays2022.csv")
raw_data2023 <- read_csv("data/raw_data/streetcar_delays2023.csv")
raw_data2024 <- read_csv("data/raw_data/streetcar_delays2024.csv")

# Combine all 3 years into one data frame
raw_data <- rbind(raw_data2022, raw_data2023, raw_data2024)

# Only keep necessary variables for analysis I am conducting.
# Removed: station location, incident type, minute gap, bound, vehicle number
raw_data <- select(raw_data, Date, Line, Time, Day, `Min Delay`)

# We are only interested in analyzing observations of currently running streetcar lines, with a delay longer than 2 minutes. 
### currently running - more actionable information. /not outdated. 2 min: negligible from a passenger perspective
# We also filter outlier delay times (2hrs+), as these were likely announced stoppages streetcar riders were informed of ahead of time. 
# We add a variable to keep track of the type of streetcar service, based on line number (Regular, Reduced, Night)
cleaned_data <-
  raw_data |>
  janitor::clean_names() |>
  filter(min_delay > 2, min_delay < 120, line %in% c(301, 304, 305, 306, 310, 501, 503, 504,
                                    505, 506, 507, 508, 509, 510, 511, 512)) |>
  mutate(service_type = case_when(line %in% c(507, 508) ~ "Reduced",
                                  line < 500 ~ "Night",
                                  .default = "Regular")) |>
  tidyr::drop_na()


# We combine date and time into 1 column, and reorder the data frame's columns.
cleaned_data$date <- as.POSIXct(paste(format(cleaned_data$date, "%Y-%m-%d"), cleaned_data$time), format = "%Y-%m-%d %H:%M:%S")
cleaned_data <- cleaned_data[, c("day", "date", "service_type", "line", "min_delay")]

#### Save data ####
write_csv(cleaned_data, "data/analysis_data/delaydata.csv")

#### Test data ####
# Checks if Streetcar line numbers are valid
setequal(unique(cleaned_data$line), 
         c(301, 304, 305, 306, 310,
           501, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512))

# Checks if all 11 day lines/5 night lines are within dataset
cleaned_data$line |>
  unique() |>
  length() == 11 + 5

# Checks constraints of delay minutes
cleaned_data$min_delay |> min() > 2
cleaned_data$min_delay |> max() < 120

# Checks classes:

is.numeric(cleaned_data$line)
# Check if the 'date' column is in datetime format
inherits(cleaned_data$date, c("POSIXct", "POSIXlt"))
is.numeric(cleaned_data$min_delay)

