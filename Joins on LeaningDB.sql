use LearningDB
go

SELECT Items.Description, count (OrderNumber) 'Num of Items'
FROM ItemsOnOrder INNER JOIN Items
	ON ItemsOnOrder.ItemNumber = Items.ItemNumber
GROUP BY Items.Description
go

--Create a list of order details showing the customer full name,
--   order date, the item name and quantity purchased

--decide where the data needed for the report exists on the db
-- name : Customer (firstname and lastname)
-- order date: Orders (orderdate)
-- item name: Items (Description)
-- quantity purchased: ItemsOnOrder (Quantity)

SELECT LastName + ', ' + FirstName 'Customer',
		OrderDate, Description, Quantity 'Qty'
FROM Customers INNER JOIN Orders
	ON Customers.CustomerNumber = Orders.CustomerNumber
	  INNER JOIN ItemsOnOrder
	ON Orders.OrderNumber = ItemsOnOrder.OrderNumber
	  INNER JOIN Items
	ON ItemsOnOrder.ItemNumber = Items.ItemNumber

go

-- How many times has a item been sold. Report on all items

SELECT Description, count(ItemsOnOrder.ItemNumber) 'Times Sold'
FROM Items LEFT OUTER JOIN ItemsOnOrder
     ON Items.ItemNumber = ItemsOnOrder.ItemNumber
Group By Description
Order by 2 desc
go

SELECT Description, count(Items.ItemNumber) 'Times Sold'
FROM Items LEFT OUTER JOIN ItemsOnOrder
     ON Items.ItemNumber = ItemsOnOrder.ItemNumber
Group By Description
Order by 2 desc
go

-- remember we said you could use count(*)
SELECT Description, count(*) 'Times Sold'
FROM Items LEFT OUTER JOIN ItemsOnOrder
     ON Items.ItemNumber = ItemsOnOrder.ItemNumber
Group By Description
Order by 2 desc
go