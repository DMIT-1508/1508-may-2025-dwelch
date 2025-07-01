-- Can one use more than a single attribute on a select column
-- Yes
-- In the IQSchool database we concatenated the FirstName and LastName
--     Select LastName + ', ' + FirstName [as] 'Name', ....
--     From Student

-- LastName + ', ' + FirstName is referred to as an expression

-- can we do other types of expression
-- calculation expression

-- display the Amount,Price, Quantity, Cost and Profit for each record on ItemsOnOrder
-- step 1; discover the datasource : ItemsOnOrder
-- step 2: identify the attributes from the datasource: Amount Price Cost but not the Profit
-- step 3: can the missing requested data be created from existing attributes: YES
--          Profit = Amount - Quantity * Cost (this is an expression to be use on your Select)
-- the equation uses basic math properties. 
-- even though ( ) is not need here, it is wise to use (  ) for better understanding of the expression

-- Cost what we pay the manufacture for the item
-- Price is what we sell the item to our customers for

--Reminder: by default the column name (title, alias) is the attribute name IF ONLY the attribute is the column
--          if the column is an expression then you MUST given the column a name (CLASS STANDARD)
--              new column name SHOULD be in single quotes HOWEVER if the column name is
--                     a single character string (no blanks) you CAN omit the single quotes

SELECT Amount, Price, Quantity, Cost, Amount - (Quantity * Cost) as 'Profit'
FROM ItemsOnOrder
--order by Profit  --can use new column names on your order by
go

--Distinct keyword
-- returns rows that are distinct from each other in the final display

-- all rows
-- the keyword All can be added to the Select BUT it is the implied default
Select  city
FROM Customers
go 

--display only rows that are different from each other
--all cities are Edmonton (3 rows)
--if Distinct works then only one row should appear
SELECT DISTINCT city
FROM Customers
go 

-- do we get 3 rows when the city is identical
-- well DISTNCT applies to the row NOT a single attribute
-- Note: the value of Phone on each row is unique
--        therefore each row is unique
SELECT DISTINCT city, Phone
FROM Customers
go 

-- Aggregates
--What are Aggregates
--these are built in functions within sql


-- COUNT()
--use: used for calculating the number of ..., how many ..., etc

--syntax
--  count(*) : counts the number of rows in a datasource regardless of the attribute values,
--                whether an attribute is null or has a value
--  count(attribute) : counts the number of rows in a datasource WHERE the attribute HAS a value,
--                      rows where the attribute value is null, is NOT COUNTED
--  count (DISTINCT attribute) : counts the distinct number of values in the attribute

SELECT count (*) 'Num of Items'
FROM ItemsOnOrder
go

--preferred method of count over using *
--replace * with the pkey attribute of the table
--IF the table has a compound pkey, only one of the attribute of the key is required
SELECT count (OrderNumber) 'Num of Items'
FROM ItemsOnOrder
go

--count the number of times an item sold across all orders
-- display the itemnumber and count of times sold

--Why: IF an attribute is within an aggregate function, regardless of numbe of aggregates on your SELECt
--       there is NO NEED for a GROUP BY clause
--     HOWEVER ANY attribute or expression NOT in an aggregate function on your SELECT, MUST also
--       appear on a GROUP BY clause in your query
--The GROUP BY clause follows the WHERE clause if you have a WHERE clause

--Note the aggregate attribute did not need to be on the Group BY
--image a large pile of paper (each represents at record)
--separate the large pile of paper using the ItemNumber into individual piles: This is grouping by attribute

SELECT ItemNumber, count (OrderNumber) 'Num of Items'
FROM ItemsOnOrder
GROUP BY ItemNumber
go

--group by the ordernumber
--how many different items were sold on each oder
SELECT OrderNumber, count (OrderNumber) 'Num of Items'
FROM ItemsOnOrder
GROUP BY OrderNumber
go

