# Data Cleaning and Exploratory Data Analysis (EDA) of Tech Company Layoffs

## Table of Contents

- [Project Overview](#project-overview)
- [Data Sources](#data-sources)
- [Tools](#tools)
- [Data Cleaning Preparation](#data-cleaning-preparation)
- [Exploratory Data Analysis (EDA)](#exploratory-data-analysis-eda)
- [Data Analysis](#data-analysis)
- [Limitations](#limitations)
- [Recommendations](#recommendations)

# Project Overview
This project analyzes tech company layoffs. It begins with cleaning the data by removing duplicates, standardizing formats, handling missing values, and removing unnecessary columns. The cleaned data is then used for exploratory analysis to uncover trends and insights, providing a comprehensive understanding of layoffs in the tech industry.


## Data Sources

Original dataset can be tracked [here](https://layoffs.fyi/).

Credits: Roger Lee

Company Layoffs Data: The primary dataset used for this analysis is the "layoffs_data.csv", which contains detailed information about each layoff made by various tech companies.



### Tools

- Excel - Dataset Medium
    - [Download here](https://www.microsoft.com/en-us/microsoft-365/excel)
- SQL Server (MySQL) - Data Cleaning & EDA
    - [Download here](https://www.mysql.com/downloads/)
- Tableau - Creating Reports
    - [Download here](https://www.tableau.com/products/desktop/download)


### Data Cleaning Preparation

1. Remove duplicates
2. Standardized the data
3. Handling null and blank values
4. Remove unnecessary columns


### Exploratory Data Analysis (EDA)

- Which companies have the highest layoffs?
- Which are the top industries with the highest average layoff percentage?
- What are the total layoffs by continent and country?
- What are the trends in layoffs by year, month, and what are layoffs trends over time?
- What are the total layoffs for each company stage, and how are they distributed across different stages?


### Data Analysis
(SQL Query Sample)
Below is a query that identifies the top 5 companies with the most layoffs for each year,
helping to highlight which companies were most affected by layoffs annually.
```sql


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
```

### Results/Findings

The exploratory data analysis (EDA) on tech company layoffs reveals several key insights:

1. Company Layoffs:

  - The top 10 companies with the highest layoffs include significant names in the tech industry.

    ![Companies  Top 10  layoffs](https://github.com/user-attachments/assets/d8b900af-72ad-428d-9677-eb5e8b67d9f2)

  - Companies with the highest total layoffs predominantly belong to well-established tech firms.
  
2. Industry Impact:

  - Top 10 Industries with the highest average layoff percentages.

    ![Industry  top 10 Industry Layoff Rate](https://github.com/user-attachments/assets/42e22338-d102-4e11-84dd-fcbec205666e)

  - The technology sector experienced varied impacts, with certain industries facing higher average layoff percentages.
    
  
3. Geographical Distribution:

  - Layoffs were widespread across continents, with North America and Asia witnessing the highest numbers.
  - The Middle East was included in the continent chart to provide a more accurate and granular representation of the data, considering its significant and unique economic and geopolitical impact on global tech industry trends and layoffs.
    
    ![Geographical  total layoffs per continent](https://github.com/user-attachments/assets/7d49f123-0f6a-45c8-a8a1-344ee13b86a6)

  - Charts showing the total number of layoffs per continent for each country
    
    ![NA](https://github.com/user-attachments/assets/38f2208b-023a-428c-a3de-6aa5053f01c7)
    
    ![ASIA](https://github.com/user-attachments/assets/0023d9d4-a724-4ad6-a38a-3b965caba97c)

    ![EU](https://github.com/user-attachments/assets/d7975dda-afd2-49ed-88a5-d7b1e5fbeb78)

    ![SA](https://github.com/user-attachments/assets/bb425c77-307f-4f78-989c-f1e50fa4d0c8)

    ![OC](https://github.com/user-attachments/assets/8d7f9049-92f1-4583-932e-65348dc2139a)

    ![AF](https://github.com/user-attachments/assets/a8268761-f0ab-4427-bd9e-ea83761fcee0)

    ![OC](https://github.com/user-attachments/assets/76fdab97-880b-4e99-ac56-7105fd23c77c)

    ![ME](https://github.com/user-attachments/assets/13297e01-522e-4c19-989b-950aa54d8a9e)

  - Countries such as the United States and India had the most substantial layoffs percentages.

    ![Pie](https://github.com/user-attachments/assets/8df487e7-0ad6-4699-883f-20d216f1d255)

4. Time-Based Trends:

  - Layoffs peaked at certain times, with significant variations in layoff numbers across different years.
    
    ![2024](https://github.com/user-attachments/assets/9ecd3063-e3fa-42ed-a5b2-581e0efa35e4)
    
    ![2023](https://github.com/user-attachments/assets/b361d4f5-8648-4ba9-bd4e-6ce311eca5c4)
    
    ![2022](https://github.com/user-attachments/assets/44092efb-9573-4dc0-a0dc-3f6ca0a83b96)
    
    ![2021](https://github.com/user-attachments/assets/62066bd2-7913-4ed3-832a-36c75ce3a5c6)
    
    ![2020](https://github.com/user-attachments/assets/ba352a9f-b3bc-4cdf-b066-c72e4a3e9985)

  - The rolling sum function calculates a cumulative total of layoffs over time. This cumulative or "rolling" total adds up the "Total Daily Layoff" figures month by month, showing the progressive increase in layoffs as time goes on.
  - The rolling sum analysis indicates trends and cumulative impacts over months.

5. Company Stages:

  - Different company stages showed varying layoff patterns, with later-stage companies experiencing more layoffs compared to early-stage startups.

    ![Screenshot 2024-07-22 202415](https://github.com/user-attachments/assets/2b12f4a2-5db1-461c-ac70-6d134d4bf368)

  - Post-IPO: Companies that have gone public, having completed their Initial Public Offering (IPO).
  - Acquired: Companies that have been bought by another company.
  - Series B, C, D, E, F, G, H, I, J: Various stages of venture capital funding, with Series A being the first major round of funding after seed funding, and subsequent series indicating later stages of funding.
  - Private Equity: Companies that have received investments from private equity firms.
  - Seed: Early stage funding for startups to develop their business ideas.
  - Subsidiary: Companies that are controlled by a parent company.

  - These findings offer a comprehensive understanding of the layoffs' impact on the tech industry, highlighting trends and patterns across companies, industries, geographies, and time periods.


### Recommendations

1. Diversify Revenue Streams:
   - Explore and develop multiple sources of income to lessen reliance on a single market or product.
2. Invest in Employee Skills:
   - Provide training and upskilling to help employees adapt to new technologies and stay valuable.
3. Improve Operational Efficiency:
   - Streamline processes and reduce unnecessary costs to enhance overall efficiency without needing layoffs.

### Limitations
The analysis is limited by incomplete data, which may lead to gaps in understanding the full scope of layoffs; temporal gaps in the dataset could obscure trends over time; and the exclusion of external market conditions and company-specific factors means that broader economic influences and unique company circumstances aren't considered, potentially affecting the accuracy of insights.

### References

1. [SQL for Data Analysis by Cathy Tanimura](https://www.oreilly.com/library/view/sql-for-data/9781492088776/)
2. [Alex The Analyst](https://github.com/AlexTheAnalyst)


