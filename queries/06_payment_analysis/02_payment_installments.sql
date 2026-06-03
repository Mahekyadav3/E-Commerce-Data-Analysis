-- ============================================================
-- Query  : Top 5 States by Average Freight Value
-- Section: 06 - Payment Analysis
-- Author : Mahek
-- Tool   : Google BigQuery
-- ============================================================
SELECT
payment_installments,
COUNT(order_id) AS num_of_orders
FROM `businesscase_1.payments`
WHERE payment_installments >= 1
GROUP BY payment_installments
ORDER BY payment_installments;
