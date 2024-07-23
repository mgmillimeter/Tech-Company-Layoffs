-- MYSQL DATA CLEANING PROJECT
-- SQL Data Cleaning Documentation
-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Handle Null or Blank Values
-- 4. Remove Unnecessary Columns

-- **SQL CLEANING SCRIPT**

-- INSPECT THE DATASET
SELECT *
FROM layoffs_data
LIMIT 1000;
-- View the first 1000 rows to understand the structure and content of the dataset

-- STEP 1: REMOVE DUPLICATES

-- #### Note: Prior to performing any data cleaning operations on the dataset, ensure that a separate copy of the original table is created. This step is crucial to preserve the integrity of the original data and to enable a controlled and reversible approach to data cleaning and analysis.

-- Create a staging table 'layoffs_data_staging' based on the structure of 'layoffs_data'
CREATE TABLE layoffs_data_staging 
LIKE layoffs_data;

-- Insert all records from 'layoffs_data' into 'layoffs_data_staging'
INSERT INTO layoffs_data_staging
SELECT * FROM layoffs_data;

-- Add a row number to identify duplicates within 'layoffs_data_staging'
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, layoff_count, `date`,
    `source`, funds_raised_millions, stage, date_added,
    country, layoff_percentage, employees_layoff_list) AS records
FROM layoffs_data_staging;
-- Generate row numbers partitioned by key columns to identify duplicate rows

-- Check for duplicates using a CTE (Common Table Expression)
WITH cte_layoffs_duplicates AS (
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, layoff_count, `date`,
    `source`, funds_raised_millions, stage, date_added,
    country, layoff_percentage, employees_layoff_list) AS records
FROM layoffs_data_staging
)
-- Select rows identified as duplicates
SELECT *
FROM cte_layoffs_duplicates
WHERE records > 1;
-- Use CTE to select rows with duplicate records for further inspection

