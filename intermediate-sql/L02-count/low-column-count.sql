-- https://community.modeanalytics.com/sql/tutorial/sql-count/
-- Write a query to count the number of non-null rows in the low column.
SELECT COUNT(low)
  FROM tutorial.aapl_historical_stock_price;