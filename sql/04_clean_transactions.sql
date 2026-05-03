CREATE OR REPLACE VIEW analytics.clean_transactions AS
SELECT
    invoice,
    stock_code,
    description,
    quantity,
    invoice_date,
    price,
    customer_id,
    country,
    quantity * price AS line_revenue
FROM raw.transactions
WHERE customer_id IS NOT NULL
  AND invoice NOT LIKE 'C%'
  AND quantity > 0
  AND price > 0
  AND stock_code NOT IN ('POST','M','D','DOT','BANK CHARGES','PADS','C2');