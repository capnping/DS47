USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- Row Count for Movie Table
SELECT COUNT(*) as TotalRows_movie FROM movie ;
-- Output: 7997 Rows

-- Row Count for Director Mapping Table
SELECT COUNT(*) as TotalRows_director_mapping FROM director_mapping ;
-- Output: 3867 Rows

-- Row Count for Genre Table
SELECT COUNT(*) as TotalRows_genre FROM genre ;
-- Output: 14662 Rows

-- Row Count for Names Table
SELECT COUNT(*) as TotalRows_names FROM names ;
-- Output: 25735 Rows

-- Row Count for Ratings Table
SELECT COUNT(*) as TotalRows_ratings FROM ratings ;
-- Output: 7997 Rows

-- Row Count for Role Mapping Table 
SELECT COUNT(*) as TotalRows_role_mapping FROM role_mapping ;
-- Output: 15615 Rows


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT
	COUNT(*) - COUNT(id) AS NULL_id_count,
    COUNT(*) - COUNT(title) AS NULL_title_count,
    COUNT(*) - COUNT(year) AS NULL_year_count,
    COUNT(*) - COUNT(date_published) AS NULL_date_published_count,
    COUNT(*) - COUNT(duration) AS NULL_duration_count,
    COUNT(*) - COUNT(country) AS NULL_country_count,
    COUNT(*) - COUNT(worlwide_gross_income) AS NULL_worlwide_gross_income_count,
    COUNT(*) - COUNT(languages) AS NULL_languages_count,
    COUNT(*) - COUNT(production_company) AS NULL_production_company_count
FROM
	movie;

-- ANS: There are 4 columns that contain null Values: country, worldwide_gross_income, languages and production_company





-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Part 1

SELECT
	Year,
    COUNT(year) AS number_of_movies
FROM
	movie
GROUP BY
	year
ORDER BY
	COUNT(year) DESC;

-- ANS: The number of movies released every year from 2017 to 2019. In 2017, 3052 movies were released, 2944 in 2018 and 2001 in 2019.

-- Part 2

SELECT
	MONTH(date_published) AS month_num,
    COUNT(*) AS number_of_movies
FROM
	movie
GROUP BY
	month_num
ORDER BY
	number_of_movies DESC;

/* ANS: The highest number of movies is produced in the month of March : 824
The least number of movies is produced in the month of December : 438 */



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT
	COUNT(id) AS number_of_movies 
FROM
	movie
WHERE
	year = 2019 and country regexp 'USA|India';

-- OUTPUT: 1059 movies were produced in the USA or India in the year 2019

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT
	DISTINCT genre
FROM
	genre;

-- OUTPUT: 13 distinct genres


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT
	g.genre, COUNT(id) AS number_of_movies
FROM
	movie as m inner join genre as g
	on  m.id = g.movie_id
group by  g.genre
order by number_of_movies DESC
LIMIT 1;


-- OUTPUT: Drama with 4285 movies had the highest number of movies produced overall

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH ct_movies_of_one_genre AS
(
SELECT
	movie_id, COUNT(genre) AS number_of_genres
FROM 
	genre
GROUP BY 
	movie_id
HAVING 
	number_of_genres = 1
)
SELECT 
	COUNT(movie_id) AS total_movies_with_one_genre
FROM 
	ct_movies_of_one_genre;


-- OUTPUT: There are 3289 movies belong to only one genre.


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT
	gn.genre,
    ROUND(AVG(duration),2) AS avg_duration
FROM
	genre AS gn
INNER JOIN
	movie AS mv
	ON mv.id = gn.movie_id
GROUP BY
		genre
ORDER BY
	avg_duration DESC ;

-- Output: Action genre with highest average duration



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


WITH ct_genre_rank AS
(
	SELECT genre, COUNT(movie_id) AS movie_count,
			RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS genre_rank
	FROM genre
	GROUP BY genre
)

SELECT *
FROM ct_genre_rank
WHERE genre='thriller';

-- OUTPUT: Thriller genre with rank 3 , produced total 1484 movies.

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT
	MIN(avg_rating) AS min_avg_rating,
	MAX(avg_rating) AS max_avg_rating,
	MIN(total_votes) AS min_total_votes,
	MAX(total_votes) AS max_total_votes,
	MIN(median_rating) AS min_median_rating,
	MAX(median_rating) AS max_median_rating
