-- https://community.modeanalytics.com/sql/tutorial/sql-join-comparison-operators/
/* In the tutorial there are two queries shown ( listed below ) which produce different results.
   As per my analysis of the queries I would expect them to produce the same result 
   ( as per my understanding of the logic of each query detailed below )
*/

-- Query #1 ( JOIN-AND )
/*
LOGIC: Left join investments to companies ( "shed" all investments that do not have matching
       records in companies but keep all companies records even if there are no matching
       investments - there will be NULL "investment" values for those )
       
       As tables are being joined - demand that each "investments" record joined to a "company" 
       record satisfies the condition (investments.funded_year > companies.founded_year + 5)

       Select certain fields, group, calculate counts ( easy stuff )
*/
SELECT companies.permalink,
       companies.name,
       companies.status,
       COUNT(investments.investor_permalink) AS investors
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments_part1 investments
    ON companies.permalink = investments.company_permalink
   AND investments.funded_year > companies.founded_year + 5
 GROUP BY 1,2, 3
/* OUTPUT TOP 100: l18-q1-output.csv */


 -- Query #2 ( JOIN-WHERE )
 /*
 LOGIC: Left join investments to companies ( "shed" all investments that do not have matching
       records in companies but keep all companies records even if there are no matching
       investments - there will be NULL "investment" values for those )
       
       After tables have been joined filter out only the records that satisfy the condition 
       (investments.funded_year > companies.founded_year + 5)

       Select certain fields, group, calculate counts ( easy stuff )
*/
 SELECT companies.permalink,
       companies.name,
       companies.status,
       COUNT(investments.investor_permalink) AS investors
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments_part1 investments
    ON companies.permalink = investments.company_permalink
 WHERE investments.funded_year > companies.founded_year + 5
 GROUP BY 1,2, 3
/* OUTPUT TOP 100: l18-q2-output.csv */

/* So ,to my understanding, the logic of both the queries should have resulted in the same data 
being produced. Which was not the case :) 
Comparing output of query #1 and #2 side-by-side it appears that query #1 ( JOIN ON AND ) also returns
records with 0 investors */

/* Next step was to extend query to inspect the results upon which the calculation is performed 
   The following queries have been produced. Ordering added to ensure that both queries return
   results in the same order to allow for more reliable comparison */

-- Query #1.1 ( JOIN-AND )
 SELECT companies.permalink,
       companies.name,
       companies.status,
       companies.founded_year,
       investments.investor_permalink,
       investments.funded_year
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments_part1 investments
    ON companies.permalink = investments.company_permalink
   AND investments.funded_year > companies.founded_year + 5 
 ORDER BY 1,2,3,4,5,6 DESC
/*OUTPUT TOP 100: l18-q1-1-output.csv*/

-- Query #2.1 ( JOIN-WHERE )
 SELECT companies.permalink,
       companies.name,
       companies.status,
       companies.founded_year,
       investments.investor_permalink,
       investments.funded_year
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments_part1 investments
    ON companies.permalink = investments.company_permalink
 WHERE investments.funded_year > companies.founded_year + 5
 ORDER BY 1,2,3,4,5,6 DESC
 /*OUTPUT TOP 100: l18-q2-1-output.csv*/

 /*  Comparing output of query #1.1 and #2.1 indicates that query #1.1 ( JOIN-AND ) does include
     records where "investment" values are NULL whereas the query #2.1 ( JOIN-WHERE ) does not include - 
     the records with missing "investment" values are filtered out.
     
     So now it looks that the AND condition in the query #1.1 does not filter out the records where
     "investment" values are NULL. Hmmm... 

     Further online search on left join and vs where brings up the following article
     https://stackoverflow.com/questions/27529423/where-vs-and-in-left-join
     
     And the idea of the reply is that by definition LEFT JOIN AND does not filter records from the
     table on the left [companies] ( and only filters out records from the table on the right [investments]
     leaving NULL values for the "filtered" values from the table on the right[investments]) 

    OK. Lesson learned being that LEFT-JOIN-AND does not filter out recors from the "left" table and only filters
    out records from the "right" table.
*/