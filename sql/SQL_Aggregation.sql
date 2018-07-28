-- Find the total amount of poster_qty paper ordered 
-- in the orders table.

SELECT SUM(poster_qty) AS poster_qty_sum
FROM orders;

-- Find the total amount of standard_qty paper ordered in
-- the orders table.

SELECT SUM(standard_qty) AS standard_qty_sum
FROM orders;

-- Find the total dollar amount of sales using 
-- the total_amt_usd in the orders table.

SELECT SUM(total_amt_usd) AS total_amt_usd_sum
FROM orders;

-- Find the total amount spent on standard_amt_usd
-- and gloss_amt_usd paper for each order in the orders table.
-- This should give a dollar amount for each order in the table.

SELECT SUM(standard_amt_usd) AS standard_amt_usd_sum,
		SUM(gloss_amt_usd) AS gloss_amt_usd_sum
FROM orders;

SELECT standard_amt_usd + gloss_amt_usd AS total_standard_gloss
FROM orders;

-- Find the standard_amt_usd per unit of standard_qty paper.
-- Your solution should use both an aggregation and
-- a mathematicaloperator.

SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS standard_qty_per_unit
FROM orders;

-- When was the earliest order ever placed? You only
-- need to return the date.

SELECT MIN(occurred_at)
FROM orders;

-- Try performing the same query as in question 1 
-- without using an aggregation function. 

SELECT occurred_at
FROM orders
ORDER BY occurred_at
LIMIT 1;

-- When did the most recent (latest) web_event occur?

SELECT MIN(occurred_at)
FROM web_events;

-- Try to perform the result of the previous query without 
-- using an aggregation function.

SELECT occurred_at
FROM web_events
ORDER BY occurred_at
LIMIT 1;

-- Find the mean (AVERAGE) amount spent per order 
-- on each paper type, as well as the mean amount of 
-- each paper type purchased per order. Your final answer 
-- should have 6 values - one for each paper type for the 
-- average number of sales, as well as the average amount.

SELECT AVG(standard_amt_usd/(standard_qty + 0.001)) AS standard_qty_per_unit,
	AVG(gloss_amt_usd/(gloss_qty + 0.001)) AS gloss_qty_per_unit, 
	AVG(poster_amt_usd/(poster_qty + 0.001)) AS poster_qty_per_unit,
	AVG(standard_qty) AS avg_standard_qty,
	AVG(gloss_qty) AS avg_gloss_qty,
	AVG(poster_qty) AS avg_poster_qty
FROM orders;

-- Via the video, you might be interested in
-- how to calculate the MEDIAN. Though this is more
-- advanced than what we have covered so far try finding -
-- what is the MEDIAN total_usd spent on all orders?

SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;

-- GROUP BY

-- Which account (by name) placed the earliest order? 
-- Your solution should have the account name and the date of 
-- the order.

SELECT a.name, o.occurred_at
FROM orders o
JOIN accounts a 
ON a.id = o.account_id
ORDER BY o.occurred_at
LIMIT 1;

-- Find the total sales in usd for each account.
-- You should include two columns - the total sales for each
-- company's orders in usd and the company name.

SELECT a.name, SUM(total) AS total_usd
FROM orders o
JOIN accounts a 
ON a.id = o.account_id
GROUP BY a.name	
ORDER BY a.name;

-- Via what channel did the most recent (latest)
-- web_event occur, which account was associated with
-- this web_event? Your query should return only three
-- values - the date, channel, and account name.

SELECT a.name, w.occurred_at, w.channel
FROM web_events w
JOIN accounts a 
ON a.id = w.account_id
ORDER BY w.occurred_at DESC
LIMIT 1;

-- Find the total number of times each type of
-- channel from the web_events was used. Your final
-- table should have two columns - the channel and the
-- number of times the channel was used.

SELECT w.channel as channel, COUNT(a.id)
FROM web_events w
JOIN accounts a 
ON a.id = w.account_id
GROUP BY w.channel
ORDER BY w.channel DESC;

-- Who was the primary contact associated 
-- with the earliest web_event?
SELECT a.primary_poc, w.occurred_at
FROM web_events w
JOIN accounts a 
ON a.id = w.account_id
ORDER BY w.occurred_at
LIMIT 1;

-- What was the smallest order placed by each account
-- in terms of total usd. Provide only two columns -
-- the account name and the total usd. Order from smallest
-- dollar amounts to largest.

