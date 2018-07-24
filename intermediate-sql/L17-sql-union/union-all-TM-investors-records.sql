-- https://community.modeanalytics.com/sql/tutorial/sql-union/
-- Write a query that appends the two crunchbase_investments datasets above (including duplicate values).
--  Filter the first dataset to only companies with names that start with the letter "T",
--  and filter the second to companies with names starting with "M" (both not case-sensitive).
--  Only include the company_permalink, company_name, and investor_name columns.

SELECT company_permalink,
       company_name,
       investor_name
FROM tutorial.crunchbase_investments_part1
WHERE company_name ILIKE 't%'

UNION ALL

SELECT company_permalink,
       company_name,
       investor_name
FROM tutorial.crunchbase_investments_part2
WHERE company_name ILIKE 'm%'