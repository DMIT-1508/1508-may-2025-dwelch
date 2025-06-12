use LearningDB
go
-- This file assumes that you have a live database that has been in active for some period of time
-- You CANNOT drop the tables and change your create definitions BECAUSE you have live data that
--          CANNOT be replaced

-- You need to make the changes to the table definitions using the ALTER command

-- Example 1: Add a field to a table
--    this field will ALSO be added to existing records on the Table
--    since I have NO value for the existing records, one needs to make the field nullable

ALTER TABLE Customers
	ADD City varchar(25) null

-- Example 2: Add a field to a table that needs a not null
--    in this scenario, you WILL need to supply a DEFAULT constraint ALONG with adding the field

ALTER TABLE Customers
    ADD Province char(2) not null
	CONSTRAINT DF_Customers_Province DEFAULT 'AB'
	CONSTRAINT CK_Customers_Province CHECK (Province like '[a-zA-Z][a-zA-Z]')

-- Example 3: Add a constraint to a table
--     add a check constraint to Items such that CurrentPrice is zero or greater
--     to add the constraint without checking the existing data use the with NOCHECK

ALTER TABLE Items
	with NOCHECK
	ADD CONSTRAINT CK_Items_CurrentPrice CHECK(CurrentPrice >= 0)

-- Example 4: Add multiple constraints to a single field on a table
--    add a check and default constraint to Quantity in the ItemsOnOrder table
--    when adding a default constraint BY ITSELF to a table you MUST also use the FOR fieldname on 
--           the constraint declaration

ALTER TABLE ItemsOnOrder
	ADD CONSTRAINT CK_ItemsOnOrder_Quantity CHECK(Quantity >= 0),
	    CONSTRAINT DF_ItemsOnOrder_Quantity DEFAULT 0 FOR Quantity