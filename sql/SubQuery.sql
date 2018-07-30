-- Number of events that occur each day for each channel.

SELECT DISTINCT channel,	
	DATE_TRUNC('day',occurred_at) AS day,
	COUNT(*) as event_number
FROM web_events
GROUP BY 1,2
ORDER BY 3 DESC;

SELECT *
FROM
	(SELECT DISTINCT channel,	
		DATE_TRUNC('day',occurred_at) AS day,
		COUNT(*) as event_number
	FROM web_events
	GROUP BY 1,2) sub;

SELECT channel,
	AVG(event_number) AS avg_event_num
FROM
	(SELECT DISTINCT channel,	
		DATE_TRUNC('day',occurred_at) AS day,
		COUNT(*) as event_number
	FROM web_events
	GROUP BY 1,2
	) sub
GROUP BY 1
ORDER BY 2 DESC;