-- Create 'layoffs_data_staging2' table to hold partially cleaned data with the `record` row to house the duplicate(s).
CREATE TABLE `layoffs_data_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `layoff_count` text,
  `date` text,
  `source` text,
  `funds_raised_millions` int DEFAULT NULL,
  `stage` text,
  `date_added` text,
  `country` text,
  `layoff_percentage` text,
  `employees_layoff_list` text,
  `records` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
-- Create a new staging table to include a 'records' column for duplicate identification

-- Insert data into 'layoffs_data_staging2', excluding duplicates identified by 'records'
INSERT INTO layoffs_data_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, layoff_count, `date`,
    `source`, funds_raised_millions, stage, date_added,
    country, layoff_percentage, employees_layoff_list) AS records
FROM layoffs_data_staging;
-- Populate 'layoffs_data_staging2' with data including row numbers for duplicates

-- Display the contents of 'layoffs_data_staging2' to verify insertion
SELECT *
FROM layoffs_data_staging2;
-- Verify that the data has been correctly inserted into the new staging table

-- Delete and update the table to remove the duplicate rows
DELETE
FROM layoffs_data_staging2
WHERE records > 1;
-- Remove duplicate rows based on the 'records' column

-- Clean up whitespace and normalize data fields

-- Trim leading and trailing whitespace from 'company', 'location', 'industry', and 'country'
UPDATE layoffs_data_staging2
SET company = TRIM(company),
    location = TRIM(location),
    layoff_count = TRIM(layoff_count),
    industry = TRIM(industry),
    country = TRIM(country);
-- Remove any leading or trailing whitespace from specified columns

-- Identify rows with potential encoding issues in 'location' column
SELECT company, country, location    
FROM layoffs_data_staging2
WHERE location REGEXP '[^a-zA-Z0-9 .,!?]';
-- Find rows with special or unknown characters in the 'location' field

-- Correct specific location names with encoding issues
UPDATE layoffs_data_staging2
SET location = CASE
    WHEN location = 'FlorianÃ³polis' THEN 'Florianópolis'
    WHEN location = 'MalmÃ¶' THEN 'Malmö'
    WHEN location = 'DÃ¼sseldorf' THEN 'Düsseldorf'
    WHEN location = 'FÃ¸rde' THEN 'Førde'
    ELSE location
END
WHERE location IN ('FlorianÃ³polis', 'MalmÃ¶', 'DÃ¼sseldorf', 'FÃ¸rde');
-- Fix known encoding issues in the 'location' column

-- STEP 2: CONVERT AND STANDARDIZE DATA TYPES

-- Identify rows where 'funds_raised_millions' is blank
SELECT *
FROM layoffs_data_staging2
WHERE funds_raised_millions = '';
-- Inspect rows with blank 'funds_raised_millions' for further action

-- Convert 'layoff_count' values from TEXT to INT
UPDATE layoffs_data_staging2
SET layoff_count = NULLIF(layoff_count, ''),
    layoff_count = CAST(layoff_count AS SIGNED INTEGER),
    layoff_percentage = NULLIF(layoff_percentage, ''),
    layoff_percentage = CAST(layoff_percentage AS FLOAT);
-- Handle blank values and cast 'layoff_count' and 'layoff_percentage' to appropriate types

-- Update and Modify the 'layoff_count' column from TEXT TO INT format
ALTER TABLE layoffs_data_staging2
MODIFY COLUMN layoff_count INT NULL;
-- Modify the column type of 'layoff_count' to INT

-- Inspect and verify the `date` column
SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_data_staging2;
-- Check the current format of the 'date' column

-- Convert 'date' values from TEXT to DATE format
UPDATE layoffs_data_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
-- Update 'date' column to DATE format

-- Update and Modify the `date` column from TEXT TO DATE format
ALTER TABLE layoffs_data_staging2
MODIFY COLUMN `date` DATE;
-- Modify the column type of 'date' to DATE

-- Convert 'layoff_percentage' values from TEXT to FLOAT
UPDATE layoffs_data_staging2
SET layoff_percentage = NULLIF(layoff_percentage, ''),
    layoff_percentage = CAST(layoff_percentage AS FLOAT);
-- Handle blank values and cast 'layoff_percentage' to FLOAT

-- Update and Modify the 'layoff_percentage' column from TEXT TO FLOAT format
ALTER TABLE layoffs_data_staging2
MODIFY COLUMN layoff_percentage FLOAT NULL;
-- Modify the column type of 'layoff_percentage' to FLOAT

-- STEP 3: HANDLE NULL VALUES

-- Inspect and verify if both columns `layoff_count` & `layoff_percentage` are blank & NULL
SELECT company, layoff_count, layoff_percentage
FROM layoffs_data_staging2
WHERE layoff_count IS NULL
    AND layoff_percentage IS NULL;
-- Check for rows where both 'layoff_count' and 'layoff_percentage' are NULL

-- Delete rows where both 'layoff_count' and 'layoff_percentage' are blank & NULL
DELETE FROM layoffs_data_staging2
WHERE layoff_count IS NULL
    AND layoff_percentage IS NULL;
-- Remove rows with NULL values in both 'layoff_count' and 'layoff_percentage'

-- STEP 4: REMOVE UNNECESSARY COLUMN(S)

-- Drop unnecessary column(s): 'records'
ALTER TABLE layoffs_data_staging2
DROP COLUMN records;
-- Drop the 'records' column now that duplicates have been removed

-- Final check on cleaned data in 'layoffs_data_staging2'
SELECT *
FROM layoffs_data_staging2;
-- Verify the final cleaned data in the staging table




-- *** EXPLORATORY DATA ANALYSIS ON TECH COMPANIES LAYOFFS ***
-- dataset source: https://layoffs.fyi/

-- *** DATA INSPECTION ***

-- Retrieve all data from the cleaned table to inspect the current state of the dataset.
SELECT *
FROM layoffs_data_staging2;
-- This query selects all columns and rows from the `layoffs_data_staging2` table, allowing for an initial examination of the dataset's structure and contents.

-- Calculate the maximum number of layoffs recorded in a single entry to understand the scale of layoffs.
SELECT MAX(layoff_count) AS max_layoff_count,
       MIN(layoff_count) AS min_layoff_count
FROM layoffs_data_staging2;
-- This query finds the highest and lowest values in the `layoff_count` column to identify the maximum and minimum layoffs recorded in any single entry.

-- Retrieve the earliest and latest dates in the dataset to understand the time range covered by the data.
SELECT MIN(`date`) AS data_start_date, 
       MAX(`date`) AS data_end_date
FROM layoffs_data_staging2;
-- This query determines the earliest and latest dates in the `date` column to understand the time range covered by the dataset.

-- *** COMPANY STATISTICS ***

-- Calculate the total number of layoffs for each company, ordered by the highest total layoffs, to identify which companies had the most layoffs.
SELECT company, SUM(layoff_count) AS total_layoff
FROM layoffs_data_staging2
GROUP BY company
ORDER BY total_layoff DESC;
-- This query groups the data by `company`, calculates the total number of layoffs for each company, and orders the results in descending order to highlight companies with the most layoffs.

-- Retrieve the top 10 companies with the most layoffs.
SELECT company, SUM(layoff_count) AS top10_company_layoffs
FROM layoffs_data_staging2
GROUP BY company
HAVING top10_company_layoffs IS NOT NULL
ORDER BY top10_company_layoffs DESC
LIMIT 10;
-- This query calculates the total layoffs for each company, orders the results in descending order, and limits the output to the top 10 companies with the highest layoffs.

-- *** INDUSTRY STATISTICS ***

-- Calculate the total number of layoffs for each industry, ordered by the highest total layoffs, to identify which industries were most affected.
SELECT industry, SUM(layoff_count) AS total_layoff
FROM layoffs_data_staging2
GROUP BY industry
ORDER BY total_layoff DESC;
-- This query groups the data by `industry`, calculates the total number of layoffs for each industry, and orders the results in descending order to show the industries most affected by layoffs.

-- Calculate the average percentage of layoffs for each industry, ordered by the highest average percentage, to understand which industries had the highest relative impact.
SELECT industry, ROUND(AVG(layoff_percentage)*100, 2) AS avg_layoff_percentage
FROM layoffs_data_staging2
GROUP BY industry
ORDER BY avg_layoff_percentage DESC;
-- This query calculates the average percentage of layoffs for each industry, rounds it to two decimal places, and orders the results in descending order to identify industries with the highest relative impact of layoffs.

-- Retrieve the top 10 industries with the highest average layoff percentage.
SELECT industry, ROUND(AVG(layoff_percentage)*100, 2) AS top10_avg_layoff_percentage
FROM layoffs_data_staging2
GROUP BY industry
ORDER BY top10_avg_layoff_percentage DESC
LIMIT 10;
-- This query calculates the average layoff percentage for each industry, orders the results in descending order, and limits the output to the top 10 industries with the highest average layoff percentage.

-- *** CONTINENT & COUNTRY STATISTICS ***

-- Create a `continent` column for further analysis.
ALTER TABLE layoffs_data_staging2
ADD COLUMN continent TEXT;

-- Update the 'continent' column based on the values in the 'country' column.
UPDATE layoffs_data_staging2
SET continent = CASE
    WHEN country IN ('Argentina', 'Brazil', 'Chile', 'Colombia', 'Peru', 'Uruguay') THEN 'South America'
    WHEN country IN ('Australia', 'New Zealand') THEN 'Oceania'
    WHEN country IN ('Austria', 'Belgium', 'Czech Republic', 'Denmark', 'Estonia', 'Finland', 'France', 'Germany', 'Greece', 'Hungary', 'Ireland', 'Italy', 'Lithuania', 'Luxembourg', 'Netherlands', 'Norway', 'Poland', 'Portugal', 'Romania', 'Russia', 'Spain', 'Sweden', 'Switzerland', 'Ukraine', 'United Kingdom') THEN 'Europe'
    WHEN country IN ('Bahrain', 'China','Hong Kong', 'India', 'Indonesia', 'Israel', 'Japan', 'Malaysia', 'Pakistan','Turkey', 'Philippines', 'Singapore', 'South Korea', 'Thailand', 'Vietnam') THEN 'Asia'
    WHEN country IN ('Cayman Islands','Canada', 'Mexico', 'United States') THEN 'North America'
    WHEN country IN ('Egypt', 'Ghana', 'Kenya', 'Nigeria', 'Senegal', 'Seychelles', 'South Africa') THEN 'Africa'
    WHEN country IN ('United Arab Emirates') THEN 'Middle East'
    ELSE 'Unknown'
END;

-- Verify the update by listing countries marked as 'Unknown' and checking if any need correction.
SELECT country, continent
FROM layoffs_data_staging2
WHERE continent = 'Unknown'
ORDER BY 1;

-- Calculate the total number of layoffs for each continent to understand the geographic distribution of layoffs.
SELECT continent, SUM(layoff_count) AS total_layoff_count
FROM layoffs_data_staging2
GROUP BY continent
ORDER BY total_layoff_count DESC;
-- This query groups the data by `continent`, calculates the total number of layoffs for each continent, and orders the results in descending order to understand the geographic distribution of layoffs.

-- Calculate the total number of layoffs for each country within Asia.
SELECT country, SUM(layoff_count) AS asia_layoff_count
FROM layoffs_data_staging2
WHERE continent = 'Asia'
GROUP BY country
HAVING SUM(layoff_count) IS NOT NULL
ORDER BY country ASC;
-- This query filters the data for the continent 'Asia', sums the layoffs by country, groups the data by country, and orders the results alphabetically.

-- Calculate the total number of layoffs for each country within Oceania.
SELECT country, SUM(layoff_count) AS oceania_layoff_count
FROM layoffs_data_staging2
WHERE continent = 'Oceania'
GROUP BY country
HAVING SUM(layoff_count) IS NOT NULL
ORDER BY country ASC;
-- Similar to the previous query but for the continent 'Oceania'. It sums the layoffs by country, groups the data by country, and orders the results alphabetically.

-- Calculate the total number of layoffs for each country within South America.
SELECT country, SUM(layoff_count) AS south_america_layoff_count
FROM layoffs_data_staging2
WHERE continent = 'South America'
GROUP BY country
HAVING SUM(layoff_count) IS NOT NULL
ORDER BY country ASC;
-- Similar to the previous queries but for the continent 'South America'. It sums the layoffs by country, groups the data by country, and orders the results alphabetically.

-- Calculate the total number of layoffs for each country within Europe.
SELECT country, SUM(layoff_count) AS europe_layoff_count
FROM layoffs_data_staging2
WHERE continent = 'Europe'
GROUP BY country
HAVING SUM(layoff_count) IS NOT NULL
ORDER BY country ASC;
-- Similar to the previous queries but for the continent 'Europe'. It sums the layoffs by country, groups the data by country, and orders the results alphabetically.

-- Calculate the total number of layoffs for each country within North America.
SELECT country, SUM(layoff_count) AS north_america_layoff_count
FROM layoffs_data_staging2
WHERE continent = 'North America'
GROUP BY country
HAVING SUM(layoff_count) IS NOT NULL
ORDER BY country ASC;
-- Similar to the previous queries but for the continent 'North America'. It sums the layoffs by country, groups the data by country, and orders the results alphabetically.

-- Calculate the total number of layoffs for each country within Africa.
SELECT country, SUM(layoff_count) AS africa_layoff_count
FROM layoffs_data_staging2
WHERE continent = 'Africa'
GROUP BY country
HAVING SUM(layoff_count) IS NOT NULL
ORDER BY country ASC;
-- Similar to the previous queries but for the continent 'Africa'. It sums the layoffs by country, groups the data by country, and orders the results alphabetically.

-- Calculate the total number of layoffs for each country, regardless of continent, to get an overall view of layoffs by country.
SELECT country, SUM(layoff_count) AS country_layoff
FROM layoffs_data_staging2
GROUP BY country
HAVING SUM(layoff_count) IS NOT NULL
ORDER BY country_layoff DESC;
-- This query provides a summary of total layoffs by country, grouping the data by `country`, and ordering the results in descending order to highlight countries with the highest total layoffs.

-- Calculate the total number of layoffs for each country and the percentage of total layoffs that each country represents.
SELECT country, SUM(layoff_count) AS country_lay_off_count,
       ROUND((SUM(layoff_count)/(SELECT SUM(layoff_count) 
       FROM layoffs_data_staging2)*100), 2) AS lay_off_percentage
FROM layoffs_data_staging2
GROUP BY country
HAVING SUM(layoff_count) IS NOT NULL
ORDER BY lay_off_percentage DESC;
-- This query calculates the total layoffs and the percentage of total layoffs for each country. The percentage is computed as the ratio of a country's layoffs to the total layoffs across all countries, helping to understand the relative impact by country.

-- *** TIME-BASED ANALYSIS ***

-- Create a `year` column for further analysis.
ALTER TABLE layoffs_data_staging2
ADD COLUMN `year` INT;

-- Update the 'year' column based on the values in the 'date' column, extracting the year.
UPDATE layoffs_data_staging2
SET `year` = YEAR(`date`);

-- Verify the update by checking the first 100 rows.
SELECT `date`, `year`
FROM layoffs_data_staging2
LIMIT 100;

-- Retrieve the top 5 companies with the most layoffs for each year (2020 - First Half of 2024).
WITH company_layoff_per_year AS (
    SELECT company, `year`, SUM(layoff_count) AS company_layoff_count
    FROM layoffs_data_staging2
    GROUP BY company, `year`
), company_year_rank AS (
    SELECT *, DENSE_RANK() OVER (PARTITION BY `year` 
    ORDER BY company_layoff_count DESC) AS ranking
    FROM company_layoff_per_year
)
SELECT *
FROM company_year_rank
WHERE ranking <= 5;
-- This query first creates a common table expression (CTE) to calculate annual layoffs by company. It then ranks these layoffs within each year using the `DENSE_RANK()` function and retrieves the top 5 companies with the highest layoffs per year.

-- Calculate the total number of layoffs for each year to observe yearly trends in layoffs.
SELECT `year`, SUM(layoff_count) AS total_layoff
FROM layoffs_data_staging2
GROUP BY `year`
HAVING SUM(layoff_count) IS NOT NULL
ORDER BY `year` DESC;
-- This query calculates the total layoffs for each year, grouping the data by `year` and ordering it in descending order to analyze the trend in layoffs over time.

-- Calculate monthly total layoffs and the rolling sum of layoffs over time to observe trends.
WITH rolling_total AS (
    SELECT SUBSTRING(`date`, 1, 7) AS `month`,
           SUM(layoff_count) AS total_layoff
    FROM layoffs_data_staging2
    GROUP BY `month`
    ORDER BY `month` ASC
)
SELECT `month`, total_layoff, 
       SUM(total_layoff) OVER (ORDER BY `month`) AS rolling_layoff
FROM rolling_total;
-- This query calculates the total layoffs for each month and then computes a rolling sum of layoffs over time to help identify trends and cumulative impacts.

-- *** COMPANY STAGE STATISTICS ***

-- Calculate the total number of layoffs for each company stage, excluding 'Unknown', to understand how layoffs are distributed across different stages.
SELECT stage, SUM(layoff_count) AS stage_total_layoff
FROM layoffs_data_staging2
WHERE stage <> 'Unknown'
GROUP BY stage
HAVING SUM(layoff_count) IS NOT NULL
ORDER BY stage_total_layoff DESC;
-- This query groups the data by `stage`, sums the layoffs for each stage, excludes entries with 'Unknown' stages, and orders the results in descending order to understand the distribution of layoffs across different company stages.




