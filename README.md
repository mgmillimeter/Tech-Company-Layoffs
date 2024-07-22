# Data Cleaning and Exploratory Data Analysis (EDA) of Tech companies layoffs


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

Original dataset can be tracked at https://layoffs.fyi/

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
  - Companies with the highest total layoffs predominantly belong to well-established tech firms.
  
2. Industry Impact:

  - The technology sector experienced varied impacts, with certain industries facing higher average layoff percentages.
  - Industries such as software and internet services had notably high layoff rates.
  
3. Geographical Distribution:

  - Layoffs were widespread across continents, with North America and Asia witnessing the highest numbers.
  - Countries such as the United States, India, and Canada had the most substantial layoffs.

4. Time-Based Trends:

  - Layoffs peaked at certain times, with significant variations in layoff numbers across different years.
  - The rolling sum analysis indicates trends and cumulative impacts over months.

5. Company Stages:

  - Different company stages showed varying layoff patterns, with later-stage companies experiencing more layoffs compared to early-stage startups.
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


