--3 Joins
SELECT c.name, b.bank_name
FROM customer c
JOIN new_accounts na ON c.customer_id = na.customer_id
JOIN bank b ON na.bank_id = b.bank_id;

SELECT e.name, c.name AS customer_name
FROM employee e
JOIN new_accounts na ON e.emp_id = na.emp_id
JOIN customer c ON na.customer_id = c.customer_id;

SELECT c.name, fs.loan_type, fs.loan_amount
FROM customer c
JOIN financial_services fs ON c.customer_id = fs.customer_id
JOIN bank b ON b.bank_id IN (SELECT bank_id FROM new_accounts WHERE customer_id = c.customer_id);



--3 WHERE + GROUP BY + HAVING + ORDER BY

SELECT city, COUNT(*) AS total_customers
FROM customer
WHERE age > 25
GROUP BY city
HAVING COUNT(*) > 1
ORDER BY total_customers DESC;


SELECT loan_type, SUM(loan_amount) AS total_loan
FROM financial_services
WHERE loan_amount > 10000
GROUP BY loan_type
HAVING SUM(loan_amount) > 50000
ORDER BY total_loan DESC;


SELECT account_type, AVG(opening_balance) AS avg_balance
FROM new_accounts
WHERE opened_on > '2010-01-01'
GROUP BY account_type
HAVING AVG(opening_balance) > 30000
ORDER BY avg_balance DESC;


--3 Joins with WHERE + GROUP BY + HAVING + ORDER BY

SELECT b.bank_name, COUNT(na.account_id) AS total_accounts
FROM bank b
JOIN new_accounts na ON b.bank_id = na.bank_id
JOIN customer c ON na.customer_id = c.customer_id
WHERE c.city = 'Mumbai'
GROUP BY b.bank_name
HAVING COUNT(na.account_id) > 1
ORDER BY total_accounts DESC;


SELECT e.name, COUNT(na.account_id) AS accounts_opened
FROM employee e
JOIN new_accounts na ON e.emp_id = na.emp_id
JOIN bank b ON na.bank_id = b.bank_id
WHERE b.city = 'Delhi'
GROUP BY e.name
HAVING COUNT(na.account_id) >= 2
ORDER BY accounts_opened DESC;


SELECT c.city, SUM(t.amount) AS total_transaction
FROM customer c
JOIN transaction t ON c.customer_id = t.customer_id
JOIN new_accounts na ON na.customer_id = c.customer_id
WHERE t.status = 'Success'
GROUP BY c.city
HAVING SUM(t.amount) > 50000
ORDER BY total_transaction DESC;


--Multi Join

SELECT c.name AS customer_name, b.bank_name, e.name AS employee_name, fs.loan_type
FROM customer c
JOIN new_accounts na ON c.customer_id = na.customer_id
JOIN bank b ON na.bank_id = b.bank_id
JOIN employee e ON na.emp_id = e.emp_id
JOIN financial_services fs ON fs.customer_id = c.customer_id;


--CTE

WITH HighValueAccounts AS (
    SELECT customer_id, opening_balance
    FROM new_accounts
    WHERE opening_balance > 50000
)
SELECT c.name, h.opening_balance
FROM HighValueAccounts h
JOIN customer c ON h.customer_id = c.customer_id;

-- Subquery

SELECT name, city
FROM customer
WHERE customer_id IN (
    SELECT customer_id
    FROM new_accounts
    WHERE opening_balance = (SELECT MAX(opening_balance) FROM new_accounts)
);