FROM
	ratings;

/*OUTPUT:
# min_avg_rating	max_avg_rating	min_total_votes	max_total_votes	min_median_rating	max_median_rating
1.0	10.0	100	725138	1	10
*/
    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

select 
	title, avg_rating,
	dense_rank() over(order by avg_rating desc ) as movie_rank
from 
	movie as m
inner join
	ratings r
	on m.id = r.movie_id
limit 10;

/* OUTPUT:
# title	avg_rating	movie_rank
Kirket	10.0	1
Love in Kilnerry	10.0	1
Gini Helida Kathe	9.8	2
Runam	9.7	3
Fan	9.6	4
Android Kunjappan Version 5.25	9.6	4
Yeh Suhaagraat Impossible	9.5	5
Safe	9.5	5
The Brighton Miracle	9.5	5
Shibu	9.4	6
*/


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have


SELECT
	median_rating,
    COUNT(movie_id) AS movie_count
FROM 
	ratings
GROUP BY
	median_rating
ORDER BY
	movie_count;

/* OUTPUT: Movies with a median rating of 7 is highest in number with a count of 2257.
		   Movies with a median rating of 1 is lowest in number with a count of 94. */


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT
	production_company, COUNT(id) AS movie_count,
	DENSE_RANK() OVER(ORDER BY COUNT(id) DESC) prod_company_rank
FROM 
	movie m
INNER JOIN 
	ratings r
	ON m.id = r.movie_id
WHERE 
	r.avg_rating > 8 AND m.production_company IS NOT NULL
GROUP BY 
	m.production_company;

-- ANSWER: Dream Warrior Pictures and National Theatre Live production houses produced the most number of hit movies 



-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT
	genre, COUNT(id) AS movie_count
FROM
	movie AS m
INNER JOIN
	genre AS g 
    ON m.id = g.movie_id
INNER JOIN
	ratings AS r 
    ON m.id = r.movie_id
WHERE
	m.year = 2017
    	AND MONTH(date_published) = 3
    	AND country LIKE '%USA%' 
        AND total_votes > 1000
GROUP BY 
	 genre;








-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT
	title, avg_rating, genre
FROM
	movie AS m
INNER JOIN
	ratings r 
    ON m.id = r.movie_id
INNER JOIN
	genre g 
    ON m.id = g.movie_id
WHERE
	avg_rating > 8 AND title LIKE 'The%'
ORDER BY avg_rating;









-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT
	COUNT(m.id) AS movie_count
FROM
	movie AS m
INNER JOIN
	ratings AS r
	ON m.id = r.movie_id
WHERE
	r.median_rating = 8
    AND date_published BETWEEN '2018-04-01' AND '2019-04-01';

-- ANSWER: movie_count - 361



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


with custom_language_table AS (
	select total_votes,
	case
	when m.languages like '%German%' then 'German'
	when m.languages like '%Italian%' then 'Italian'
end
as filtered_language
from 
	movie as m
inner join
	ratings as r
	on m.id = r.movie_id
)
select 
	sum(total_votes) as aggregate_votes, filtered_language
from 
	custom_language_table
where 
	filtered_language IS not null
group by 
	filtered_language;


/* OUTPUT: 
# aggregate_votes	filtered_language
	2003623			Italian
	4421525			German
*/

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/



-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


SELECT
    COUNT(*) - COUNT(name) AS name_nulls,
    COUNT(*) - COUNT(height) AS height_nulls,
    COUNT(*) - COUNT(date_of_birth) AS date_of_birth_nulls,
    COUNT(*) - COUNT(known_for_movies) AS known_for_movies_nulls
FROM names;

