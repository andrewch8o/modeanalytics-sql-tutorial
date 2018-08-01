-- https://community.modeanalytics.com/sql/tutorial/sql-datetime-format/
/*
While running my implementation of the query ( 69 entries for 'software' category, against the "tutorial.crunchbase_companies" and "tutorial.crunchbase_acquisitions" tables ) 
and comparing execution results against the "solution" query ( 72 entries for 'software' category, against the "tutorial.crunchbase_companies_clean_date" and "tutorial.crunchbase_acquisitions_clean_date" ) tables
I have noticed inconsistencies which had to be further investigated
*/

-- my
SELECT
  companies.permalink
FROM tutorial.crunchbase_companies companies
JOIN tutorial.crunchbase_acquisitions acquisitions
ON companies.permalink = acquisitions.company_permalink
WHERE companies.founded_at IS NOT NULL
AND TO_TIMESTAMP(acquisitions.acquired_at, 'MM/DD/YY') - TO_TIMESTAMP(companies.founded_at, 'MM/DD/YY') <= INTERVAL '5 years'
AND companies.category_code = 'software'
/* produces 69 entries */

-- cleaned
SELECT companies.permalink
  FROM tutorial.crunchbase_companies_clean_date companies
  JOIN tutorial.crunchbase_acquisitions_clean_date acquisitions
    ON acquisitions.company_permalink = companies.permalink
 WHERE founded_at_clean IS NOT NULL
 AND acquisitions.acquired_at_cleaned <= companies.founded_at_clean::timestamp + INTERVAL '5 years'
 AND companies.category_code = 'software'
/* produces 72 entries */


-- Investigating the differences between the two queries
SELECT *
FROM 
  (SELECT companies.permalink as pl_clean
    FROM tutorial.crunchbase_companies_clean_date companies
    JOIN tutorial.crunchbase_acquisitions_clean_date acquisitions
      ON acquisitions.company_permalink = companies.permalink
   WHERE founded_at_clean IS NOT NULL
   AND acquisitions.acquired_at_cleaned <= companies.founded_at_clean::timestamp + INTERVAL '5 years'
   AND companies.category_code = 'software') software_5yr_comp_acquisitions_cleaned 
FULL OUTER JOIN
  (SELECT
    companies.permalink as pl
  FROM tutorial.crunchbase_companies companies
  JOIN tutorial.crunchbase_acquisitions acquisitions
  ON companies.permalink = acquisitions.company_permalink
  WHERE companies.founded_at IS NOT NULL
  AND TO_TIMESTAMP(acquisitions.acquired_at, 'MM/DD/YY') - TO_TIMESTAMP(companies.founded_at, 'MM/DD/YY') <= INTERVAL '5 years'
  AND companies.category_code = 'software') software_5yr_comp_acquisitions
ON pl_clean = pl
WHERE pl IS NULL OR 
      pl_clean IS NULL
/*
pl_clean,pl
"/company/pokelabo",
"/company/hiwired",
"/company/real-girls-media-network-inc",
*/

-- OK. The query against the "cleaned" data set produces 3 more entries ( explains the difference ). 
-- Further investigating specifics
SELECT
    companies.permalink as pl,
    companies.founded_at as c_founded,
    acquisitions.acquired_at as a_acquired,
    companies.category_code as c_category,
    TO_TIMESTAMP(acquisitions.acquired_at, 'MM/DD/YY') as a_acquired_tmstmp,
    TO_TIMESTAMP(companies.founded_at, 'MM/DD/YY') as c_founded_tmstmp,
    AGE(TO_TIMESTAMP(acquisitions.acquired_at, 'MM/DD/YY'),TO_TIMESTAMP(companies.founded_at, 'MM/DD/YY')) as founded_acquired_diff,
    TO_TIMESTAMP(acquisitions.acquired_at, 'MM/DD/YY') - TO_TIMESTAMP(companies.founded_at, 'MM/DD/YY') <= INTERVAL '5 years' as within_5_yrs
  FROM tutorial.crunchbase_companies companies
  JOIN tutorial.crunchbase_acquisitions acquisitions
  ON companies.permalink = acquisitions.company_permalink
  WHERE 
  companies.founded_at IS NOT NULL
  --AND TO_TIMESTAMP(acquisitions.acquired_at, 'MM/DD/YY') - TO_TIMESTAMP(companies.founded_at, 'MM/DD/YY') <= INTERVAL '5 years'
  AND companies.category_code = 'software'
  AND companies.permalink IN ('/company/pokelabo','/company/hiwired','/company/real-girls-media-network-inc')
/*
pl,c_founded,a_acquired,c_category,a_acquired_tmstmp,c_founded_tmstmp,founded_acquired_diff,within_5_yrs
"/company/hiwired",1/1/04,1/1/09,software,2009-01-01 00:00:00,2004-01-01 00:00:00,5 years 0 mons 0 days 0 hours 0 mins 0.00 secs,false
"/company/pokelabo",11/1/07,10/25/12,software,2012-10-25 00:00:00,2007-11-01 00:00:00,4 years 11 mons 24 days 0 hours 0 mins 0.00 secs,false
"/company/real-girls-media-network-inc",1/1/06,12/13/10,software,2010-12-13 00:00:00,2006-01-01 00:00:00,4 years 11 mons 12 days 0 hours 0 mins 0.00 secs,false
*/

/* Comparing to cleanned data*/
SELECT 
    companies.permalink as pl,
    companies.founded_at_clean as c_founded,
    acquisitions.acquired_at_cleaned as a_acquired,
    companies.category_code as c_category,
    acquisitions.acquired_at_cleaned::timestamp as a_acquired_tmstmp,
    companies.founded_at_clean::timestamp as c_founded_tmstmp,
    AGE(acquisitions.acquired_at_cleaned::timestamp,companies.founded_at_clean::timestamp) as founded_acquired_diff,
    acquisitions.acquired_at_cleaned <= companies.founded_at_clean::timestamp + INTERVAL '5 years' as within_5_yrs
    FROM tutorial.crunchbase_companies_clean_date companies
    JOIN tutorial.crunchbase_acquisitions_clean_date acquisitions
      ON acquisitions.company_permalink = companies.permalink
   WHERE founded_at_clean IS NOT NULL
   --AND acquisitions.acquired_at_cleaned <= companies.founded_at_clean::timestamp + INTERVAL '5 years'
   AND companies.category_code = 'software'
   AND companies.permalink IN ('/company/pokelabo','/company/hiwired','/company/real-girls-media-network-inc')
/*
pl,c_founded,a_acquired,c_category,a_acquired_tmstmp,c_founded_tmstmp,founded_acquired_diff,within_5_yrs
"/company/hiwired",2004-01-01,2009-01-01 00:00:00,software,2009-01-01 00:00:00,2004-01-01 00:00:00,5 years 0 mons 0 days 0 hours 0 mins 0.00 secs,true
"/company/pokelabo",2007-11-01,2012-10-25 00:00:00,software,2012-10-25 00:00:00,2007-11-01 00:00:00,4 years 11 mons 24 days 0 hours 0 mins 0.00 secs,true
"/company/real-girls-media-network-inc",2006-01-01,2010-12-13 00:00:00,software,2010-12-13 00:00:00,2006-01-01 00:00:00,4 years 11 mons 12 days 0 hours 0 mins 0.00 secs,true
*/

-- Apparently, the problem boils down to the way the dates are compared.
-- Two questions remain:
--   * What is the difference in date comparison?
--   * Why does it work differently only on these three records?