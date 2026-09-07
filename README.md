# 📊 SQL Data Analytics Grind

A daily SQL practice journey focused on preparing for **Data Analyst internships** and **SQL interviews**.

![SQL](https://img.shields.io/badge/SQL-Practice-blue)
![Progress](https://img.shields.io/badge/Days_Completed-4-brightgreen)
![Questions](https://img.shields.io/badge/Questions_Solved-40-orange)

---

## 📅 Daily Challenge Format
- 🟢 4 Easy
- 🟡 4 Medium
- 🔴 2 Hard

## 🧠 Topics Covered
`SELECT` `WHERE` `GROUP BY` `HAVING` `JOINs` `CASE WHEN` `Subqueries` `CTEs` `Window Functions` `ROW_NUMBER()` `RANK()` `DENSE_RANK()` `LEAD()` `LAG()` `Aggregations` `Date Functions` `Advanced SQL`

---

## 📑 Table of Contents
- [Day 01](#day-01)
- [Day 02](#day-02)
- [Day 03](#day-03)
- [Day 04](#day-04)

---

<details>
<summary><h2 id="day-01">📘 Day 01</h2></summary>

### Topics
- Aggregations
- GROUP BY
- HAVING
- Window Functions
- PARTITION BY
- DENSE_RANK
- Subqueries

### Progress
✅ **10/10 Questions Attempted**

### Key Learnings
- Difference between GROUP BY and PARTITION BY
- DENSE_RANK with PARTITION BY
- Filtering window-function results using a subquery

</details>

---

<details>
<summary><h2 id="day-02">📗 Day 02</h2></summary>

### Topics
- INNER JOIN
- LEFT JOIN
- Aggregations
- GROUP BY
- CASE WHEN
- Subqueries
- Window Functions
- PARTITION BY
- DENSE_RANK
- CTEs

### Progress
✅ **10/10 Questions Attempted**

### Key Learnings
- Difference between INNER JOIN and LEFT JOIN
- Using LEFT JOIN to include departments with no employees
- Using CASE WHEN for salary categorization
- Finding overall averages using subqueries
- Using PARTITION BY for department-level calculations
- Using DENSE_RANK with PARTITION BY to find top salaries per department
- Using window functions without GROUP BY
- Using CTEs to structure complex queries
- Filtering calculated window-function results using a CTE
- Difference between department average and company average salary

</details>

---

<details>
<summary><h2 id="day-03">📙 Day 03</h2></summary>

### Topics
- INNER JOIN
- LEFT JOIN
- Aggregations
- GROUP BY
- CASE WHEN
- Window Functions
- PARTITION BY
- MAX() OVER()
- AVG() OVER()
- DENSE_RANK
- CTEs
- Date Functions
- Subqueries

### Progress
✅ **10/10 Questions Attempted**

### Key Learnings
- Using `YEAR()` to extract the year from a date
- Filtering dates directly instead of applying functions when possible
- Difference between INNER JOIN and LEFT JOIN
- Using LEFT JOIN to include departments with no employees
- Using `MAX() OVER(PARTITION BY ...)` to find the highest salary in each department
- Calculating differences using window-function results
- Using `DENSE_RANK()` to find the second-highest unique salary while including ties
- Using `AVG() OVER(PARTITION BY ...)` for department-level averages
- Using `AVG() OVER()` to calculate the overall company average
- Using CTEs to calculate and filter window-function results
- Using multiple window functions together in a single query
- Using `CAST()` to avoid integer division when calculating percentages
- Structuring complex SQL problems as **Calculate → CTE → Filter**

</details>

---
<details>
<summary><h2 id="day-04">📕 Day 04</h2></summary>

### Topics
- Self JOIN
- INNER JOIN
- LEFT JOIN
- Multiple JOINs
- GROUP BY
- COUNT
- SUM
- COALESCE
- Window Functions
- PARTITION BY
- ROW_NUMBER
- DENSE_RANK
- CTEs
- Date Comparison
- Aggregations

### Progress
✅ **10/10 Questions Attempted**

### Key Learnings
- Using Self JOIN to connect employees with their managers
- Using LEFT JOIN to include employees without managers or projects
- Joining multiple tables through a bridge table
- Using `COALESCE()` to handle NULL values in aggregations
- Using `SUM()` and `COUNT()` with `GROUP BY`
- Using `DENSE_RANK()` to handle ties in ranking problems
- Difference between `ROW_NUMBER()` and `DENSE_RANK()`
- Using window functions after aggregation
- Using CTEs to break complex SQL problems into multiple steps
- Calculating department-level averages with `AVG() OVER(PARTITION BY ...)`
- Comparing individual employee performance with department averages
- Combining JOINs, GROUP BY, CTEs, and window functions in complex queries

</details>

---

⭐ *More days coming soon — follow along as this SQL grind continues!*
