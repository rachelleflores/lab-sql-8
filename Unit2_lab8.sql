# Unit 2 Lab 8
USE sakila;

# 1. Rank films by length (filter out the rows with nulls or zeros in length column). Select only columns title, length and rank in your output.
SELECT title, length, DENSE_RANK() OVER(ORDER BY length DESC) as ranking -- using dense_rank() to have same ranking for similar lengths and continue the ranking downward
FROM film
WHERE length IS NOT NULL OR length != 0;

# 2. Rank films by length within the rating category (filter out the rows with nulls or zeros in length column). In your output, only select the columns title, length, rating and rank.
SELECT title, length, rating, 
	DENSE_RANK() OVER(PARTITION BY rating ORDER BY length DESC) as rating_rank
FROM film
WHERE length IS NOT NULL OR length != 0;

# 3. How many films are there for each of the categories in the category table? Hint: Use appropriate join between the tables "category" and "film_category".
SELECT name, COUNT(film_id) as film_count
FROM category as c
INNER JOIN film_category as f
USING (category_id)
GROUP BY name;

# 4. Which actor has appeared in the most films? Hint: You can create a join between the tables "actor" and "film actor" and count the number of times an actor appears.
-- Heads up: I have 2 results depending on whether I used group by the full name or by actor_id
# full name
SELECT CONCAT(first_name," ", last_name) as full_name, COUNT(film_id) as film_starring -- decided to join first and last names to create just one column. makes things simpler, I think :)
FROM actor as a
INNER JOIN film_actor as f
USING (actor_id)
GROUP BY full_name
ORDER BY film_starring DESC
LIMIT 1; -- there are 2 actor ids for Susan Davis so maybe they are 2 different people!!!

SELECT *
FROM actor
WHERE actor_id = 101 OR actor_id = 110;

# actor id
SELECT first_name, last_name, COUNT(film_id) as film_starring
FROM actor as a
INNER JOIN film_actor as f
USING (actor_id)
GROUP BY actor_id
ORDER BY film_starring DESC
LIMIT 1;

# 5. Which is the most active customer (the customer that has rented the most number of films)? Hint: Use appropriate join between the tables "customer" and "rental" and count the rental_id for each customer.
SELECT customer_id, first_name, last_name, COUNT(rental_id) as films_rented
FROM customer as c
INNER JOIN  rental as r
USING (customer_id)
GROUP BY customer_id, first_name, last_name
ORDER BY films_rented DESC
LIMIT 1;

# Bonus: Which is the most rented film? (The answer is Bucket Brotherhood).
-- This query might require using more than one join statement. Give it a try. We will talk about queries with multiple join statements later in the lessons.
-- Hint: You can use join between three tables - "Film", "Inventory", and "Rental" and count the rental ids for each film.

SELECT title, COUNT(rental_id) as rental_count
FROM film as f
INNER JOIN inventory as i
USING (film_id)
INNER JOIN rental as r
USING (inventory_id)
GROUP BY title
ORDER BY rental_count DESC
LIMIT 1;