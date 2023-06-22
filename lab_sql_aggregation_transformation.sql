USE sakila;
-- Challenge 1
-- 1. As a movie rental company, we need to use SQL built-in functions to help us gain insights into our business operations:
-- 1.1 Determine the shortest and longest movie durations and name the values as max_duration and min_duration.
SELECT MIN(length) as min_duration
	, MAX(length) as max_duration
FROM sakila.film;

-- 1.2. Express the average movie duration in hours and minutes. Don't use decimals. Hint: look for floor and round functions.
SELECT avg(length)
     ,concat(AVG(length) DIV 60, ' hours',', ', ROUND(AVG(length) % 60,0), ' minutes') as avg_movie_duration
FROM sakila.film;

-- 2. We need to use SQL to help us gain insights into our business operations related to rental dates:
-- 2.1 Calculate the number of days that the company has been operating. Hint: To do this, use the rental table, and the DATEDIFF() function to subtract the earliest date in the rental_date column from the latest date.
SELECT DATEDIFF( MAX(rental_date), MIN(rental_date))
FROM sakila.rental;

-- 2.2 Retrieve rental information and add two additional columns to show the month and weekday of the rental. Return 20 rows of results.
SELECT *
	, date_format(rental_date, '%m') as rental_month
	, WEEKDAY(rental_date) as rental_weekday
FROM sakila.rental
LIMIT 20;

-- 2.3 Retrieve rental information and add an additional column called DAY_TYPE with values 'weekend' or 'workday', depending on the day of the week. Hint: use a conditional expression.
SELECT *
	, date_format(rental_date, '%m') as rental_month
	, WEEKDAY(rental_date) as rental_weekday
    , CASE
		WHEN WEEKDAY(rental_date) < '5' THEN "workday"
		ELSE "weekend"
	END as DAY_TYPE
FROM sakila.rental
LIMIT 20;

/*
3. We need to ensure that our customers can easily access information about our movie collection. 
To achieve this, retrieve the film titles and their rental duration. 
If any rental duration value is NULL, replace it with the string 'Not Available'. 
Sort the results by the film title in ascending order. 
Please note that even if there are currently no null values in the rental duration column, 
the query should still be written to handle such cases in the future.
*/
SELECT title
    , CASE
		WHEN rental_duration IS NULL THEN "Not Available"
        ELSE rental_duration
        END AS rental_duration
FROM film
ORDER BY title ASC;

 /*
 4. As a marketing team for a movie rental company, we need to create a personalized email campaign for our customers. 
 To achieve this, we want to retrieve the concatenated first and last names of our customers, 
 along with the first 3 characters of their email address, 
 so that we can address them by their first name and use their email address to send personalized recommendations. 
 The results should be ordered by last name in ascending order to make it easier for us to use the data.
 
 */
SELECT concat(first_name, last_name, left(email, 3))
FROM customer
ORDER BY last_name ASC;


-- Challenge 2
-- 1. We need to analyze the films in our collection to gain insights into our business operations. 
 -- Using the film table, determine:
-- 1.1 The total number of films that have been released.
SELECT COUNT(film_id)
FROM film;

-- 1.2 The number of films for each rating.
SELECT rating
	, COUNT(film_id)
FROM film
GROUP BY rating;

-- 1.3 The number of films for each rating, and sort the results in descending order of the number of films. This will help us better understand the popularity of different film ratings and adjust our purchasing decisions accordingly.
SELECT rating
	, COUNT(film_id)
FROM film
GROUP BY rating
ORDER BY COUNT(film_id) DESC;

-- 2. We need to track the performance of our employees. 
-- Using the rental table, determine the number of rentals processed by each employee. 
-- This will help us identify our top-performing employees and areas where additional training may be necessary.
SELECT staff_id
	, count(rental_id)
FROM rental
GROUP BY 1;


-- 3. Using the film table, determine:
-- 3.1 The mean film duration for each rating, and sort the results in descending order of the mean duration. 
-- Round off the average lengths to two decimal places. This will help us identify popular movie lengths for each category.
SELECT rating
	, ROUND(AVG(length),2)
FROM film
GROUP BY rating
ORDER BY 2 DESC;

-- 3.2 Identify which ratings have a mean duration of over two hours, to help us select films for customers who prefer longer movies.
SELECT rating
	, ROUND(AVG(length),2) as average_length
FROM film
GROUP BY rating
HAVING average_length > 120
ORDER BY 2 DESC;

-- 4. Determine which last names are not repeated in the table actor.
SELECT last_name
	,COUNT(last_name) as count_last_name
FROM actor
GROUP BY 1
HAVING count_last_name < 2;
