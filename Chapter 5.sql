/*
 Chapter 5 (use Sakila DB) - Postgres SQL syntax here!
 */

/*
 CROSS JOIN (AKA Decart multiplication) AKA CARTESIAN JOIN
 */
SELECT c.first_name, c.last_name, a.address
FROM customer c
         CROSS JOIN address a;

/*
 With `ON` conditions
 */
SELECT c.first_name, c.last_name, a.address
FROM customer c
         JOIN address a ON a.address_id = c.address_id;

/*
 Using internal table merging with INNER JOIN (INNER added by default^ but the best practise do it explicitly)
 */
SELECT c.first_name, c.last_name, a.address
FROM customer c
         INNER JOIN address a ON a.address_id = c.address_id;

/*
 use `USING` extend `ON`
 */
SELECT
FROM customer c
         INNER JOIN address a USING (address_id);

/*
 Using ANSI syntax
 */
SELECT c.first_name, c.last_name, a.address
FROM customer c,
     address a
WHERE c.address_id = a.address_id;

-- Another one query with OLD-style syntax
SELECT c.first_name, c.last_name, a.address
FROM customer c,
     address a
WHERE c.address_id = a.address_id
  AND a.postal_code = '52137';

-- SQL92
SELECT c.first_name, c.last_name, a.address
FROM customer c
         INNER JOIN address a
                    ON a.address_id = c.address_id
WHERE a.postal_code = '52137';

/*
 Three table Joining
 */
SELECT c.first_name, c.last_name, ct.city
FROM customer c
         INNER JOIN address a ON a.address_id = c.address_id
         INNER JOIN city ct ON a.city_id = ct.city_id;

/*
 Don't remember that SQL not procedural language, and query order doesn't matter!
 */
SELECT c.first_name, c.last_name, ct.city
FROM city ct
         INNER JOIN address a
                    ON a.city_id = ct.city_id
         INNER JOIN customer c
                    ON c.address_id = a.address_id;

/*
 Using sub-queries in kind of table
 */
SELECT c.first_name, c.last_name, addr.address, addr.city
FROM customer AS c
         INNER JOIN (SELECT a.address_id, a.address, ct.city
                     FROM address AS a
                              INNER JOIN city AS ct
                                         ON a.city_id = ct.city_id
                     WHERE a.district = 'California') AS addr
                    ON c.address_id = addr.address_id;

/*
 Multiple queries to same table (without multiple queries to same table)
 */
SELECT f.title
FROM film f
         INNER JOIN film_actor fa
                    ON f.film_id = fa.film_id
         INNER JOIN actor a
                    ON fa.actor_id = a.actor_id
WHERE ((a.first_name = 'CATE' AND a.last_name = 'MCQUEEN')
    OR (a.first_name = 'CUBA' AND a.last_name = 'BIRCH'));

/*
With multiple queries to same table
 */
SELECT f.title
FROM film f
         INNER JOIN film_actor fa1
                    ON f.film_id = fa1.film_id
         INNER JOIN actor a1
                    ON fa1.actor_id = a1.actor_id
         INNER JOIN film_actor fa2
                    ON f.film_id = fa2.film_id
         INNER JOIN actor a2
                    ON fa2.actor_id = a2.actor_id
WHERE ((a1.first_name = 'CATE' AND a1.last_name = 'MCQUEEN')
    AND (a2.first_name = 'CUBA' AND a2.last_name = 'BIRCH'));

/*
 TASKS FROM END OF CHAPTER 5
 */

-- 5.1
SELECT c.first_name, c.last_name, a.address, ct.city
FROM customer AS c
         INNER JOIN address a
                    ON c.address_id = a.address_id
         INNER JOIN city ct
                    ON a.city_id = ct.city_id
WHERE a.district = 'California';
-- ANSWER: 9 rows

-- 5.2
SELECT f.title
FROM film f
         INNER JOIN film_actor fa
                    ON f.film_id = fa.film_id
         INNER JOIN actor a
                    ON a.actor_id = fa.actor_id
WHERE a.first_name = 'JOHN';
-- ANSWER: 29 rows

-- 5.3
-- My solution
SELECT c.city, a1.address, a2.address, c.city_id
FROM city c
         INNER JOIN address a1 ON c.city_id = a1.city_id
         INNER JOIN address a2 ON c.city_id = a2.city_id
WHERE a1.address != a2.address;
-- ANSWER: 8 rows

-- Solution from book:
SELECT a1.address AS addr1, a2.address AS addr2, a1.city_id
FROM address a1
         INNER JOIN address a2
ON a1.city_id = a2.city_id
  AND a1.address_id != a2.address_id;
-- ANSWER: 8 rows
