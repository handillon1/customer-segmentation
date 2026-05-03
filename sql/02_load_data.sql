TRUNCATE raw.transactions;

COPY raw.transactions(invoice, stock_code, description, quantity,
                      invoice_date, price, customer_id, country)
FROM 'C:/temp/retail_2009_2010.csv'
WITH (FORMAT CSV, HEADER true, ENCODING 'UTF8');

COPY raw.transactions(invoice, stock_code, description, quantity,
                      invoice_date, price, customer_id, country)
FROM 'C:/temp/retail_2010_2011.csv'
WITH (FORMAT CSV, HEADER true, ENCODING 'UTF8');