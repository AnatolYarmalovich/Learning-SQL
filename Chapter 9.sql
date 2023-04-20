/*
 Chapter 9 (use Sakila DB) - Postgres SQL syntax here!
 */

SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id = (SELECT MAX(customer_id) FROM customer);

/*
 Use subquery by itself for clearer understand what query are return
 */
SELECT MAX(customer_id)
FROM customer;

/*
 Scalar non correlated sub-queries
 */
SELECT city_id, city
FROM city
WHERE country_id != (SELECT country_id
                     FROM country
                     WHERE country.country = 'India');

-- Lot's of rows in result set!
SELECT country_id
FROM country
WHERE country.country != 'India';

/*
 Sub-queries with one column and multiple rows
 */

-- Operators `IN` and `NOT IN`
SELECT country_id
FROM country
WHERE country IN ('Canada', 'Mexico');

-- The same result with `OR` operator
SELECT country_id
FROM country
WHERE country = 'Canada'
   OR country = 'Mexico';

SELECT city_id, city
FROM city
WHERE country_id IN
      (SELECT country_id
       FROM country
       WHERE country IN ('Canada', 'Mexico'));

-- Use `NOT IN`
SELECT city_id, city
FROM city
WHERE country_id NOT IN
      (SELECT country_id
       FROM country
       WHERE country IN ('Canada', 'Mexico'));

-- `ALL` operator
SELECT first_name, last_name
FROM customer
WHERE customer_id != ALL (SELECT customer_id
                          FROM payment
                          WHERE amount = 0);

-- same requirements with `NOT IN`
SELECT first_name, last_name
FROM customer
WHERE customer_id NOT IN (SELECT customer_id
                          FROM payment
                          WHERE amount = 0);

/*
 Do not compare with NULL
 */
SELECT first_name, last_name
FROM customer
WHERE customer_id NOT IN (122, 452, NULL);

-- `ALL` in HAVING
SELECT customer_id, COUNT(*)
FROM rental
GROUP BY customer_id
HAVING COUNT(*) > ALL
       (SELECT COUNT(*)
        FROM rental r
                 INNER JOIN customer c
                            ON r.customer_id = c.customer_id
                 INNER JOIN address a
                            ON c.address_id = a.address_id
                 INNER JOIN city ct
                            ON a.city_id = ct.city_id
                 INNER JOIN country co
                            ON ct.country_id = co.country_id
        WHERE co.country IN ('United States', 'Mexico', 'Canada')
        GROUP BY r.customer_id);

-- `ANY`
SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > ANY
       (SELECT SUM(p.amount)
        FROM payment p
                 INNER JOIN customer c
                            ON p.customer_id = c.customer_id
                 INNER JOIN address a
                            ON c.address_id = a.address_id
                 INNER JOIN city ct
                            ON a.city_id = ct.city_id
                 INNER JOIN country co
                            ON ct.country_id = co.country_id
        WHERE co.country IN ('Bolivia', 'Paraguay', 'Chile')
        GROUP BY co.country);

/*
 Multi column Sub-queries
 */
SELECT fa.actor_id, fa.film_id
FROM film_actor fa
WHERE fa.actor_id IN
      (SELECT actor_id
       FROM actor
       WHERE last_name = 'MONROE')
  AND fa.film_id IN
      (SELECT film_id
       FROM film
       WHERE rating = 'PG');

SELECT actor_id, film_id
FROM film_actor
WHERE (actor_id, film_id) IN
      (SELECT a.actor_id, film_id
       FROM actor a
                CROSS JOIN film f
       WHERE a.last_name = 'MONROE'
         AND f.rating = 'PG');

/*
 Correlated Sub-queries
 */
SELECT c.first_name, c.last_name
FROM customer c
WHERE 20 =
      (SELECT COUNT(*)
       FROM rental r
       WHERE r.customer_id = c.customer_id);

SELECT c.first_name, c.last_name
FROM customer c
WHERE (SELECT SUM(p.amount)
       FROM payment p
       WHERE p.customer_id = c.customer_id)
          BETWEEN 180 AND 240;

-- `Exists` operator
SELECT c.first_name, c.last_name
FROM customer c
WHERE EXISTS
          (
              SELECT 1
              FROM rental r
              WHERE r.customer_id = c.customer_id
                AND DATE(r.rental_date) < '2022-05-25'
          );

