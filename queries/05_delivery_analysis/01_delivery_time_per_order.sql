-- ============================================================
-- Query  : Top 5 States by Average Freight Value
-- Section: 05 - Delivery & Freight Analysis
-- Author : Mahek
-- Tool   : Google BigQuery
-- ============================================================
SELECT
order_id,
DATE_DIFF(
order_delivered_customer_date, order_purchase_timestamp, DAY)
AS delivery_time,
DATE_DIFF(
order_delivered_customer_date,
order_estimated_delivery_date,
DAY)
AS diff_estimated_delivery
FROM `businesscase_1`.`orders` AS orders
WHERE order_delivered_customer_date is not null and order_purchase_timestamp is not null
and order_estimated_delivery_date is not null
ORDER BY order_purchase_timestamp;
