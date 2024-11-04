--Netflix project
Drop TABLE IF EXXISTS NETFLIX;
CREATE TABLE netflix
(
   show_id VARCHAR(10),
   type VARCHAR(10),
   title VARCHAR(150),
   director VARCHAR(210),
   casts VARCHAR(1000),
   country VARCHAR(150),
   date_added VARCHAR(50),
   release_year int,
   rating VARCHAR(10),
   duration VARCHAR(15),
   listed_in VARCHAR(150),
   description VARCHAR(300)
);

SELECT * FROM netflix;

select 
count(*) as total_content 
from netflix;

select 
distinct type
from netflix;

select * from netflix;

--15 Business problems & solutions

-- 1. Count the number of Movies vs TV Shows
 SELECT 
 type, count(*) as total
 from netflix
 group by type;


--2. Find the most common rating for movies and TV shows
SELECT  
     type,
     rating
FROM
(
SELECT
    type, rating,
    count(*),
	RANK() over(partition by type order by count(*) desc) as ranking
    FROM netflix
    Group by 1,2
) as t1
WHERE
   ranking=1 ;

--3. List all movies released in a specific year (e.g., 2020)
SELECT *
FROM netflix
where type='Movie'
      And
	  release_year=2020;

-- 4. Find the top 5 countries with the most content on Netflix
select
  unnest(string_to_array(country,',')) as new_country,
  count (show_id) as total_content
  from netflix
  group by 1
  order by  2 desc
  limit 5;


5. Identify the longest movie
SELECT * FROM netflix
where type='Movie'
       and 
	   duration=(select max(duration) from netflix);

6. Find content added in the last 5 years
SELECT * FROM netflix
WHERE 
TO_DATE(date_added, 'Month dd,yyyy')>= current_date - interval '5 years'

7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT * FROM NETFLIX
WHERE director ilike '%Rajiv Chilaka%';

--8. List all TV shows with more than 5 seasons
SELECT * FROM NETFLIX
WHERE type='TV Show'
and split_part(duration,' ',1):: numeric>5

--9. Count the number of content items in each genre
SELECT 
UNNEST (STRING_TO_ARRAY(listed_in,',')) as genre,
COUNT (show_id) as total_content
FROM NETFLIX
GROUP BY 1;

--10.Find each year and the average numbers of content release in India on netflix. 
--return top 5 year with highest avg content release!
SELECT
EXTRACT(YEAR FROM TO_DATE(date_added , 'Month dd,yyyy')) as year,
count(*) as yearly_content,
round(count(*)::numeric/(select count(*) from netflix where country='India')::numeric*100
,2) as  avg_content_per_year
from netflix
where country='India'
group by 1

11. List all movies that are documentaries
SELECT * FROM netflix
where listed_in ilike '%documentaries%'

12. Find all content without a director
SELECT * FROM netflix
Where director is null;


13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT * FROM netflix
WHERE casts ilike '%salman khan%'
and 
release_year>  extract(year from current_date) -10



14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
select 
unnest(string_to_array(casts,',')) as actors,
count(*) as total_content
from netflix
where country ilike '%India%'
group by 1
order by 2 desc
limit 10;


-- 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
 the description field. Label content containing these keywords as 'Bad' and all other 
  content as 'Good'. Count how many items fall into each category.

with new_table
as 
(
SELECT *,
Case when  description ilike '%kill%'or
     description ilike '% violence%' then 'Bad_content'
     else 'Good_content'
end category
FROM netflix
)
SELECT 
category,
count(*) as total_content
from new_table
group by 1;




