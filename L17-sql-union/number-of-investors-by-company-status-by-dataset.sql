-- https://community.modeanalytics.com/sql/tutorial/sql-union/
-- Write a query that shows 3 columns. The first indicates which dataset (part 1 or 2) the data comes from, 
--   the second shows company status, and the third is a count of the number of investors. 
-- Hint: you will have to use the tutorial.crunchbase_companies table as well as the investments tables. 
--   And you'll want to group by status and dataset.

-- As the question concerns number of investors ( and not investments ) - using DISTINCT to count investors
select companies.status, COUNT(DISTINCT investments.investor_permalink)
from tutorial.crunchbase_companies companies
left join tutorial.crunchbase_investments_part1 investments
on companies.permalink = investments.company_permalink
group by 1
