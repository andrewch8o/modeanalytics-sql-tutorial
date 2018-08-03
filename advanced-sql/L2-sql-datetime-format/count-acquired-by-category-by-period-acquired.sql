-- https://community.modeanalytics.com/sql/tutorial/sql-datetime-format/
/* Write a query that counts the number of companies acquired within 3 years, 5 years, and 10 years 
     of being founded (in 3 separate columns). 
     Include a column for total companies acquired as well. 
     Group by category and limit to only rows with a founding date.*/
SELECT
  companies.category_code as companies_category_code,
  COUNT(CASE WHEN TO_TIMESTAMP(acquisitions.acquired_at, 'MM/DD/YY') <= TO_TIMESTAMP(companies.founded_at, 'MM/DD/YY') + INTERVAL '3 years' 
            THEN 1
            ELSE NULL END) AS acquired_within_3_yrs_count,
  COUNT(CASE WHEN TO_TIMESTAMP(acquisitions.acquired_at, 'MM/DD/YY') <= TO_TIMESTAMP(companies.founded_at, 'MM/DD/YY') + INTERVAL '5 years'
            THEN 1
            ELSE NULL END) AS acquired_within_5_yrs_count,
  COUNT(CASE WHEN TO_TIMESTAMP(acquisitions.acquired_at, 'MM/DD/YY') <= TO_TIMESTAMP(companies.founded_at, 'MM/DD/YY') + INTERVAL '10 years'
            THEN 1
            ELSE NULL END) AS acquired_within_10_yrs_count,
  COUNT(companies.permalink) as acquired_all_time_count
FROM tutorial.crunchbase_companies companies
JOIN tutorial.crunchbase_acquisitions acquisitions
ON companies.permalink = acquisitions.company_permalink
WHERE companies.founded_at IS NOT NULL
GROUP BY 1
ORDER BY 5 DESC
