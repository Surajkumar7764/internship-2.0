-- ============================================================
-- PROJECT 3: HR ANALYTICS USING SQL
-- File: 03_analysis_queries.sql
-- Purpose: Attrition, salary distribution, and performance insights
-- ============================================================

-- ------------------------------------------------------------
-- Q1. ATTRITION RATE BY DEPARTMENT
-- ------------------------------------------------------------
SELECT
    d.department_name,
    COUNT(e.employee_id) AS total_employees,
    SUM(CASE WHEN e.status = 'Resigned' THEN 1 ELSE 0 END) AS resigned_count,
    ROUND(100.0 * SUM(CASE WHEN e.status = 'Resigned' THEN 1 ELSE 0 END) / COUNT(e.employee_id), 2) AS attrition_rate_percent
FROM departments d
JOIN employees e ON e.department_id = d.department_id
GROUP BY d.department_id
ORDER BY attrition_rate_percent DESC;


-- ------------------------------------------------------------
-- Q2. AVERAGE SALARY BY DEPARTMENT
-- ------------------------------------------------------------
SELECT
    d.department_name,
    COUNT(e.employee_id) AS headcount,
    ROUND(AVG(e.salary), 2) AS avg_salary,
    MIN(e.salary) AS min_salary,
    MAX(e.salary) AS max_salary
FROM departments d
JOIN employees e ON e.department_id = d.department_id
WHERE e.status = 'Active'
GROUP BY d.department_id
ORDER BY avg_salary DESC;


-- ------------------------------------------------------------
-- Q3. GENDER PAY GAP BY DEPARTMENT
-- ------------------------------------------------------------
SELECT
    d.department_name,
    ROUND(AVG(CASE WHEN e.gender = 'Male' THEN e.salary END), 2) AS avg_salary_male,
    ROUND(AVG(CASE WHEN e.gender = 'Female' THEN e.salary END), 2) AS avg_salary_female,
    ROUND(
        AVG(CASE WHEN e.gender = 'Male' THEN e.salary END) -
        AVG(CASE WHEN e.gender = 'Female' THEN e.salary END), 2
    ) AS pay_gap_male_minus_female
FROM departments d
JOIN employees e ON e.department_id = d.department_id
WHERE e.status = 'Active'
GROUP BY d.department_id
ORDER BY pay_gap_male_minus_female DESC;


-- ------------------------------------------------------------
-- Q4. TOP PERFORMERS (rating 4 or 5, currently active)
-- ------------------------------------------------------------
SELECT
    e.employee_name,
    d.department_name,
    e.performance_rating,
    e.salary,
    e.hire_date
FROM employees e
JOIN departments d ON d.department_id = e.department_id
WHERE e.performance_rating >= 4 AND e.status = 'Active'
ORDER BY e.performance_rating DESC, e.salary DESC
LIMIT 15;


-- ------------------------------------------------------------
-- Q5. AVERAGE TENURE (in years) BY DEPARTMENT
-- (For resigned employees: hire_date -> resignation_date
--  For active employees: hire_date -> today)
-- ------------------------------------------------------------
SELECT
    d.department_name,
    ROUND(AVG(
        CASE
            WHEN e.status = 'Resigned' THEN julianday(e.resignation_date) - julianday(e.hire_date)
            ELSE julianday('2026-08-07') - julianday(e.hire_date)
        END
    ) / 365.0, 2) AS avg_tenure_years
FROM departments d
JOIN employees e ON e.department_id = d.department_id
GROUP BY d.department_id
ORDER BY avg_tenure_years DESC;


-- ------------------------------------------------------------
-- Q6. PERFORMANCE RATING DISTRIBUTION (workforce quality check)
-- ------------------------------------------------------------
SELECT
    performance_rating,
    COUNT(*) AS num_employees,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM employees), 2) AS percent_of_workforce
FROM employees
GROUP BY performance_rating
ORDER BY performance_rating DESC;


-- ------------------------------------------------------------
-- Q7. HIGH ATTRITION DEPARTMENTS FLAGGED FOR HR REVIEW
-- (Departments with attrition rate above the company average)
-- ------------------------------------------------------------
WITH dept_attrition AS (
    SELECT
        d.department_name,
        ROUND(100.0 * SUM(CASE WHEN e.status = 'Resigned' THEN 1 ELSE 0 END) / COUNT(e.employee_id), 2) AS attrition_rate_percent
    FROM departments d
    JOIN employees e ON e.department_id = d.department_id
    GROUP BY d.department_id
),
company_avg AS (
    SELECT ROUND(100.0 * SUM(CASE WHEN status = 'Resigned' THEN 1 ELSE 0 END) / COUNT(*), 2) AS avg_rate
    FROM employees
)
SELECT
    da.department_name,
    da.attrition_rate_percent,
    ca.avg_rate AS company_avg_attrition_rate,
    'Needs HR Review' AS flag
FROM dept_attrition da, company_avg ca
WHERE da.attrition_rate_percent > ca.avg_rate
ORDER BY da.attrition_rate_percent DESC;
