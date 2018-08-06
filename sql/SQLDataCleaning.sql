-- In the accounts table, there is a column 
-- holding the website for each company. The last three 
-- digits specify what type of web address they are using. 
-- A list of extensions (and pricing) is provided here https://iwantmyname.com/domains/domain-name-registration-list-of-extensions. 
-- Pull these extensions and provide how many of each website 
-- type exist in the accounts table.

SELECT RIGHT(website,3) AS website_extension,
		COUNT(*) AS num
FROM accounts
GROUP BY 1;

-- There is much debate about how much the name 
-- (or even the first letter of a company name) matters. 
-- Use the accounts table to pull the first letter of 
-- each company name to see the distribution of company 
-- names that begin with each letter (or number). 

SELECT LEFT((name),1) AS company_name_first_letter,
		COUNT(*) AS num
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

SELECT LEFT(UPPER(name),1) AS company_name_first_letter,
		COUNT(*) AS num
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

-- Use the accounts table and a CASE statement to create 
-- two groups: one group of company names that start with 
-- a number and a second group of those company names that 
-- start with a letter. What proportion of company names 
-- start with a letter?

SELECT SUM(num) nums, SUM(letter) letters
FROM (
		SELECT name, 
			CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 1 ELSE 0 END AS num, 
         	CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 0 ELSE 1 END AS letter
      FROM accounts) t1;

-- Consider vowels as a, e, i, o, and u. 
-- What proportion of company names start with a vowel, 
-- and what percent start with anything else?

SELECT ((num_vowel * 100)/total) AS vowel_percent, ((num_non_vowel * 100)/total) AS non_vowel_percent
FROM	(SELECT SUM(vowel) num_vowel, SUM(non_vowel) num_non_vowel, SUM(vowel) + SUM(non_vowel) AS total
		FROM	(
			SELECT name, 
				CASE WHEN LEFT(LOWER(name), 1) IN ('a','e','i','o','u') 
		                   THEN 1 ELSE 0 END AS vowel, 
		     	CASE WHEN LEFT(LOWER(name), 1) IN ('a','e','i','o','u') 
		                   THEN 0 ELSE 1 END AS non_vowel
		  	FROM accounts) t1) t2

-- Quiz: POSITION, STRPOS, & SUBSTR - AME DATA AS QUIZ 1

-- Use the accounts table to create first and last name columns
-- that hold the first and last names for the primary_poc. 

SELECT primary_poc,
	LEFT(primary_poc, STRPOS(primary_poc,' ')-1) AS firstName,
	RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc,' ')) AS lastName
FROM accounts;


-- Now see if you can do the same thing for every rep name 
-- in the sales_reps table. Again provide first and last 
-- name columns.

SELECT name,
	LEFT(name, STRPOS(name,' ')-1) AS firstName,
	RIGHT(name, LENGTH(name) - STRPOS(name,' ')) AS lastName
FROM sales_reps;

-- Quizzes CONCAT

-- Each company in the accounts table wants to create an 
-- email address for each primary_poc. The email address 
-- should be the first name of the primary_poc . last name 
-- primary_poc @ company name .com.

SELECT LOWER(CONCAT(firstName,lastName,'@',name))
	FROM (SELECT name,
		LEFT(primary_poc, STRPOS(primary_poc,' ')-1) AS firstName,
		RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc,' ')) AS lastName
		FROM accounts) tb1;

-- You may have noticed that in the previous solution 
-- some of the company names include spaces, which will 
-- certainly not work in an email address. See if you can 
-- create an email address that will work by removing 
-- all of the spaces in the account name, but otherwise 
-- your solution should be just as in question 1. 
-- Some helpful documentation is here https://www.postgresql.org/docs/8.1/static/functions-string.html.

SELECT REPLACE(email,' ','') poc_email
	FROM(
		SELECT LOWER(CONCAT(firstName,lastName,'@',name)) AS email
		FROM (SELECT name,
			LEFT(primary_poc, STRPOS(primary_poc,' ')-1) AS firstName,
			RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc,' ')) AS lastName
			FROM accounts) tb1
		) tb2;

