-- ============================================================
-- Query  : Customer Table Schema
-- Section: 03 - Regional Distribution
-- Author : Mahek
-- Tool   : Google BigQuery
-- ============================================================
select distinct c.customer_state,
extract(month from o.order_purchase_timestamp ) as month,
count(*) as no_of_orders
from `businesscase_1.orders` o join `businesscase_1.customers` c 
on o.customer_id = c.customer_id
group by c.customer_state, extract(month from o.order_purchase_timestamp )
order by c.customer_state,month;
