-- ============================================================
-- Query  : Top 5 States by Average Freight Value
-- Section: 05 - Delivery & Freight Analysis
-- Author : Mahek
-- Tool   : Google BigQuery
-- ============================================================
SELECT
EXTRACT(MONTH FROM order_purchase_timestamp) AS month,
EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
COUNT(*) AS total_orders
FROM
`businesscase_1.orders`
GROUP BY
EXTRACT(MONTH FROM order_purchase_timestamp),
EXTRACT(YEAR FROM order_purchase_timestamp)
ORDER BY
2,1;
