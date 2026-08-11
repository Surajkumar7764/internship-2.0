-- ============================================================
-- PROJECT 1: SALES DATA ANALYSIS USING SQL
-- File: 03_analysis_queries.sql
-- Purpose: Answer key business questions
--   1. Monthly revenue trend
--   2. Top-selling products
--   3. Repeat customers
--   4. Profit margins by category
--   5. Customer lifetime value (bonus)
-- ============================================================

-- ------------------------------------------------------------
-- Q1. MONTHLY REVENUE TREND
-- (Revenue = amount actually paid, only completed/paid orders)
-- ------------------------------------------------------------
SELECT
    strftime('%Y-%m', payment_date) AS month,
    ROUND(SUM(amount), 2) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders
FROM payments
GROUP BY month
ORDER BY month;


-- ------------------------------------------------------------
-- Q2. TOP-SELLING PRODUCTS (by revenue and by quantity)
-- ------------------------------------------------------------
SELECT
    p.product_name,
    p.category,
    SUM(oi.quantity) AS total_quantity_sold,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY p.product_id
ORDER BY total_revenue DESC
LIMIT 5;


-- ------------------------------------------------------------
-- Q3. REPEAT CUSTOMERS
-- (Customers who placed more than one completed order)
-- ------------------------------------------------------------
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(pay.amount), 2) AS total_spent
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN payments pay ON pay.order_id = o.order_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id
HAVING COUNT(o.order_id) > 1
ORDER BY total_orders DESC, total_spent DESC;


-- ------------------------------------------------------------
-- Q4. PROFIT MARGIN BY CATEGORY
-- (Profit = (price - cost) * quantity sold)
-- ------------------------------------------------------------
SELECT
    p.category,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue,
    ROUND(SUM(oi.quantity * p.cost), 2) AS total_cost,
    ROUND(SUM(oi.quantity * (oi.unit_price - p.cost)), 2) AS total_profit,
    ROUND(
        100.0 * SUM(oi.quantity * (oi.unit_price - p.cost)) / SUM(oi.quantity * oi.unit_price), 2
    ) AS profit_margin_percent
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY p.category
ORDER BY total_profit DESC;


-- ------------------------------------------------------------
-- Q5 (BONUS). CUSTOMER SEGMENTATION BY TOTAL SPEND
-- (High / Medium / Low value customers)
-- ------------------------------------------------------------
SELECT
    c.customer_id,
    c.customer_name,
    ROUND(SUM(pay.amount), 2) AS total_spent,
    CASE
        WHEN SUM(pay.amount) >= 15000 THEN 'High Value'
        WHEN SUM(pay.amount) >= 7000  THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN payments pay ON pay.order_id = o.order_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id
ORDER BY total_spent DESC;


-- ------------------------------------------------------------
-- Q6 (BONUS). ORDER STATUS BREAKDOWN (data quality check)
-- ------------------------------------------------------------
SELECT
    status,
    COUNT(*) AS num_orders,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM orders), 2) AS percent_of_total
FROM orders
GROUP BY status;
