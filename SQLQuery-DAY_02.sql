select * from Employees
select * from Departments
select * from Projects

--Q1 Display every employee along with their department name.
select e.Employeename,d.departmentname name from Employees as e
join  Departments as d
on e.DepartmentID=d.DepartmentID

--Q2 Display the names of employees who work in the IT department.
select e.Employeename,d.departmentname name from Employees as e
join  Departments as d
on e.DepartmentID=d.DepartmentID
where d.DepartmentID='101'


--Q3 Find the number of employees in each department.
select d.departmentname,count(e.employeeid) as EmployeeCount from Employees as e
join Departments as d
on d.DepartmentID=e.DepartmentID
group by d.departmentname

--Q4 Display every employee's name, salary, and a new column called SalaryCategory.
select employeename,salary,
case
	when Salary >= 85000 then 'High'
	when Salary >= 65000 then 'Medium'
	else 'LOW'
end as  SalaryCategory
from Employees

--Q5 Find the average salary of each department.
select d.departmentname,avg(e.Salary) as AverageSalary from Departments as d
join Employees as e
on d.DepartmentID=e.DepartmentID
group by d.departmentname

--Q6 Find employees whose salary is greater than the overall average salary of all employees.
select Employeename,Salary from Employees
where salary>(select avg(salary)  from Employees)

--Q7 For each department, count how many employees belong to each salary category:
	SELECT
    d.DepartmentName,
    COUNT(CASE 
        WHEN e.Salary >= 85000 THEN 1
    END) AS HighCount,
    COUNT(CASE 
        WHEN e.Salary >= 65000 AND e.Salary < 85000 THEN 1
    END) AS MediumCount,
    COUNT(CASE 
        WHEN e.Salary < 65000 THEN 1
    END) AS LowCount
FROM Departments AS d
LEFT JOIN Employees AS e
    ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName;

--Q8 Display every employee along with
SELECT
    e.EmployeeName,
    d.DepartmentName,
    e.Salary,
    AVG(e.Salary) OVER (
        PARTITION BY e.DepartmentID
    ) AS DepartmentAverageSalary,
    e.Salary - AVG(e.Salary) OVER (
        PARTITION BY e.DepartmentID
    ) AS DifferenceFromDepartmentAverage
FROM Employees AS e
JOIN Departments AS d
    ON e.DepartmentID = d.DepartmentID;

--Q9 — Top 2 salaries per department
SELECT
    DepartmentName,
    EmployeeName,
    Salary
FROM
(
    SELECT
        d.DepartmentName,
        e.EmployeeName,
        e.Salary,
        DENSE_RANK() OVER (
            PARTITION BY e.DepartmentID
            ORDER BY e.Salary DESC
        ) AS SalaryRank
    FROM Employees AS e
    JOIN Departments AS d
        ON e.DepartmentID = d.DepartmentID
) AS RankedEmployees
WHERE SalaryRank <= 2;

--Q10 Find employees whose salary is:
--greater than their department's average salary AND greater than the overall company average salary.

WITH SalaryData AS
(
    SELECT
        e.EmployeeName,
        d.DepartmentName,
        e.Salary,
        AVG(e.Salary) OVER(PARTITION BY d.DepartmentName) AS DepartmentAverageSalary,
        AVG(e.Salary) OVER() AS CompanyAverageSalary
    FROM Employees AS e
    JOIN Departments AS d
        ON e.DepartmentID = d.DepartmentID
)

SELECT
    EmployeeName,
    DepartmentName,
    Salary,
    DepartmentAverageSalary,
    CompanyAverageSalary
FROM SalaryData 
where Salary > DepartmentAverageSalary
AND Salary > CompanyAverageSalary
 