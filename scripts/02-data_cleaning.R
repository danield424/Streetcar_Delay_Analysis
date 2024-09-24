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
raw_data <- read_csv("data/raw_data/streetcar_delays2023.csv")
# only keep necessary variables for analysis
colnames(raw_data)
raw_data <- select(raw_data, Date, Line, Time, Day, `Min Delay`)

# only keep currently running streetcar lines, and observations with delays.
# also removed outlier delay times (2.5hrs+) as these were likely announced stoppages
# and streetcar riders would likely have been informed of them.
# keep note of the types of streetcar line (Regular, Reduced, Night)
unique(raw_data$Line)
cleaned_data <-
  raw_data |>
  janitor::clean_names() |>
  filter(min_delay > 0, min_delay < 150, line %in% c(301, 304, 306, 310, 501, 503, 504,
                                    505, 506, 507, 508, 509, 510, 511, 512)) |>
  mutate(service_type = case_when(line %in% c(507, 508) ~ "Reduced",
                                  line < 500 ~ "Night",
                                  .default = "Regular")) |>
  tidyr::drop_na()


# combine date and time into 1 column, reorder data frame by column name
cleaned_data$date <- as.POSIXct(paste(format(cleaned_data$date, "%Y-%m-%d"), cleaned_data$time), format = "%Y-%m-%d %H:%M:%S")
cleaned_data <- cleaned_data[, c("day", "date", "service_type", "line", "min_delay")]

glimpse(cleaned_data)
head(cleaned_data)
summary(cleaned_data)
unique(cleaned_data$line)

#### Save data ####
write_csv(cleaned_data, "data/analysis_data/delaydata.csv")



#### Test data ####
# Checks if Streetcar line numbers are valid
setequal(unique(cleaned_data$line), 
         c(301, 304, 306, 310,
           501, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512))

# Checks if all 11 day lines/5 night lines are within dataset
cleaned_data$line |>
  unique() |>
  length() == 11 + 4

# Checks constraints of delay minutes
cleaned_data$min_delay |> min() > 0

# Checks classes:

is.numeric(cleaned_data$line)
# Check if the 'date' column is in datetime format
inherits(cleaned_data$date, c("POSIXct", "POSIXlt"))
is.numeric(cleaned_data$min_delay)

