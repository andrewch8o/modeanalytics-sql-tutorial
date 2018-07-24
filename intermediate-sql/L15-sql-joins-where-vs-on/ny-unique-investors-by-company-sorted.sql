-- https://community.modeanalytics.com/sql/tutorial/sql-joins-where-vs-on/
-- Write a query that shows a company's name, "status" (found in the Companies table), 
--  and the number of unique investors in that company. 
--  Order by the number of investors from most to fewest. 
--  Limit to only companies in the state of New York.

SELECT
  companies.name AS company_name,
  companies.status AS company_status,
  COUNT(distinct investments.investor_permalink) AS unique_investors_count
FROM tutorial.crunchbase_companies companies
LEFT JOIN tutorial.crunchbase_investments investments
ON companies.permalink = investments.company_permalink
  AND companies.state_code = 'NY'
GROUP BY 1,2
ORDER BY 3 DESC