# 🚲 Cyclistic Bike-Share Case Study (Google Data Analytics Capstone)

## 📌 Project Overview

This project is part of the **Google Data Analytics Capstone** and focuses on analyzing historical bike-share data to support **Cyclistic**, a fictional Chicago-based company. The goal is to understand how **casual riders** and **annual members** use Cyclistic bikes differently and provide data-driven recommendations to increase annual memberships.

---

## 🎯 Business Task

**Primary Objective**: Determine how casual riders and annual members use Cyclistic bikes differently to inform marketing strategies aimed at converting casual riders into annual members.

---

## 📊 Tools Used

- **R / RStudio**
  - `tidyverse` (data wrangling)
  - `lubridate` (date-time manipulation)
  - `janitor` (column cleaning)
  - `ggplot2` (visualizations)
  - `readr` (CSV handling)

---

## 🧩 Data Sources

- Publicly available Divvy Bike trip data (provided by Motivate International Inc.)
- 12 months of `.csv` trip files from **August 2023 – July 2024**
- Source: [Divvy Trip Data](https://divvy-tripdata.s3.amazonaws.com/index.html)

Each file includes anonymized trip-level data such as:
- Start/End time
- Start/End station
- Rider type (member/casual)
- Rideable type (bike type)

---

## 🛠️ Data Cleaning & Processing

- Merged 12 monthly CSVs using `bind_rows()`
- Removed null values and blank rows/columns with `janitor::remove_empty()`
- Calculated:
  - `ride_length_seconds` using `difftime()`
  - `day_of_week` from ride start timestamps
- Filtered out rides with negative or 0-second durations
- Standardized weekday factor levels for plotting consistency

---

## 📈 Analysis Performed

- **Descriptive statistics** on ride length by rider type
- **Weekly trends**:
  - Number of rides and average ride time by day
- **Monthly trends**:
  - Ride volume across time by rider type
- **Bike usage** (if available): Usage of different rideable types

---

## 📊 Key Visualizations

- Bar chart: Number of rides by weekday (split by rider type)
- Line chart: Average ride duration by weekday
- Time series: Monthly ride trends by rider type

Visuals created using `ggplot2`.

---

## 📌 Key Findings

1. **Casual riders** take longer rides on average, especially on weekends.
2. **Members** ride more consistently across the week and prefer shorter, utilitarian trips.
3. Casual riders are more active during warmer months, suggesting seasonality plays a role in usage patterns.

---

## ✅ Recommendations

1. **Weekend Promotions**: Target casual riders with weekend-based membership discounts.
2. **In-app Nudges**: Highlight cost savings and features of annual memberships after long or repeated casual rides.
3. **Social Campaigns**: Leverage seasonality to push timely campaigns at the start of spring/summer to maximize conversion.

---

## 📁 Outputs

- `monthly_summary.csv` — Monthly ride count and average duration
- `weekday_summary.csv` — Rides and durations by day and user type
- All plots are viewable in the R script or exported upon request

---
