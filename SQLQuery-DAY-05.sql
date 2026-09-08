select * from Customers
select * from Orders
select * from OrderItems
select * from Products

--Q1 — Customer Order Count
--Display every customer along with the number of orders they have placed.
select c.customername,count(o.orderid) as Ordercount from Customers as c
left join Orders as o
on c.customerid=o.CustomerID
group by c.Customername

-- Q2-Completed Orders
select o.orderid,c.customername,o.orderdate,o.Amount from orders as o
left join customers as c
on o.CustomerID=c.CustomerID

--Q3 Total Completed Spending
SELECT
    c.CustomerName,
    SUM(
        CASE
            WHEN o.Status = 'Completed' THEN o.Amount
            ELSE 0
        END
    ) AS TotalSpending
FROM Customers AS c
LEFT JOIN Orders AS o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerName;

--Q4.Customers Who Never Ordered
select c.customerid,c.customername from Customers as c
left join Orders as o
on c.CustomerID=o.CustomerID
where o.CustomerID is null

-- Q5 — Customers Above Average Spending
WITH CustomerSpending AS
(
    SELECT
        c.CustomerID,
        c.CustomerName,
        SUM(o.Amount) AS TotalSpending
    FROM Customers AS c
    JOIN Orders AS o
        ON c.CustomerID = o.CustomerID
    WHERE o.Status = 'Completed'
    GROUP BY
        c.CustomerID,
        c.CustomerName
),
AverageSpending AS
(
    SELECT
        CustomerName,
        TotalSpending,
        AVG(TotalSpending) OVER() AS AverageCustomerSpending
    FROM CustomerSpending
)
SELECT
    CustomerName,
    TotalSpending,
    AverageCustomerSpending
FROM AverageSpending
WHERE TotalSpending > AverageCustomerSpending;


--Q6 — Highest Order Per Customer
with cte as (
select c.customername,o.orderid,o.Amount,
DENSE_RANK() over(partition by c.customerid order by o.amount desc) as orderrank from Customers as c
join Orders o 
on c.CustomerID=o.CustomerID
)
select CustomerName,OrderID,Amount from cte
where orderrank=1


--Q7 — Monthly Sales
select month(orderdate) as Months,sum(Amount) as Totalsales
from Orders 
where status='Completed'
group by month(orderdate)

--Q8 — Product Sales Analysis
SELECT 
    p.ProductName,
    p.Category,
    COALESCE(
        SUM(CASE 
                WHEN o.Status = 'Completed' THEN oi.Quantity 
                ELSE 0 
            END), 
        0
    ) AS TotalQuantitySold,
    
    COALESCE(
        SUM(CASE 
                WHEN o.Status = 'Completed' THEN p.Price * oi.Quantity 
                ELSE 0 
            END), 
        0
    ) AS TotalRevenue

FROM Products p
LEFT JOIN OrderItems oi
    ON p.ProductID = oi.ProductID
LEFT JOIN Orders o
    ON oi.OrderID = o.OrderID

GROUP BY 
    p.ProductID,
    p.ProductName,
    p.Category;


-- Q9 — Top Customer in Each City

WITH CustomerSpending AS (
    SELECT
        c.CustomerID,
        c.CustomerName,
        c.City,
        SUM(o.Amount) AS TotalSpending
    FROM Customers c
    JOIN Orders o
        ON c.CustomerID = o.CustomerID
    WHERE o.Status = 'Completed'
    GROUP BY
        c.CustomerID,
        c.CustomerName,
        c.City
),
RankedCustomers AS (
    SELECT
        CustomerID,
        CustomerName,
        City,
        TotalSpending,
        DENSE_RANK() OVER (
            PARTITION BY City
            ORDER BY TotalSpending DESC
        ) AS SpendingRank
    FROM CustomerSpending
)
SELECT
    CustomerName,
    City,
    TotalSpending
FROM RankedCustomers
WHERE SpendingRank = 1;

-- Q10 — Customer Performance Analysis
WITH CustomerStats AS (
    SELECT
        c.CustomerID,
        c.CustomerName,
        c.City,
        COUNT(o.OrderID) AS TotalOrders,
        SUM(o.Amount) AS TotalSpending,
        AVG(o.Amount) AS AverageOrderValue,
        MAX(o.Amount) AS HighestOrderValue
    FROM Customers c
    JOIN Orders o
        ON c.CustomerID = o.CustomerID
    WHERE o.Status = 'Completed'
    GROUP BY
        c.CustomerID,
        c.CustomerName,
        c.City
),
CustomerAnalysis AS (
    SELECT
        CustomerName,
        City,
        TotalOrders,
        TotalSpending,
        AverageOrderValue,
        HighestOrderValue,

        AVG(TotalSpending) OVER () AS AverageCustomerSpending,

        HighestOrderValue - AverageOrderValue
            AS DifferenceFromAverage,

        (AverageOrderValue * 100.0 / HighestOrderValue)
            AS PercentageOfHighestOrder

    FROM CustomerStats
)
SELECT
    CustomerName,
    City,
    TotalOrders,
    TotalSpending,
    AverageOrderValue,
    HighestOrderValue,
    DifferenceFromAverage,
    PercentageOfHighestOrder
FROM CustomerAnalysis
WHERE TotalSpending > AverageCustomerSpending
  AND TotalOrders >= 2;