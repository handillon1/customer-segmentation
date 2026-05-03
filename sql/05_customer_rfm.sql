DROP TABLE IF EXISTS analytics.customer_rfm;

CREATE TABLE analytics.customer_rfm AS
WITH snap AS (
    SELECT MAX(invoice_date)::date + 1 AS snapshot_date
    FROM analytics.clean_transactions
)
SELECT
    t.customer_id,
    MAX(t.country) AS country,
    snap.snapshot_date - MAX(t.invoice_date)::date AS recency_days,
    COUNT(DISTINCT t.invoice) AS frequency,
    SUM(t.line_revenue)::numeric(12,2) AS monetary,
    AVG(t.line_revenue)::numeric(12,2) AS avg_basket,
    MIN(t.invoice_date)::date AS first_purchase,
    MAX(t.invoice_date)::date AS last_purchase
FROM analytics.clean_transactions t
CROSS JOIN snap
GROUP BY t.customer_id, snap.snapshot_date;

CREATE INDEX idx_customer_rfm_id ON analytics.customer_rfm(customer_id);
