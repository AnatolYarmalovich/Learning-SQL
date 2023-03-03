/*
 Chapter 7 (use Sakila DB) - Postgres SQL syntax here!
 */

/*
 String literal types
 */

CREATE TABLE string_tbl
(
    char_fld  CHAR(30),
    vchar_fld VARCHAR(30),
    text_fld  TEXT
);

/*
 String generation and insertion
 */
INSERT INTO string_tbl (char_fld, vchar_fld, text_fld)
VALUES ('this is char data',
        'this is varchar data',
        'this is text data');

/*
 Try to make UPDATE query when var_char more than 30 characters
 */
UPDATE string_tbl
SET vchar_fld = 'This is a piece of extremely long data';

/*
 Include single quotes
 */
-- Query with error:
-- UPDATE string_tbl
-- SET text_fld = 'This string didn't WORK';

-- Solution:
UPDATE string_tbl
SET text_fld = 'This string didn''t WORK, but it does now';

/*
 For select query no special handling needed
 */
SELECT text_fld
FROM string_tbl;

/*
 Getting string with additional `'` symbol
 */
SELECT QUOTE_LITERAL(text_fld)
FROM string_tbl;

/*
 Include special character
 */
SELECT 'danke sch' || CHR(148) || 'n';


/*
 Erase string_tbl data
 */
DELETE
FROM string_tbl;

/*
 Insert new data
 */
INSERT INTO string_tbl (char_fld, vchar_fld, text_fld)
VALUES ('This string is 28 characters',
        'This string is 28 characters',
        'This string is 28 characters');

/*
 String function with numeric values return type (LENGTH of string)
 */
SELECT LENGTH(char_fld) AS char_lenght, LENGTH(vchar_fld) AS vchar_lenght, LENGTH(text_fld) AS text_lenght
FROM string_tbl;

/*
 Find position of given string
 */
SELECT POSITION('characters' IN vchar_fld)
FROM string_tbl;

/*
 Compare strings
 */

-- Erase table
DELETE
FROM string_tbl;

-- Insert new values
INSERT INTO string_tbl(vchar_fld)
VALUES ('abcd'),
       ('xyz'),
       ('QRSTUV'),
       ('qrstuv'),
       ('12345');

/*
 There's 5 strings in sorted order
 */
SELECT vchar_fld
FROM string_tbl
ORDER BY vchar_fld;

/*
 Use LIKE operator for logical comparison
 */
SELECT name, name LIKE '%y' ends_in_y
FROM category;

/*
 Use regex pattern for difficult template
 */
SELECT name, name ~* 'y$' ends_in_y
FROM category;

/*
 String functions that return string
 */

-- Erase table
DELETE
FROM string_tbl;

-- Add values
INSERT INTO string_tbl (text_fld)
VALUES ('This string was 29 characters');

/*
 Add additional string to available string
 */
UPDATE string_tbl
SET text_fld = CONCAT(text_fld, ', but now it is longer');

-- Check
SELECT text_fld
FROM string_tbl;

/*
 Using concat func for create a merged string from two separated string
 */
SELECT CONCAT(first_name, ' ', last_name, ' has been a customer since ', date(create_date)) cust_narrative
FROM customer;

-- Use `||` operator
SELECT first_name || ' ' || customer.last_name || ' has been a customer since ' || date(create_date) cust_narrative
FROM customer;

/*
 Replace func using
 */
SELECT REPLACE('goodbye world', 'goodbye', 'hello');

/*
 Substr func using
 */
SELECT SUBSTR('goodbye cruel world', 9, 5);

/*
 Working with numeric data
 */
SELECT (37 * 59) / (78 - (8 * 6));

/*
  Mod func using
 */
SELECT MOD(10, 4);

-- With floating point numbers
SELECT MOD(22.75, 5);

/*
 Pow function
 */
SELECT POW(2, 8);

/*
 Calculate measures from byte source
 */

SELECT POW(2, 10) kilobyte,
       POW(2, 20) megabyte,
       POW(2, 30) gigabyte,
       POW(2, 40) terabyte;

/*
 Round floating point digits ceil and floor functions
 Ceil round to highest
 Floor round to lowest
 */

SELECT CEIL(72.445), FLOOR(72.445);

/*
 Use round func, for round numbers with math rules
 */
SELECT ROUND(72.49999), ROUND(72.5), ROUND(72.50001);

/*
 With rounding accuracy
 */
SELECT ROUND(72.0909, 1), ROUND(72.0909, 2), ROUND(72.0909, 3);

/*
 Truncate func
 */
SELECT TRUNC(72.0909, 1), TRUNC(72.0909, 2), TRUNC(72.0909, 3);

/*
 Work with temporal data
 */

-- Create account table
CREATE TABLE account
(
    account_id INT PRIMARY KEY NOT NULL,
    acct_type  VARCHAR(30),
    balance    float
);

-- Insert data
INSERT INTO account(account_id, acct_type, balance)
VALUES (123, 'MONEY MARKET', 785.22);

INSERT INTO account(account_id, acct_type, balance)
VALUES (456, 'SAVINGS', 0.00);

INSERT INTO account(account_id, acct_type, balance)
VALUES (789, 'CHECKING', -324.22);

-- Work with SIGN and ABS func
SELECT account_id, SIGN(balance), ABS(balance)
FROM account;

/*
 Working with Temporal Data
 */
SET TIMEZONE = 'CET';
SELECT CURRENT_SETTING('TIMEZONE'), CLOCK_TIMESTAMP();

UPDATE rental
SET return_date = '2019-09-17 15:30:00'
WHERE rental_id = 99999;

-- Cast string to date
SELECT CAST('2019-09-17 15:30:00' AS DATE) date_field, CAST('2019-09-17 15:30:00' AS TIME) time_field;

-- String to date function
UPDATE rental
SET return_date = TO_DATE('September 17, 2019', 'Month dd, YYYY')
WHERE rental_id = 99999;

-- Check
SELECT TO_DATE('September 17, 2019', 'Month dd, YYYY');

-- Get current time
SELECT CURRENT_DATE, CURRENT_TIME, CURRENT_TIMESTAMP;

/*
 Functions with date as return type
 */
SELECT CURRENT_DATE + INTERVAL '1 year';

SELECT CURRENT_TIME + INTERVAL '3:00:11';

/*
 Date functions with string as return type
 */
SELECT TO_CHAR(date '2019-09-18', 'Day');

/*
 Extract year
 */
SELECT EXTRACT(YEAR FROM date '2019-09-18 22:19:05');

/*
 Functions with number return type
 */
SELECT DATE_PART('day', timestamp '2019-06-21 00:00:00') - DATE_PART('day', timestamp '2019-09-03 00:00:00');

/*
 TASKS FROM END OF CHAPTER 7
 */

-- 7.1
SELECT SUBSTRING('Please find the substring in this string' FROM 17 FOR 9);
--OR
SELECT SUBSTR('Please find the substring in this string', 17, 9);

-- 7.2
SELECT ABS(-25.76823), SIGN(-25.76823), ROUND(-25.76823, 2);

-- 7.3
SELECT date_part('month', current_date::timestamp);
--OR
SELECT to_char(current_date, 'Month');