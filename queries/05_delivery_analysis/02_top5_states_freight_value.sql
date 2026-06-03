-- ============================================================
-- Query  : Top 5 States by Average Freight Value
-- Section: 05 - Delivery & Freight Analysis
-- Author : Mahek
-- Tool   : Google BigQuery
-- ============================================================
SELECT
customer_state,
avg_freight_value,
CASE
WHEN rank_desc <= 5 THEN 'Top 5 (Longest)'
WHEN rank_asc <= 5 THEN 'Bottom 5 (Shortest)'
END AS category
FROM (
SELECT
c.customer_state,
AVG(oi.freight_value) AS avg_freight_value,
RANK() OVER (ORDER BY AVG(oi.freight_value) DESC) AS rank_desc,
RANK() OVER (ORDER BY AVG(oi.freight_value) ASC) AS rank_asc
FROM `businesscase_1.customers` c join `businesscase_1.orders` o on c.customer_id =
o.customer_id
join `businesscase_1.order_items` oi on o.order_id = oi.order_id
GROUP BY c.customer_state
) t
WHERE rank_desc <= 5
OR rank_asc <= 5
ORDER BY
category,
avg_freight_value DESC;
