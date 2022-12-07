/*
 Chapter 4 (use Sakila DB) - Postgres SQL syntax here!
 */

/*
 Don't forget:
WHERE true OR true = true
WHERE true OR false = true
WHERE false OR true = true
WHERE false OR false = false
 */

/*
 Brackets `()` using
 */
SELECT *
FROM customer
WHERE (first_name = 'STEVEN' OR last_name = 'YOUNG')
  AND create_date > '2006-01-01';

/*
 `NOT`operator
 */
SELECT *
FROM customer
WHERE NOT (first_name = 'STEVEN' OR last_name = 'YOUNG')
  AND create_date > '2006-01-01';

/*
 Without `NOT` operator
 */
SELECT *
FROM customer
WHERE first_name <> 'STEVEN'
  AND last_name <> 'YOUNG'
  AND create_date > '2006-01-01'

/*
 equality conditions
 */
SELECT c.email
FROM customer c
         INNER JOIN rental r
                    ON c.customer_id = r.customer_id
WHERE date(r.rental_date) = '2005-06-14';

/*
 non-equality conditions
 */
SELECT c.email
FROM customer c
         INNER JOIN rental r
                    ON c.customer_id = r.customer_id
WHERE date(r.rental_date) != '2005-06-14';

/*
 One equality conditions for delete query
 */
DELETE
FROM rental
WHERE DATE_PART('year', CAST(rental.rental_date AS date)) = 2004;

/*
 multiple equality conditions for delete query
 */
DELETE
FROM rental
WHERE DATE_PART('year', CAST(rental.rental_date AS date)) <> 2005
  AND DATE_PART('year', CAST(rental.rental_date AS date)) != 2006;

/*
 Range equality conditions
 */
SELECT customer_id, rental_date
FROM rental
WHERE rental_date < '2005-05-25';

/*
 If we add height bound in range we can get more accurate result
 */
SELECT customer_id, rental_date
FROM rental
WHERE rental_date <= '2005-06-16'
  AND rental_date >= '2005-06-14';

/*
 Between operator - contain low and height condition in one operator
 */
SELECT customer_id, rental_date
FROM rental
WHERE rental_date BETWEEN '2005-06-14' AND '2005-06-16';

/*
 Numeric ranges in conditions
 */
SELECT customer_id, payment_date, amount
FROM payment
WHERE amount BETWEEN 10.0 AND 11.99;

/*
 String literals ranges in conditions
 */
SELECT last_name, first_name
FROM customer
WHERE last_name BETWEEN 'FA' AND 'FR';

/*
 Increase string literals range conditions from `FR` to `FRB'
 */
SELECT last_name, first_name
FROM customer
WHERE last_name BETWEEN 'FA' AND 'FRB';

/*
 Concrete values with `OR` conditions
 */
SELECT title, rating
FROM film
WHERE rating = 'G'
   OR rating = 'PG';

/*
 The best way sometime use `IN` operator for multiples conditions options
 */
SELECT title, rating
FROM film
WHERE rating
          IN ('G', 'PG');

/*
 use sub queries for query
 */
SELECT title, rating
FROM film
WHERE rating IN (SELECT rating
                 FROM film
                 WHERE title LIKE '%PET%');

/*
 `Not in` using
 */
SELECT title, rating
FROM film
WHERE rating NOT IN ('PG-13', 'R', 'NC-17');

/*
 compliance conditions with `left` function
 */
SELECT last_name, first_name
FROM customer
WHERE "left"(last_name, 1) = 'Q';

/*
 wildcard characters and `LIKE` operator
 */
SELECT last_name, first_name
FROM customer
WHERE last_name LIKE '_A_T%S';

/*
 multiple search conditions
 */
SELECT last_name, first_name
FROM customer
WHERE last_name LIKE 'Q%'
   OR last_name LIKE 'Y%';

/*
 REGEX using in search query building `~` operator in Postgres
 */
SELECT last_name, first_name
FROM customer
WHERE last_name ~ '^[QY]';

/*
 Check if value is `null` -> `is null` operator
 */
SELECT rental_id, customer_id
FROM rental
WHERE rental.return_date IS NULL;

/*
 or use `is not null` for get all values where return_date not null
 */
SELECT rental_id, customer_id
FROM rental
WHERE rental.return_date IS NOT NULL;

SELECT rental_id, customer_id, return_date
FROM rental
WHERE return_date IS NULL
   OR return_date NOT BETWEEN '2005-05-01' AND '2005-09-01';

/*
 TASKS FROM END OF CHAPTER 4
 */

-- 4.1
SELECT payment_id, customer_id, amount, TO_CHAR(payment_date, 'YYYY-MM-dd')
FROM payment
WHERE customer_id != 5
  AND (amount > 8 OR date(payment_date) = '2005-08-23');

-- Answer result included 855 rows

-- 4.2
SELECT payment_id, customer_id, amount, TO_CHAR(payment_date, 'YYYY-MM-dd')
FROM payment
WHERE customer_id = 5
  AND (amount > 6 OR TO_CHAR(payment_date, 'YYYY-MM-dd') = '2005-06-19');

-- Answer result included 5 rows

-- 4.3
SELECT amount
FROM payment
WHERE amount IN (1.98, 7.98, 9.98);

-- 4.4
SELECT first_name, last_name
FROM customer
WHERE last_name LIKE '_A%W%';