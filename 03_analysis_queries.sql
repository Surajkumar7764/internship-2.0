-- ============================================================
-- PROJECT 5: E-COMMERCE PERFORMANCE ANALYSIS USING SQL
-- File: 03_analysis_queries.sql
-- Purpose: Conversion rate, AOV, peak sales time, cancellation
--          rate, and delivery performance KPIs
-- ============================================================

-- ------------------------------------------------------------
-- Q1. CONVERSION RATE (website visits -> orders placed)
-- ------------------------------------------------------------
SELECT
    (SELECT COUNT(*) FROM website_visits) AS total_visits,
    (SELECT COUNT(*) FROM orders) AS total_orders,
    ROUND(100.0 * (SELECT COUNT(*) FROM orders) / (SELECT COUNT(*) FROM website_visits), 2) AS conversion_rate_percent;


-- ------------------------------------------------------------
-- Q2. AVERAGE ORDER VALUE (AOV)
-- ------------------------------------------------------------
SELECT
    ROUND(SUM(oi.quantity * oi.unit_price) * 1.0 / COUNT(DISTINCT o.order_id), 2) AS average_order_value
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status != 'Cancelled';


-- ------------------------------------------------------------
-- Q3. PEAK SALES TIME (by hour of day)
-- ------------------------------------------------------------
SELECT
    order_hour,
    COUNT(*) AS num_orders
FROM orders
WHERE status != 'Cancelled'
GROUP BY order_hour
ORDER BY num_orders DESC
LIMIT 5;


-- ------------------------------------------------------------
-- Q4. CANCELLATION RATE
-- ------------------------------------------------------------
SELECT
    COUNT(*) AS total_orders,
    SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_orders,
    ROUND(100.0 * SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) / COUNT(*), 2) AS cancellation_rate_percent
FROM orders;


-- ------------------------------------------------------------
-- Q5. DELIVERY PERFORMANCE (on-time %)
-- ------------------------------------------------------------
SELECT
    delivery_status,
    COUNT(*) AS num_deliveries,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM deliveries), 2) AS percent_of_deliveries
FROM deliveries
GROUP BY delivery_status
ORDER BY num_deliveries DESC;


-- ------------------------------------------------------------
-- Q6. TOP-SELLING PRODUCTS & CATEGORY REVENUE
-- ------------------------------------------------------------
SELECT
    p.product_name,
    p.category,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status != 'Cancelled'
GROUP BY p.product_id
ORDER BY revenue DESC
LIMIT 5;


-- ------------------------------------------------------------
-- Q7. MONTHLY SALES PERFORMANCE TREND
-- ------------------------------------------------------------
SELECT
    strftime('%Y-%m', o.order_date) AS month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status != 'Cancelled'
GROUP BY month
ORDER BY month;
