-- ============================================================
-- Query  : Top 5 States by Average Freight Value
-- Section: 05 - Delivery & Freight Analysis
-- Author : Mahek
-- Tool   : Google BigQuery
-- ============================================================
SELECT
customer_state,
avg_delivery_time,
CASE
WHEN rank_desc <= 5 THEN 'Top 5 (Longest)'
WHEN rank_asc <= 5 THEN 'Bottom 5 (Shortest)'
END AS category
FROM (
SELECT
customer_state,
AVG(timestamp_diff(o.order_delivered_customer_date,o.order_approved_at,day)) AS
avg_delivery_time,
RANK() OVER (ORDER BY
AVG(timestamp_diff(o.order_delivered_customer_date,o.order_approved_at,day)) DESC) AS
rank_desc,
RANK() OVER (ORDER BY
AVG(timestamp_diff(o.order_delivered_customer_date,o.order_approved_at,day)) ASC) AS
rank_asc
FROM `businesscase_1.orders` o join `businesscase_1.customers` c on o.customer_id =
c.customer_id
GROUP BY customer_state
) t
WHERE rank_desc <= 5
OR rank_asc <= 5
ORDER BY
category,
avg_delivery_time DESC;
