/*
 Chapter 6 (use Sakila DB) - Postgres SQL syntax here!
 */

/*
 SET Operations - Combined query
 */
SELECT 1 num, 'abc' str
UNION
SELECT 9 num, 'xyz' str;

/*
 UNION ALL operator
 */
SELECT 'CUST' type, c.first_name, c.last_name
FROM customer c
UNION ALL
SELECT 'ACTR' type, a.first_name, a.last_name
FROM actor a;

/*
 Be accurate! UNION ALL operator don't delete duplicate from resulting SET!
 */
SELECT 'ACTR' type, a.first_name, a.last_name
FROM actor a
UNION ALL
SELECT 'ACTR' type, a.first_name, a.last_name
FROM actor a;

SELECT c.first_name, c.last_name
FROM customer c
WHERE c.first_name LIKE 'J%'
  AND c.last_name LIKE 'D%'
UNION ALL
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'J%'
  AND a.last_name LIKE 'D%';

/*
 Use UNION extend UNION ALL for removing duplicates in resulting SET
 */
SELECT c.first_name, c.last_name
FROM customer c
WHERE c.first_name LIKE 'J%'
  AND c.last_name LIKE 'D%'
UNION
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'J%'
  AND a.last_name LIKE 'D%';

/*
 INTERSECT operator
 */
SELECT c.first_name, c.last_name
FROM customer c
WHERE c.first_name LIKE 'D%'
  AND c.last_name LIKE 'T%'
INTERSECT
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'D%'
  AND a.last_name LIKE 'T%';

SELECT c.first_name, c.last_name
FROM customer c
WHERE c.first_name LIKE 'J%'
  AND c.last_name LIKE 'D%'
INTERSECT
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'J%'
  AND a.last_name LIKE 'D%';

-- Also we have INTERSECT ALL (and this operator don't delete a duplicates in resulting SET)!

/*
 EXCEPT operator
 */
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'J%'
  AND a.last_name LIKE 'D%'
EXCEPT
SELECT c.first_name, c.last_name
FROM customer c
WHERE c.first_name LIKE 'J%'
  AND c.last_name LIKE 'D%';

-- Also we have EXCEPT ALL (and this operator don't delete a duplicates in resulting SET)!

/*
 Sorting resulting SET when use combined query
 */
SELECT a.first_name AS fname, a.last_name AS lname
FROM actor a
WHERE a.first_name LIKE 'J%'
  AND a.last_name LIKE 'D%'
UNION ALL
SELECT c.first_name, c.last_name
FROM customer c
WHERE c.first_name LIKE 'J%'
  AND c.last_name LIKE 'D%'
ORDER BY lname, fname;

/*
 PRIORITY IN SET'S OPERATIONS - PRIORITY IS VERY IMPORTANT PART, WATCH BELLOW!
 */
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'J%'
  AND a.last_name LIKE 'D%'
UNION ALL
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'M%'
  AND a.last_name LIKE 'T%'
UNION
SELECT c.first_name, c.last_name
FROM customer c
WHERE c.first_name LIKE 'J%'
  AND c.last_name LIKE 'D%';
-- resulting set include 6 rows!!!

SELECT a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'J%'
  AND a.last_name LIKE 'D%'
UNION
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'M%'
  AND a.last_name LIKE 'T%'
UNION ALL
SELECT c.first_name, c.last_name
FROM customer c
WHERE c.first_name LIKE 'J%'
  AND c.last_name LIKE 'D%';
-- resulting set include 7 rows!!!

/*
 Use brackets for changing priority of sets operator execution
 */

SELECT a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'J%'
  AND a.last_name LIKE 'D%'
UNION
(SELECT a.first_name, a.last_name
 FROM actor a
 WHERE a.first_name LIKE 'M%'
   AND a.last_name LIKE 'T%'
 UNION ALL
 SELECT c.first_name, c.last_name
 FROM customer c
 WHERE c.first_name LIKE 'J%'
   AND c.last_name LIKE 'D%');

/*
 TASKS FROM END OF CHAPTER 6
 */

-- 6.1
/*
* A = { L, M, N, O, P }
* B = { P, Q, R, S, T }
* A union B = { L, M, N, O, P, Q, R, S, T }
* A union all B = { L, M, N, O, P, P, Q, R, S, T }
* A intersect B = { P }
* A except B = { L, M, N, O }
 */

-- 6.2
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.last_name LIKE 'L%'
UNION
SELECT c.first_name, c.last_name
FROM customer c
WHERE c.last_name LIKE 'L%';

-- 6.3
SELECT a.first_name, a.last_name AS lname
FROM actor a
WHERE a.last_name LIKE 'L%'
UNION
SELECT c.first_name, c.last_name AS lname
FROM customer c
WHERE c.last_name LIKE 'L%'
ORDER BY lname;