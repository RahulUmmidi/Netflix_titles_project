# Netflix Data Analysis Project

## 📌 Project Overview
This project involves analyzing the Netflix dataset to uncover insights about content trends, country-wise production, and yearly releases. Using SQL, we perform various queries to explore content distribution, the longest movie, and the growth of Netflix content over the years.

## 📂 Dataset Description
The dataset used in this project is obtained from Kaggle and contains information about Netflix titles, including:
- **Title** – Name of the movie/show.
- **Director** – Name of the director(s).
- **Cast** – Leading actors.
- **Country** – Country where the content was produced.
- **Release Year** – The year when the content was added.
- **Duration** – The length of the movie or show.
- Few other columns including show_id, description, date_added, rating, Genre(Listed in)

## 🎯 Objectives

1. Analyze the distribution of content types (movies vs TV shows).
2. Identify the most common ratings for movies and TV shows.
3. List and analyze content based on release years, countries, and durations.
4. Explore and categorize content based on specific criteria and keywords.




## Dataset

- The data for this project is sourced from the Kaggle dataset:
- Dataset Link: https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download

## Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```
## Business Problems and Solutions

- 1. Count the Number of Movies vs TV Shows
```sql
SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;
```
- Objective: Determine the distribution of content types on Netflix.

- 2. Find the Most Common Rating for Movies and TV Shows
```sql
WITH CTE AS
(
SELECT type,rating,COUNT(*),
	Rank() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as rank from netflix
GROUP BY type,rating
)
SELECT type, rating from CTE WHERE rank = 1;
```
- Objective: Identify the most frequently occurring rating for each type of content.

- 3. List All Movies Released in a Specific Year (e.g., 2020)
```sql
SELECT * 
FROM netflix
WHERE release_year = 2020;
```
- Objective: Retrieve all movies released in a specific year.

- 4. Find the Top 5 Countries with the Most Content on Netflix
```sql
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
```
- Objective: Identify the top 5 countries with the highest number of content items.

- 5. Identify the Longest Movie
```sql
Select title, duration
from netflix
where type = 'Movie' and duration is NOT NULL
ORDER BY CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) DESC
LIMIT 1;
```
- Objective: Find the movie with the longest duration.

- 6. Find Content Added in the Last 5 Years
```sql
Select title, type, date_added
from netflix
WHERE date_added IS NOT NULL
AND TO_DATE(date_added, 'MONTH DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'
ORDER BY date_added DESC;
```
- Objective: Retrieve content added to Netflix in the last 5 years.

- 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
```sql
select * from netflix 
	WHERE director Ilike '%Rajiv Chilaka%';  --ILIKE: Case sensitive
```
- Objective: List all content directed by 'Rajiv Chilaka'.

- 8. List All TV Shows with More Than 5 Seasons
```sql
WITH CTE AS(
select *,CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) as new_duration from netflix
)
SELECT * from CTE
WHERE type = 'TV Show' and new_duration>5;
```
- Objective: Identify TV shows with more than 5 seasons.

- 9. Count the Number of Content Items in Each Genre
```sql
select COUNT(show_id), UNNEST(STRING_TO_ARRAY(listed_in,',')) as new_listedin from netflix
GROUP BY 2;
```
- Objective: Count the number of content items in each genre.

- 10.Find each year and the average numbers of content release in India on netflix. Return top 5 year with highest avg content release!
```sql
select EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS Year,
ROUND(COUNT(show_id)::numeric/(select COUNT(*) FROM netflix WHERE country like '%India%')::numeric*100,2) Average
from netflix
WHERE country like '%India%'
GROUP BY Year
ORDER BY 2 DESC
LIMIT 5;
```
- Objective: Calculate and rank years by the average number of content releases by India.

- 11. List All Movies that are Documentaries
```sql
select * from netflix
WHERE type ='Movie'
AND listed_in like '%Documentaries';
```
- Objective: Retrieve all movies classified as documentaries.

- 12. Find All Content Without a Director
```sql
SELECT * 
FROM netflix
WHERE director IS NULL;
```
- Objective: List content that does not have a director.

- 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
```sql
select title,casts,release_year from netflix
WHERE type = 'Movie' and casts ilike '%Salman Khan%' and (release_year) >= EXTRACT(YEAR FROM CURRENT_DATE) - 10
```
- Objective: Count the number of movies featuring 'Salman Khan' in the last 10 years.

- 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
```sql
select UNNEST(STRING_TO_ARRAY(casts,',')) AS actors,COUNT(*)
from netflix
WHERE country ilike '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

```
- Objective: Identify the top 10 actors with the most appearances in Indian-produced movies.

- 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
```sql
select COUNT(show_id), 
CASE 
WHEN description ilike '%kill%' or description ilike '%violence%' THEN 'Bad'
ELSE 'Good'
END AS new_category
from netflix
GROUP BY 2;
```
- Objective: Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

# Findings and Conclusion

- Content Distribution: The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- Common Ratings: Insights into the most common ratings provide an understanding of the content's target audience.
- Geographical Insights: The top countries and the average content releases by India highlight regional content distribution.
- Content Categorization: Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.
- This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.



## 📊 Key Findings
- The **United States** and **India** are among the top content producers on Netflix.
- The longest movie in the dataset was **XYZ (replace with the actual title from your query results)**.
- Netflix has significantly increased content production in recent years.
- The highest average content release year for India was **YYYY (replace with actual result)**.

## 🚀 How to Run the Queries
1. Download the dataset from Kaggle (or use the provided dataset if available).
2. Import the dataset into **PostgreSQL**.
3. Open your preferred SQL editor (PgAdmin, DBeaver, etc.).
4. Run the queries provided in **Netflix_practice.sql**.
5. Analyze the output and derive insights.

## 📞 Contact
If you have any questions or feedback, feel free to connect:

**Rahul Ummidi**  
📧 Email: rahulummidi789@gmail.com  
🔗 LinkedIn: https://www.linkedin.com/in/rahul-ummidi 

**Thank you, and I look forward to connecting with you!

---