-- We would also like to create an initial password,
-- which they will change after their first log in. 
-- The first password will be the first letter of the 
-- primary_poc's first name (lowercase), then the last 
-- letter of their first name (lowercase), the first 
-- letter of their last name (lowercase), the last letter 
-- of their last name (lowercase), the number of letters in 
-- their first name, the number of letters in their last name, 
-- and then the name of the company they are working with, 
-- all capitalized with no spaces.

SELECT (first_let_firstName || last_let_firstName || first_let_lastName || last_let_lastName 
		|| len_firstName || len_lastName || companyName) AS initialPassword
FROM(
	SELECT LOWER(LEFT(firstName,1)) AS first_let_firstName,
		LOWER(RIGHT(firstName,1)) AS last_let_firstName,
		LOWER(LEFT(lastName,1)) AS first_let_lastName,
		LOWER(RIGHT(lastName,1)) AS last_let_lastName,
		LENGTH(firstName) AS len_firstName,
		LENGTH(lastName) AS len_lastName,
		UPPER(REPLACE(name, ' ','')) AS companyName
	FROM (
		SELECT name,
			LEFT(primary_poc, STRPOS(primary_poc,' ')-1) AS firstName,
			RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc,' ')) AS lastName
		FROM accounts) tb1
	) tb2;

-- STILL IN CONSTRUCTION
WITH wtb1 AS(
		SELECT name,
			LEFT(primary_poc, STRPOS(primary_poc,' ')-1) AS firstName,
			RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc,' ')) AS lastName
		FROM accounts), 
 tb1 AS (
	SELECT LOWER(LEFT(firstName,1)) AS first_let_firstName,
		LOWER(RIGHT(firstName,1)) AS last_let_firstName,
		LOWER(LEFT(lastName,1)) AS first_let_lastName,
		LOWER(RIGHT(lastName,1)) AS last_let_lastName,
		LENGTH(firstName) AS len_firstName,
		LENGTH(lastName) AS len_lastName,
		UPPER(REPLACE(name, ' ','')) AS companyName
	FROM wtb1),
 tb3 AS (
 		SELECT LOWER(CONCAT(firstName,lastName,'@',name)) AS email
		FROM (SELECT name,
			LEFT(primary_poc, STRPOS(primary_poc,' ')-1) AS firstName,
			RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc,' ')) AS lastName
			FROM accounts) tac),
 tb4 AS (
 	SELECT (first_let_firstName || last_let_firstName || first_let_lastName || last_let_lastName 
		|| len_firstName || len_lastName || companyName) AS initialPassword
	FROM tb1)

SELECT REPLACE(t3.email,' ','') AS poc_email, t4.initialPassword AS initialPassword
FROM tb3 t3
JOIN tb4 t4
	ON t3.name = t4.name;
-- STILL IN CONSTRUCTION

-- CORRECTION
WITH t1 AS (
 SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name, 
 	RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
 FROM accounts)
SELECT first_name,
	last_name,
	CONCAT(first_name, '.', last_name, '@', name, '.com'), 
	LEFT(LOWER(first_name), 1) || RIGHT(LOWER(first_name), 1) || LEFT(LOWER(last_name), 1) 
	|| RIGHT(LOWER(last_name), 1) || LENGTH(first_name) || LENGTH(last_name) || REPLACE(UPPER(name), ' ', '')
FROM t1;

-- Write a query to look t the tpp 10 rows to understand 
-- the columns and the raw data in the dataset 
-- called sf_crime_data.

SELECT *
FROM sf_crime_data
LIMIT 10;

-- Extracting just date

SELECT LEFT(date,STRPOS(date,' ')-1) AS date
FROM sf_crime_data
LIMIT 10;

-- Udacity Platform gave me the wrong DBs

-- The format of the date column is mm/dd/yyyy with 
-- times that are not correct also at the end of the date.

