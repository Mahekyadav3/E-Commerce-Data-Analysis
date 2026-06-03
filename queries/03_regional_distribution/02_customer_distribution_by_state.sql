-- ============================================================
-- Query  : Customer Table Schema
-- Section: 01 - Exploratory Analysis
-- Author : Mahek
-- Tool   : Google BigQuery
-- ============================================================
select distinct customer_state,
count(*) as no_of_customers
from `businesscase_1.customers`
group by customer_state
order by customer_state;