/* OUTPUT: 
   # name_nulls	height_nulls	date_of_birth_nulls	known_for_movies_nulls
     0	        17335	        13431	            15226
*/


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH ct_top_genres
AS
(
SELECT
	g.genre,
	COUNT(g.movie_id) as movie_count
FROM 
	genre g
INNER JOIN 
	ratings r
	ON g.movie_id = r.movie_id
WHERE 
	avg_rating>8
GROUP BY 
	genre
ORDER BY 
	movie_count DESC
LIMIT 3
),
ct_top_directors
AS
(
SELECT
	n.name as director_name,
	COUNT(d.movie_id) as movie_count,
	RANK() OVER(ORDER BY COUNT(d.movie_id) DESC) director_rank
FROM 
	names n
INNER JOIN 
	director_mapping d
	ON n.id = d.name_id
INNER JOIN 
	ratings r
	ON r.movie_id = d.movie_id
INNER JOIN 
	genre g
	ON g.movie_id = d.movie_id,
	ct_top_genres
WHERE 
	r.avg_rating > 8 AND g.genre IN (ct_top_genres.genre)
GROUP BY 
	n.name
ORDER BY 
	movie_count DESC
)
SELECT 
	director_name,
	movie_count
FROM 
	ct_top_directors
WHERE 
	director_rank <= 3
LIMIT 3;


/* OUTPUT:
 
# director_name	 movie_count
James Mangold	 4
Joe Russo		 3
Soubin Shahir	 3

*/


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
	n.name AS actor_name, COUNT(rm.movie_id) AS movie_count
FROM 
	role_mapping rm
INNER JOIN 
	names n
	ON n.id = rm.name_id
INNER JOIN 
	ratings r
    ON r.movie_id = rm.movie_id
WHERE 
	category="actor" AND r.median_rating >= 8
GROUP BY 
	n.name
ORDER BY 
	movie_count DESC
LIMIT 2;

/* OUTPUT:
# actor_name	movie_count
Mammootty		8
Mohanlal		5
*/



/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
	production_company,
	SUM(total_votes) AS vote_count,
	DENSE_RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM 
	movie m
INNER JOIN 
	ratings r
	ON m.id = r.movie_id
GROUP BY 
	production_company
ORDER BY 
	vote_count DESC
LIMIT 3;

/* OUTPUT:

# production_company	vote_count	prod_comp_rank
Marvel Studios			2656967		1
Twentieth Century Fox	2411163		2
Warner Bros.			2396057		3

*/

-- ANSWER: Marvel Studios, Twentieth Century Fox, Warner Bros. are top 3 production houses.

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
WITH actors_info AS (
	SELECT N.NAME  AS actor_name, total_votes, Count(R.movie_id) AS movie_count,
	Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actor_avg_rating
FROM   
	movie AS M
INNER JOIN 
	ratings AS R
	ON M.id = R.movie_id
INNER JOIN 
	role_mapping AS RM
	ON M.id = RM.movie_id
INNER JOIN 
	names AS N
	ON RM.name_id = N.id
WHERE  
	category = 'ACTOR' AND country = "india"
GROUP  BY NAME
HAVING movie_count >= 5
)
SELECT *,
	Rank() OVER(ORDER BY actor_avg_rating DESC) AS actor_rank
FROM  actors_info;






-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actresses_info AS
(
	SELECT n.NAME AS actress_name, total_votes, Count(r.movie_id) AS movie_count,
	Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
FROM 
	movie AS m
INNER JOIN 
	ratings  AS r
	ON m.id=r.movie_id
INNER JOIN 
	role_mapping AS rm
	ON m.id = rm.movie_id
INNER JOIN 
	names AS n
	ON rm.name_id = n.id
WHERE 
	category = 'ACTRESS' AND country = "INDIA" AND languages LIKE '%HINDI%'
GROUP BY NAME
HAVING movie_count>=3 
)
SELECT *,
	Rank() OVER(ORDER BY actress_avg_rating DESC) AS actress_rank
FROM actresses_info 
LIMIT 5;







/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT
	title, genre,
	CASE
   	 WHEN avg_rating > 8 then 'Superhit movies'
    	WHEN avg_rating between 7 and 8 then 'Hit movies'
    	WHEN avg_rating between 5 and 7 then 'One-time-watch movies'
    	else 'Flop movies'
    END as movie_classification
FROM
	movie AS m
INNER JOIN
	genre AS g ON m.id = g.movie_id
INNER JOIN
	ratings AS r
	ON m.id = r.movie_id
WHERE genre = 'Thriller';




/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT genre,
	ROUND(AVG(duration)) AS avg_duration,
	SUM(round(AVG(duration),2)) OVER w AS running_total_duration,
	AVG(round(AVG(duration),2)) OVER w AS moving_avg_duration
