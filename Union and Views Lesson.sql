use IQSchool
go
-- Union [ALL]
-- Union can be used to create one result set from the results of more than one query

--Rules
--a) The queries being combined must have the same number of columns 
--b) the columns must be of compatible (similar) datatypes
--c) The column names of the results are taken from the first table in the Union
--d) Any ordering is done on the last query
--e) Union removes duplicate rows (each row is a set of unique values although
--    there may be duplicate values in a particular column between rows)
--f) if you wish to have all rows regardless of duplicate rows, use Union ALL

SELECT Staffid 'ID', LastName + ', ' + FirstName 'Name', ' ' 'Gender',PositionDescription 'Status'
FROM Staff s INNER JOIN Position p
  ON s.PositionID = p.PositionID
UNION
SELECT StudentID , LastName + ', ' + FirstName, Gender, '  ' 
FROM Student s 
 
Order By 2 

--Make the union query a view
--Benefits
-- 1. Simplicity and Abstraction
-- Simplifies complex queries: Views can encapsulate joins, 
--      subqueries, and calculations
-- Instead of repeating a complex query with multiple joins, 
--      users query the view like a table
-- 2. Data Security
-- Limits data exposure: You can expose only specific columns or rows 
--      via a view, protecting sensitive data
-- Supports GRANT/REVOKE: Permissions can be set on views to restrict access 
--      without modifying the underlying tables
-- 3. Logical Data Independence
-- Decouples applications from base table structure: If table structure changes, 
--      the view can be updated without impacting application code using it.
-- Useful in evolving schemas
-- 4. Reusability and Maintainability
-- Once defined, a view can be used in multiple queries or reports, promoting 
--      consistency and reducing duplication.
-- Easier to maintain logic in one place
-- 5. Performance (in some cases)
-- Helps especially with expensive aggregations or joins

-- Caveats
-- Views don’t store data (unless materialized); they reflect 
--      live data from the base tables
-- Poorly designed views (especially nested ones) can hurt performance
-- Not all views are updatable — especially if they involve joins, 
--     aggregations, or DISTINCT
-- cannot use all query clauses in a view: order by

-- Views can be DROP like other sql objects
DROP VIEW IF Exists NameList
go

--To create a VIEW use 
--    CREATE VIEW viewname
--    as
--      query

CREATE VIEW Namelist
as
SELECT Staffid 'ID', LastName + ', ' + FirstName 'Name', ' ' 'Gender',PositionDescription 'Status'
FROM Staff s INNER JOIN Position p
  ON s.PositionID = p.PositionID
UNION
SELECT StudentID , LastName + ', ' + FirstName, Gender, '  ' 
FROM Student s 

go

--how to use a View
-- treat the VIEW as another table
-- the columns of the VIEW table are the column names used in creating the view in the first place
-- the user sees the follows columns: ID, Name, Gender, Status

--Can views be used in joins, subqueries: YES
--Why? a view generates a table of data
SELECT ID, Name, Gender
FROM Namelist --name of the view is used as the table name
Order by Name  --order by is NOT allowed on the view, ordering is a decision of the USER
go
