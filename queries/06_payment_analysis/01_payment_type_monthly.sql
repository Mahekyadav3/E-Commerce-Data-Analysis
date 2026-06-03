-- ============================================================
-- Query  : Top 5 States by Average Freight Value
-- Section: 06 - Payment Analysis
-- Author : Mahek
-- Tool   : Google BigQuery
-- ============================================================
select extract(month from o.order_purchase_timestamp) as month,
p.payment_type as payment_type,
count(*) as no_of_orders
from `businesscase_1.orders` o join `businesscase_1.payments` p on o.order_id = p.order_id
group by extract(month from o.order_purchase_timestamp), p.payment_type
order by extract(month from o.order_purchase_timestamp) ;
