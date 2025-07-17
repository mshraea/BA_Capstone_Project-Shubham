--  Database Setup
CREATE DATABASE payroll_database;
USE payroll_database;

-- Create employees table
CREATE TABLE employees (
    EMPLOYEE_ID INT PRIMARY KEY,
    NAME VARCHAR(100) NOT NULL,
    DEPARTMENT VARCHAR(50),
    EMAIL VARCHAR(100),
    PHONE_NO BIGINT,
    JOINING_DATE DATE,
    SALARY DECIMAL(10,2),
    BONUS DECIMAL(10,2),
    TAX_PERCENTAGE DECIMAL(5,2)
);

-- Data Entry (10 sample records )
INSERT INTO employees VALUES
(1, 'Satendra Mishra', 'Sales', 'satendra.m@company.com', 9876543210, '2023-01-15', 85000, 15000, 20),
(2, 'Rajendra Singh', 'IT', 'rajendra.s@company.com', 9876543211, '2022-08-20', 95000, 12000, 25),
(3, 'Shubham Sharma', 'HR', 'shubham.s@company.com', 9876543212, '2023-05-10', 75000, 8000, 18),
(4, 'Himanshu Mishra', 'Sales', 'himanshu.m@company.com', 9876543213, '2023-03-01', 82000, 14000, 20),
(5, 'Rajan Khanna', 'IT', 'rajan.k@company.com', 9876543214, '2022-11-15', 98000, 13000, 25),
(6, 'Amrit Tripathi', 'Finance', 'amrit.t@company.com', 9876543215, '2023-02-01', 88000, 10000, 22),
(7, 'Abhishek Pandey', 'Sales', 'abhishek.p@company.com', 9876543216, '2022-12-10', 80000, 12000, 20),
(8, 'Aniket Pandey', 'IT', 'aniket.p@company.com', 9876543217, '2023-04-15', 92000, 11000, 25),
(9, 'Ashu Kumar', 'Finance', 'ashu.k@company.com', 9876543218, '2022-09-01', 86000, 9000, 22),
(10, 'JP Chawla', 'HR', 'jp.c@company.com', 9876543219, '2023-06-01', 78000, 7000, 18);

-- Payroll Queries 
-- a) Employees sorted by salary in descending order

SELECT NAME, SALARY 
FROM employees 
ORDER BY SALARY DESC;


-- b) Employees with total compensation > $100,000

SELECT NAME, (SALARY + BONUS) as TOTAL_COMPENSATION 
FROM employees 
WHERE (SALARY + BONUS) > 100000;


-- c) Update bonus for Sales department
UPDATE employees 
SET BONUS = BONUS * 1.1 
WHERE DEPARTMENT = 'Sales';

-- d) Calculate net salary after tax
SELECT 
    NAME,
    SALARY,
    BONUS,
    (SALARY + BONUS) * (1 - TAX_PERCENTAGE/100) as NET_SALARY 
FROM employees;


-- e) Average, minimum, and maximum salary per department
SELECT 
    DEPARTMENT,
    AVG(SALARY) as AVG_SALARY,
    MIN(SALARY) as MIN_SALARY,
    MAX(SALARY) as MAX_SALARY 
FROM employees 
GROUP BY DEPARTMENT;

--  Advanced Queries

-- a) Employees who joined in last 6 months
SELECT NAME, JOINING_DATE 
FROM employees 
WHERE JOINING_DATE >= DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH);

-- b) Employee count by department
SELECT 
    DEPARTMENT,
    COUNT(*) as EMPLOYEE_COUNT 
FROM employees 
GROUP BY DEPARTMENT;

-- c) Department with highest average salary
SELECT 
    DEPARTMENT,
    AVG(SALARY) as AVG_SALARY 
FROM employees 
GROUP BY DEPARTMENT 
ORDER BY AVG_SALARY DESC 
LIMIT 1;

-- d) Employees with same salary
SELECT e1.NAME, e1.SALARY 
FROM employees e1 
INNER JOIN employees e2 
ON e1.SALARY = e2.SALARY 
AND e1.EMPLOYEE_ID != e2.EMPLOYEE_ID 
ORDER BY e1.SALARY;
