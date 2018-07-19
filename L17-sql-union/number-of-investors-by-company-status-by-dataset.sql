-- https://community.modeanalytics.com/sql/tutorial/sql-union/
-- Write a query that shows 3 columns. The first indicates which dataset (part 1 or 2) the data comes from, 
--   the second shows company status, and the third is a count of the number of investors. 
-- Hint: you will have to use the tutorial.crunchbase_companies table as well as the investments tables. 
--   And you'll want to group by status and dataset.

SELECT 
  'crunchbase_investments_part1' AS data_set, 
  companies.status AS companies_status, 
  COUNT(DISTINCT investments.investor_permalink) AS investors_count
FROM tutorial.crunchbase_companies companies
LEFT JOIN tutorial.crunchbase_investments_part1 investments
ON companies.permalink = investments.company_permalink
GROUP BY 1, 2

UNION ALL

SELECT 
  'crunchbase_investments_part2' AS data_set, 
  companies.status AS companies_status, 
  COUNT(DISTINCT investments.investor_permalink) AS investors_count
FROM tutorial.crunchbase_companies companies
LEFT JOIN tutorial.crunchbase_investments_part2 investments
ON companies.permalink = investments.company_permalink
GROUP BY 1, 2
