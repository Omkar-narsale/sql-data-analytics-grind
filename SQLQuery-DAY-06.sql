use  [SQL PRACTICE]

select * from Employees
select * from Departments
select * from EmployeeProjects
select * from Projects


--Q1 — Department Employee Count
select d.departmentname,count(e.employeeid) as Employeecount 
from employees as e
left join departments as d
on e.DepartmentID=d.DepartmentID
group by d.departmentname

--Q2 — Employee Salary Category
with cte as (
select e.employeename,d.departmentname,e.salary,
case 
	when e.Salary >= 85000 then 'High'
	when e.Salary >= 65000 and e.salary < 85000 then 'Medium'
	else 'Low'
	end
	 as SalaryCategory
	from employees as e
	join departments as d
	on e.departmentid=d.departmentid
)
select EmployeeName,DepartmentName,Salary,SalaryCategory from cte

--Q3 — Project Budget Analysis
SELECT 
    p.ProjectName,
    d.DepartmentName,
    p.Budget,
    AVG(p.Budget) OVER (
        PARTITION BY d.DepartmentID
    ) AS DepartmentAverageBudget
FROM Projects AS p
JOIN Departments AS d
    ON p.DepartmentID = d.DepartmentID;

--Q4 — Employees With No Projects
select e.employeeid,e.employeename,d.departmentname
from Employees as e
left join Departments as d
on e.DepartmentID=d.DepartmentID
join Projects p
on d.DepartmentID=p.DepartmentID
where p.projectid is NULL

--Q5 — Employee vs Manager Salary
select e.employeename,m.employeename as Managername,e.salary as EmployeeSalary,m.Salary as ManagerSalary,e.Salary - m.Salary AS SalaryDifference
from Employees as e
join Employees as m
on e.ManagerID=m.EmployeeID
where e.Salary>m.Salary

--Q6 — Department Project Statistics
with cte as (
select d.departmentname,
count(p.projectid) over(partition by d.departmentid) as NumberOfProjects,
sum(p.budget) over(partition by d.departmentid) as TotalProjectBudget,
avg(p.budget) over(partition by d.departmentid) as AverageProjectBudget
 FROM Departments AS d
    LEFT JOIN Projects AS p
        ON d.DepartmentID = p.DepartmentID
)select distinct  DepartmentName,NumberOfProjects,TotalProjectBudget,AverageProjectBudget from cte

--Q7 — Top 2 Employees by Project Hours

WITH EmployeeHours AS (
    SELECT
        e.EmployeeID,
        e.EmployeeName,
        d.DepartmentName,
        SUM(ep.HoursWorked) AS TotalHoursWorked
    FROM Employees AS e
    JOIN Departments AS d
        ON e.DepartmentID = d.DepartmentID
    JOIN EmployeeProjects AS ep
        ON e.EmployeeID = ep.EmployeeID
    GROUP BY
        e.EmployeeID,
        e.EmployeeName,
        d.DepartmentName
),
RankedEmployees AS (
    SELECT
        EmployeeID,
        EmployeeName,
        DepartmentName,
        TotalHoursWorked,
        DENSE_RANK() OVER (
            PARTITION BY DepartmentName
            ORDER BY TotalHoursWorked DESC
        ) AS DepartmentRank
    FROM EmployeeHours
)

SELECT
    EmployeeName,
    DepartmentName,
    TotalHoursWorked
FROM RankedEmployees
WHERE DepartmentRank <= 2;


--Q8 — Employee Performance vs Department
WITH EmployeeHours AS (
    SELECT
        e.EmployeeID,
        e.EmployeeName,
        d.DepartmentName,
        d.DepartmentID,
        SUM(ep.HoursWorked) AS TotalHoursWorked
    FROM Employees e
    JOIN Departments d ON e.DepartmentID = d.DepartmentID
    JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
    GROUP BY e.EmployeeID, e.EmployeeName, d.DepartmentName, d.DepartmentID
),

