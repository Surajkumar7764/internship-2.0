-- ============================================================
-- PROJECT 4: BANKING TRANSACTION ANALYSIS USING SQL
-- File: 01_schema.sql
-- Purpose: Account/customer/transaction tables with referential
--          integrity, to detect unusual patterns and financial risk
-- ============================================================

DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS customers;

-- Customers table
CREATE TABLE customers (
    customer_id   INTEGER PRIMARY KEY,
    customer_name TEXT NOT NULL,
    city          TEXT,
    join_date     DATE NOT NULL
);

-- Accounts table
CREATE TABLE accounts (
    account_id     INTEGER PRIMARY KEY,
    customer_id     INTEGER NOT NULL,
    account_type     TEXT NOT NULL CHECK (account_type IN ('Savings','Current','Salary')),
    open_date         DATE NOT NULL,
    balance            DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Transactions table
CREATE TABLE transactions (
    transaction_id    INTEGER PRIMARY KEY,
    account_id          INTEGER NOT NULL,
    transaction_date     DATE NOT NULL,
    amount                 DECIMAL(12,2) NOT NULL,
    transaction_type       TEXT NOT NULL CHECK (transaction_type IN ('Credit','Debit')),
    description             TEXT,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

-- Loans table
CREATE TABLE loans (
    loan_id            INTEGER PRIMARY KEY,
    customer_id          INTEGER NOT NULL,
    loan_amount            DECIMAL(12,2) NOT NULL,
    status                   TEXT NOT NULL CHECK (status IN ('Active','Paid','Default')),
    disbursement_date         DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE INDEX idx_accounts_customer ON accounts(customer_id);
CREATE INDEX idx_transactions_account ON transactions(account_id);
CREATE INDEX idx_transactions_date ON transactions(transaction_date);
CREATE INDEX idx_loans_customer ON loans(customer_id);
