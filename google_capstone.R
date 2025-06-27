#Installing the packages
install.packages('tidyverse')
install.packages('janitor')
install.packages('lubridate')

#Loading the packages
library(tidyverse)
library(janitor)
library(lubridate)
library(dplyr)
library(ggplot2)
library(readr)

#Import csv files
Aug2023 <- read_csv("Downloads/Google_Capstone(DivvyMonthlyTripData)/08_2023.csv")
Sep2023 <- read_csv("Downloads/Google_Capstone(DivvyMonthlyTripData)/09_2023.csv")
Oct2023 <- read_csv("Downloads/Google_Capstone(DivvyMonthlyTripData)/10_2023.csv")
Nov2023 <- read_csv("Downloads/Google_Capstone(DivvyMonthlyTripData)/11_2023.csv")
Dec2023 <- read_csv("Downloads/Google_Capstone(DivvyMonthlyTripData)/12_2023.csv")
Jan2024 <- read_csv("Downloads/Google_Capstone(DivvyMonthlyTripData)/01_2024.csv")
Feb2024 <- read_csv("Downloads/Google_Capstone(DivvyMonthlyTripData)/02_2024.csv")
Mar2024 <- read_csv("Downloads/Google_Capstone(DivvyMonthlyTripData)/03_2024.csv")
Apr2024 <- read_csv("Downloads/Google_Capstone(DivvyMonthlyTripData)/04_2024.csv")
May2024 <- read_csv("Downloads/Google_Capstone(DivvyMonthlyTripData)/05_2024.csv")
Jun2024 <- read_csv("Downloads/Google_Capstone(DivvyMonthlyTripData)/06_2024.csv")
Jul2024 <- read_csv("Downloads/Google_Capstone(DivvyMonthlyTripData)/07_2024.csv")

#Format Cleaning
str(Aug2023)
str(Sep2023)
str(Oct2023)
str(Nov2023)
str(Dec2023)
str(Jan2024)
str(Feb2024)
str(Mar2024)
str(Apr2024)
str(Jun2024)
str(Jul2024)

#Merging all months under one table
all_months <- bind_rows(Aug2023, Sep2023, Oct2023, Nov2023, Dec2023, 
Jan2024, Feb2024, Mar2024, Apr2024, May2024, Jun2024, Jul2024)

#Cleaning & removing any spaces, parentheses, etc.
all_months <- clean_names(all_months)

#Remove any empty columns and rows 
remove_empty(all_months, which = c())

#Length of each ride
all_months <- all_months %>%
  mutate(ride_length_seconds = as.numeric(difftime(ended_at, started_at, units = "secs")),
         ride_length = sprintf("%02d:%02d:%02d", 
                               as.integer(ride_length_seconds) %/% 3600,         # Hours
                               as.integer(ride_length_seconds) %% 3600 %/% 60,   # Minutes
                               as.integer(ride_length_seconds) %% 60))           # Seconds
# Day of each ride
all_months <- all_months %>%
  mutate(day_of_week = weekdays(started_at))

# Remove rides with invalid or negative duration
all_months <- all_months %>%
  filter(ride_length_seconds > 0)

# Standardize weekday ordering
all_months$day_of_week <- factor(all_months$day_of_week,
                                 levels = c("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"))

# Summary stats overall
all_months %>% summarize(
  mean_length = mean(ride_length_seconds),
  median_length = median(ride_length_seconds),
  max_length = max(ride_length_seconds),
  min_length = min(ride_length_seconds)
)

# By membership type
all_months %>%
  group_by(member_casual) %>%
  summarize(
    count = n(),
    avg_length = mean(ride_length_seconds),
    median_length = median(ride_length_seconds),
    sd_length = sd(ride_length_seconds)
  )

# Activity Patterns by Day of Week
day_summary <- all_months %>%
  group_by(member_casual, day_of_week) %>%
  summarize(
    num_rides = n(),
    avg_length = mean(ride_length_seconds)
  ) %>%
  arrange(member_casual, day_of_week)

print(day_summary)

# Visualizations

# Rides per day by member type
ggplot(day_summary, aes(x = day_of_week, y = num_rides, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(title = "Number of Rides per Day by Membership Type",
       x = "Day of Week", y = "Total Rides", fill = "User Type")

# Avg ride duration by day
ggplot(day_summary, aes(x = day_of_week, y = avg_length/60, color = member_casual, group = member_casual)) +
  geom_line(size=1.5) + geom_point(size=3) +
  labs(title = "Average Ride Duration (minutes) per Day",
       x = "Day of Week", y = "Avg Duration (min)")

# Monthly trends
monthly_summary <- all_months %>%
  mutate(month = floor_date(started_at, "month")) %>%
  group_by(member_casual, month) %>%
  summarize(
    num_rides = n(),
    avg_length = mean(ride_length_seconds)
  ) %>%
  arrange(member_casual, month)

# Plot monthly ride counts
ggplot(monthly_summary, aes(x = month, y = num_rides, color = member_casual)) +
  geom_line() + geom_point() +
  labs(title = "Monthly Ride Count by User Type",
       x = "Month", y = "Total Rides")

# Analyze rideable types
if("rideable_type" %in% names(all_months)) {
  all_months %>%
    group_by(member_casual, rideable_type) %>%
    summarize(count = n(), avg_duration = mean(ride_length_seconds)) %>%
    ggplot(aes(x = rideable_type, y = count, fill = member_casual)) +
    geom_col(position="dodge") +
    labs(title = "Rideable Type Usage by User Type", x = "Rideable Type", y = "Count")
}


# Report

# Save monthly summary
write_csv(monthly_summary, "google-data-analytics/monthly_summary.csv")

# Save weekday summary
write_csv(day_summary, "google-data-analytics/weekday_summary.csv")
