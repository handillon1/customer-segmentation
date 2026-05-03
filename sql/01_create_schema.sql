CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS analytics;

CREATE TABLE raw.transactions (
    invoice        TEXT,
    stock_code     TEXT,
    description    TEXT,
    quantity       INTEGER,
    invoice_date   TIMESTAMP,
    price          NUMERIC(10,2),
    customer_id    INTEGER,
    country        TEXT
);
