# Project 3 — HR Analytics Using SQL

Analyzes employee data across departments to understand attrition trends,
salary distribution (including pay-gap checks), and workforce performance —
built to guide real HR decisions.

---

## 📁 Project Files

| File | Purpose |
|---|---|
| `01_schema.sql` | Creates `departments` and `employees` tables linked by relational key |
| `02_sample_data.sql` | Inserts sample data (8 departments, 142 employees) |
| `03_analysis_queries.sql` | 7 queries: attrition, salary, pay gap, performance, tenure |
| `hr_analytics.db` | Pre-built SQLite database |
| `README.md` | This guide |

---

## 🧩 Database Design

```
departments (department_id PK, department_name)
employees   (employee_id PK, employee_name, department_id FK, gender,
             salary, hire_date, status, resignation_date, performance_rating)
```

`status` is `'Active'` or `'Resigned'`; `resignation_date` is `NULL` for
active employees. `performance_rating` is on a 1–5 scale.

---

## ▶️ Step-by-Step: How to Run

**Step 1:** Open a terminal in this folder.

**Step 2:** Build the database:
```bash
sqlite3 hr_analytics.db < 01_schema.sql
sqlite3 hr_analytics.db < 02_sample_data.sql
```

**Step 3:** Run the analysis:
```bash
sqlite3 hr_analytics.db < 03_analysis_queries.sql
```

> No `sqlite3` CLI? Open `hr_analytics.db` in **DB Browser for SQLite**
> (https://sqlitebrowser.org) and run queries from the "Execute SQL" tab.

---

## 📊 What Each Query Tells You

### 1. Attrition Rate by Department
**Sample result:** Sales has the highest attrition (~44%), notably above
Engineering (~26%) and Customer Support (~24%).

### 2. Average Salary by Department
Ranks departments by average active-employee salary — Product and
Engineering pay the highest in this dataset.

### 3. Gender Pay Gap by Department
Compares average male vs. female salary per department. **Sample result:**
Engineering shows the widest gap (~₹23K), while Product is essentially
balanced (slightly favoring female average) — a useful audit table for HR.

### 4. Top Performers
Lists active employees rated 4 or 5, sorted by rating then salary — a
quick retention-priority / promotion-candidate list.

### 5. Average Tenure by Department
Calculates average years of service (using resignation date for
ex-employees, today's date for active ones) — Product employees stay
longest on average in this dataset (~3.1 years).

### 6. Performance Rating Distribution
A workforce-quality snapshot: what % of employees fall into each rating
bucket (this dataset: ~13% rated 5, ~38% rated 4).

### 7. High-Attrition Departments Flagged for Review
Automatically flags any department whose attrition rate is **above the
company-wide average** — a ready-made action list for HR leadership.

---

## ✅ How This Meets the Task Plan Criteria

- **Well-Structured:** Employees properly linked to departments via foreign key; `CHECK` constraints enforce valid gender/status/rating values.
- **Accurate & Reliable:** Attrition and averages use correct `GROUP BY` + conditional aggregation (`CASE WHEN` inside `SUM`/`AVG`), not manual counting.
- **Decision-Focused:** Every query maps to a real HR decision — who to retain, where pay gaps exist, which departments need review.
- **Clearly Reported:** Query 7 auto-generates a "flagged for review" list rather than leaving interpretation to the reader.
- **Reproducible:** All logic (attrition thresholds, tenure formula, rating buckets) is documented in-query and in this README.

---

## 🚀 Next Steps / Extensions

- Add an `exit_interviews` table with reason codes to correlate attrition causes.
- Track promotions/salary revisions over time with a `salary_history` table.
- Build a Power BI/Tableau dashboard on top of the CSV exports for leadership reporting.