SELECT a.name, MIN(o.total_amt_usd)
FROM accounts a 
JOIN orders o
ON	o.account_id = a.id
GROUP BY a.name
ORDER BY a.name;

-- Solution
SELECT w.channel, COUNT(*)
FROM web_events w
GROUP BY w.channel

-- Find the number of sales reps in each region.
-- Your final table should have two columns - the region
-- and the number of sales_reps. Order from fewest reps 
-- to most reps.

SELECT r.name, COUNT(a.sales_rep_id) AS number
FROM accounts a 
JOIN sales_reps s 
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
ORDER BY number;

-- GROUP BY PART 2
-- For each account, determine the average amount of
-- each type of paper they purchased across their orders.
-- Your result should have four columns - one for the account
-- name and one for the average quantity purchased for each
-- of the paper types for each account. 

SELECT a.name, AVG(o.standard_qty) standard_avg,
	AVG(o.gloss_qty) gloss_avg,
	AVG(o.poster_qty) poster_avg
FROM accounts a 
JOIN orders o 
	ON o.account_id = a.id
GROUP BY a.name
ORDER BY a.name;

-- For each account, determine the average amount spent
-- per order on each paper type. Your result should have
-- four columns - one for the account name and one for the 
-- average amount spent on each paper type.


SELECT a.name, AVG(o.standard_amt_usd) standard_qty,
	AVG(o.gloss_amt_usd) gloss_qty,
	AVG(o.poster_amt_usd) poster_qty
FROM accounts a 
JOIN orders o 
	ON o.account_id = a.id
GROUP BY a.name
ORDER BY a.name;

SELECT a.name, AVG(o.standard_amt_usd/(o.standard_qty + 0.001)) standard_qty,
	AVG(o.gloss_amt_usd/(o.gloss_qty + 0.001)) gloss_qty,
	AVG(o.poster_amt_usd/(o.poster_qty + 0.001)) poster_qty
FROM accounts a 
JOIN orders o 
	ON o.account_id = a.id
GROUP BY a.name
ORDER BY a.name;

-- Determine the number of times a particular channel 
-- was used in the web_events table for each sales rep. 
-- Your final table should have three columns - the name of 
-- the sales rep, the channel, and the number of occurrences. 
-- Order your table with the highest number of occurrences first.

SELECT s.name, w.channel, COUNT(*) as num
FROM web_events w 
JOIN accounts a
	ON w.account_id = a.id
JOIN sales_reps s 
	ON s.id = a.sales_rep_id
GROUP BY s.name, w.channel
ORDER BY num DESC;

-- Determine the number of times a particular channel
-- was used in the web_events table for each region.
-- Your final table should have three columns - the
-- region name, the channel, and the number of occurrences.
-- Order your table with the highest number of occurrences
-- first.

SELECT r.name, w.channel, COUNT(*) as num
FROM web_events w 
JOIN accounts a
	ON w.account_id = a.id
JOIN sales_reps s 
	ON s.id = a.sales_rep_id
JOIN region r
	ON s.region_id = r.id
GROUP BY r.name, w.channel
ORDER BY num DESC;

--DISTINCT

-- Use DISTINCT to test if there are any accounts 
-- associated with more than one region.

SELECT DISTINCT a.id, r.name
FROM accounts a
JOIN sales_reps s 
	ON s.id = a.sales_rep_id
JOIN region r
	ON s.region_id = r.id
ORDER BY a.id;

SELECT DISTINCT id, name
FROM accounts;

-- Have any sales reps worked on more than one account?

SELECT DISTINCT s.id AS sales_reps, a.id AS account
FROM accounts a
JOIN sales_reps s 
	ON s.id = a.sales_rep_id
ORDER BY s.id, a.id;

SELECT DISTINCT id, name
FROM sales_reps;

-- HAVING is used as WHERE for aggregated data
-- HAVING does not recognize x (from AS)

-- HAVING

-- How many of the sales reps have more 
-- than 5 accounts that they manage?

SELECT sales_rep_id, COUNT(*) AS acc
FROM accounts
GROUP BY sales_rep_id
HAVING COUNT(*) > 5
ORDER BY acc DESC;

SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
HAVING COUNT(*) > 5
ORDER BY num_accounts;

-- How many accounts have more than 20 orders?