Ranked AS (
    SELECT *,
        AVG(TotalHoursWorked) OVER(PARTITION BY DepartmentID) AS DepartmentAverageHours
    FROM EmployeeHours
)

SELECT
    EmployeeName,
    DepartmentName,
    TotalHoursWorked,
    DepartmentAverageHours,
    TotalHoursWorked - DepartmentAverageHours AS DifferenceFromDepartmentAverage
FROM Ranked
WHERE TotalHoursWorked > DepartmentAverageHours;


--Q9 — Most Valuable Department
WITH DepartmentSalary AS (
    SELECT
        d.DepartmentID,
        d.DepartmentName,
        COALESCE(SUM(e.Salary), 0) AS TotalEmployeeSalary
    FROM Departments d
    LEFT JOIN Employees e
        ON d.DepartmentID = e.DepartmentID
    GROUP BY
        d.DepartmentID,
        d.DepartmentName
),
DepartmentBudget AS (
    SELECT
        d.DepartmentID,
        COALESCE(SUM(p.Budget), 0) AS TotalProjectBudget
    FROM Departments d
    LEFT JOIN Projects p
        ON d.DepartmentID = p.DepartmentID
    GROUP BY
        d.DepartmentID
),
DepartmentValue AS (
    SELECT
        ds.DepartmentName,
        ds.TotalEmployeeSalary,
        db.TotalProjectBudget,
        ds.TotalEmployeeSalary + db.TotalProjectBudget AS CombinedValue
    FROM DepartmentSalary ds
    JOIN DepartmentBudget db
        ON ds.DepartmentID = db.DepartmentID
),
RankedDepartments AS (
    SELECT
        DepartmentName,
        TotalProjectBudget,
        TotalEmployeeSalary,
        CombinedValue,
        DENSE_RANK() OVER (
            ORDER BY CombinedValue DESC
        ) AS DepartmentRank
    FROM DepartmentValue
)
SELECT
    DepartmentName,
    TotalProjectBudget,
    TotalEmployeeSalary,
    CombinedValue
FROM RankedDepartments
WHERE DepartmentRank = 1;


--Q10 — Advanced Employee Performance
WITH EmployeeHours AS (
    SELECT
        e.EmployeeID,
        e.EmployeeName,
        d.DepartmentName,
        COUNT(ep.ProjectID) AS TotalProjects,
        SUM(ep.HoursWorked) AS TotalHoursWorked
    FROM Employees e
    JOIN Departments d
        ON e.DepartmentID = d.DepartmentID
    JOIN EmployeeProjects ep
        ON e.EmployeeID = ep.EmployeeID
    GROUP BY
        e.EmployeeID,
        e.EmployeeName,
        d.DepartmentName
),
EmployeeAnalysis AS (
    SELECT
        EmployeeID,
        EmployeeName,
        DepartmentName,
        TotalProjects,
        TotalHoursWorked,

        TotalHoursWorked * 1.0 / TotalProjects
            AS AverageHoursPerProject,

        AVG(TotalHoursWorked) OVER (
            PARTITION BY DepartmentName
        ) AS DepartmentAverageHours

    FROM EmployeeHours
),
FinalAnalysis AS (
    SELECT
        EmployeeName,
        DepartmentName,
        TotalProjects,
        TotalHoursWorked,
        AverageHoursPerProject,
        DepartmentAverageHours,

        TotalHoursWorked - DepartmentAverageHours
            AS DifferenceFromDepartmentAverage,

        TotalHoursWorked * 100.0 / DepartmentAverageHours
            AS PercentageOfDepartmentAverage

    FROM EmployeeAnalysis
)
SELECT
    EmployeeName,
    DepartmentName,
    TotalProjects,
    TotalHoursWorked,
    AverageHoursPerProject,
    DepartmentAverageHours,
    DifferenceFromDepartmentAverage,
    PercentageOfDepartmentAverage
FROM FinalAnalysis
WHERE TotalProjects >= 2
  AND TotalHoursWorked > DepartmentAverageHours;