select * from Employees

--Q1 Display the names and salaries of all employees whose salary is greater than 70,000.
select * from Employees
where salary > 70000

--Q2 Find the average salary of all employees.
select avg(salary) as AverageSalary from Employees

--Q3 Display the number of employees in each department.
select distinct Department,count(Employeeid) as EmployeeCount
from Employees
group by Department

--Q4 Find the maximum salary in the IT department
select max(salary) as [Maxsalary] from Employees
where department='IT'

--Q5 Find the average salary of each department.
select department,avg(salary) as AverageSalary from Employees
group by department 

--Q6 Find departments whose average salary is greater than 70,000.
select department,avg(salary) as AverageSalary from Employees
group by department
having  avg(salary)>70000

--Q7 Display every employee along with their department's average salary.
SELECT
    EmployeeName,
    Department,
    Salary,
    AVG(Salary) OVER (PARTITION BY Department) AS DepartmentAvgSalary
FROM Employees;

--Q8 Rank employees by salary within each department, from highest to lowest.
select EmployeeName,
    Department,
    Salary,
    DENSE_RANK() over(partition by department order by Salary desc) as  SalaryRank
    from Employees

-- Q9 Find the highest-paid employee(s) from each department.
SELECT Department, EmployeeName, Salary
FROM (
    SELECT 
        Department,
        EmployeeName,
        Salary,
        DENSE_RANK() OVER (
            PARTITION BY Department 
            ORDER BY Salary DESC
        ) AS SalaryRank
    FROM Employees
) AS RankedEmployees
WHERE SalaryRank = 1;


--Q10 Find employees whose salary is greater than the average salary of their own department.
select Employeename,Department,Salary,DepartmentAvgSalary
from(
select Employeename,Department,Salary,
Avg(salary) over(partition by department) as DepartmentAvgSalary from Employees
) as e
where salary > DepartmentAvgSalary
