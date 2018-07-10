-- https://community.modeanalytics.com/sql/tutorial/sql-right-join/
-- Count the number of unique companies (don't double-count companies) and unique acquired companies by state. 
--   Do not include results for which there is no state data, 
--   and order by the number of acquired companies from highest to lowest.
-- Use RIGHT JOIN operation

select companies.state_code as state_code,
       count(distinct companies.permalink) as companies_count,
       count(distinct acquisitions.company_permalink) as acquired_count
    from tutorial.crunchbase_acquisitions acquisitions
    right join tutorial.crunchbase_companies companies
           on companies.permalink = acquisitions.company_permalink
    where companies.state_code is not NULL
    group by companies.state_code
    order by acquired_count desc