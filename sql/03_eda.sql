-- Date range
SELECT MIN(invoice_date), MAX(invoice_date) FROM raw.transactions;

-- Rows missing a customer 
SELECT COUNT(*) FROM raw.transactions WHERE customer_id IS NULL;

-- Cancellations
SELECT COUNT(*) FROM raw.transactions WHERE invoice LIKE 'C%';

-- Top countries
SELECT country, COUNT(*) AS n FROM raw.transactions
GROUP BY country ORDER BY n DESC LIMIT 10;
