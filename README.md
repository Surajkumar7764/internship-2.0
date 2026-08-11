# Data Analysis with SQL — Internship Project Submission

**CodeVedX Internship Task Plan | 5 Projects**
🌐 www.codevedx.com &nbsp;|&nbsp; 📧 contact@codevedx.in &nbsp;|&nbsp; 🔗 LinkedIn: CodeVedX

This repository contains 5 complete, self-contained SQL data analysis
projects. Each project has its own folder with a full schema, sample
data, analysis queries, a pre-built SQLite database, and a detailed
`README.md`.

---

## 📂 Repository Structure

```
.
├── Project1_Sales_Data_Analysis/
│   ├── 01_schema.sql
│   ├── 02_sample_data.sql
│   ├── 03_analysis_queries.sql
│   ├── sales_analysis.db
│   └── README.md
│
├── Project2_Customer_Behavior_Analysis/
│   ├── 01_schema.sql
│   ├── 02_sample_data.sql
│   ├── 03_analysis_queries.sql
│   ├── customer_behavior.db
│   └── README.md
│
├── Project3_HR_Analytics/
│   ├── 01_schema.sql
│   ├── 02_sample_data.sql
│   ├── 03_analysis_queries.sql
│   ├── hr_analytics.db
│   └── README.md
│
├── Project4_Banking_Transaction_Analysis/
│   ├── 01_schema.sql
│   ├── 02_sample_data.sql
│   ├── 03_analysis_queries.sql
│   ├── banking_analysis.db
│   └── README.md
│
├── Project5_Ecommerce_Performance_Analysis/
│   ├── 01_schema.sql
│   ├── 02_sample_data.sql
│   ├── 03_analysis_queries.sql
│   ├── ecommerce_analysis.db
│   └── README.md
│
├── .gitignore
└── README.md   ← you are here
```

---

## 📋 Project Summaries

| # | Project | Focus | Key Techniques |
|---|---|---|---|
| 1 | **Sales Data Analysis** | Revenue trends, top products, repeat customers, profit margins | Joins, `GROUP BY`, aggregation |
| 2 | **Customer Behavior Analysis** | RFM segmentation, CLV, churn detection, engagement | CTEs, `CASE WHEN` segmentation, date math |
| 3 | **HR Analytics** | Attrition rate, salary/pay-gap analysis, top performers, tenure | Conditional aggregation, multi-CTE |
| 4 | **Banking Transaction Analysis** | Fraud/spike detection, high-value transactions, loan risk | **Window functions: `LAG`, `LEAD`** |
| 5 | **E-Commerce Performance Analysis** | Conversion rate, AOV, peak sales time, delivery performance | Cross-table KPIs, funnel analysis |

Every project independently satisfies its task-plan criteria:
**Well-Structured → Accurate & Reliable → Insight/Decision/Risk/Performance-Focused → Clearly Reported → Reproducible.**

---

## ▶️ Quick Start (any project)

```bash
cd Project1_Sales_Data_Analysis          # or any other project folder
sqlite3 <db_name>.db < 01_schema.sql
sqlite3 <db_name>.db < 02_sample_data.sql
sqlite3 <db_name>.db < 03_analysis_queries.sql
```

Or simply open the included `.db` file for that project directly in
**DB Browser for SQLite** (free — https://sqlitebrowser.org) — no
setup needed, the data is already loaded.

Each project's own `README.md` has full details: schema diagram,
step-by-step run instructions, what each query means, and sample
results.

---

## 🎓 Internship Submission Checklist

Per the task plan's Internship Instructions:

- [x] All 5 projects built with schema + sample data + analysis queries
- [x] Each project has its own `README.md`
- [x] All SQL is documented and reproducible
- [ ] Upload this folder to **GitHub** with proper commits *(see below)*
- [ ] Export project documentation as **PDF + PPT** and upload to Google Drive

### Uploading to GitHub
```bash
cd sql_internship_projects        # this folder
git init
git add .
git commit -m "Initial commit: 5 SQL data analysis projects (Sales, Customer Behavior, HR, Banking, E-Commerce)"
git branch -M main
git remote add origin <your-repo-url>
git push -u origin main
```
Tip: commit each project separately for a cleaner history, e.g.
`git add Project1_Sales_Data_Analysis && git commit -m "Add Project 1: Sales Data Analysis"`, repeated per project.

---

## 🛠️ Tech Used

- **SQLite 3** (portable, zero-setup — every `.sql` file also runs on MySQL/PostgreSQL with minor date-function syntax changes, noted in each project's README)
- Plain `.sql` files — no proprietary tools required to review or re-run anything

---

*Built as part of the CodeVedX "Data Analysis with SQL" internship task plan.*
