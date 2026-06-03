-- ============================================================
-- Query  : Customer Table Schema
-- Section: 01 - Exploratory Analysis
-- Author : Mahek
-- Tool   : Google BigQuery
-- ============================================================
select
max(order_purchase_timestamp) as last_order_date,
min(order_purchase_timestamp) as first_order_date
from businesscase_1.orders;
