-- ============================================================
-- PROJECT 3: HR ANALYTICS USING SQL
-- File: 01_schema.sql
-- Purpose: Employee, department tables linked with relational keys
--          to analyze attrition, salary, and performance
-- ============================================================

DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

-- Departments table
CREATE TABLE departments (
    department_id   INTEGER PRIMARY KEY,
    department_name TEXT NOT NULL UNIQUE
);

-- Employees table
CREATE TABLE employees (
    employee_id        INTEGER PRIMARY KEY,
    employee_name       TEXT NOT NULL,
    department_id        INTEGER NOT NULL,
    gender                TEXT NOT NULL CHECK (gender IN ('Male','Female')),
    salary                DECIMAL(10,2) NOT NULL,
    hire_date             DATE NOT NULL,
    status                 TEXT NOT NULL CHECK (status IN ('Active','Resigned')),
    resignation_date       DATE,               -- NULL if still active
    performance_rating     INTEGER NOT NULL CHECK (performance_rating BETWEEN 1 AND 5),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE INDEX idx_employees_department ON employees(department_id);
CREATE INDEX idx_employees_status ON employees(status);
