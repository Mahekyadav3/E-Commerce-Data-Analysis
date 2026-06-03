-- ============================================================
-- Query  : Top 5 States by Average Freight Value
-- Section: 04 - Economic Impact
-- Author : Mahek
-- Tool   : Google BigQuery
-- ============================================================
WITH monthly_data AS (
SELECT
EXTRACT(YEAR FROM o.order_purchase_timestamp) AS year,
EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month,
p.payment_value
FROM
businesscase_1.payments p
JOIN
businesscase_1.orders o ON p.order_id = o.order_id
WHERE
EXTRACT(YEAR FROM o.order_purchase_timestamp) IN (2017, 2018)
AND EXTRACT(MONTH FROM o.order_purchase_timestamp) <= 8
),
yearly_total AS (
SELECT
year,
SUM(payment_value) AS total_payment
FROM
monthly_data
GROUP BY
year
)
SELECT
ROUND(
(MAX(CASE WHEN year = 2018 THEN total_payment END) -
MAX(CASE WHEN year = 2017 THEN total_payment END)) * 100 /
MAX(CASE WHEN year = 2017 THEN total_payment END),
2
) AS percent_increase
FROM yearly_total;
