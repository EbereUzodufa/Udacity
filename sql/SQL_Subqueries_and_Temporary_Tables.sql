-- Use DATE_TRUNC to pull month level information about 
-- the first order ever placed in the orders table.

SELECT DATE_TRUNC('month',occurred_at) months
FROM orders
ORDER BY 1;

-- Most correct
SELECT MIN(occurred_at)
FROM orders;

-- Use the result of the previous query to find only the 
-- orders that took place in the same month and year as the 
-- first order, and then pull the average for each type of 
-- paper qty in this month

SELECT id, occurred_at, AVG(standard_qty) avg_standard_qty,
	AVG(poster_qty) avg_poster_qty,
	AVG(gloss_qty) avg_gloss_qty
FROM orders
WHERE DATE_TRUNC('month',occurred_at) =
	(SELECT DATE_TRUNC('month',MIN(occurred_at))
	FROM orders)
GROUP BY 1,2
ORDER BY occurred_at;

SELECT AVG(standard_qty) avg_standard_qty,
	AVG(poster_qty) avg_poster_qty,
	AVG(gloss_qty) avg_gloss_qty
FROM orders
WHERE DATE_TRUNC('month',occurred_at) =
	(SELECT DATE_TRUNC('month',MIN(occurred_at))
	FROM orders);

-- The total amount spent on all orders on the first month
-- that any order was placed in the orders table (in terms of usd)
SELECT SUM(total_amt_usd)
FROM orders
WHERE DATE_TRUNC('month',occurred_at) =
	(SELECT DATE_TRUNC('month',MIN(occurred_at))
	FROM orders);

-- Provide the name of the sales_rep in each region with the 
-- largest amount of total_amt_usd sales.
SELECT s.name, r.name, SUM(o.total_amt_usd) t1
FROM orders o 
JOIN accounts a
ON a.id = o.account_id
JOIN sales_reps s 
ON s.id = a.sales_rep_id
JOIN region r 
ON r.id = s.region_id
GROUP BY s.name, r.name
ORDER BY 3 DESC;

SELECT t1.sname, t1.rname, MAX(ct1)
FROM (SELECT s.name sname, r.name rname, SUM(o.total_amt_usd) ct1
	FROM orders o 
	JOIN accounts a
	ON a.id = o.account_id
	JOIN sales_reps s 
	ON s.id = a.sales_rep_id
	JOIN region r 
	ON r.id = s.region_id
	GROUP BY s.name, r.name) t1
GROUP BY t1.sname, t1.rname
ORDER BY 3 DESC;

-- For the region with the largest (sum) of sales total_amt_usd,
-- how many total (count) orders were placed? 

SELECT t1.sname, t1.rname, MAX(ct1), t1.cnt
FROM (SELECT s.name sname, r.name rname, 
		SUM(o.total_amt_usd) ct1, COUNT(o.total_amt_usd) cnt
	FROM orders o 
	JOIN accounts a
	ON a.id = o.account_id
	JOIN sales_reps s 
	ON s.id = a.sales_rep_id
	JOIN region r 
	ON r.id = s.region_id
	GROUP BY s.name, r.name) t1
GROUP BY t1.sname, t1.rname, t1.cnt
ORDER BY 3 DESC;

-- Most correct

SELECT t3.rep_name, t3.region_name, t3.total_amt
FROM(SELECT region_name, MAX(total_amt) total_amt
     FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
             FROM sales_reps s
             JOIN accounts a
             ON a.sales_rep_id = s.id
             JOIN orders o
             ON o.account_id = a.id
             JOIN region r
             ON r.id = s.region_id
             GROUP BY 1, 2) t1
     GROUP BY 1) t2
JOIN (SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
     FROM sales_reps s
     JOIN accounts a
     ON a.sales_rep_id = s.id
     JOIN orders o
     ON o.account_id = a.id
     JOIN region r
     ON r.id = s.region_id
     GROUP BY 1,2
     ORDER BY 3 DESC) t3
ON t3.region_name = t2.region_name AND t3.total_amt = t2.total_amt;


-- For the name of the account that purchased the most 
-- (in total over their lifetime as a customer) 
-- standard_qty paper, how many accounts still had more in total 
-- purchases?

SELECT MAX(ct1)
FROM (SELECT s.name sname, r.name rname, SUM(o.total_amt_usd) ct1
	FROM orders o 
	JOIN accounts a
	ON a.id = o.account_id
	JOIN sales_reps s 
	ON s.id = a.sales_rep_id
	JOIN region r 
	ON r.id = s.region_id
	GROUP BY s.name, r.name);