FROM 
	movie AS m
INNER JOIN
    genre g ON m.id = g.movie_id
GROUP BY genre
WINDOW w AS (order BY g.genre ROWS UNBOUNDED PRECEDING);









-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top_3_genre AS
( 	
	SELECT 
		genre, COUNT(movie_id) AS number_of_movies
    FROM 
		genre AS g
    INNER JOIN movie AS m
		ON g.movie_id = m.id
    GROUP BY genre
    ORDER BY COUNT(movie_id) DESC
    LIMIT 3
),

top_5_movies AS
(
	SELECT genre,
			year,
			title AS movie_name,
			worlwide_gross_income,
			DENSE_RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
        
	FROM movie AS m 
    INNER JOIN genre AS g 
    ON m.id= g.movie_id
	WHERE genre IN (SELECT genre 
					  FROM top_3_genre)
)

SELECT *
FROM top_5_movies
WHERE movie_rank <= 5;

/* ANSWER: 'Shatamanam Bhavati' ranked 1 in Drama genre in year 2017.
		   'The Villain' ranked 1 in Thriller genre in year 2018.
           'Prescience' ranked 1 in Thriller genre in year 2019.




-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

Select
	production_company,
	COUNT(id) as movie_count,
	ROW_NUMBER() OVER(ORDER BY COUNT(id) DESC) AS prod_comp_rank
FROM 
	movie m
INNER JOIN 
	ratings r
ON m.id = r.movie_id
WHERE 
	median_rating>=8
AND 
	production_company IS NOT NULL
AND 
	POSITION(',' IN languages) > 0
GROUP BY 
	production_company
LIMIT 2;

/* OUTPUT: Top two production houses are:

# production_company	movie_count	prod_comp_rank
Twentieth Century Fox	4			2
Star Cinema				7			1

*/


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT
	name AS actress_name,
    SUM(total_votes) AS total_votes,
    COUNT(r.movie_id) AS movie_count,
    ROUND(SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes),2) AS actress_avg_rating,
    ROW_NUMBER() OVER( ORDER BY COUNT(r.movie_id) DESC ) AS actress_rank
FROM
	names AS n
INNER JOIN
	role_mapping AS rm
    ON rm.name_id = n.id
INNER JOIN
	ratings AS r
    ON r.movie_id = rm.movie_id
INNER JOIN
	genre AS g
    ON g.movie_id = r.movie_id
WHERE
	avg_rating > 8
    AND category = 'actress'
    AND genre = 'drama'
GROUP BY
	name
LIMIT 3;

/* OUTPUT:

# actress_name	     total_votes	movie_count	 actress_avg_rating	actress_rank
Amanda Lawrence	     656	        2	         8.94	            3
Parvathy Thiruvothu	 4974	        2	         8.25	            1
Susan Brown	         656	        2	         8.94	            2

*/








/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH cte_date_info AS
(
SELECT d.name_id,
	NAME,
	d.movie_id,
	duration,
	r.avg_rating,
	total_votes,
	m.date_published,
	Lead(date_published,1) OVER(PARTITION BY d.name_id ORDER BY date_published,movie_id ) 
AS next_date_published
FROM 
	director_mapping AS d
INNER JOIN 
	names AS n 
    ON n.id = d.name_id
INNER JOIN 
	movie AS m 
	ON m.id = d.movie_id
INNER JOIN 
	ratings AS r 
    ON r.movie_id = m.id ),
top_director_summary AS
(
SELECT *,
	Datediff(next_date_published, date_published) AS date_difference
FROM cte_date_info 
)
SELECT 
	name_id AS director_id,
	NAME AS director_name,
	COUNT(movie_id) AS number_of_movies,
    ROUND(AVG(date_difference),2) AS avg_inter_movie_days,
    ROUND(AVG(avg_rating),2) AS avg_rating,
    SUM(total_votes) AS total_votes,
	MIN(avg_rating) AS min_rating,
	MAX(avg_rating) AS max_rating,
	SUM(duration) AS total_duration
FROM 
	top_director_summary
GROUP BY 
	director_id
ORDER BY 
	COUNT(movie_id) DESC
limit 9;









