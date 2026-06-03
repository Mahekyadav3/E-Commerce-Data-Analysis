-- ============================================================
-- Query  : Customer Table Schema
-- Section: 01 - Exploratory Analysis
-- Author : Mahek
-- Tool   : Google BigQuery
-- ============================================================
select
count(distinct customer_city) as count_of_cities,
count(distinct customer_state) as count_of_state
from businesscase_1.customers;


-- ============================================================

  
SELECT
COUNT(DISTINCT c.customer_city) AS count_of_cities,
COUNT(DISTINCT c.customer_state) AS count_of_states
FROM
businesscase_1.customers c
JOIN
businesscase_1.orders o ON c.customer_id = o.customer_id
WHERE
o.order_purchase_timestamp BETWEEN '2016-01-01' AND '2018-12-31';
