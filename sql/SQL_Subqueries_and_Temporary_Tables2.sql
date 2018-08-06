-- Provide the name of the sales_rep 
-- in each region with the largest amount of total_amt_usd sales.

WITH tb1 AS (SELECT s.name sname, 
				r.name rname, SUM(o.total_amt_usd) ct1
		FROM orders o 
		JOIN accounts a
		ON a.id = o.account_id
		JOIN sales_reps s 
		ON s.id = a.sales_rep_id
		JOIN region r 
		ON r.id = s.region_id
		GROUP BY s.name, r.name
		ORDER BY 3 DESC),
	tb2 AS (SELECT rname rep_name, MAX(ct1) ct2
			FROM tb1
		GROUP BY 1)

SELECT sname, rname, tb1.ct1
FROM tb1
JOIN tb2
ON tb1.rname = tb2.rep_name and tb1.ct1 = tb2.ct2;

-- For the region with the largest sales total_amt_usd,
-- how many total orders were placed? 

WITH tb1 AS (SELECT s.name sname, 
				r.name rname, SUM(o.total_amt_usd) ct1,
				COUNT(o.total) cto
		FROM orders o 
		JOIN accounts a
		ON a.id = o.account_id
		JOIN sales_reps s 
		ON s.id = a.sales_rep_id
		JOIN region r 
		ON r.id = s.region_id
		GROUP BY s.name, r.name
		ORDER BY 3 DESC),
	tb2 AS (SELECT rname rep_name, MAX(ct1) ct2
			FROM tb1
		GROUP BY 1)

SELECT sname, rname, tb1.ct1, cto
FROM tb1
JOIN tb2
ON tb1.rname = tb2.rep_name and tb1.ct1 = tb2.ct2
LIMIT 1;

-- CORRECTION

WITH tb1 AS (SELECT r.name rname, SUM(o.total_amt_usd) ct1
		FROM orders o 
		JOIN accounts a
		ON a.id = o.account_id
		JOIN sales_reps s 
		ON s.id = a.sales_rep_id
		JOIN region r 
		ON r.id = s.region_id
		GROUP BY r.name),
	tb2 AS (
			SELECT MAX(ct1)
			FROM tb1
		)

SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (SELECT * FROM tb2);

-- For the account that purchased the most (in total over 
-- their lifetime as a customer) standard_qty paper, 
-- how many accounts still had more in total purchases? 


WITH temp_table AS (
		SELECT AVG(o.total_amt_usd) avg_all
        FROM orders o
        JOIN accounts a
        ON a.id = o.account_id),
	 avg_table AS (
	  	SELECT o.account_id,
			AVG(o.total_amt_usd) avg_amt
    	FROM orders o
	    GROUP BY 1)

SELECT AVG(avg_amt)
FROM avg_table
HAVING avg_table.avg_amt > temp_table;

-- CORRECTION
WITH t1 AS (
  SELECT a.name account_name, SUM(o.standard_qty) total_std, 
  	SUM(o.total) total
  FROM accounts a
  JOIN orders o
  ON o.account_id = a.id
  GROUP BY 1
  ORDER BY 2 DESC
  LIMIT 1), 
t2 AS (
  SELECT a.name
  FROM orders o
  JOIN accounts a
  ON a.id = o.account_id
  GROUP BY 1
  HAVING SUM(o.total) > (SELECT total FROM t1))
SELECT COUNT(*)
FROM t2;


