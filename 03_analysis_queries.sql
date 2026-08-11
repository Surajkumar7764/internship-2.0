-- ============================================================
-- PROJECT 4: BANKING TRANSACTION ANALYSIS USING SQL
-- File: 03_analysis_queries.sql
-- Purpose: Detect unusual spending patterns and financial risk
--          using window functions (LAG, LEAD)
-- ============================================================

-- ------------------------------------------------------------
-- Q1. UNUSUAL SPENDING SPIKES (using LAG)
-- Flags a debit transaction as a spike if it is more than
-- 5x the customer's previous debit transaction amount.
-- ------------------------------------------------------------
WITH debit_txns AS (
    SELECT
        transaction_id,
        account_id,
        transaction_date,
        amount,
        LAG(amount) OVER (PARTITION BY account_id ORDER BY transaction_date, transaction_id) AS prev_amount
    FROM transactions
    WHERE transaction_type = 'Debit'
)
SELECT
    transaction_id,
    account_id,
    transaction_date,
    amount,
    prev_amount,
    ROUND(amount / NULLIF(prev_amount, 0), 2) AS spike_ratio
FROM debit_txns
WHERE prev_amount IS NOT NULL
  AND amount > prev_amount * 5
ORDER BY spike_ratio DESC;


-- ------------------------------------------------------------
-- Q2. HIGH-VALUE TRANSACTIONS (above ₹75,000)
-- ------------------------------------------------------------
SELECT
    t.transaction_id,
    c.customer_name,
    t.account_id,
    t.transaction_date,
    t.amount,
    t.transaction_type,
    t.description
FROM transactions t
JOIN accounts a ON a.account_id = t.account_id
JOIN customers c ON c.customer_id = a.customer_id
WHERE t.amount > 75000
ORDER BY t.amount DESC;


-- ------------------------------------------------------------
-- Q3. RAPID SUCCESSIVE HIGH-VALUE TRANSACTIONS (using LEAD)
-- Flags cases where two large debits (>10,000) happen on the
-- SAME account within 2 days of each other - a common fraud pattern.
-- ------------------------------------------------------------
WITH ordered_debits AS (
    SELECT
        transaction_id,
        account_id,
        transaction_date,
        amount,
        LEAD(transaction_date) OVER (PARTITION BY account_id ORDER BY transaction_date, transaction_id) AS next_date,
        LEAD(amount) OVER (PARTITION BY account_id ORDER BY transaction_date, transaction_id) AS next_amount
    FROM transactions
    WHERE transaction_type = 'Debit' AND amount > 10000
)
SELECT
    account_id,
    transaction_date AS txn1_date,
    amount AS txn1_amount,
    next_date AS txn2_date,
    next_amount AS txn2_amount,
    CAST(julianday(next_date) - julianday(transaction_date) AS INTEGER) AS days_apart
FROM ordered_debits
WHERE next_date IS NOT NULL
  AND julianday(next_date) - julianday(transaction_date) <= 2
ORDER BY account_id, transaction_date;


-- ------------------------------------------------------------
-- Q4. LOAN DEFAULT RATE
-- ------------------------------------------------------------
SELECT
    COUNT(*) AS total_loans,
    SUM(CASE WHEN status = 'Default' THEN 1 ELSE 0 END) AS defaulted_loans,
    ROUND(100.0 * SUM(CASE WHEN status = 'Default' THEN 1 ELSE 0 END) / COUNT(*), 2) AS default_rate_percent,
    ROUND(SUM(CASE WHEN status = 'Default' THEN loan_amount ELSE 0 END), 2) AS total_amount_at_risk
FROM loans;


-- ------------------------------------------------------------
-- Q5. LOAN RISK CATEGORIZATION PER CUSTOMER
-- ------------------------------------------------------------
SELECT
    c.customer_name,
    COUNT(l.loan_id) AS total_loans,
    ROUND(SUM(l.loan_amount), 2) AS total_loan_amount,
    SUM(CASE WHEN l.status = 'Default' THEN 1 ELSE 0 END) AS defaults,
    CASE
        WHEN SUM(CASE WHEN l.status = 'Default' THEN 1 ELSE 0 END) > 0 THEN 'High Risk'
        WHEN SUM(l.loan_amount) > 800000 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_level
FROM customers c
JOIN loans l ON l.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY defaults DESC, total_loan_amount DESC;


-- ------------------------------------------------------------
-- Q6. MONTHLY DEBIT vs CREDIT SUMMARY (cash flow monitoring)
-- ------------------------------------------------------------
SELECT
    strftime('%Y-%m', transaction_date) AS month,
    ROUND(SUM(CASE WHEN transaction_type = 'Credit' THEN amount ELSE 0 END), 2) AS total_credit,
    ROUND(SUM(CASE WHEN transaction_type = 'Debit' THEN amount ELSE 0 END), 2) AS total_debit,
    ROUND(SUM(CASE WHEN transaction_type = 'Credit' THEN amount ELSE -amount END), 2) AS net_flow
FROM transactions
GROUP BY month
ORDER BY month;


-- ------------------------------------------------------------
-- Q7. SUSPICIOUS TRANSACTION SUMMARY REPORT
-- (Combines high value + rapid succession flags into one risk view)
-- ------------------------------------------------------------
SELECT
    a.account_id,
    c.customer_name,
    COUNT(t.transaction_id) AS high_value_txn_count,
    ROUND(SUM(t.amount), 2) AS total_high_value_amount,
    CASE
        WHEN COUNT(t.transaction_id) >= 3 THEN 'High Risk Account'
        WHEN COUNT(t.transaction_id) >= 1 THEN 'Watchlist'
        ELSE 'Normal'
    END AS risk_flag
FROM accounts a
JOIN customers c ON c.customer_id = a.customer_id
JOIN transactions t ON t.account_id = a.account_id AND t.amount > 75000
GROUP BY a.account_id
ORDER BY high_value_txn_count DESC, total_high_value_amount DESC;
