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

SELECT a.name, AVG(o.standard_amt_usd) standard_qty,
	AVG(o.gloss_amt_usd) gloss_qty,
	AVG(o.poster_amt_usd) poster_qty
FROM accounts a 
JOIN orders o 
	ON o.account_id = a.id
GROUP BY a.name
ORDER BY a.name;

-- For each account, determine the average amount spent
-- per order on each paper type. Your result should have
-- four columns - one for the account name and one for the 
-- average amount spent on each paper type.

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