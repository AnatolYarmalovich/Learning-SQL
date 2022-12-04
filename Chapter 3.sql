/*
 Select (use Sakila DB) - Postgres SQL syntax here!
 */

/*
 use '*' symbol for chose all of available columns in table
 */
SELECT *
FROM language;

/*
 specific query -> result include language_id, name, last_update columns in resulting set
 */
SELECT language_id, name, last_update
FROM language;

/*
 specific query -> include just name column in resulting set
 */
SELECT name
FROM language;

/*
 use column, literal, expression and call of internal function in one query;
 */
SELECT language_id, 'COMMON' languahe_usage, language_id * 3.14159217 lang_pi_value, upper(name) language_name
FROM language;

/*
 use internal DB functions in SELECT query;
 */
SELECT version(), "current_user"(), version();

/*
 use pseudonym in result set with some function
 */
SELECT language_id, 'COMMON' language_usage, language_id * 2 lang_multiplied_value, upper(name) language_name
FROM language;

/*
 use pseudonym in result set with some function with AS typecasting
 for improving command readability
 */
SELECT language_id, 'COMMON' AS language_usage, language_id * 2 AS lang_multiplied_value, upper(name) AS language_name
FROM language;

-- Duplicate removing
/*
 With duplicates
 */
SELECT actor_id
FROM film_actor
ORDER BY actor_id;

/*
 Without (command-key 'distinct')
 */
SELECT DISTINCT actor_id
FROM film_actor
ORDER BY actor_id;

/*
 Derived table, sub-query
 */
SELECT concat(cust.last_name, ', ', cust.first_name) full_name
FROM
    (
        SELECT first_name, last_name, email
        FROM customer
        WHERE first_name = 'JESSIE'
    )
        cust;

/*
 Temporary table create - table killed after some transaction or when session dropped!
 */

CREATE TEMPORARY TABLE actors_j
(
    actor_id SMALLINT,
    first_name VARCHAR(45),
    last_name VARCHAR(45)
);

-- Inserting some data into temporary table (this rows lives in memory until DB session is alive)
INSERT INTO actors_j
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE 'J%';

-- Read all data from temporary db named actors_j:
SELECT * FROM actors_j;

/*
 VIEW's creating
 */
CREATE VIEW cust_vw AS
SELECT customer_id, first_name, last_name,active
FROM customer;

-- using VIEW's in queries
SELECT first_name, last_name
FROM cust_vw
WHERE active = 0;

/*
 Relationships between tables
 */
SELECT customer.first_name, customer.last_name, to_char(rental.rental_date, 'HH24:mm:ss') rental_time
FROM customer
         INNER JOIN rental
                    ON customer.customer_id = rental.customer_id
WHERE date(rental.rental_date) = '2005-06-14';

/*
 Make a multiple table query using a table pseudonym
 */
SELECT c.first_name, c.last_name, date_trunc('day', r.rental_date)::date rental_time
FROM customer c
         INNER JOIN rental r
                    ON c.customer_id = r.customer_id
WHERE date_trunc('day', r.rental_date) = '2005-06-14';

/*
 The same command but using 'AS' key-word for improve readability
 */
SELECT c.first_name, c.last_name, date_trunc('day', r.rental_date)::date rental_time
FROM customer AS c
         INNER JOIN rental AS r
                    ON c.customer_id = r.customer_id
WHERE date_trunc('day', r.rental_date) = '2005-06-14';

/*
 'WHERE' key-word using + 'AND' key-word for adding one more filtering condition
 */
SELECT title
FROM film
WHERE rating = 'G' AND rental_duration >= 7;

/*
 Exchange from AND to OR
 */
SELECT title
FROM film
WHERE rating = 'G' OR rental_duration >= 7;

/*
 Using multiple filtering conditions
 */
SELECT title, rating, rental_duration
FROM film
WHERE (rating = 'G' AND rental_duration >= 7)
   OR (rating = 'PG-13' AND rental_duration < 4);

/*
 Using 'GROUP BY' with 'HAVING' keywords for sorting
 */
SELECT c.first_name, c.last_name, count(*)
FROM customer c
         INNER JOIN rental r
                    ON c.customer_id = r.customer_id
GROUP BY c.first_name, c.last_name
HAVING count(*) >= 40;

/*
 Using 'ORDER BY' keywords  for sorting in some kind of order
 */

-- WITHOUT 'ORDER BY'
SELECT c.first_name, c.last_name, to_char(r.rental_date, 'HH24:mm:ss') rental_time
FROM customer c
         INNER JOIN rental r
                    ON c.customer_id = r.customer_id
WHERE date(r.rental_date) = '2005-06-14';

-- For order our result set by last name (in alphabetical order)
SELECT c.first_name, c.last_name, to_char(r.rental_date, 'HH24:mm:ss') rental_time
FROM customer c
         INNER JOIN rental r
                    ON c.customer_id = r.customer_id
WHERE date(r.rental_date) = '2005-06-14'
ORDER BY c.last_name;

-- Also add one more params for ordering, in case if user's have same last name
SELECT c.first_name, c.last_name, to_char(r.rental_date, 'HH24:mm:ss') rental_time
FROM customer c
         INNER JOIN rental r
                    ON c.customer_id = r.customer_id
WHERE date(r.rental_date) = '2005-06-14'
ORDER BY c.last_name, c.first_name;

/*
 Sort in Ascending or Descending order
 */
SELECT c.first_name, c.last_name, to_char(r.rental_date, 'HH24:mm:ss') rental_time
FROM customer c
         INNER JOIN rental r
                    ON c.customer_id = r.customer_id
WHERE date(r.rental_date) = '2005-06-14'
ORDER BY to_char(r.rental_date, 'HH24:mm:ss') DESC;

/*
 Use 'LIMIT' command word for limit resulting set by first 5-th
 */
SELECT c.first_name, c.last_name, to_char(r.rental_date, 'HH24:mm:ss') rental_time
FROM customer c
         INNER JOIN rental r
                    ON c.customer_id = r.customer_id
WHERE date(r.rental_date) = '2005-06-14'
ORDER BY to_char(r.rental_date, 'HH24:mm:ss') DESC
LIMIT 5;

/*
 Tasks from book
 */

-- 3.1
SELECT a.actor_id, a.first_name, a.last_name
FROM actor AS a
ORDER BY a.last_name, a.first_name;

-- 3.2
SELECT a.actor_id, a.first_name, a.last_name
FROM actor AS a
WHERE (a.last_name = 'WILLIAMS')
   OR (a.last_name = 'DAVIS');

-- OR Solution from book:
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name IN ('WILLIAMS', 'DAVIS');

-- 3.3
SELECT DISTINCT r.customer_id
FROM rental AS r
WHERE date(r.rental_date) = '2005-07-05';

-- 3.4
SELECT c.email, r.return_date
FROM customer AS c
         INNER JOIN rental r
                    ON c.customer_id = r.customer_id
WHERE date(r.rental_date) = '2005-06-14'
ORDER BY r.return_date DESC;
