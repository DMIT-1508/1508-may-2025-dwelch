use LearningDB
go

--Subquery
--Why?
--typically use when you need to generate information from your data
--   to use to compare to other data
-- kind of like the " chicken and egg" problem

--so how do actually create a subquery
--  query within a query [within a query ...]
--  the query within a query is the subquery

-- 1st determine what the subquery is to produce
-- typically you will return a single column of values (list of values) OR a single value (one row, one column)

-- 2nd is to use the subquery on your "outer" query

--Joins vs subqueries
-- there are times when a join can replace a subject
-- typically you wish to judge using a join vs a subject on the following criteria
--    for performance and readability in production SQL?
--    the amount of data that will be processed?
--    depending on the query itself, a join maynot be possible, and a subquery required?

--Using a subquery on as a column on the SELECT
-- called a scalar subquery
-- recongized by return a single value (One row, One value)
-- subquery is also a correlated subquery, because the inner
--		query depends on each row from the outer query
-- subquery is executed once for each customer row

-- List all customers (fullname) and the amount of GSt and total amount of orders.

-- as a set of subqueries
-- subquery
--    (SELECT Sum(GST)
--		 FROM Orders
--		 WHERE Orders.CustomerNumber = Customers.CustomerNumber) 'GST'

-- what is happening
--   for each costumer row, the customernumber is being sent to the subquery
--   the subquery is selecting ONLY that customer information
--   the subquery is executing, summing the GST and return a single value
-- this is a correlated subquery and you can tell by the use of the customernumber
--		from the two tables on the WHERE clause
--     Orders.CustomerNumber = Customers.CustomerNumber


SELECT FirstName + ' ' + LastName 'Name',
		(SELECT Sum(GST)
		 FROM Orders
		 WHERE Orders.CustomerNumber = Customers.CustomerNumber) 'GST',
		 (SELECT Sum(Total)
		 FROM Orders
		 WHERE Orders.CustomerNumber = Customers.CustomerNumber) 'Total'
FROM Customers

go

-- could this also have been done with a join? YES

SELECT FirstName + ' ' + LastName 'Name',
		Sum(GST) 'GST',
		 Sum(Total) 'Total'
FROM Customers c INNER JOIN Orders o
	ON c.CustomerNumber = o.CustomerNumber
GROUP BY FirstName, LastName
go

--add customer with no orders
--comment out once run 
--INSERT INTO Customers (LastName, FirstName, Phone, City, Province)
--VALUES('Welch', 'Don', '780-378-5334', 'Edmonton','AB')
--go

--if the two queries above are re-executed, you will will notice
--   that the subquery produces a row where there is NO GST or Total for a customer
--   that has not placed an order

--What about using a OUTER JOIN?
-- the FROm statement specifies taking ALL of the Customer records regardless on matching
--     the Order records
--Note: The result is the same as the subquery
SELECT FirstName + ' ' + LastName 'Name',
		Sum(GST) 'GST',
		 Sum(Total) 'Total'
FROM Customers c LEFT OUTER JOIN Orders o
	ON c.CustomerNumber = o.CustomerNumber
GROUP BY FirstName, LastName
go

