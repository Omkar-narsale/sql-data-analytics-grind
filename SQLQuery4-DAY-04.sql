select * from Employees
select * from Departments
select * from EmployeeProjects
select * from Projects



-- Q1 — Employee and Manager
select e.Employeename,m.Employeename as Managername from employees as e
join Employees as m
on e.ManagerID=m.EmployeeID

-- Q2-Employees with No Manager
select e.Employeename,e.salary from employees as e
left join Employees as m
on e.ManagerID=m.EmployeeID
WHERE e.ManagerID IS NULL;

-- Q3 — Project Count by Department
select d.departmentname,count(p.projectid) as ProjectCount from Departments as d
left join Projects as p
on d.DepartmentID=p.DepartmentID
group by d.Departmentname

--Q4-Employees Working on Projects
select e.employeename,p.projectname,ep.hoursworked from Employees as e
join EmployeeProjects as ep
on e.EmployeeID=ep.EmployeeID
join  Projects as p
on ep.ProjectID=p.ProjectID

-- Q5 — Employees Earning More Than Their Manager
select e.employeename as EmployeeName ,e.salary as EmployeeSalary,m.employeename as Managername,e.salary as Managersalary
from Employees as e
join Employees as m
on e.ManagerID=m.EmployeeID
where e.Salary>m.Salary

-- Q6 — Total Hours Worked by Employee
--For every employee, calculate their total project hours.
SELECT 
    e.EmployeeID,
    e.EmployeeName,
    SUM(COALESCE(ep.HoursWorked, 0)) AS TotalHoursWorked 
FROM Employees AS e
LEFT JOIN EmployeeProjects AS ep 
    ON e.EmployeeID = ep.EmployeeID
LEFT JOIN Projects AS p 
    ON ep.ProjectID = p.ProjectID
GROUP BY 
    e.EmployeeID, 
    e.EmployeeName;

-- Q7 — Most Experienced Employee in Each Department
WITH RankedEmployees AS (
    SELECT 
        d.DepartmentName,
        e.EmployeeName,
        e.JoiningDate,
        ROW_NUMBER() OVER(PARTITION BY e.DepartmentId ORDER BY e.JoiningDate ASC) as Rank
    FROM Employees AS e
    JOIN Departments AS d ON e.DepartmentId = d.DepartmentId
)
SELECT 
    DepartmentName,
    EmployeeName,
    JoiningDate
FROM RankedEmployees
WHERE Rank = 1;

-- Q8 — Project with Highest Total Hours
select p.projectname,sum(ep.Hoursworked) as TotalHoursWorked
from Projects as p
join EmployeeProjects as ep
on p.projectid=ep.projectid
group by p.projectname


--Q9 — Department with Highest Average Salary

WITH DepartmentAvg AS (
    SELECT 
        d.DepartmentName,
        AVG(e.Salary) AS AverageSalary
    FROM Departments AS d
    JOIN Employees AS e
        ON d.DepartmentID = e.DepartmentID
    GROUP BY d.DepartmentID, d.DepartmentName
),
RankedDepartments AS (
    SELECT
        DepartmentName,
        AverageSalary,
        DENSE_RANK() OVER(
            ORDER BY AverageSalary DESC
        ) AS SalaryRank
    FROM DepartmentAvg
)
SELECT
    DepartmentName,
    AverageSalary
FROM RankedDepartments
WHERE SalaryRank = 1;


--Q10 — Employee Project Performance

WITH EmployeeHours AS
(
    SELECT
        e.EmployeeID,
        e.EmployeeName,
        d.DepartmentName,
        SUM(ep.HoursWorked) AS TotalHoursWorked,
        COUNT(ep.ProjectID) AS NumberOfProjects
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
DepartmentAnalysis AS
(
    SELECT
        EmployeeID,
        EmployeeName,
        DepartmentName,
        TotalHoursWorked,
        NumberOfProjects,

        TotalHoursWorked * 1.0 / NumberOfProjects
            AS AverageHoursPerProject,

        AVG(TotalHoursWorked) OVER(
            PARTITION BY DepartmentName
        ) AS DepartmentAverageHours

    FROM EmployeeHours
)
SELECT
    EmployeeName,
    DepartmentName,
    TotalHoursWorked,
    AverageHoursPerProject,
    DepartmentAverageHours,
    TotalHoursWorked - DepartmentAverageHours
        AS DifferenceFromDepartmentAverage
FROM DepartmentAnalysis
WHERE TotalHoursWorked > DepartmentAverageHours
  AND NumberOfProjects >= 2;