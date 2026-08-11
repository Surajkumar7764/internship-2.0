# Project 4 — Banking Transaction Analysis Using SQL

Monitors account transaction data to detect unusual spending patterns,
high-value transactions, and loan default risk — using SQL **window
functions (LAG, LEAD)** as required for accurate pattern detection.

---

## 📁 Project Files

| File | Purpose |
|---|---|
| `01_schema.sql` | Creates `customers`, `accounts`, `transactions`, `loans` with referential integrity |
| `02_sample_data.sql` | Inserts sample data (25 customers, 33 accounts, 817 transactions, 11 loans) |
| `03_analysis_queries.sql` | 7 queries: spike detection, high-value txns, rapid succession fraud pattern, loan risk |
| `banking_analysis.db` | Pre-built SQLite database |
| `README.md` | This guide |

---

## 🧩 Database Design

```
customers    (customer_id PK, customer_name, city, join_date)
accounts     (account_id PK, customer_id FK, account_type, open_date, balance)
transactions (transaction_id PK, account_id FK, transaction_date, amount, transaction_type, description)
loans        (loan_id PK, customer_id FK, loan_amount, status, disbursement_date)
```

Referential integrity: every account belongs to a customer, every
transaction belongs to an account, every loan belongs to a customer —
no orphaned records.

---

## ▶️ Step-by-Step: How to Run

**Step 1:** Open a terminal in this folder.

**Step 2:** Build the database:
```bash
sqlite3 banking_analysis.db < 01_schema.sql
sqlite3 banking_analysis.db < 02_sample_data.sql
```

**Step 3:** Run the analysis:
```bash
sqlite3 banking_analysis.db < 03_analysis_queries.sql
```

> No `sqlite3` CLI? Open `banking_analysis.db` in **DB Browser for
> SQLite** (https://sqlitebrowser.org) and run queries from "Execute SQL".
> Note: window functions (`LAG`/`LEAD`) need SQLite 3.25+ / any modern
> MySQL 8+ or PostgreSQL — all standard in recent installs.

---

## 📊 What Each Query Tells You

### 1. Unusual Spending Spikes (`LAG`)
Compares each debit to the **same account's previous debit** using
`LAG()`. Flags any transaction that's more than 5x the prior one.
**Sample result:** 58 spike transactions detected, the largest a
₹2.7L transfer that was 385x the account's previous debit.

### 2. High-Value Transactions
Every transaction above ₹75,000 — a standard AML/compliance threshold
starting point.

### 3. Rapid Succession High-Value Transactions (`LEAD`)
Uses `LEAD()` to check if **two large debits (>₹10,000) happen within
2 days on the same account** — a classic structuring/fraud pattern.
**Sample result:** 11 such pairs found, including two transactions on
the very same day for one account.

### 4. Loan Default Rate
Headline risk KPI. **Sample result:** 18.18% default rate, ~₹18L at risk.

### 5. Loan Risk Categorization
Labels each borrowing customer **High / Medium / Low Risk** based on
default history and total exposure — ready for a risk dashboard.

### 6. Monthly Debit vs Credit Summary
Net cash flow per month — useful for liquidity monitoring at the bank level.

### 7. Suspicious Transaction Summary Report
Rolls up high-value activity per account into a **Watchlist / High Risk
Account / Normal** flag — the "clearly reported" risk summary required
by the task plan.

---

## ✅ How This Meets the Task Plan Criteria

- **Well-Structured:** 4 tables with full referential integrity (FKs on every child table).
- **Accurate & Reliable:** `LAG`/`LEAD` window functions used correctly, partitioned by `account_id` and ordered by date — avoids comparing transactions across different accounts.
- **Risk-Focused:** Every query outputs a risk signal — spike ratio, high-value flag, default status, or risk level.
- **Clearly Reported:** Query 7 consolidates raw transaction flags into a single per-account risk label.
- **Reproducible:** Spike threshold (5x), high-value threshold (₹75,000), and rapid-succession window (2 days) are all documented and easy to tune.

---

## 🚀 Next Steps / Extensions

- Add a `flagged_transactions` audit table that logs which rule caught each case.
- Layer in a rolling 30-day average spend per account (window function `AVG() OVER`) for smarter anomaly detection than simple prior-transaction comparison.
- Connect to a real-time alerting system for the "High Risk Account" segment.
