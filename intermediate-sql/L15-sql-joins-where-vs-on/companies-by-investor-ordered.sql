-- https://community.modeanalytics.com/sql/tutorial/sql-joins-where-vs-on/
-- Write a query that lists investors based on the number of companies in which they are invested.
--   Include a row for companies with no investor, and order from most companies to least.

-- Because there are records in crunchbase_companies with no matches in crunchbase_investments and vice-versa
--  in order to reliably answer the question it has to be split in two:

-- Number of companies with no investor
SELECT count(*) AS count_companies_no_investor
FROM tutorial.crunchbase_companies companies
LEFT JOIN tutorial.crunchbase_investments investments
  ON investments.company_permalink = companies.permalink
  WHERE investments.investor_permalink is NULL 
-- Result
/* 9363 */
  
-- Number of companies per investor
SELECT 
  investments.investor_permalink as investor_permalink,
  count(distinct companies.permalink) as number_of_companies_invested_in
FROM tutorial.crunchbase_investments investments 
LEFT JOIN tutorial.crunchbase_companies companies
  ON investments.company_permalink = companies.permalink
GROUP BY 1
ORDER BY 2 DESC
-- Results ( top )
/*
/company/y-combinator	370
/financial-organization/sv-angel	356
/financial-organization/intel-capital	320
/financial-organization/sequoia-capital	276
/financial-organization/new-enterprise-associates	260
/financial-organization/500-startups	253
/financial-organization/accel-partners	248
/financial-organization/draper-fisher-jurvetson	228
/company/techstars	226
/financial-organization/kleiner-perkins-caufield-byers	215
/financial-organization/first-round-capital	175
/financial-organization/greylock	163
/financial-organization/index-ventures	159
/financial-organization/andreessen-horowitz	157
/financial-organization/bessemer-venture-partners	142
/financial-organization/google-ventures	138
/financial-organization/idg-ventures-china	135
/financial-organization/lightspeed-venture-partners	133
/financial-organization/battery-ventures	132
/financial-organization/benchmark-2	132
/financial-organization/menlo-ventures	130
/financial-organization/khosla-ventures	122
/financial-organization/us-venture-partners	122
/financial-organization/general-catalyst-partners	121
*/
-- Solution query
SELECT CASE WHEN investments.investor_name IS NULL THEN 'No Investors'
            ELSE investments.investor_name END AS investor,
       COUNT(DISTINCT companies.permalink) AS companies_invested_in
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments investments
    ON companies.permalink = investments.company_permalink
 GROUP BY 1
 ORDER BY 2 DESC
-- Results ( top )
/* 
No Investors	9363
Y Combinator	370
SV Angel	357
Intel Capital	320
Sequoia Capital	276
New Enterprise Associates	260
500 Startups	253
Accel Partners	248
Draper Fisher Jurvetson (DFJ)	228
Techstars	226
Kleiner Perkins Caufield & Byers	215
First Round Capital	175
Greylock Partners	163
Index Ventures	160
Andreessen Horowitz	157
Bessemer Venture Partners	142
Google Ventures	138
IDG Capital Partners	135
Lightspeed Venture Partners	133
Battery Ventures	132
Benchmark	132
Menlo Ventures	130
Khosla Ventures	122
US Venture Partners	122
General Catalyst Partners	121
*/

-- There is difference for sv-angel
/*
/financial-organization/sv-angel	356
VS
SV Angel	357
*/
select count(*) from tutorial.crunchbase_investments where investor_permalink='/financial-organization/sv-angel'
/* 489 */
select count(*) from tutorial.crunchbase_investments where investor_name = 'SV Angel'
/* 490 */
select company_permalink,company_name,investor_permalink,investor_name 
from tutorial.crunchbase_investments 
where investor_name = 'SV Angel' and investor_permalink<>'/financial-organization/sv-angel'
/* /company/secret,	Secret,	/company/sv-angel,	SV Angel */

/* My script calculated summary for '/financial-organization/sv-angel' as 356 because the foreign key was 
     used to calculate the aggregated count rather then the company name.
   The reason for using foreign key instead of name in my query is that I was not sure if every record in the 
     tutorial.crunchbase_investments table would have the company name value set and did not want to rely on it. 
*/

/* 
   Both scripts calculated the same number of companies per investor.
   The only difference would be that my solution also is to produce list of investors that have not made
     any investments.
*/

-- Further re-verification:
-- My query
SELECT 
  investments.investor_permalink as investor_permalink,
  count(distinct companies.permalink) as number_of_companies_invested_in
FROM tutorial.crunchbase_investments investments 
LEFT JOIN tutorial.crunchbase_companies companies
  ON investments.company_permalink = companies.permalink
GROUP BY 1
ORDER BY 2 ASC
/* TOP 10
/company/caele-holding	0
/company/cytyc	0
/company/axel-springer	0
/company/cabot-solutions-pvt-ltd	0
/company/clifton-cowley-ventures	0
/company/curious-pictures	0
/company/appincloud-sweden-ab	0
/company/avaco	0
/company/bluefrog-interactive	0
/company/burda-international	0
*/

-- Suggested solution
SELECT CASE WHEN investments.investor_name IS NULL THEN 'No Investors'
            ELSE investments.investor_name END AS investor,
       COUNT(DISTINCT companies.permalink) AS companies_invested_in
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments investments
    ON companies.permalink = investments.company_permalink
 GROUP BY 1
 ORDER BY 2 ASC
/*TOP 10
Access Partners	1
Acer	1
Accera Venture Partners	1
Access National Bank	1
Accor Services	1
Ace Limited	1
Accelerace	1
Accelerator Fund	1
Access	1
Access Medical Ventures	1
*/