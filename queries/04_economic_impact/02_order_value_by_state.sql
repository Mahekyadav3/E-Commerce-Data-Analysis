-- ============================================================
-- Query  : Top 5 States by Average Freight Value
-- Section: 04 - Economic Impact
-- Author : Mahek
-- Tool   : Google BigQuery
-- ============================================================
select distinct c.customer_state,
round(sum(p.payment_value),2) as total_value_of_orderprice,
round(avg(p.payment_value),2) as average_of_orderprice
from `businesscase_1.payments` p join `businesscase_1.orders` o on p.order_id = o.order_id
join `businesscase_1.customers` c on c.customer_id = o.customer_id
group by c.customer_state
order by c.customer_state;
