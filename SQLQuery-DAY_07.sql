use [SQL PRACTICE]

select * from Employees
select * from Departments
select * from EmployeeProjects
--Q1 — Employees Above Company Average
with cte as (
select e.employeename,d.departmentname,e.salary,
avg(e.salary) over() as CompanyAverageSalary
from Employees as e
join departments d 
on e.DepartmentID=d.DepartmentID
) 
select EmployeeName,DepartmentName,Salary,CompanyAverageSalary from cte 
where salary>CompanyAverageSalary


--Q2 — Department Salary Statistics
with cte as(
select d.departmentname,
count(e.Employeeid) over(partition by d.departmentid) as EmployeeCount,
min(e.salary) over(partition by d.departmentid) as MinimumSalary,
max(e.salary) over(partition by d.departmentid) as MaximumSalary,
avg(e.salary) over(partition by d.departmentid) as AverageSalary
from departments as d
left join employees as e
on d.departmentid=e.departmentid
)
select distinct DepartmentName,EmployeeCount,MinimumSalary,MaximumSalary,AverageSalary
from cte 

--Q3 — Recently Joined Employees
select e.employeename,d.departmentname,e.joiningdate,e.salary
from employees as e
join Departments as d
on e.DepartmentID=d.DepartmentID
where year(e.JoiningDate) >='2022'
order by e.joiningdate desc

--Q4 — Project Budget Category
with cte as (
select p.projectname,d.departmentname,p.budget,
case 
	when p.Budget>= 400000 then 'High'
	when p.Budget >= 250000 then 'Medium'
	else 'Low'
	end as BudgetCategory
	from projects as p
	join Departments as d
	on p.DepartmentID=d.DepartmentID
	)
select ProjectName,DepartmentName,Budget,BudgetCategory from cte

--Q5 — Employees Earning More Than Their Department Average
with cte as (
select e.Employeename,d.departmentname,e.salary,
avg(e.salary) over(partition by d.departmentid) as DepartmentAverageSalary
from employees as e
join departments as d
on e.departmentid=d.departmentid
)
select EmployeeName,DepartmentName,Salary,DepartmentAverageSalary,salary-DepartmentAverageSalary as	DifferenceFromAverage
from cte 
WHERE Salary > DepartmentAverageSalary;


--Q6 — Department Salary Ranking
with cte as (
select e.employeename,d.departmentname,e.salary,
DENSE_RANK() over(partition by d.departmentid order by e.salary desc) as SalaryRank
from employees as e
join Departments as d
on e.DepartmentID=d.DepartmentID
)
select EmployeeName,DepartmentName,Salary,SalaryRank
from cte 
where SalaryRank<=2

--Q7 —Employee Project Contribution
WITH EmployeeStats AS (
    SELECT
        e.EmployeeName,
        d.DepartmentName,
        COUNT(ep.ProjectID) AS TotalProjects,
        SUM(ep.HoursWorked) AS TotalHoursWorked
    FROM Employees AS e
    JOIN Departments AS d
        ON e.DepartmentID = d.DepartmentID
    JOIN EmployeeProjects AS ep
        ON ep.EmployeeID = e.EmployeeID
    GROUP BY
        e.EmployeeName,
        d.DepartmentName
),
EmployeeAnalysis AS (
    SELECT
        EmployeeName,
        DepartmentName,
        TotalProjects,
        TotalHoursWorked,
        TotalHoursWorked * 1.0 / TotalProjects AS AverageHoursPerProject
    FROM EmployeeStats
)
SELECT
    EmployeeName,
    DepartmentName,
    TotalProjects,
    TotalHoursWorked,
    AverageHoursPerProject
FROM EmployeeAnalysis
WHERE AverageHoursPerProject > 100;

--Q8 — Department With Highest Project Budget
with cte as (
select d.departmentname,Sum(p.Budget) as TotalProjectBudget
from departments as d
join projects p 
on d.DepartmentID=p.DepartmentID
group by d.DepartmentName
),
cte1 as (
select departmentname,TotalProjectBudget,
DENSE_RANK() over( order by TotalProjectBudget desc) as DepartmentRank
from cte
)
select departmentname,TotalprojectBudget from cte1
WHERE DepartmentRank = 1

--Q9 — Employee Salary vs Department and Company
with cte as (
select e.employeename,d.departmentname,e.salary,
avg(e.salary) over(partition by d.departmentid) as DepartmentAverageSalary,
avg(e.salary) over() as CompanyAverageSalary
from employees as e
join Departments as d
on e.DepartmentID=d.DepartmentID
)
select EmployeeName,DepartmentName,Salary,DepartmentAverageSalary,CompanyAverageSalary,
Salary-DepartmentAverageSalary as DifferenceFromDepartmentAverage,
Salary-CompanyAverageSalary as DifferenceFromCompanyAverage
from cte 
where Salary>DepartmentAverageSalary and Salary>CompanyAverageSalary

--Q10 — Advanced Employee Performance Ranking
with cte as (
select e.employeename,d.departmentname,count(ep.projectid) as TotalProjects,
sum(Hoursworked) as TotalHoursWorked
from employees as e
join Departments as d
on e.DepartmentID=d.DepartmentID
join EmployeeProjects as ep
on e.EmployeeID=ep.EmployeeID
group by e.EmployeeName,d.DepartmentName
),
cte1 AS (
    SELECT
        EmployeeName,
        DepartmentName,
        TotalProjects,
        TotalHoursWorked,
        TotalHoursWorked * 1.0 / TotalProjects AS AverageHoursPerProject,
        AVG(TotalHoursWorked) OVER (
            PARTITION BY DepartmentName
        ) AS DepartmentAverageHours
    FROM cte
),
cte2 as (
select EmployeeName,
        DepartmentName,
        TotalProjects,
        TotalHoursWorked,
        AverageHoursPerProject,
        DepartmentAverageHours,
DifferenceFromDepartmentAverage= TotalHoursWorked - DepartmentAverageHours,
PerformancePercentage= (TotalHoursWorked / DepartmentAverageHours) *100.0,
dense_rank() over(PARTITION BY DepartmentName order by TotalHoursWorked DESC ) as DepartmentRank
from cte1
)
select EmployeeName,
DepartmentName,
TotalProjects,
TotalHoursWorked,
AverageHoursPerProject,
DepartmentAverageHours,
DifferenceFromDepartmentAverage,
PerformancePercentage,
DepartmentRank
from cte2
where TotalProjects >= 2
AND
TotalHoursWorked > DepartmentAverageHours
AND
DepartmentRank <= 2
