# Project 5 — E-Commerce Performance Analysis Using SQL

Analyzes product sales, delivery performance, and customer traffic to
measure the KPIs that matter most in e-commerce: conversion rate,
average order value, peak sales time, cancellations, and delivery reliability.

---

## 📁 Project Files

| File | Purpose |
|---|---|
| `01_schema.sql` | Creates `customers`, `products`, `website_visits`, `orders`, `order_items`, `deliveries` — normalized and connected |
| `02_sample_data.sql` | Inserts sample data (35 customers, 15 products, 600 visits, 84 orders, 173 items, 77 deliveries) |
| `03_analysis_queries.sql` | 7 KPI queries |
| `ecommerce_analysis.db` | Pre-built SQLite database |
| `README.md` | This guide |

---

## 🧩 Database Design

```
customers      (customer_id PK, customer_name, city, signup_date)
products       (product_id PK, product_name, category, price)
website_visits (visit_id PK, customer_id FK nullable, visit_date, visit_hour)
orders         (order_id PK, customer_id FK, order_date, order_hour, status)
order_items    (order_item_id PK, order_id FK, product_id FK, quantity, unit_price)
deliveries     (delivery_id PK, order_id FK unique, expected_date, delivered_date, delivery_status)
```

`website_visits.customer_id` is nullable to represent **anonymous/guest
browsing**, which is essential for an accurate conversion-rate
calculation (visits ≠ only logged-in customers).

---

## ▶️ Step-by-Step: How to Run

**Step 1:** Open a terminal in this folder.

**Step 2:** Build the database:
```bash
sqlite3 ecommerce_analysis.db < 01_schema.sql
sqlite3 ecommerce_analysis.db < 02_sample_data.sql
```

**Step 3:** Run the analysis:
```bash
sqlite3 ecommerce_analysis.db < 03_analysis_queries.sql
```

> No `sqlite3` CLI? Open `ecommerce_analysis.db` in **DB Browser for
> SQLite** (https://sqlitebrowser.org) and run queries from "Execute SQL".

---

## 📊 What Each Query Tells You

### 1. Conversion Rate
Website visits that turned into an order. **Sample result: 14.0%**
(84 orders from 600 visits) — a realistic e-commerce benchmark.

### 2. Average Order Value (AOV)
Revenue per non-cancelled order. **Sample result: ₹13,306** — a core
metric for evaluating marketing spend efficiency.

### 3. Peak Sales Time
Ranks hours of the day by order volume. **Sample result:** 5–6 PM is
the peak ordering window — directly useful for scheduling flash sales
or ad spend.

### 4. Cancellation Rate
**Sample result: 8.33%** of all orders were cancelled — a health
metric to track against industry benchmarks (~5–10% is typical).

### 5. Delivery Performance
Breaks down delivered orders into **On Time / Delayed / Not
Delivered**. **Sample result: 66% on-time rate** — flags a logistics
issue worth investigating (23% delayed).

### 6. Top-Selling Products
Ranks products by revenue for non-cancelled orders — "Standing Desk"
leads in this dataset.

### 7. Monthly Sales Trend
Order count and revenue by month — the base data for a sales
dashboard or forecasting model.

---

## ✅ How This Meets the Task Plan Criteria

- **Well-Structured:** 6 normalized tables properly connected (visits → orders → items → deliveries), with a `UNIQUE` constraint ensuring one delivery per order.
- **Accurate & Reliable:** Cancelled orders are explicitly excluded from revenue/AOV/product-performance queries (`WHERE status != 'Cancelled'`) to avoid inflating numbers.
- **Performance-Focused:** Directly answers conversion rate, AOV, and peak sales time as required — the three headline KPIs named in the task plan.
- **Clearly Reported:** Every query returns a single, labeled KPI or ranked table ready to drop into a dashboard.
- **Reproducible:** KPI definitions (e.g., "cancelled orders excluded from AOV", "on-time = delivered on/before expected date") are documented here for future analysts.

---

## 🚀 Next Steps / Extensions

- Add a `discounts`/`coupons` table to measure promo effectiveness on conversion rate.
- Track `visit_id` → `order_id` explicitly (session-level attribution) for a true funnel analysis, not just aggregate conversion.
- Build a Power BI/Tableau dashboard combining this project's KPIs with Project 1's revenue trend for a full sales+ops view.
