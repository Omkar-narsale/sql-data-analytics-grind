use [SQL PRACTICE]

select * from Employees
select * from Departments
Select * from Projects

--Q1 — Employee Joining Year
select Employeename,Joiningdate,year(Joiningdate)as JoiningYear from Employees

--Q2 — Employees Joined After 2021
select Employeename,Joiningdate 
from Employees
where year(Joiningdate)>='2021'

--Q3 — Department Salary Statistics
select d.departmentname,count(e.Employeeid) as [Number of Employees],sum(e.salary) as [Total Salary],avg(e.salary) as [Average Salary]
from Employees as e
left join departments as d
on e.departmentid=d.departmentid
group by d.departmentname

--Q4 — Project Information
select p.projectname,d.departmentname,p.budget from Projects as p
join Departments as d
on p.departmentid=d.DepartmentID

--Q5 — Department Highest Salary
WITH SalaryData AS
(
    SELECT
        d.DepartmentName,
        e.EmployeeName,
        e.Salary,
        MAX(e.Salary) OVER(
            PARTITION BY e.DepartmentID
        ) AS DepartmentMaxSalary
    FROM Employees AS e
    JOIN Departments AS d
        ON e.DepartmentID=d.DepartmentID
)
SELECT
    DepartmentName,
    EmployeeName,
    Salary
FROM SalaryData
WHERE Salary = DepartmentMaxSalary;

--Q6 — Salary Difference from Highest Salary
with cte as
(
select e.EmployeeName,d.DepartmentName,e.salary,
max(salary) over(partition by d.departmentid) as HighestSalaryInDepartment,
MAX(e.Salary) OVER(PARTITION BY e.DepartmentID) - e.Salary as DifferenceFromHighestSalary
from employees as e
JOIN Departments AS d
        ON e.DepartmentID=d.DepartmentID
)
select EmployeeName,DepartmentName,Salary,HighestSalaryInDepartment,DifferenceFromHighestSalary
from cte


--Q7 — Department Salary Ranking
with cte as 
(
    select 
        e.employeename,
        d.departmentname,
        e.salary,
        dense_rank() over(partition by d.departmentid order by e.salary desc) as SalaryRank
    from employees as e
    join departments as d
        on e.departmentid = d.departmentid
) 
select EmployeeName, DepartmentName, Salary, SalaryRank
from cte;


--Q8 — Departments Above Company Average
with cte as (
select d.departmentname,
avg(e.salary) over(partition by d.departmentid) as DepartmentAverageSalary,
avg(e.salary) over() as CompanyAverageSalary
from employees as e
join departments as d
on e.DepartmentID=d.DepartmentID
)
select DepartmentName,DepartmentAverageSalary,CompanyAverageSalary
from cte 
where DepartmentAverageSalary > CompanyAverageSalary

--Q9 — Second Highest Salary Per Department
with cte as (
select d.departmentname,e.employeename,e.salary,
dense_rank() over(partition by d.departmentid order by e.salary desc) as salaryrank
from Employees as e
join Departments as d
on e.DepartmentID=d.DepartmentID
)
select DepartmentName,EmployeeName,Salary
from cte 
where salaryrank=2

--Q10 — Department Salary Analysis
WITH cte AS
(
    SELECT
        e.EmployeeName,
        d.DepartmentName,
        e.Salary,
        AVG(e.Salary) OVER(
            PARTITION BY e.DepartmentID
        ) AS DepartmentAverageSalary,
        MAX(e.Salary) OVER(
            PARTITION BY e.DepartmentID
        ) AS DepartmentMaxSalary,
        e.Salary - AVG(e.Salary) OVER(
            PARTITION BY e.DepartmentID
        ) AS DifferenceFromDepartmentAverage,
        (
            CAST(e.Salary AS DECIMAL(10,2)) /
            MAX(e.Salary) OVER(
                PARTITION BY e.DepartmentID
            )
        ) * 100 AS PercentageOfDepartmentMaxSalary
    FROM Employees AS e
    JOIN Departments AS d
        ON e.DepartmentID = d.DepartmentID
)
SELECT
    EmployeeName,
    DepartmentName,
    Salary,
    DepartmentAverageSalary,
    DepartmentMaxSalary,
    DifferenceFromDepartmentAverage,
    PercentageOfDepartmentMaxSalary
FROM cte
WHERE Salary > DepartmentAverageSalary
  AND PercentageOfDepartmentMaxSalary >= 80;