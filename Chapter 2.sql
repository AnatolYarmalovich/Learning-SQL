/*
 Chapter 2 (use Sakila DB) - Postgres SQL syntax here!
 */

CREATE TYPE eye_color AS ENUM ('BR','BL','GR');

CREATE TABLE person
(
    person_id   SERIAL,
    fname       VARCHAR(20),
    lname       VARCHAR(20),
    eye_color   eye_color,
    birth_date  DATE,
    street      VARCHAR(30),
    city        VARCHAR(20),
    state       VARCHAR(20),
    country     VARCHAR(20),
    postal_code VARCHAR(20),
    CONSTRAINT pk_person PRIMARY KEY (person_id)
);

/*
 Because people can have more than two
 */
CREATE TABLE favourite_food
(
    person_id SMALLINT,
    food      VARCHAR(20),
    CONSTRAINT pk_favourite_food PRIMARY KEY (person_id, food),
    CONSTRAINT fk_favFood_person_id FOREIGN KEY (person_id) REFERENCES person (person_id)
);

/*
 Insert couple persons to database:
 */
INSERT INTO person (person_id, fname, lname, eye_color, birth_date)
VALUES (1, 'William', 'Turner', 'BR', '1972-05-27');

INSERT INTO person (fname, lname, eye_color, birth_date)
VALUES ('Test', 'Testovich', 'BR', '1972-05-27');

/*
 Try to get person by ID and by first name:
 */
SELECT person_id, fname, lname, birth_date
FROM person
WHERE person_id = 2;

SELECT person_id, fname, lname, birth_date
FROM person
WHERE fname = 'William';

/*
 Add some food:
 */
INSERT INTO favourite_food (person_id, food)
VALUES (1, 'pizza');

INSERT INTO favourite_food (person_id, food)
VALUES (1, 'cookies');

INSERT INTO favourite_food (person_id, food)
VALUES (1, 'nachos');

/*
 Just get food for person with ID == 1
 */
SELECT food
FROM favourite_food
WHERE person_id = 1
ORDER BY food;

/*
 Add one more person with additional fields
 */
INSERT INTO person (fname, lname, eye_color, birth_date, street, city, state, country, postal_code)
VALUES ('Susan', 'Smith', 'BL', '1975-12-19', '23 Maple St.', 'Arlington', 'VA', 'USA', '20220');

/*
 Get all persons same columns from table
 */
SELECT person_id, fname, lname, birth_date
FROM person;

/*
 Generate an XML
 */

/*
 Update rows in table
 */
UPDATE person
SET street      = 'Unknown str.',
    city        = 'Boston',
    state       = 'MA',
    country     = 'USA',
    postal_code = '02138'
WHERE person_id = 1;

/*
 Delete rows in table
 */
DELETE
FROM person
WHERE person_id = 3;

/*
 Typical errors
 1. Not unique Primary key
 */
INSERT INTO person (person_id, fname, lname, eye_color, birth_date)
VALUES (1, 'Charles', 'Fulton', 'GR', '1968-01-15');

/*
 2. Not available Foreign key (InnoDB mechanism)
 */
INSERT INTO favourite_food (person_id, food)
VALUES (999, 'lasagna');

/*
 3. Column value violation
 */
UPDATE person
SET eye_color = 'XX'
WHERE person_id = 1;

/*
 4. Not correct data format for column
 */
UPDATE person
SET birth_date = '19819'
WHERE person_id = 1;


