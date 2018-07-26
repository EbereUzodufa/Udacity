-- Joining tables orders and accounts

SELECT orders.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

-- Try pulling all the data from the accounts table, 
-- and all the data from the orders table.

SELECT orders.*, accounts.* --You can use just *; it worked for me
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

-- Try pulling standard_qty, gloss_qty, and poster_qty from 
-- the orders table, and the website and the primary_poc from 
-- the accounts table.

SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty,
		accounts.website, accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

-- Provide a table for all web_events associated with account name 
-- of Walmart. There should be three columns. Be sure to include the 
-- primary_poc, time of the event, and the channel for each event. 
-- Additionally, you might choose to add a fourth column to assure 
-- only Walmart events were chosen. 

SELECT a.name, a.primary_poc, w.occurred_at, w.channel
FROM web_events AS w
JOIN accounts AS a
ON w.account_id = a.id
WHERE a.name='Walmart';

-- SOLUTION Udacity Solution
-- SELECT a.primary_poc, w.occurred_at, w.channel, a.name
-- FROM web_events w
-- JOIN accounts a
-- ON w.account_id = a.id
-- WHERE a.name = 'Walmart';

-- Provide a table that provides the region for each sales_rep along
-- with their associated accounts. Your final table should include
-- three columns: the region name, the sales rep name, and the
-- account name. Sort the accounts alphabetically (A-Z) according to
-- account name. 

SELECT s.name reps, a.name accounts, r.name region
FROM accounts AS a
JOIN sales_reps AS s
ON a.sales_rep_id = s.id
JOIN region AS r
ON s.region_id = r.id
ORDER BY a.name;


-- SOLUTION Udacity Solution
-- SELECT r.name region, s.name rep, a.name account
-- FROM sales_reps s
-- JOIN region r
-- ON s.region_id = r.id
-- JOIN accounts a
-- ON a.sales_rep_id = s.id
-- ORDER BY a.name;

-- Provide the name for each region for every order, as well as the 
-- account name and the unit price they paid (total_amt_usd/total)
-- for the order. Your final table should have 3 columns: region name,
-- account name, and unit price. A few accounts have 0 for total,
-- so I divided by (total + 0.01) to assure not dividing by zero.

SELECT r.name region, a.name account, (o.total_amt_usd/(o.total+0.01)) unit_price
FROM accounts AS a
JOIN sales_reps AS s
ON a.sales_rep_id = s.id
JOIN region AS r
ON s.region_id = r.id
JOIN orders AS o
ON a.id = o.account_id;

-- Provide a table that provides the region for each sales_rep
-- along with their associated accounts. This time only for the
-- Midwest region. Your final table should include three columns:
-- the region name, the sales rep name, and the account name.
-- Sort the accounts alphabetically (A-Z) according to
-- account name.

SELECT r.name region, s.name reps, a.name account
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r 
ON s.region_id = r.id
	AND r.name = 'Midwest';

-- Provide a table that provides the region for each sales_rep
-- along with their associated accounts. This time only for
-- accounts where the sales rep has a first name starting with S
-- and in the Midwest region. Your final table should include
-- three columns: the region name, the sales rep name, and
-- the account name. Sort the accounts alphabetically (A-Z)
-- according to account name. 

SELECT r.name region, s.name reps, a.name account
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r 
ON s.region_id = r.id
	AND s.name LIKE 'S%'
	AND r.name = 'Midwest'
ORDER BY a.name;

-- Provide a table that provides the region for each 
-- sales_rep along with their associated accounts. This time 
-- only for accounts where the sales rep has a last name 
-- starting with K and in the Midwest region. Your final 
-- table should include three columns: the region name, 
-- the sales rep name, and the account name. Sort the accounts 
-- alphabetically (A-Z) according to account name.

SELECT r.name region, s.name reps, a.name account
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r 
ON s.region_id = r.id
	AND s.name LIKE '%K'
	AND r.name = 'Midwest'
ORDER BY a.name;

-- Provide the name for each region for every order, 
-- as well as the account name and the unit price they 
-- paid (total_amt_usd/total) for the order. However, you should 
-- only provide the results if the standard order quantity 
-- exceeds 100. Your final table should have 3 columns: region 
-- name, account name, and unit price. In order to avoid a 
-- division by zero error, adding .01 to the denominator here 
-- is helpful total_amt_usd/(total+0.01). 

SELECT r.name region, a.name account, (o.total_amt_usd/(o.total+0.01)) unit_price
FROM accounts AS a
JOIN sales_reps AS s
	ON a.sales_rep_id = s.id
JOIN region AS r
	ON s.region_id = r.id
JOIN orders AS o
	ON a.id = o.account_id
	AND o.standard_qty > 100;