-- subquery used in a calculation in a SELECT column
--Round(value, to number of decimal) but still display too many places
--CAST(value as decimal(number of digit places, number of displayed decimals)
SELECT 
    c.FirstName + ' ' + c.LastName 'Name',
    SUM(o.Total) 'CustomerTotal',
    CAST(Round(SUM(o.Total) * 100.0 / 
        (SELECT SUM(Total) FROM Orders),2) as decimal(8,2)) 'PercentOfTotal'
FROM Customers c JOIN Orders o 
 ON c.CustomerNumber = o.CustomerNumber
GROUP BY c.FirstName , c.LastName
go 

-- as part of a filter WHERE clause
--benefit
-- obtain a value that is unknown to you but is needed for the query
-- subquery is executed once, the list is returned to the execution of the
--   WHERE

--List all customers with orders
-- Do not need any data on the Order table
-- Do need to know the customer with orders
-- the subquery is executed ONLY once
SELECT FirstName + ' ' + LastName 'Name'
FROM Customers
WHERE CustomerNumber IN (SELECT DISTINCT CustomerNumber 
						 FROM Orders)
go

SELECT DISTINCT FirstName + ' ' + LastName 'Name'
FROM Customers c INNER JOIN Orders o
   ON c.CustomerNumber = o.CustomerNumber
go

--can a subquery be used on the filter clause (Having) for a Group By
SELECT ItemNumber, SUM(Price) AS TotalItemSales
FROM ItemsOnOrder
GROUP BY ItemNumber
HAVING SUM(Price) >= (SELECT Avg(CurrentPrice)
						FROM Items)

-- Modifying comparison operators with subqueries
-- use of ANY and ALL with a subquery
--If your subquery returns multiple rows use Any or All
--Any  on subquery
-- The subquery returns a list of values
-- Use ANY when you want to compare a value to at least one value returned by a subquery
-- In this example retrieve the orderdates for orders between May 15 an 19
--   then search all orders where the orderdate is equal to any of the 
--   retrieved dates.

SELECT OrderNumber,OrderDate
FROM Orders
WHERE OrderDate = ANY (SELECT OrderDate
						FROM Orders
						WHERE Month(OrderDate) = 5 AND (DAY(OrderDate) between 15 and 19))
go

--Using IN is similar to using = ANY
SELECT OrderNumber,OrderDate
FROM Orders
WHERE OrderDate IN (SELECT OrderDate
						FROM Orders
						WHERE Month(OrderDate) = 5 AND (DAY(OrderDate) between 15 and 19))
go


-- All  on subquery
-- The subquery returns a list of values
-- Use ALL when you want to compare a value to every value returned by a subquery
-- usually used with the > , >=, < or <= operators

--Find the order with the highest profit
--knowledge needed: know all the profits (expression) by order
--examine this data and determine the highest profit
--Now, use the highest profit in comparing to all groups on the having clause

--step 1 create your calculated data set and place in a temporary dataset (name does not matter)
--       NOTE ALL columns in Select need a column name assigned

--SELECT SUM(Amount - (Quantity * Cost)) Profit
--              FROM ItemsOnOrder
--              GROUP BY OrderNumber 

--step 2 find the value you wish to use from this temporary dataset
--       place step 1 in ( ... step1 ...) on the FROM statement
--       use the column names from step1 in step 2 select (eg Profit)
--       Adding an 'as tempdatasourcename' at the end of your select places the data into a 
--				temporary dataset
--Select Max(Profit)
--        from (SELECT SUM(Amount - (Quantity * Cost)) Profit
--              FROM ItemsOnOrder
--             GROUP BY OrderNumber) as temp

--Step 3 use step 2 on one side of your having condition inside (... step2 ...)
SELECT     orderNumber,
            SUM(Amount - (Quantity * Cost)) AS Profit
FROM ItemsOnOrder
GROUP BY OrderNumber
-- the code on the right side of the = sign is the subquery
HAVING Sum(Amount - (Quantity * Cost)) = (Select Max(Profit)
                                          from (SELECT SUM(Amount - (Quantity * Cost)) 'Profit'
                                                FROM ItemsOnOrder
                                                GROUP BY OrderNumber) as temp)
go
--Find all the orders greater than or equal to the avg profit
SELECT     orderNumber,
            SUM(Amount - (Quantity * Cost)) AS Profit
FROM ItemsOnOrder
GROUP BY OrderNumber
-- the code on the right side of the = sign is the subquery
HAVING Sum(Amount - (Quantity * Cost)) >= (Select Avg(Profit)
                                          from (SELECT SUM(Amount - (Quantity * Cost)) 'Profit'
                                                FROM ItemsOnOrder
                                                GROUP BY OrderNumber) as temp)
go