SELECT a.first_name, a.last_name
FROM actor a
WHERE NOT EXISTS
    (
        SELECT 1
        FROM film_actor fa
                 INNER JOIN film f ON f.film_id = fa.film_id
        WHERE fa.actor_id = a.actor_id
          AND f.rating = 'R'
    );

/*
 Data Manipulation Using Correlated Subqueries
 */

UPDATE customer
SET last_update = (SELECT MAX(r.rental_date)
                   FROM rental r
                   WHERE r.customer_id = customer_id);

UPDATE customer c
SET last_update =
        (SELECT MAX(r.rental_date)
         FROM rental r
         WHERE r.customer_id = c.customer_id)
WHERE EXISTS(SELECT 1
             FROM rental r
             WHERE r.customer_id = c.customer_id);

/*
 Subqueries as Data Sources
 */

-- with `FROM` clause
SELECT c.first_name, c.last_name, pymnt.num_rentals, pymnt.tot_payments
FROM customer c
         INNER JOIN (SELECT customer_id, COUNT(*) num_rentals, SUM(amount) tot_payments
                     FROM payment
                     GROUP BY customer_id) pymnt
                    ON c.customer_id = pymnt.customer_id;

SELECT customer_id, COUNT(*) num_rentals, SUM(amount) tot_payments
FROM payment
GROUP BY customer_id;

/*
 Correlated sub-queries
 */
SELECT c.first_name, c.last_name
FROM customer c
WHERE 20 = (SELECT COUNT(*)
            FROM rental r
            WHERE r.customer_id = c.customer_id);

-- using correlated sub-queries with range condition

SELECT c.first_name, c.last_name
FROM customer c
WHERE (SELECT SUM(p.amount)
       FROM payment p
       WHERE p.customer_id = c.customer_id)
          BETWEEN 180 AND 240;

/*
 EXIST operator and correlated sub-queries
 */

SELECT c.first_name, c.last_name
FROM customer c
WHERE EXISTS
          (
              SELECT 1
              FROM rental r
              WHERE r.customer_id = c.customer_id
                AND TO_CHAR(r.rental_date, 'YYYY-MM-DD') < '2022-05-25'
          );

-- NOT EXIST operator

SELECT a.first_name, a.last_name
FROM actor a
WHERE NOT EXISTS(
        SELECT 1
        FROM film_actor fa
                 INNER JOIN film f ON f.film_id = fa.film_id
        WHERE fa.actor_id = a.actor_id
          AND f.rating = 'R'
    );

/*
 Work with data include correlated sub-queries
 */

UPDATE customer c
SET last_update = (SELECT MAX(r.rental_date)
                   FROM rental r
                   WHERE r.customer_id = c.customer_id)


-- with EXIST operator in where clause
UPDATE customer c
SET last_update = (SELECT MAX(r.rental_date)
                   FROM rental r
                   WHERE r.customer_id = c.customer_id)
WHERE EXISTS(
              SELECT 1
              FROM rental r
              WHERE r.customer_id = c.customer_id
          );

-- Delete instruction
-- 1. Create demo_customer table, that represents a customer as a copy of the customer table
CREATE TABLE demo_customer AS
SELECT *
FROM customer;

DELETE
FROM demo_customer AS dc
WHERE 365 < ALL (SELECT EXTRACT(DAY FROM AGE(NOW(), r.rental_date)) AS days_since_last_rental
                 FROM rental r
                 WHERE r.customer_id = dc.customer_id)

DROP TABLE demo_customer;

/*
 Sub-queries as a data source
 */

SELECT c.first_name,
       c.last_name,
       pymnt.num_rentals,
       pymnt.tot_payments
FROM customer AS c
         INNER JOIN (SELECT customer_id, COUNT(*) AS num_rentals, SUM(amount) AS tot_payments
                     FROM payment
                     GROUP BY customer_id
                     ORDER BY customer_id ASC) AS pymnt
                    ON c.customer_id = pymnt.customer_id;


-- sub-queries result
SELECT customer_id, COUNT(*) AS num_rentals, SUM(amount) AS tot_payments
FROM payment
GROUP BY customer_id
ORDER BY customer_id;

/*
 Generate data with sub-queries
 */
SELECT 'Small Fry' name, 0 low_limit, 74.99 high_limit
UNION ALL
SELECT 'Average Joes' name, 75 low_limit, 149.99 high_limit
UNION ALL
SELECT 'Heavy Hitters' name, 150 low_limit, 9999999.99 high_limit;