SELECT date orig_date, 
	(SUBSTR(date, 7, 4) || '-' 
		|| LEFT(date, 2) || '-' 
		|| SUBSTR(date, 4, 2)) new_date
FROM sf_crime_data;

-- Notice, this new date can be operated on 
-- using DATE_TRUNC and DATE_PART in the same 
-- way as earlier lessons.

SELECT date orig_date, 
	(SUBSTR(date, 7, 4) || 
		'-' || LEFT(date, 2) || 
		'-' || SUBSTR(date, 4, 2))::DATE new_date
FROM sf_crime_data;

-- COALESCE

-- Run the query entered below in the SQL workspace 
-- to notice the row with missing data

SELECT *
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;


-- Use COALESCE to fill in the account.id column with the 
-- account.id for the NULL value for table in 1
SELECT COALESCE(accounts.id,'') AS Modified_id
FROM accounts;

-- CORRECTION
SELECT COALESCE(a.id, a.id) filled_id, 
	a.name, a.website, a.lat, a.long, 
	a.primary_poc, a.sales_rep_id, o.*
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;


-- Use COALESCE to fill in the orders.account_id column with the 
-- account.id fr NULL value for the table in 1

SELECT COALESCE(a.id, o.account_id) filled_id, 
	a.name, a.website, a.lat, a.long, 
	a.primary_poc, a.sales_rep_id, o.*
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

-- CORRECTION
SELECT COALESCE(a.id, a.id) filled_id, 
	a.name, a.website, a.lat, a.long, a.primary_poc, 
	a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, 
	o.occurred_at, o.standard_qty, o.gloss_qty, 
	o.poster_qty, o.total, o.standard_amt_usd, 
	o.gloss_amt_usd, o.poster_amt_usd, o.total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

-- Use COALESCE to fill in each of the qty and usd column with 0
-- for the table in 1

SELECT COALESCE(o.standard_amt_usd, 0) filled_standard_amt_usd, 
	COALESCE(o.poster_amt_usd, 0) filled_poster_amt_usd,
	COALESCE(o.gloss_amt_usd, 0) filled_gloss_amt_usd,
	COALESCE(o.standard_qty, 0) filled_standard_qty,
	COALESCE(o.gloss_qty, 0) filled_gloss_qty,
	COALESCE(o.poster_qty, 0) filled_poster_qty
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

-- CORRECTION (mine correct though)
SELECT COALESCE(a.id, a.id) filled_id, 
	a.name, 
	a.website, 
	a.lat, 
	a.long, 
	a.primary_poc, 
	a.sales_rep_id, 
	COALESCE(o.account_id, a.id) account_id, 
	o.occurred_at, 
	COALESCE(o.standard_qty, 0) standard_qty, 
	COALESCE(o.gloss_qty,0) gloss_qty, 
	COALESCE(o.poster_qty,0) poster_qty, 
	COALESCE(o.total,0) total, 
	COALESCE(o.standard_amt_usd,0) standard_amt_usd, 
	COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, 
	COALESCE(o.poster_amt_usd,0) poster_amt_usd, 
	COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

-- Run the query in 1 with the WHERE removed and 
-- COUNT the numbers of ids

SELECT COUNT(*)
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;

-- Run the query in 5, but with the COALESCE function used in
-- questions 2 through 4

SELECT COALESCE(a.id, a.id) filled_id, 
	a.name, 
	a.website, 
	a.lat, 
	a.long, 
	a.primary_poc, 
	a.sales_rep_id, 
	COALESCE(o.account_id, a.id) account_id, 
	o.occurred_at, 
	COALESCE(o.standard_qty, 0) standard_qty, 
	COALESCE(o.gloss_qty,0) gloss_qty, 
	COALESCE(o.poster_qty,0) poster_qty, 
	COALESCE(o.total,0) total, 
	COALESCE(o.standard_amt_usd,0) standard_amt_usd, 
	COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, 
	COALESCE(o.poster_amt_usd,0) poster_amt_usd, 
	COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;