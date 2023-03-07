/*
 Chapter 8 (use Sakila DB) - Postgres SQL syntax here!
 */
SELECT customer_id
FROM rental;

/*
 Use GROUP BY operator
 */
SELECT customer_id
FROM rental
GROUP BY customer_id;

/*
 Use aggregate function Count()
 */
SELECT customer_id, COUNT(*)
FROM rental
GROUP BY customer_id;

/*
 Order by 2 description
 */
SELECT customer_id, COUNT(*)
FROM rental
GROUP BY customer_id
ORDER BY 2 DESC;

/*
 Error with WHERE
 */
SELECT customer_id, COUNT(*)
FROM rental
WHERE COUNT(*) >= 40
GROUP BY customer_id;

/*
 Correct query with aggregate func
 */
SELECT customer_id, COUNT(*)
FROM rental
GROUP BY customer_id
HAVING COUNT(*) >= 40;

/*
 Aggregated functions
 */
SELECT MAX(amount) max_amt,
       MIN(amount) min_amt,
       AVG(amount) avg_amt,
       SUM(amount) tot_amt,
       COUNT(*)    num_payments
FROM payment;


/*
    Error generated because explicit groups needs GROUPED BY
 */
SELECT customer_id,
       MAX(amount) max_amt,
       MIN(amount) min_amt,
       AVG(amount) avg_amt,
       SUM(amount) tot_amt,
       COUNT(*)    num_payments
FROM payment;

-- Fixed:
SELECT customer_id,
       MAX(amount) max_amt,
       MIN(amount) min_amt,
       AVG(amount) avg_amt,
       SUM(amount) tot_amt,
       COUNT(*)    num_payments
FROM payment
GROUP BY customer_id;

/*
 Calculate num of rows in table `payment` and only uniq values
 */
SELECT COUNT(customer_id)          num_rows,
       COUNT(DISTINCT customer_id) num_customers
FROM payment;

/*
 use expressions with aggregated functions
 */
SELECT MAX(DATE_PART('day', return_date::date) - DATE_PART('day', rental_date::date))
FROM rental;

/*
 NULL handling
 */
CREATE TABLE number_tbl
(
    val SMALLINT
);

INSERT INTO number_tbl
VALUES (1);

INSERT INTO number_tbl
VALUES (3);

INSERT INTO number_tbl
VALUES (5);

SELECT COUNT(*) num_rows,
       COUNT(val),
       SUM(val),
       MAX(val),
       AVG(val)
FROM number_tbl;

INSERT INTO number_tbl
VALUES (NULL);

SELECT COUNT(*)   num_rows,
       COUNT(val) num_vals,
       SUM(val)   total,
       MAX(val)   max_val,
       AVG(val)   avg_val
FROM number_tbl;

/*
 Grouping by one column
 */
SELECT actor_id, COUNT(*)
FROM film_actor
GROUP BY actor_id
ORDER BY actor_id;

/*
 Multiple-columns grouping
 */
SELECT fa.actor_id, f.rating, COUNT(*)
FROM film_actor fa
         INNER JOIN film f
                    ON fa.film_id = f.film_id
GROUP BY fa.actor_id, f.rating
ORDER BY 1, 2;

/*
 Grouping with expressions
 */
SELECT EXTRACT(YEAR FROM rental_date) AS year,
       COUNT(*)                          how_many
FROM rental
GROUP BY EXTRACT(YEAR FROM rental_date);

/*
 Generating finishing set with `WITH ROLLUP`
 */
SELECT fa.actor_id, f.rating, COUNT(*)
FROM film_actor fa
         INNER JOIN film f ON fa.film_id = f.film_id
GROUP BY
    ROLLUP (fa.actor_id, f.rating)
ORDER BY 1, 2;

/*
 Grouping filter
 */
SELECT fa.actor_id, f.rating, COUNT(*)
FROM film_actor fa
         INNER JOIN film f
                    ON fa.film_id = f.film_id
WHERE f.rating IN ('G', 'PG')
GROUP BY fa.actor_id, f.rating
HAVING COUNT(*) > 9;

/*
 TASKS FROM END OF CHAPTER 8
 */

-- 8.1
SELECT COUNT(*)
FROM payment;

-- 8.2
SELECT customer_id, COUNT(*), SUM(amount)
FROM payment
GROUP BY customer_id;

-- 8.3
SELECT customer_id, COUNT(*), SUM(amount)
FROM payment
GROUP BY customer_id
HAVING COUNT(*) >= 40;

