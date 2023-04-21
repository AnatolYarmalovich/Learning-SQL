/*
 Chapter 12 (use Sakila DB) - Postgres SQL syntax here!
 */

START TRANSACTION


/*
TASKS FROM END OF CHAPTER 12
*/

-- 12.1

-- 1. Create tables

CREATE TABLE acc_transaction
(
    account_id         SERIAL PRIMARY KEY,
    avail_balance      FLOAT(6),
    last_activity_date DATE DEFAULT NOW()
);

CREATE TABLE bank_transaction
(
    txn_id      SERIAL PRIMARY KEY,
    account_id  INT,
    txn_date    DATE DEFAULT NOW(),
    txn_type_cd CHAR(1) NOT NULL,
    amount      FLOAT(6),
    FOREIGN KEY (account_id) REFERENCES acc_transaction (account_id)
);

INSERT INTO acc_transaction(account_id, avail_balance, last_activity_date)
VALUES (123, 500, '2019-07-10 20:53:27'),
       (789, 75, '2019-06-22 15:18:35');

INSERT INTO bank_transaction(txn_id, account_id, txn_date, txn_type_cd, amount)
VALUES (1001, 123, '2019-05-15', 'C', 500),
       (1002, 789, '2019-06-01', 'C', 75);

BEGIN;

INSERT INTO bank_transaction(txn_id, account_id, txn_date, txn_type_cd, amount)
VALUES (1003, 123, NOW(), 'D', 50),
       (1004, 789, NOW(), 'C', 50);

UPDATE acc_transaction
SET avail_balance      = avail_balance - 50,
    last_activity_date = NOW()
WHERE account_id = 123;

UPDATE acc_transaction
SET avail_balance      = avail_balance + 50,
    last_activity_date = NOW()
WHERE account_id = 789;

COMMIT;

DROP TABLE acc_transaction CASCADE;
DROP TABLE bank_transaction;