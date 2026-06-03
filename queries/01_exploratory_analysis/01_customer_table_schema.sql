-- ============================================================
-- Query  : Data Type of All Columns in Customers Table
-- Section: 01 - Exploratory Analysis
-- Author : Mahek
-- Tool   : Google BigQuery
-- Insight: Customers table has 5 columns — 4 STRING, 1 INTEGER.
--          customer_id is the primary key.
-- ============================================================
 
SELECT column_name, data_type
FROM businesscase_1.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'customers';