SELECT a.name, COUNT(orders.*) AS acc
FROM orders
JOIN accounts a
	ON orders.account_id = a.id
GROUP BY a.name
HAVING COUNT(*) > 20
ORDER BY acc DESC;

-- Which account has the most orders?
SELECT a.name, SUM(orders.*) AS acc
FROM orders
JOIN accounts a
	ON orders.account_id = a.id
GROUP BY a.name
ORDER BY acc DESC
LIMIT 1;

-- How many accounts spent more than 30,000 
-- usd total across all orders?

SELECT a.name, SUM(o.total_amt_usd) AS acc
FROM orders o
JOIN accounts a
	ON o.account_id = a.id
GROUP BY a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY acc DESC;

-- How many accounts spent less than 1,000 usd 
-- total across all orders?

SELECT a.name, SUM(o.total_amt_usd) AS acc
FROM orders o
JOIN accounts a
	ON o.account_id = a.id
GROUP BY a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY acc DESC;

-- Which account has spent the most with us?

SELECT a.name, SUM(o.total_amt_usd) AS acc
FROM orders o
JOIN accounts a
	ON o.account_id = a.id
GROUP BY a.name
ORDER BY acc DESC
LIMIT 1;

-- Which account has spent the least with us?

SELECT a.name, SUM(o.total_amt_usd) AS acc
FROM orders o
JOIN accounts a
	ON o.account_id = a.id
GROUP BY a.name
ORDER BY acc
LIMIT 1;

-- Which accounts used facebook as a channel to 
-- contact customers more than 6 times?

SELECT a.name, w.channel, COUNT(w.channel) AS acc
FROM web_events w
JOIN accounts a
	ON w.account_id = a.id
GROUP BY a.name, w.channel
ORDER BY acc DESC;


SELECT a.name, w.channel, COUNT(w.channel) AS acc
FROM web_events w
JOIN accounts a
	ON w.account_id = a.id
GROUP BY a.name, w.channel
HAVING w.channel = 'facebook' --Double quote dont work
ORDER BY acc DESC;

-- Bemebem bahd guy
SELECT a.name, w.channel, COUNT(w.channel) AS acc
FROM web_events w
JOIN accounts a
	ON w.account_id = a.id
	WHERE w.channel = 'facebook'
GROUP BY a.name, w.channel
HAVING COUNT(w.channel) > 6
ORDER BY acc DESC;
-- Bemebem bahd guy

--There solution

SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
HAVING COUNT(*) > 6 AND w.channel = 'facebook'
ORDER BY use_of_channel;

-- Which account used facebook most as a channel? 
SELECT a.name, w.channel, COUNT(w.channel) AS acc
FROM web_events w
JOIN accounts a
	ON w.account_id = a.id
	WHERE w.channel = 'facebook'
GROUP BY a.name, w.channel
HAVING COUNT(w.channel) > 6
ORDER BY acc DESC
LIMIT 1;

-- Which channel was most frequently used by most accounts?

SELECT channel, COUNT(*) as num
FROM web_events
GROUP BY channel
ORDER BY num DESC
LIMIT 1;

--DATES

-- Find the sales in terms of total dollars for all orders 
-- in each year, ordered from greatest to least. Do you 
-- notice any trends in the yearly sales totals?

SELECT DATE_TRUNC('year', occurred_at) AS Year, 
		SUM(total_amt_usd) AS total_order
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

-- Which month did Parch & Posey have the greatest 
-- sales in terms of total dollars? 
-- Are all months evenly represented by the dataset?

SELECT DATE_TRUNC('month', occurred_at) AS Year, 
		SUM(total_amt_usd) AS total_order
FROM orders
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- Which year did Parch & Posey have the greatest
-- sales in terms of total number of orders? 
-- Are allyears evenly represented by the dataset?

SELECT DATE_TRUNC('year', occurred_at) AS Year, 
		COUNT(*) AS total_order
FROM orders
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- Which month did Parch & Posey have the greatest sales 
-- in terms of total number of orders? 
-- Are all months evenly represented by the dataset?

SELECT DATE_TRUNC('month', occurred_at) AS Year, 
		COUNT(*) AS total_order
FROM orders
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

SELECT DATE_PART('month', occurred_at) ord_month, COUNT(*) total_sales
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC; 

