use IQSchool
go

--The delete statement removes rows from a table. It does not act on
--individual columns as you can only delete a row and not a column.

--delete is different from drop as the delete command does not
--   remove the table

--DELETE [ from ] table name
--[ FROM clause ]
--[ WHERE clause ]

--[ from ] - optional
--- makes the statement more ENGLISH like on the DELETE clause
--table name - required
--- identifies the table you want to delete rows from

--FROM clause - optional
--- identifies additional tables referenced in the where clause
--- lets you delete rows in table A based on data
--       recorded in a different table ( table B )

--WHERE clause - optional
--- identifies which rows to delete from the table
--- if not coded ALL rows are deleted

--NOTES:
-- IF your tables DO NOT have IDENTITY pkey for the parent table
--    of your relationship AND you have a script of inserts,
--    your script should execute and replace the drop records

-- IF your tables DOES have IDENTITY pkey for the parent table
--    of your relationship AND you have a script of inserts,
--    your script will NOT execute UNLESS you UPDATE all the
--    values in your foreign key tables to the NEW IDENTITY values
--    created when the parent table record were re-added.

SELECT 'Before', CourseID, MaxStudents
From Course
WHERE CourseId Like 'DB1508_'
go
DELETE Course
WHERE CourseId = 'DB1508B'
go
SELECT 'Before', CourseID, MaxStudents
From Course
WHERE CourseId Like 'DB1508_'
go

--delete multiple rows
SELECT 'Before', CourseID, MaxStudents
From Course
WHERE CourseId Like 'DB1508_'
go
DELETE Course
WHERE CourseId Like 'DB1508_'
go
SELECT 'Before', CourseID, MaxStudents
From Course
WHERE CourseId Like 'DB1508_'
go