SELECT pymnt_grps.name, COUNT(*) num_customers
FROM (SELECT customer_id, COUNT(*) AS num_rentals, SUM(amount) AS tot_payments
      FROM payment
      GROUP BY customer_id) pymnt
         INNER JOIN
     (SELECT 'Small Fry' name, 0 low_limit, 74.99 high_limit
      UNION ALL
      SELECT 'Average Joes' name, 75 low_limit, 149.99 high_limit
      UNION ALL
      SELECT 'Heavy Hitters' name, 150 low_limit, 9999999.99 high_limit) pymnt_grps
     ON pymnt.tot_payments
         BETWEEN pymnt_grps.low_limit AND pymnt_grps.high_limit
GROUP BY pymnt_grps.name;

/*
 Sub-queries for solve concreate task
 */
SELECT c.first_name, c.last_name, ct.city, SUM(p.amount) AS tot_payments, COUNT(*) AS tot_rentals
FROM payment p
         INNER JOIN customer AS c
                    ON p.customer_id = c.customer_id
         INNER JOIN address AS a
                    ON c.address_id = a.address_id
         INNER JOIN city AS ct
                    ON a.city_id = ct.city_id
GROUP BY c.first_name, c.last_name, ct.city;

SELECT customer_id, COUNT(*) AS tot_rentals, SUM(amount) AS tot_payments
FROM payment
GROUP BY customer_id
ORDER BY customer_id;

SELECT c.first_name, c.last_name, ct.city, pymnt.tot_payments, pymnt.tot_rentals
FROM (SELECT customer_id, COUNT(*) AS tot_rentals, SUM(amount) AS tot_payments
      FROM payment
      GROUP BY customer_id) pymnt
         INNER JOIN customer AS c
                    ON pymnt.customer_id = c.customer_id
         INNER JOIN address a
                    ON c.address_id = a.address_id
         INNER JOIN city ct
                    ON a.city_id = ct.city_id;

/*
 Common table expressions
 */

WITH actors_s AS
         (SELECT actor_id, first_name, last_name
          FROM actor
          WHERE last_name LIKE 'S%'),
     actors_s_pg AS
         (SELECT s.actor_id, s.first_name, s.last_name, f.film_id, f.title
          FROM actors_s AS s
                   INNER JOIN film_actor fa
                              ON s.actor_id = fa.actor_id
                   INNER JOIN film f
                              ON f.film_id = fa.film_id
          WHERE f.rating = 'PG'),
     actors_s_pg_revenue AS
         (SELECT spg.first_name, spg.last_name, p.amount
          FROM actors_s_pg spg
                   INNER JOIN inventory AS i
                              ON i.film_id = spg.film_id
                   INNER JOIN rental AS r
                              ON i.inventory_id = r.inventory_id
                   INNER JOIN payment p
                              ON r.rental_id = p.rental_id)
SELECT spg_rev.first_name, spg_rev.last_name, SUM(spg_rev.amount) AS tot_revenue
FROM actors_s_pg_revenue AS spg_rev
GROUP BY spg_rev.first_name, spg_rev.last_name
ORDER BY 3 DESC;

/*
 TASKS FROM END OF CHAPTER 9
 */

-- 9.1
-- film_id
SELECT fc.film_id
FROM film_category AS fc
         INNER JOIN category c
                    ON fc.category_id = c.category_id
WHERE c.name = 'Action';

-- Complete query
SELECT f.title
FROM film AS f
WHERE f.film_id IN (SELECT fc.film_id
                    FROM film_category AS fc
                             INNER JOIN category c
                                        ON fc.category_id = c.category_id
                    WHERE c.name = 'Action');

-- 9.2
SELECT f.title
FROM film f
WHERE EXISTS(
              SELECT 1
              FROM film_category fc
                       INNER JOIN category c ON c.category_id = fc.category_id
              WHERE c.name = 'Action'
                AND fc.film_id = f.film_id
          )

-- 9.3
SELECT 'Hollywood Star' AS level, 30 AS min_roles, 99999 AS max_roles
UNION ALL
SELECT 'Prolific Actor' AS level, 20 AS min_roles, 29 AS max_roles
UNION ALL
SELECT 'Newcomer' AS level, 1 AS min_roles, 19 AS max_roles