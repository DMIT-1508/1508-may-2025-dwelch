-- the use command will tell the system which database that this follow commands whould be executed in.

use LearningDB
go
-- Customers
-- loading of data using JUST the create table script
--INSERT INTO Customers (LastName, FirstName, Phone) VALUES
--('Ujest', 'Shirley','780-123-4567'),
--('Behold', 'Lowand','780-987-7654'),
--('Stew-Dent','Iam','589-384-5647')
--go

-- loading of data AFTER the execution of ALTER commands
INSERT INTO Customers (LastName, FirstName, Phone, City, Province) VALUES
('Ujest', 'Shirley','780-123-4567','Edmonton','AB'),
('Behold', 'Lowand','780-987-7654','Edmonton','AB'),
('Stew-Dent','Iam','589-384-5647','Edmonton','AB')
go

-- Orders
INSERT INTO Orders(OrderDate,CustomerNumber, SubTotal, GST, Total) VALUES
('2025/05/11',1,186.07, 9.30,195.37),
('2025/05/11',2,304.98, 15.25,320.23),
('2025/05/17',1,71.97, 3.60,75.57),
('2025/05/18',1,111.14, 5.56,116.70),
('2025/05/21',3,166.20, 8.31,174.51)
go

-- Items
INSERT INTO Items(Description, CurrentPrice, CurrentCost) VALUES
('Yellow solid door - standard',74.66, 42.56),
('Red solid door - standard',74.66, 42.56),
('Standard door frame',41.67, 28.75),
('Claw Hammer',21.45, 12.95),
('3 in Wood Screw X 10',6.99, 5.26),
('3 in Wood Screw 3 lb',23.99, 16.77),
('2.5 in Wood Screw X 10',6.99, 5.26),
('2.5 in Wood Screw 3 lb',23.99, 16.77),
('Multi-Speed Hand Drill',89.69, 62.45),
('Standard solid door',71.66, 38.99),
('3 window solid door',110.55, 82.55),
('Solid plank trim X 8 ft',15.25, 8.44)

INSERT INTO ItemsOnOrder(OrderNumber,ItemNumber, Quantity, Price, Amount, Cost) VALUES
(5,2,1,74.66,74.66,42.56),
(5,6,1,23.99,23.99,16.77),
(5,3,1,41.67,41.67,28.75),
(5,12,3,15.25,45.75,8.44),
(10,6,2,23.99,47.98,16.77),
(10,10,2,71.66,143.32,38.99),
(10,9,1,89.69,89.69,62.45),
(10,8,1,23.99,23.99,16.77),
(15,6,3,23.99,71.97,16.77),
(15,9,1,89.69,89.69,62.45),
(20,4,1,21.45,21.45,12.95),
(25,11,1,110.55,110.55,82.55),
(25,3,1,41.67,41.67,28.75),
(25,7,2,6.99,13.98,5.26)