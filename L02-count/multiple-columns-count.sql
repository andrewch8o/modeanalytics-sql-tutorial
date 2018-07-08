--https://community.modeanalytics.com/sql/tutorial/sql-count/
--Write a query that determines counts of every single column. Which column has the most null values?
--date,year,month,open,high,low,close,volume,id
SELECT count(date) as count_date,
      count(year) as count_year,
      count(month) as count_month,
      count(open) as count_open,
      count(high) as count_high,
      count(low) as count_low,
      count(close) as count_close,
      count(volume) as count_volume,
      count(id) as count_id
FROM tutorial.aapl_historical_stock_price;