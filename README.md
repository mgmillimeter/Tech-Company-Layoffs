# Tech Companies Layoffs Analysis (2020 - 2024)

Analyzing Tech Companies layoffs trends from 2020-2024. Interactive Tableau Dashboard can be found _[here](https://public.tableau.com/app/profile/martin.guiller.iii/viz/Layoffs_17224772413930/Dashboard1?publish=yes)._

The interactive dashboard provides an in-depth analysis of tech company layoffs, highlighting key trends across industries, geographic regions, funding stages, and temporal patterns.

![Tec-Company-Layoffs](https://github.com/user-attachments/assets/9d1f5ff4-5bd4-4a87-bb34-69247a354a3c)

### Layoffs Metrics and Dimensions

- _company_: The name of the company that has announced layoffs.
- _location_: The city or region where the layoffs are taking place.
- _industry_: The industry sector in which the company operates (e.g., Food, Finance, Crypto).
- _layoff_count_: The number of employees laid off in the announcement.
- _funds_raised_millions_: The amount of funds the company has raised, in millions of Indian Rupees.
- _stage_: The business stage of the company (e.g., Unknown, Post-IPO).
- _country_: The country where the layoffs are occurring.



## Summary of Insights

### 1. Industries with Significant Layoffs
The top industries experiencing significant layoffs are:
- **Retail**: 67,368 layoffs
- **Consumer**: 63,814 layoffs
- **Transportation**: 57,913 layoffs

*Insight*: Retail, Consumer, and Transportation industries face the most significant layoffs, indicating economic shifts and industry-specific challenges.

### 2. Geographic Variation in Layoff Trends
Layoffs by region:
- **North America**: 377,837 layoffs
- **Asia**: 68,908 layoffs
- **Europe**: 63,088 layoffs

*Insight*: North America, especially the United States, has the highest number of layoffs, followed by Asia and Europe.

### 3. Layoff Occurrences by Company Funding Stage
Layoffs by funding stage:
- **Post-IPO**: 290,594 layoffs
- **Acquired**: 40,921 layoffs
- **Series B**: 28,372 layoffs

*Insight*: Post-IPO companies have the highest layoff occurrences, followed by Acquired companies.

### 4. Temporal Patterns in Layoffs
There are noticeable spikes in layoffs around the fourth quarter of 2022 and the first quarter of 2023.

*Insight*: Significant peaks in layoffs in late 2022 and early 2023 highlight periods of economic adjustment and restructuring.

### 5. Correlation Between Layoffs and Funds Raised
A weak positive correlation exists between funds raised and layoff counts.

*Insight*: Companies with higher funds raised tend to have slightly higher layoff counts, but the correlation is weak, indicating that fundraising alone is not a strong predictor of layoffs.


## Recommendations and Next Steps

### Recommendations

1. **Mitigation Strategies:**
   - **Focus on High-Risk Industries:** Prioritize risk management in Retail, Consumer, and Transportation sectors.
   - **Support Post-IPO Companies:** Provide targeted support to stabilize workforces in post-IPO companies.
   - **Regional Interventions:** Implement workforce support programs in North America, particularly the United States.
   - **Effective Fund Utilization:** Ensure raised funds are used effectively to promote sustainable growth and employment stability.

### Next Steps

1. **Total Workforce Analysis:**
   - **Gather Workforce Data:** Collect data on total workforce to compute layoff percentages.
   - **Assess Impact:** Analyze layoff impacts across companies, industries, and regions.

2. **Detailed Sub-Industry Analysis:**
   - **Granular Breakdown:** Break down industries into sub-industries for detailed insights.
   - **Identify Vulnerable Sub-Industries:** Develop targeted mitigation strategies.

3. **External Factors Analysis:**
   - **Economic Indicators:** Study the impact of market trends, inflation rates, and policies on layoffs.
   - **Qualitative Insights:** Conduct surveys or interviews for qualitative insights.

### Limitations

- **Incomplete Data:** Lack of total workforce data limits the ability to calculate layoff percentages.
- **External Factors Not Included:** The dataset does not account for broader economic factors influencing layoffs.
- **Sub-Industry Details Missing:** The dataset does not provide granular details on sub-industries, limiting detailed analysis.

By addressing these recommendations and next steps, stakeholders can better understand and mitigate the impact of layoffs in the tech industry.



## Data Sources

Original dataset can be tracked _[here](https://layoffs.fyi/)._

Credits: _Roger Lee_


## Data manipulation and transformation sample
__You can view the whole process of SQL Data Cleaning and Exploratory Data Analysis (EDA) Script__ _[here](https://github.com/mgmillimeter/Tech-Company-Layoffs/blob/main/sql_data_analysis_project-techcomapanies_layoffs.sql)_
    
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

    
### References

1. _[SQL for Data Analysis by Cathy Tanimura](https://www.oreilly.com/library/view/sql-for-data/9781492088776/)_
2. _[Alex The Analyst](https://github.com/AlexTheAnalyst)_

