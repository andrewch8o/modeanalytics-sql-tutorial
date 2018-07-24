-- https://community.modeanalytics.com/sql/tutorial/sql-data-types/
/*
  Convert the funding_total_usd and founded_at_clean columns in the 
    tutorial.crunchbase_companies_clean_date table to strings (varchar format) using a different 
    formatting function for each one.
*/
select 
  CAST(funding_total_usd AS VARCHAR ) as funding_total_usd_varchar, 
  founded_at_clean::VARCHAR as founded_at_clean_varchar
from tutorial.crunchbase_companies_clean_date