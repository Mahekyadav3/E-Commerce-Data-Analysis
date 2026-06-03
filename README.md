# 🛒 Target Brazil — E-Commerce SQL Analysis

> **BigQuery SQL project** analyzing Target's Brazilian e-commerce operations to extract business insights across customers, orders, payments, freight, and delivery performance.

---

## 📌 Project Overview

This project simulates the role of a **Data Analyst at Target**, tasked with analyzing a multi-table e-commerce dataset hosted on **Google BigQuery**. The goal is to uncover actionable insights across the customer journey — from order placement to delivery and payment.

**Dataset period:** September 2016 – October 2018  
**Platform:** Google BigQuery (`businesscase_1` dataset)  
**Tables used:** `customers`, `orders`, `order_items`, `payments`, `products`, `sellers`, `geolocation`, `order_reviews`

---

## 🗂️ Table of Contents

1. [Dataset Structure](#1-dataset-structure)
2. [Exploratory Analysis](#2-exploratory-analysis)
3. [Order Trends & Seasonality](#3-order-trends--seasonality)
4. [Regional Distribution](#4-regional-distribution)
5. [Economic Impact](#5-economic-impact)
6. [Delivery & Freight Analysis](#6-delivery--freight-analysis)
7. [Payment Analysis](#7-payment-analysis)
8. [Key Takeaways](#8-key-takeaways)

---

## 1. Dataset Structure

The `customers` table contains **5 columns**: `customer_id` (STRING, primary key), `customer_unique_id` (STRING), `customer_zip_code_prefix` (INTEGER), `customer_city` (STRING), and `customer_state` (STRING).

```sql
SELECT column_name, data_type
FROM businesscase_1.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'customers';
```

---

## 2. Exploratory Analysis

### 2.1 Order Date Range

```sql
SELECT
  MAX(order_purchase_timestamp) AS last_order_date,
  MIN(order_purchase_timestamp) AS first_order_date
FROM businesscase_1.orders;
```

**Result:** Orders span from **2016-09-04** to **2018-10-17**

---

### 2.2 Cities & States Coverage

```sql
SELECT
  COUNT(DISTINCT customer_city)  AS count_of_cities,
  COUNT(DISTINCT customer_state) AS count_of_state
FROM businesscase_1.customers;
```

| Metric | Value |
|--------|-------|
| Distinct Cities | 4,119 |
| Distinct States | 27 |

> **Insight:** Brazil has 5,570 total cities — meaning ~1,451 cities still have no order activity.  
> **Recommendation:** Investigate gaps via market research; deploy targeted marketing or explore new store/fulfillment locations in uncovered cities.

---

## 3. Order Trends & Seasonality

### 3.1 Year-over-Year Growth

```sql
SELECT
  EXTRACT(MONTH FROM order_purchase_timestamp) AS month,
  EXTRACT(YEAR  FROM order_purchase_timestamp) AS year,
  COUNT(*) AS total_orders
FROM `businesscase_1.orders`
GROUP BY 1, 2
ORDER BY 2, 1;
```

| Period | Orders |
|--------|--------|
| Sep 2016 | 4 |
| Mar 2018 (peak) | ~7,269 |
| Sep 2018 (anomaly) | 16 |

> **Insight:** Strong upward trend from late 2016 through mid-2018, followed by a sudden collapse in Fall 2018 — likely a data anomaly or structural shift.  
> **Recommendation:** Investigate the Sep–Oct 2018 data drop; build anomaly detection into reporting pipelines.

---

### 3.2 Monthly Seasonality

Recurring demand peaks:
- **End-of-year:** November – January
- **Mid-year:** May – August

> **Recommendation:** Align promotions and inventory planning around these seasonal peaks.

---

### 3.3 Time of Day Analysis

```sql
SELECT
  CASE
    WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN  0 AND  6 THEN 'Dawn'
    WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN  7 AND 12 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 13 AND 18 THEN 'Afternoon'
    WHEN EXTRACT(HOUR FROM order_purchase_timestamp) BETWEEN 19 AND 23 THEN 'Night'
  END AS time_of_day,
  COUNT(*) AS order_count
FROM `businesscase_1.orders`
GROUP BY 1
ORDER BY 2 DESC;
```

| Time of Day | Orders |
|-------------|--------|
| Afternoon | 38,135 |
| Night | 28,331 |
| Morning | 27,733 |
| Dawn | 5,242 |

> **Recommendation:** Run flash sales and push notifications during Afternoon and Night windows. Consider "Price Drop Hours" (midnight–6 AM) to boost Dawn orders.

---

## 4. Regional Distribution

### 4.1 Orders by State (Month-on-Month)

```sql
SELECT DISTINCT c.customer_state,
  EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month,
  COUNT(*) AS no_of_orders
FROM `businesscase_1.orders` o
JOIN `businesscase_1.customers` c ON o.customer_id = c.customer_id
GROUP BY 1, 2
ORDER BY 1, 2;
```

**Top states:** SP › RJ › MG › RS › PR › SC  
**Lowest states:** RR, SE, RO, MT, MS, MA, AP, AM, AL, AC

> **Recommendation:** Deploy region-specific marketing, voucher campaigns, and promotional events in underperforming states.

---

### 4.2 Customer Distribution by State

| State | Customers |
|-------|-----------|
| SP | ~41,750 |
| RJ | ~12,850 |
| MG | ~11,640 |
| RR | ~50 (lowest) |

---

## 5. Economic Impact

### 5.1 YoY Revenue Growth (Jan–Aug)

```sql
WITH monthly_data AS (
  SELECT
    EXTRACT(YEAR  FROM o.order_purchase_timestamp) AS year,
    EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month,
    p.payment_value
  FROM businesscase_1.payments p
  JOIN businesscase_1.orders o ON p.order_id = o.order_id
  WHERE EXTRACT(YEAR  FROM o.order_purchase_timestamp) IN (2017, 2018)
    AND EXTRACT(MONTH FROM o.order_purchase_timestamp) <= 8
),
yearly_total AS (
  SELECT year, SUM(payment_value) AS total_payment
  FROM monthly_data
  GROUP BY year
)
SELECT ROUND(
  (MAX(CASE WHEN year = 2018 THEN total_payment END) -
   MAX(CASE WHEN year = 2017 THEN total_payment END)) * 100 /
   MAX(CASE WHEN year = 2017 THEN total_payment END), 2
) AS percent_increase
FROM yearly_total;
```

**Result: +136.98% revenue growth from 2017 → 2018**

> **Recommendation:** Identify top-performing product categories from this period; apply combo/bundle strategies to move slow inventory alongside bestsellers.

---

### 5.2 Order Value by State

| State | Total Order Value | Avg Order Value |
|-------|-------------------|-----------------|
| SP | 5,998,226.90 (highest total) | 137.50 (lowest avg) |
| PB | — | 248.33 (highest avg) |

> **Recommendation:** Target PB with premium pricing; use bundling and add-on suggestions in SP to lift average order value.

---

### 5.3 Freight Value by State

**Highest total freight:** SP › RJ › MG › RS › SC › PR  
**Highest avg freight:** RR › PB › RO  
**Lowest avg freight:** SP › PR › RJ

> **Recommendation:** Use route consolidation and carrier optimization in high-avg-freight states (RR, PB, RO) to reduce costs.

---

## 6. Delivery & Freight Analysis

### 6.1 Delivery Time Calculation

```sql
SELECT
  order_id,
  DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp,    DAY) AS delivery_time,
  DATE_DIFF(order_delivered_customer_date, order_estimated_delivery_date, DAY) AS diff_estimated_delivery
FROM `businesscase_1.orders`
WHERE order_delivered_customer_date IS NOT NULL
  AND order_purchase_timestamp      IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
ORDER BY order_purchase_timestamp;
```

> **Insight:** Delivery variance ranges from **39 days early to 39 days late**.  
> **Recommendation:** Implement OTIF (On-Time In-Full) tracking; use predictive routing models to reduce variance.

---

### 6.2 Top 5 States — Avg Freight Value

| Rank | Highest Avg Freight | Lowest Avg Freight |
|------|--------------------|--------------------|
| 1 | RR (~43) | SP (~15) |
| 2 | PB (~43) | PR (~21) |
| 3 | RO (~41) | RJ (~21) |
| 4 | AC (~40) | MG (~21) |
| 5 | PI (~39) | DF (~21) |

---

### 6.3 Top 5 States — Avg Delivery Time

| Fastest (days) | Slowest (days) |
|----------------|----------------|
| SP — 7.9 | RR — 28.6 |
| MG — 11.1 | AP — 26.1 |
| PR — 11.1 | AM — 25.5 |
| DF — 12.1 | AL — 23.5 |
| SC — 14.0 | PA — 22.8 |

---

### 6.4 States with Fastest Delivery vs Estimate

States delivering **7–10 days ahead** of estimated date: **AL, MA, SE, ES, BA**

> **Recommendation:** Improve ETA prediction models with AI/ML; overly early deliveries can disrupt customer planning as much as late ones.

---

## 7. Payment Analysis

### 7.1 Payment Method Preferences (Month-on-Month)

```sql
SELECT
  EXTRACT(MONTH FROM o.order_purchase_timestamp) AS month,
  p.payment_type,
  COUNT(*) AS no_of_orders
FROM `businesscase_1.orders` o
JOIN `businesscase_1.payments` p ON o.order_id = p.order_id
GROUP BY 1, 2
ORDER BY 1;
```

**Order of preference:** Credit Card › UPI › Voucher › Debit Card › Other

> **Recommendation:** Promote tokenized "Click to Pay" and digital wallets; implement AI fraud detection for high-volume credit card and UPI transactions.

---

### 7.2 Payment Installment Distribution

```sql
SELECT
  payment_installments,
  COUNT(order_id) AS num_of_orders
FROM `businesscase_1.payments`
WHERE payment_installments >= 1
GROUP BY 1
ORDER BY 1;
```

| Installments | Orders |
|---|---|
| 1 | 52,546 |
| 2 | 12,413 |
| 3 | 10,461 |
| 4 | 7,098 |
| 10+ | drops sharply |

> **Recommendation:** Promote 2–3 installment BNPL options; offer zero-interest installments on high-ticket items to drive upsell without extending payment cycles.

---

## 8. Key Takeaways

| Area | Finding |
|------|---------|
| 📦 Orders | Strong growth trend 2016–2018; anomalous drop in Fall 2018 needs investigation |
| 🕐 Peak hours | Afternoon (38K orders) is the highest-demand window |
| 🗺️ Geography | SP dominates; 1,451 cities have zero coverage |
| 💰 Revenue | 137% YoY growth (Jan–Aug 2017 vs 2018) |
| 🚚 Delivery | SP, MG, PR are fastest; RR, AP, AM are slowest |
| 💳 Payments | Credit card is dominant; 1-installment preferred by most |

---

## 🛠️ Tools & Technologies

![BigQuery](https://img.shields.io/badge/Google_BigQuery-4285F4?style=for-the-badge&logo=googlebigquery&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-336791?style=for-the-badge&logo=postgresql&logoColor=white)

- **Platform:** Google BigQuery
- **Language:** Standard SQL
- **Techniques:** CTEs, Window Functions (`RANK() OVER`), Date functions (`DATE_DIFF`, `EXTRACT`), Aggregations, Multi-table JOINs

---

*Project by Mahek | Data Analysis Case Study*
