-- ============================================================
-- PROJECT 2: CUSTOMER BEHAVIOR ANALYSIS USING SQL
-- File: 03_analysis_queries.sql
-- Purpose: RFM segmentation, CLV, churn detection, engagement patterns
-- "Today" reference date used for recency calculations: 2026-08-07
-- ============================================================

-- ------------------------------------------------------------
-- Q1. RECENCY, FREQUENCY, MONETARY (RFM) PER CUSTOMER
-- ------------------------------------------------------------
SELECT
    c.customer_id,
    c.customer_name,
    CAST(julianday('2026-08-07') - julianday(MAX(t.transaction_date)) AS INTEGER) AS recency_days,
    COUNT(t.transaction_id) AS frequency,
    ROUND(SUM(t.amount), 2) AS monetary_value
FROM customers c
JOIN transactions t ON t.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY monetary_value DESC;


-- ------------------------------------------------------------
-- Q2. RFM SEGMENTATION
-- (Simple rule-based scoring: label each customer as
--  Champion / Loyal / At Risk / Lost based on recency & frequency)
-- ------------------------------------------------------------
WITH rfm AS (
    SELECT
        c.customer_id,
        c.customer_name,
        CAST(julianday('2026-08-07') - julianday(MAX(t.transaction_date)) AS INTEGER) AS recency_days,
        COUNT(t.transaction_id) AS frequency,
        ROUND(SUM(t.amount), 2) AS monetary_value
    FROM customers c
    JOIN transactions t ON t.customer_id = c.customer_id
    GROUP BY c.customer_id
)
SELECT
    customer_id,
    customer_name,
    recency_days,
    frequency,
    monetary_value,
    CASE
        WHEN recency_days <= 240 AND frequency >= 6 THEN 'Champion'
        WHEN recency_days <= 400 AND frequency >= 3 THEN 'Loyal'
        WHEN recency_days > 400 AND frequency >= 3 THEN 'At Risk'
        WHEN recency_days > 400 AND frequency < 3  THEN 'Lost / Churned'
        ELSE 'New / Occasional'
    END AS rfm_segment
FROM rfm
ORDER BY monetary_value DESC;


-- ------------------------------------------------------------
-- Q3. CUSTOMER LIFETIME VALUE (CLV)
-- (Total spend + average order value + tenure in days)
-- ------------------------------------------------------------
SELECT
    c.customer_id,
    c.customer_name,
    c.signup_date,
    COUNT(t.transaction_id) AS total_orders,
    ROUND(SUM(t.amount), 2) AS total_spent,
    ROUND(AVG(t.amount), 2) AS avg_order_value,
    CAST(julianday('2026-08-07') - julianday(c.signup_date) AS INTEGER) AS customer_age_days,
    ROUND(SUM(t.amount) * 1.0 /
          ((julianday('2026-08-07') - julianday(c.signup_date)) / 365.0), 2) AS estimated_annual_clv
FROM customers c
JOIN transactions t ON t.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 10;


-- ------------------------------------------------------------
-- Q4. CHURN ANALYSIS
-- (Customers with no transaction in the last 300 days = churn risk)
-- ------------------------------------------------------------
SELECT
    c.customer_id,
    c.customer_name,
    MAX(t.transaction_date) AS last_purchase_date,
    CAST(julianday('2026-08-07') - julianday(MAX(t.transaction_date)) AS INTEGER) AS days_since_last_purchase,
    CASE
        WHEN CAST(julianday('2026-08-07') - julianday(MAX(t.transaction_date)) AS INTEGER) > 300
        THEN 'Churn Risk'
        ELSE 'Active'
    END AS churn_status
FROM customers c
JOIN transactions t ON t.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY days_since_last_purchase DESC;


-- ------------------------------------------------------------
-- Q5. ENGAGEMENT / BEHAVIORAL PATTERNS
-- (Most-used interaction channels, overall engagement level)
-- ------------------------------------------------------------
SELECT
    channel,
    COUNT(*) AS total_interactions,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM interactions
GROUP BY channel
ORDER BY total_interactions DESC;


-- ------------------------------------------------------------
-- Q6. HIGH-ENGAGEMENT vs LOW-ENGAGEMENT CUSTOMERS
-- (based on total interaction count)
-- ------------------------------------------------------------
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(i.interaction_id) AS total_interactions,
    CASE
        WHEN COUNT(i.interaction_id) >= 15 THEN 'High Engagement'
        WHEN COUNT(i.interaction_id) >= 6  THEN 'Medium Engagement'
        ELSE 'Low Engagement'
    END AS engagement_level
FROM customers c
LEFT JOIN interactions i ON i.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY total_interactions DESC;


-- ------------------------------------------------------------
-- Q7. REPEAT PURCHASE RATE (overall business metric)
-- ------------------------------------------------------------
SELECT
    ROUND(100.0 * SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS repeat_purchase_rate_percent
FROM (
    SELECT customer_id, COUNT(*) AS order_count
    FROM transactions
    GROUP BY customer_id
);