-- In which month of which year did Walmart spend 
-- the most on gloss paper in terms of dollars?

SELECT DATE_TRUNC('month', occurred_at) AS Year, 
		SUM(gloss_amt_usd) AS gloss_total_order
FROM orders o 
JOIN accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

--CASE

-- We would like to understand 3 different levels 
-- of customers based on the amount associated with 
-- their purchases. The top branch includes anyone with 
-- a Lifetime Value (total sales of all orders) greater than 
-- 200,000 usd. The second branch is between 200,000 and 
-- 100,000 usd. The lowest branch is anyone under 100,000 usd. 
-- Provide a table that includes the level associated with 
-- each account. You should provide the account name, 
-- the total sales of all orders for the customer, and 
-- the level. Order with the top spending customers listed first.

SELECT a.name, SUM(o.total_amt_usd),
	CASE WHEN o.total_amt_usd > 200000 THEN 'top branch'
		WHEN o.total_amt_usd BETWEEN 100000 AND 200000 THEN 'second branch'
		ELSE 'lowest branch' END AS level
FROM orders o 
JOIN accounts a 
	ON a.id = o.account_id
GROUP BY 1,3
ORDER BY 1;

-- We would now like to perform a similar calculation to 
-- the first, but we want to obtain the total amount spent 
-- by customers only in 2016 and 2017. Keep the same levels 
-- as in the previous question. Order with the top spending 
-- customers listed first.

--WRONG
SELECT DISTINCT a.name, 
	CASE WHEN o.occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
		THEN SUM(o.total_amt_usd) END AS total_amt,
	CASE WHEN o.total_amt_usd > 200000 THEN 'top branch'
		WHEN o.total_amt_usd BETWEEN 100000 AND 200000 THEN 'second branch'
		ELSE 'lowest branch' END AS level
FROM orders o 
JOIN accounts a 
	ON a.id = o.account_id
GROUP BY a.name, o.occurred_at,3
ORDER BY 1;
--WRONG

--RIGHT
SELECT a.name, SUM(o.total_amt_usd),
	CASE WHEN o.total_amt_usd > 200000 THEN 'top branch'
		WHEN o.total_amt_usd BETWEEN 100000 AND 200000 THEN 'second branch'
		ELSE 'lowest branch' END AS level
FROM orders o 
JOIN accounts a 
	ON a.id = o.account_id
WHERE o.occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
GROUP BY 1,3
ORDER BY 1;
--RIGHT


-- We would like to identify top performing sales reps, 
-- which are sales reps associated with more than 200 orders. 
-- Create a table with the sales rep name, the total number 
-- of orders, and a column with top or not depending on if 
-- they have more than 200 orders. Place the top sales 
-- people first in your final table.

--Wrong
SELECT s.name,
	SUM(o.total),
	CASE WHEN SUM(o.total) > 200 THEN 'top'
		ELSE 'not' END AS ranking
FROM orders o 
JOIN accounts a 
	ON a.id = o.account_id
JOIN sales_reps s 
	ON s.id = a.sales_rep_id
GROUP BY 1
ORDER BY 3 DESC;
--Wrong


-- Right
SELECT s.name, COUNT(*) num_ords,
     CASE WHEN COUNT(*) > 200 THEN 'top'
     ELSE 'not' END AS sales_rep_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY 2 DESC;
-- Right

-- The previous didn't account for the middle, 
-- nor the dollar amount associated with the sales. 
-- Management decides they want to see these characteristics 
-- represented as well. We would like to identify top 
-- performing sales reps, which are sales reps associated 
-- with more than 200 orders or more than 750000 in total 
-- sales. The middle group has any rep with more than 150 
-- orders or 500000 in sales. Create a table with the sales 
-- rep name, the total number of orders, total sales across 
-- all orders, and a column with top, middle, or low 
-- depending on this criteria. Place the top sales people 
-- based on dollar amount of sales first in your final 
-- table. You might see a few upset sales people by this 
-- criteria!

SELECT s.name, COUNT(*) num_ords, 
	SUM(o.total_amt_usd) sum_ords,
 	CASE WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'top'
 		 WHEN COUNT(*) > 200 OR (SUM(o.total_amt_usd) <= 750000 AND SUM(o.total_amt_usd) > 500000) THEN 'middle'
 		 ELSE 'low' END AS sales_rep_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY 3 DESC;