# Project 1 — Sales Data Analysis Using SQL

A complete, ready-to-run SQL project analyzing sales data (customers, products,
orders, order items, payments) to extract business insights: revenue trends,
top-selling products, repeat customers, and profit margins.

This matches CodeVedX's Task Plan requirements: **well-structured, accurate
and reliable, insight-focused, clearly reported, and reproducible.**

---

## 📁 Project Files

| File | Purpose |
|---|---|
| `01_schema.sql` | Creates the 5 tables (customers, products, orders, order_items, payments) with primary/foreign keys and indexes |
| `02_sample_data.sql` | Inserts realistic sample data (30 customers, 15 products, 66 orders, 161 order items, 60 payments) |
| `03_analysis_queries.sql` | 6 SQL queries answering the key business questions |
| `sales_analysis.db` | Pre-built SQLite database (ready to query immediately) |
| `README.md` | This guide |

---

## 🧩 Database Design (Schema)

```
customers (customer_id PK, customer_name, email, city, signup_date)
products  (product_id PK, product_name, category, price, cost)
orders    (order_id PK, customer_id FK, order_date, status)
order_items (order_item_id PK, order_id FK, product_id FK, quantity, unit_price)
payments  (payment_id PK, order_id FK, payment_date, amount, payment_method)
```

**Relationships:**
- One customer → many orders
- One order → many order_items (many-to-many between orders & products)
- One order → one payment (if not cancelled)

This normalized structure avoids duplicate/incorrect data and supports
accurate joins for analysis.

---

## ▶️ Step-by-Step: How to Run This Project

### Option A — Using SQLite (easiest, no installation needed on most systems)

**Step 1: Open a terminal in the project folder.**

**Step 2: Build the database from scratch (or just use the included `sales_analysis.db`).**
```bash
sqlite3 sales_analysis.db < 01_schema.sql
sqlite3 sales_analysis.db < 02_sample_data.sql
```

**Step 3: Run the analysis queries.**
```bash
sqlite3 sales_analysis.db < 03_analysis_queries.sql
```
Or open it interactively:
```bash
sqlite3 sales_analysis.db
sqlite> .headers on
sqlite> .mode column
sqlite> -- paste any query from 03_analysis_queries.sql
```

> If `sqlite3` isn't installed: download the free **DB Browser for SQLite**
> (https://sqlitebrowser.org), open `sales_analysis.db`, and run queries in
> its "Execute SQL" tab.

### Option B — Using MySQL / PostgreSQL

1. Create a new database, e.g. `CREATE DATABASE sales_db;`
2. Minor syntax tweaks needed:
   - Replace `INTEGER PRIMARY KEY` → `INT AUTO_INCREMENT PRIMARY KEY` (MySQL) or `SERIAL PRIMARY KEY` (PostgreSQL)
   - Replace `strftime('%Y-%m', payment_date)` → `DATE_FORMAT(payment_date, '%Y-%m')` (MySQL) or `TO_CHAR(payment_date, 'YYYY-MM')` (PostgreSQL)
3. Run `01_schema.sql`, then `02_sample_data.sql`, then `03_analysis_queries.sql`.

### Option C — Import into Excel / Google Sheets for dashboards
Export any query result as CSV (`.mode csv` then `.output result.csv` in sqlite3)
and build pivot tables/charts on top for the "Clearly Reported" requirement.

---

## 📊 Business Questions Answered

### 1. Monthly Revenue Trend
Tracks total revenue and order count per month (based on actual payments received).
```sql
SELECT strftime('%Y-%m', payment_date) AS month,
       ROUND(SUM(amount), 2) AS total_revenue,
       COUNT(DISTINCT order_id) AS total_orders
FROM payments
GROUP BY month
ORDER BY month;
```
**Sample result (from included data):** Revenue ranged from ~₹12K to ~₹197K
across months, with August 2025 being the highest revenue month.

### 2. Top-Selling Products
Ranks products by revenue for completed orders only.
```sql
SELECT p.product_name, p.category,
       SUM(oi.quantity) AS total_quantity_sold,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY p.product_id
ORDER BY total_revenue DESC
LIMIT 5;
```
**Sample result:** "Standing Desk" is the top revenue-generating product
(~₹3.45L), followed by "Monitor 24-inch" and "External SSD 1TB".

### 3. Repeat Customers
Identifies customers with more than one completed order — key for retention analysis.
```sql
SELECT c.customer_id, c.customer_name,
       COUNT(o.order_id) AS total_orders,
       ROUND(SUM(pay.amount), 2) AS total_spent
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN payments pay ON pay.order_id = o.order_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id
HAVING COUNT(o.order_id) > 1
ORDER BY total_orders DESC, total_spent DESC;
```

### 4. Profit Margin by Category
Compares revenue, cost, and profit margin % across product categories.
```sql
SELECT p.category,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue,
       ROUND(SUM(oi.quantity * p.cost), 2) AS total_cost,
       ROUND(SUM(oi.quantity * (oi.unit_price - p.cost)), 2) AS total_profit,
       ROUND(100.0 * SUM(oi.quantity * (oi.unit_price - p.cost))
             / SUM(oi.quantity * oi.unit_price), 2) AS profit_margin_percent
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY p.category
ORDER BY total_profit DESC;
```
**Sample result:** Stationery has the highest margin % (~59%), while
Electronics generates the most absolute profit.

### 5. Bonus — Customer Segmentation
Buckets customers into High/Medium/Low value based on total spend — useful
for targeted marketing.

### 6. Bonus — Order Status Breakdown
Data-quality check: what % of orders are Completed vs Cancelled vs Pending.

---

## ✅ How This Meets the Task Plan Criteria

- **Well-Structured:** Proper primary/foreign keys, normalized 5-table schema.
- **Accurate & Reliable:** Only `status = 'Completed'` orders counted in revenue/profit queries to avoid inflating numbers with cancelled orders; joins tested and verified.
- **Insight-Focused:** Directly answers revenue trends, top products, repeat customers, and profit margins as required.
- **Clearly Reported:** Every query has a clear title, purpose, and can be exported to CSV/Excel for dashboards.
- **Reproducible:** All schema, data, and queries are provided as plain `.sql` files — anyone can rebuild the exact same database from scratch.

---

## 🚀 Next Steps / Extensions

- Add a `refunds` table and adjust profit calculations.
- Build a dashboard in Excel/Power BI/Tableau on top of the CSV exports.
- Add window functions (`RANK()`, `LAG()`) for month-over-month growth %.
- Move to Project 2 (Customer Behavior Analysis) using the same schema pattern.
