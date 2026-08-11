-- ============================================================
-- PROJECT 2: CUSTOMER BEHAVIOR ANALYSIS USING SQL
-- File: 01_schema.sql
-- Purpose: Well-structured schema with proper indexing/normalization
--          to study customer transactions and engagement behavior
-- ============================================================

DROP TABLE IF EXISTS interactions;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS customers;

-- Customers table
CREATE TABLE customers (
    customer_id   INTEGER PRIMARY KEY,
    customer_name TEXT NOT NULL,
    email         TEXT UNIQUE NOT NULL,
    city          TEXT,
    signup_date   DATE NOT NULL
);

-- Transactions table (purchase behavior)
CREATE TABLE transactions (
    transaction_id   INTEGER PRIMARY KEY,
    customer_id       INTEGER NOT NULL,
    transaction_date  DATE NOT NULL,
    amount             DECIMAL(10,2) NOT NULL,
    product_category   TEXT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Interactions table (engagement behavior: website visits, app opens, emails, etc.)
CREATE TABLE interactions (
    interaction_id   INTEGER PRIMARY KEY,
    customer_id       INTEGER NOT NULL,
    interaction_date  DATE NOT NULL,
    channel            TEXT NOT NULL CHECK (channel IN ('Website Visit','App Open','Email Click','Ad Click','Support Chat')),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Indexes for normalized, query-friendly structure
CREATE INDEX idx_transactions_customer ON transactions(customer_id);
CREATE INDEX idx_transactions_date ON transactions(transaction_date);
CREATE INDEX idx_interactions_customer ON interactions(customer_id);
CREATE INDEX idx_interactions_date ON interactions(interaction_date);
