-- SELECT * FROM artist;
-- SELECT * FROM canvas_size;
-- SELECT * FROM image_link;
-- SELECT * FROM museum_hours;
-- SELECT * FROM museum;
-- SELECT * FROM product_size;
-- SELECT * FROM subject;
-- SELECT * FROM work;

-- 1) Fetch all the paintings which are not displayed in any museums.
SELECT *
FROM work
WHERE museum_id IS NULL;

-- 2) Are there museums without any paintings?
SELECT * 
FROM museum m
LEFT JOIN work w ON w.museum_id = m.museum_id
WHERE w.museum_id IS NULL;

-- 3) How many paintings have an asking price of more than their regular price? 
SELECT 
	COUNT(*) 
FROM product_size
WHERE sale_price > regular_price;

-- 4) Identify the paintings whose asking price is less than 50% of its regular price.
SELECT *
FROM product_size
WHERE  sale_price < (regular_price / 2);

-- 5) Which canvas size costs the most?
SELECT 
	cs.label AS size,
	ps.sale_price
FROM canvas_size cs
JOIN product_size ps ON ps.size_id = CAST(cs.size_id AS text)
ORDER BY ps.sale_price DESC
LIMIT 1;

-- 6) Delete duplicate records from work, product_size, subject and image_link tables.
SELECT
	COUNT(name),
	name
FROM work
GROUP BY name, artist_id
HAVING COUNT(name) > 1

DELETE FROM
	work w1
USING work w2
WHERE w1.work_id < w2.work_id
AND w1.name = w2.name
AND w1.artist_id = w2.artist_id

-- 7) Identify the museums with invalid city information in the given dataset.
SELECT * 
FROM museum
WHERE city ~ '^[0-9]'

-- 8) Fetch the top 10 most famous painting subjects.
SELECT 
	subject,
	COUNT(work_id) AS num_paintings
FROM subject
GROUP BY subject
ORDER BY COUNT(work_id) DESC
LIMIT 10

-- 9) Identify the museums which are open on both Sunday and Monday. Display museum name, city.
SELECT
	DISTINCT
	m.name,
	m.city
FROM museum_hours mh
JOIN museum m ON m.museum_id = mh.museum_id
WHERE mh.day IN ('Sunday', 'Monday')
AND mh.open IS NOT NULL

-- 10) How many museums are open every single day?
SELECT
	COUNT(DISTINCT museum_id) AS num_museums_open_every_day
FROM museum_hours
WHERE day IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')
AND open IS NOT NULL

-- 11) Which are the top 5 most popular museums? (Popularity is defined based on most number of paintings in a museum)
SELECT
	m.museum_id, 
	m.name,
	COUNT(*) as num_paintings
FROM museum m
JOIN work w ON m.museum_id = w.museum_id
GROUP BY m.museum_id, m.name
ORDER BY num_paintings DESC
LIMIT 5;

-- 12) Which museum is open for the longest during a day? Display the museum name, state and hours on its longest day.
SELECT
	m.name,
	m.state,
	EXTRACT(HOUR FROM TO_TIMESTAMP(SUBSTRING(mh.close, 1, 5), 'HH:MM'))
FROM museum m
JOIN museum_hours mh ON mh.museum_id = m.museum_id

-- 13) Which are the 3 most popular and 3 least popular painting styles?
(SELECT 
	subject,
	COUNT(work_id) AS num_paintings
FROM subject
GROUP BY subject
ORDER BY COUNT(work_id) DESC
LIMIT 3)
UNION
(SELECT 
	subject,
	COUNT(work_id) AS num_paintings
FROM subject
GROUP BY subject
ORDER BY COUNT(work_id) ASC
LIMIT 3)
ORDER BY num_paintings DESC

