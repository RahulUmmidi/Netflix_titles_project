---------------- Netflix Project ---------------

CREATE TABLE netflix
(
	show_id VARCHAR(6),	
	type	VARCHAR(10),
	title	VARCHAR(150),
	director	VARCHAR(220),
	casts	VARCHAR(1000),
	country	VARCHAR(150),
	date_added	VARCHAR(50),
	release_year	INT,
	rating	VARCHAR(10),
	duration	VARCHAR(15),
	listed_in	VARCHAR(100),
	description	 VARCHAR(250)
	);

select * from netflix;

select distinct type from netflix;

--1. Count the number of movies and TV shows

select type, COUNT(*) FROM netflix
GROUP BY type;

-- 2. Find the most common rating for the movies and TV shows

WITH CTE AS
(
SELECT type,rating,COUNT(*),
	Rank() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as rank from netflix
GROUP BY type,rating
)
SELECT type, rating from CTE WHERE rank = 1; 

-- 3. List all the movies released in specific year(for instanc 2002)

select * from netflix;

select * from netflix where type= 'Movie' and release_year = '2002';

-- 4. Find the top 5 countries with most content in netflix

/*select show_id, country from netflix
	WHERE country='Germany';  -- 67 

select show_id, country from netflix
	WHERE country like '%East Germany%';


select show_id, country from netflix
	WHERE country like '%Germany%'; -- 231

select UNNEST(STRING_TO_ARRAY(country,',')),show_id from netflix

	select country, show_id from netflix;


select UNNEST(STRING_TO_ARRAY(country,',')), count(show_id) from netflix
	GROUP BY 1;*/

WITH SplitCountries AS (
    SELECT UNNEST(STRING_TO_ARRAY(country, ',')) AS country
    FROM netflix
)
select TRIM(country) AS country, COUNT(*) AS total_titles
from SplitCountries
where country IS NOT NULL
GROUP BY country
ORDER BY total_titles DESC
LIMIT 5;

-- 5. Identify the longest movie

Select title, duration
from netflix
where type = 'Movie' and duration is NOT NULL
ORDER BY CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) DESC
LIMIT 1;

-- 6. Find the content added in the last five years

Select title, type, date_added
from netflix
WHERE date_added IS NOT NULL
AND TO_DATE(date_added, 'MONTH DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'
ORDER BY date_added DESC;

-- 7. Find all the movies and TV shows by specific director('Rajiv Chilaka')

select * from netflix 
	WHERE director Ilike '%Rajiv Chilaka%';  --ILIKE: Case sensitive

-- 8. List all the Tv shows with more than 5 seasons

/*select * from netflix
WHERE type = 'TV Show' and duration like '%6%'; I */

WITH CTE AS(
select *,CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) as new_duration from netflix
)
SELECT * from CTE
WHERE type = 'TV Show' and new_duration>5;

-- 9. Count the number of content items in each genre

select COUNT(show_id), UNNEST(STRING_TO_ARRAY(listed_in,',')) as new_listedin from netflix
GROUP BY 2;

-- 10. Find each year and the average number of content release by India on netflix. Return the top 5 year with highest avg content release year

select EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS Year,
ROUND(COUNT(show_id)::numeric/(select COUNT(*) FROM netflix WHERE country like '%India%')::numeric*100,2) Average
from netflix
WHERE country like '%India%'
GROUP BY Year
ORDER BY 2 DESC
LIMIT 5;

-- 11. List all the movies that are documentaries

select * from netflix
WHERE type ='Movie'
AND listed_in like '%Documentaries';

-- 12. Find all the content without a director

select * from netflix where director is NULL;

-- 13. Find in how many movies actor 'Salman Khan' acted in last ten years

select title,casts,release_year from netflix
WHERE type = 'Movie' and casts ilike '%Salman Khan%' and (release_year) >= EXTRACT(YEAR FROM CURRENT_DATE) - 10

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India

select UNNEST(STRING_TO_ARRAY(casts,',')) AS actors,COUNT(*)
from netflix
WHERE country ilike '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description
-- field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category

select show_id, title, 
CASE 
WHEN description ilike '%kill%' or description ilike '%violence%' THEN 'Bad'
ELSE 'Good'
END AS new_category
from netflix;

select COUNT(show_id), 
CASE 
WHEN description ilike '%kill%' or description ilike '%violence%' THEN 'Bad'
ELSE 'Good'
END AS new_category
from netflix
GROUP BY 2;
#New Update













