use LearningDB
go
-- Customers
INSERT INTO Customers (LastName, FirstName, Phone) VALUES
('Ujest', 'Shirley','780-123-4567'),
('Behold', 'Lowand','780-987-7654'),
('Stew-Dent','Iam','589-384-5647')
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
INSERT INTO Items(Description, CurrentPrice) VALUES
('Yellow solid door - standard',74.66),
('Red solid door - standard',74.66),
('Standard door frame',41.67),
('Claw Hammer',21.45),
('3 in Wood Screw X 10',6.99),
('3 in Wood Screw 3 lb',23.99),
('2.5 in Wood Screw X 10',6.99),
('2.5 in Wood Screw 3 lb',23.99),
('Multi-Speed Hand Drill',89.69),
('Standard solid door',71.66),
('3 window solid door',110.55),
('Solid plank trim X 8 ft',15.25)

INSERT INTO ItemsOnOrder(OrderNumber,ItemNumber, Quantity, Price, Amount) VALUES
(5,2,1,74.66,74.66),
(5,6,1,23.99,23.99),
(5,3,1,41.67,41.67),
(5,12,3,15.25,45.75),
(10,3,2,23.99,47.98),
(10,10,2,71.66,143.32),
(10,9,1,89.69,89.69),
(10,8,1,23.99,23.99),
(15,6,3,23.99,71.97),
(15,9,1,89.69,89.69),
(20,4,1,21.45,21.45),
(25,11,1,110.55,110.55),
(25,3,1,41.67,41.67),
(25,7,2,6.99,13.98)