-- this is a comment, note it starts with a double dash
-- a comment does not execute on the sql
-- it is for notes only

-- even though you can enter your code in any text editor
--		the extension for your file must be .sql for it 
--		to execute within the SSMS

-- the execution of your "script" is done as a query

-- to create a table within a database, one first needs the database
-- to create a database use the following command
-- once your database EXISTS, you comment out the command so it does NOT run again

-- CREATE DATABASE LearningDB

-- the go command tell the system to execute the previous commands
-- this is referred to as a "batch"
-- a batch starts at the top of your file and runs until 
--		a) the end of the file
--      b) encounters a go command

-- go

-- this batch will delete all existing table so that the next batch can create the table
-- Drop a table
-- dropping of tables can be done in one batch

-- WARNNG: when you drop a table, ALL data within the data is DESTROYED!!!!
--         when you drop a table, then the order is important, "child" tables (fkey table) MUST be dropped
--				BEFORE the "parent" table (Pkey table)



DROP TABLE ItemsOnOrder -- child table to Items
DROP TABLE Items
DROP TABLE Orders -- child table to Customers
DROP TABLE Customers
go

-- Creating a table
-- use the Data Definition Language (DDL) commands

-- each attribute (field) at minimum contains an attribute name and a datatype
--		in addition it could contain other directives to help description and restrict data within the attribute

-- the CustomerNumber attribute contains
-- a) the attribute name
-- b) the attribute datatype (it is a whole number: int)
-- c) OPTIONALLY request for the system to generate a value for this attribute ; IDENTITY(seed, increment)
-- d) state if a value is required (not null) or can be empty (null). NOTE; default is not null.
-- e) this attribute is consider the primary key of the table. Clustered instructs the system on how to
--		organize the index. The name pattern is prefix_table_attribute 
-- f) indicating an attribute to be a primary key means that the attribute will ALWAYS have an unique value
--		in the data record compared to all other records on the table
-- h) if a constraint is coded with the attribute, BY DEFAULT, the constraint is associated with that attribute

-- separate each attribute using a ,

-- the LastName attribute contains
-- a) the attribute name
-- b) the attribute datatype (a variable number of characters up to and include 100 characters)
-- c) state if a value is required (not null) or can be empty (null). NOTE; default is not null.


-- the FirstName attribute contains
-- a) the attribute name
-- b) the attribute datatype (a variable number of characters up to and include 100 characters)
-- c) state if a value is required (not null) or can be empty (null). NOTE; default is not null.

-- the Phone attribute contains
-- a) the attribute name
-- b) the attribute datatype (an exact number of 12 characters, xxx-xxx-xxxx)
-- c) state if a value is required (not null) or can be empty (null). NOTE; default is not null.

-- LastName and FirstName must have at least one character

CREATE TABLE Customers (
	CustomerNumber int IDENTITY(1, 1) not null
		CONSTRAINT PK_Customers_CustomerNumber primary key clustered,
	LastName       varchar(100) not null
		CONSTRAINT CK_Customers_LastName CHECK (LastName like '[a-zA-Z]%'), 
	FirstName       varchar(100) not null
		CONSTRAINT CK_Customers_FirstName CHECK (FirstName like '[a-zA-Z]%'), 
	Phone			char(12) null
)

-- CustomerNumber is a foreign key associated with the Customer table
-- The foreign key constraint can be coded with the attribute or at the end of the table
-- syntax: CONSTRAINT FK_tables_attribute FOREIGN KEY (attribute name on this table)
--			REFERENCES parenttablename (primary key attribute)

-- Place check constraints on the money attributes
-- the domain of the accept values is 0 or positive value
-- if a constraint test is only against the attribute then
--		the constraint can be code (and usually is) on the
--		declaration of the attribute
-- OTHERWISE you must create a table level constraint

CREATE TABLE Orders (
	OrderNumber	int IDENTITY(5,5) not null
		CONSTRAINT PK_Orders_OrderNumber primary key clustered,
	OrderDate	smalldatetime	not null,
	CustomerNumber	int			not null
		CONSTRAINT FK_OrdersCustomers_CustomerNumber FOREIGN KEY (CustomerNumber)
			REFERENCES Customers (CustomerNumber),
	Subtotal		money		not null
		CONSTRAINT CK_Orders_Subtotal CHECK (Subtotal >= 0),
	GST				money		not null
		CONSTRAINT CK_Orders_GST CHECK (GST >= 0),
	Total			money		not null
		CONSTRAINT CK_Orders_Total CHECK (Total >= 0)
)

-- IMPORTANT!!!!!
-- Order of table declaration is important
-- All tables that will be used in a relationship (pkey to fkey) MUST have the "parent" table (PKey) declared
--		BEFORE the attribute is later used in a foreign key constraint


-- You could place your single attribute primary key constraint at the end of the table
-- If you do so, then you must indicate the attribute in the table
CREATE TABLE Items (
	ItemNumber		int IDENTITY(1, 1) not null,
	Description     varchar(100)	not null, 
	CurrentPrice	money			not null,
	CONSTRAINT PK_Items_ItemNumber primary key clustered (ItemNumber)
)

-- The primary key for a compound table has its constraint at the end of the table AFTER all attribute.
-- This is referred to as a table constraint
-- Foreign key constraints on a compound primary key table can have the constraint place on the appropiate
--		attribute.

-- IMPORTANT !!!!!!!!!!!!!!
-- any table that has a foreign key constraint MUST be declare AFTER the "parent" table with the primary key

-- the Amount value must be equal to the Price * Quantity
-- since there are multiple different attributes within this
--		constraint, the constraint must be coded at the table
--		level
CREATE TABLE ItemsOnOrder (
	OrderNumber		int			not null
		CONSTRAINT FK_ItemsOnOrderOrders_OrderNumber FOREIGN KEY (OrderNumber)
			REFERENCES Orders (OrderNumber),
	ItemNumber		int			not null
		CONSTRAINT FK_ItemsOnOrderItems FOREIGN KEY (ItemNumber)
			REFERENCES Items (ItemNumber),
	Quantity		int			not null,
	Price			money		not null,
	Amount			money		not null,
	CONSTRAINT PK_ItemsOnOrder_OrderNumberItemNumber primary key clustered (OrderNumber, ItemNumber),
	CONSTRAINT CK_ItemsOnOrder_AmountQuantityPrice 
		CHECK (Amount = Price * Quantity)
)


go