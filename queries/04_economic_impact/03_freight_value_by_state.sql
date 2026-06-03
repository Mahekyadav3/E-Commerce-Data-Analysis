-- ============================================================
-- Query  : Top 5 States by Average Freight Value
-- Section: 05 - Delivery & Freight Analysis
-- Author : Mahek
-- Tool   : Google BigQuery
-- ============================================================
select distinct c.customer_state,
round(sum(oi.freight_value),2) as total_value_of_freight,
round(avg(oi.freight_value),2) as average_of_freight
from `businesscase_1.order_items` oi join `businesscase_1.orders` o on oi.order_id =
o.order_id
join `businesscase_1.customers` c on c.customer_id = o.customer_id
group by c.customer_state
order by c.customer_state;
