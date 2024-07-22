# Cohort Analysis

This repository contains SQL queries for cleaning and analyzing data from Aruna's fishermen buying records.

## Description

The `cohort_analysis.sql` script consists of multiple steps to clean and analyze the data:

1. **Base Table Creation**: 
    - Selects relevant columns from the source table.
    - Cleans up `category` and `items` columns using `COALESCE` and `NULLIF` functions to handle empty strings.

2. **Filtered Data**: 
    - Filters out records with empty `items`, non-positive `quantity`, dates before July 1, 2023, and zero `amount`.

3. **Remove Duplicate Entries**: 
    - Uses `ROW_NUMBER` to identify and remove duplicate entries based on `id_buying`, `quantity`, `category`, and `items`.

4. **Determine Cohort Data**: 
    - Calculates the first buying date for each fisherman and derives the cohort date (first day of the month of the first purchase).

5. **Merge with Clean Data**: 
    - Joins the cleaned data with the cohort data to add cohort-related information.

6. **Calculate Cohort Index**: 
    - Computes the `cohort_index`, which represents the number of months since the first purchase.

## Contact

Feel free to reach me out if you have any question [here](mailto:dsafryda.putri@gmail.com).