SELECT a.name
FROM accounts a
JOIN orders o 
ON o.account_id = a.id
WHERE o.standard_qty > (
	SELECT MAX(ct1)
	FROM (SELECT r.name rname, 
			SUM(o.total_amt_usd) ct1
		FROM orders o 
		JOIN accounts a
		ON a.id = o.account_id
		JOIN sales_reps s 
		ON s.id = a.sales_rep_id
		JOIN region r 
		ON r.id = s.region_id
		GROUP BY r.name) mai
);

SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (
      SELECT MAX(total_amt)
      FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
              FROM sales_reps s
              JOIN accounts a
              ON a.sales_rep_id = s.id
              JOIN orders o
              ON o.account_id = a.id
              JOIN region r
              ON r.id = s.region_id
              GROUP BY r.name) sub);

-- For the customer that spent the most (in total over their 
-- lifetime as a customer) total_amt_usd, how many 
-- web_events did they have for each channel?

SELECT a.name account_name,
	SUM(o.standard_qty) total_std,
	SUM(o.total) total
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

SELECT a.name
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY 1
HAVING SUM(o.total) > (
	SELECT total 
  	FROM (
  		SELECT a.name act_name, 
  			SUM(o.standard_qty) tot_std, 
  			SUM(o.total) total
        FROM accounts a
        JOIN orders o
            ON o.account_id = a.id
        GROUP BY 1
        ORDER BY 2 DESC
        LIMIT 1) 
  	sub
);

SELECT COUNT(*)
FROM (SELECT a.name
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY 1
      HAVING SUM(o.total) > (SELECT total 
                  FROM (SELECT a.name act_name, SUM(o.standard_qty) tot_std, SUM(o.total) total
                        FROM accounts a
                        JOIN orders o
                        ON o.account_id = a.id
                        GROUP BY 1
                        ORDER BY 2 DESC
                        LIMIT 1) inner_tab)
            ) counter_tab;


-- COULDN'T DO THIS PART WELL. SO I KEPT THE SOLUTION TO 
-- LEARN BETTER

-- For the customer that spent the most 
-- (in total over their lifetime as a customer) 
-- total_amt_usd, how many web_events did they have 
-- for each channel?

-- Here, we first want to pull the customer 
-- with the most spent in lifetime value.

SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY 3 DESC
LIMIT 1;

-- Now, we want to look at the number of events on each 
-- channel this company had, which we can match with just the id.

SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id AND a.id =  (
	SELECT id
 	FROM (
 			SELECT a.id, a.name, 
 				SUM(o.total_amt_usd) tot_spent
               FROM orders o
               JOIN accounts a
               	ON a.id = o.account_id
               GROUP BY a.id, a.name
               ORDER BY 3 DESC
               LIMIT 1
       ) inner_table
 	)
GROUP BY 1, 2
ORDER BY 3 DESC;


-- I added an ORDER BY for no real reason, and the account 
-- name to assure I was only pulling from one account.


-- What is the lifetime average amount spent in terms of
-- total_amt_usd for the top 10 total spending accounts?

-- First, we just want to find the top 10 accounts in terms of 
-- highest total_amt_usd.

SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY 3 DESC
LIMIT 10;

-- Now, we just want the average of these 10 amounts.

SELECT AVG(tot_spent)
FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY a.id, a.name
      ORDER BY 3 DESC
       LIMIT 10) temp;

-- What is the lifetime average amount spent in 
-- terms of total_amt_usd for only the companies that spent 
-- more than the average of all orders.

-- First, we want to pull the average of all accounts in 
-- terms of total_amt_usd:

SELECT AVG(o.total_amt_usd) avg_all
FROM orders o
JOIN accounts a
ON a.id = o.account_id;

-- Then, we want to only pull the accounts with more than 
-- this average amount.

SELECT o.account_id, AVG(o.total_amt_usd)
FROM orders o
GROUP BY 1
HAVING AVG(o.total_amt_usd) > 
	(SELECT AVG(o.total_amt_usd) avg_all
       FROM orders o
       JOIN accounts a
       ON a.id = o.account_id
   );

-- Finally, we just want the average of these values

SELECT AVG(avg_amt)
FROM (
	SELECT o.account_id,
		AVG(o.total_amt_usd) avg_amt
    FROM orders o
    GROUP BY 1
    HAVING AVG(o.total_amt_usd) > 
    	(SELECT AVG(o.total_amt_usd) avg_all
	       FROM orders o
	       JOIN accounts a
           ON a.id = o.account_id
           )
	) temp_table;