--can we use an expression in an aggregate?
--yes
SELECT OrderNumber, count (OrderNumber) 'Num of Items',
		sum(Amount) 'Order Total', sum(Amount - (Quantity * Cost)) 'Profit'
FROM ItemsOnOrder
GROUP BY OrderNumber
go

SELECT ItemNumber, count (OrderNumber) 'Num of Items',
		sum(Amount) 'Order Total', sum(Amount - (Quantity * Cost)) 'Profit'
FROM ItemsOnOrder
GROUP BY ItemNumber
go

--what if the expression is NOT in an aggregate
--REMEMBER ANY attribute not with in an aggregate even if in an expression; The attribute/expression
--     MUST appear on the GROUP BY

--NOTE here that the display line uses ALL GROUP BY attributes/expression to determine the group
SELECT ItemNumber, count (OrderNumber) 'Num of Items',
		sum(Amount) 'Order Total', sum(Amount - (Quantity * Cost)) 'Profit'
		, Amount - (Quantity * Cost) 'non agg exp'
FROM ItemsOnOrder
GROUP BY ItemNumber,  Amount - (Quantity * Cost)
go

-- other aggregates
-- sum, max, min, avg 
-- each needs an attribute or expression
-- NOTE unlike count(*), you cannot use the * in these aggregates!!!!!!!!
-- sum : use when you need to tally, total, etc
--     : needs to be numeric
--     : adding the numer column values together to get a single value
-- max : use when you need to find the largest, highest, most
--     : can be used against numerics and strings and dates
--          - numerics : highest numeric value in a sequence
--          - string : last in the ascending alphabet order of string regardless of string length
--          - dates : latest date
--     : ignores records with null values
-- min : use when you need to find the smallest, lowest, least
--     : can be used against both numerics and strings and dates
--          - numerics : lowest numeric in sequence
--          - string : first in the ascending alphabet order of string regardless of string length
--          - dates : earliest date
--     : ignores records with null values
-- avg : use when you need to find an average in a series of numbers
--     : needs to be numeric

SELECT max(CurrentPrice) 'Max Price', min(CurrentPrice) 'Min Price', avg(CurrentPrice) 'Avg Price'
FROM Items
go

-- Filering a group: HAVING clause
--how to filter (like the where) on a group
--it applies its criteria after group by has grouped its aggregate data. 
--MUST have a group by to work
--can use aggregates on clause whereas where clause CANNOT use aggregates

--Which orders have more than 3 items on it.
Select OrderNumber, count(ItemNumber) 'items on Order'
from ItemsOnOrder
group by OrderNumber
--filter the piles of orders finding which orders have more that 3 items
Having count(itemnumber) > 3 
go

--BAD aggregate test, aggregates on where clause NOT ALLOWED
Select OrderNumber, count(ItemNumber)
from ItemsOnOrder
--WARNING!!!! An aggregate may not appear in the WHERE clause unless it is in a subquery 
--            contained in a HAVING clause or a select list, and the column being aggregated is 
--            an outer reference
where count(itemnumber) > 3 
group by OrderNumber
go

--Which orders have a profit greater than 100.00 and at least 4 items on it
--Similar to the WHERE clause, you can have multiple conditions on your HAVING clause
--		and use the logical operators
Select OrderNumber, count(ItemNumber) 'Qty Sold',  
		sum(Amount - (Quantity * Cost)) 'Profit'
from ItemsOnOrder
group by OrderNumber
Having sum(Amount - (Quantity * Cost)) > 100
       AND
       count(ItemNumber) > 3
go

--Subqueries
--using a subquery to solve aggregates against expressions
--typically use when you need to generate information from your data
--   to use to compare to your data
-- kind of like the " chicken and egg" problem
--here I need to know the highest profit first
--    then I can compare all the other profits to that highest profit

--Find the order with the highest profit
--knowledge needed: known all the profits (expression) by order
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
                                       from (SELECT SUM(Amount - (Quantity * Cost)) Profit
                                          FROM ItemsOnOrder
                                          GROUP BY OrderNumber) as temp)