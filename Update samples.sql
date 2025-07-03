use IQSchool
go

--UPDATE
-- used to alter the current value of a table attribute
-- can alter one or more row attributes at a time
-- can alter one or more rows of a table at a time
--   TAKE CARE the attribute on each row will have the assigning
--		value given to it
-- can use JOINS on your command, IF SO, you MUST use the optional
--   FROM clause
--the WHERE clause indicates which row(s) are to be altered
--IF NOT WHERE clause is specified then ALL table rows are altered
--IF WHERE clause is specified BUT condition is NOT MEET no row(s) are altere
--   AND the execution is NOT considered an error


-- UPDATE tablename
-- SET table attribute = constant,
--	   table attribute = expression,
--     table attribute = scalar subquery
--[FROM tablename INNER JOIN anotherTable
--    ON tablename.attribute = anotherTable.attribute]
--[WHERE tablename attribute = some value [AND/OR .....]]

--NOTES: all expressions and scalar subquery are done FIRST BEFORE
--       values are assigned to the receiving table attribute

-- Change the MaxStudents to 25 where the CourseID is DB1508A
SELECT 'Before', CourseID, MaxStudents
From Course
WHERE CourseId = 'DB1508A'
go
UPDATE Course
Set MaxStudents = 25
WHERE CourseId = 'DB1508A'
go
SELECT 'After', CourseID, MaxStudents
From Course
WHERE CourseId = 'DB1508A'
go

-- multiple rows being altered
-- expression is execute for each row
-- the expression result replaces the original value
SELECT 'Before', CourseID, MaxStudents
From Course
WHERE CourseId LIKE 'DB1508_'
go
UPDATE Course
Set MaxStudents = MaxStudents + 5
WHERE CourseId LIKE 'DB1508_'
go
SELECT 'After', CourseID, MaxStudents
From Course
WHERE CourseId LIKE 'DB1508_'
go

-- alter the MaxStudents for DB1508B to be the avg of the other
--   DB1508 courses
-- use a subquery to calculate the value to use
SELECT 'Before', CourseID, MaxStudents
From Course
WHERE CourseId = 'DB1508B'
go
UPDATE Course
Set MaxStudents = (SELECT AVG(MaxStudents)
					FROM Course
					WHERE CourseId LIKE 'DB1508_')
WHERE CourseId = 'DB1508B'
go
SELECT 'After', CourseID, MaxStudents
From Course
WHERE CourseId = 'DB1508B'
go

SELECT 'Before', CourseID, MaxStudents, CourseCost
From Course
WHERE CourseId = 'DB1508A'
go
UPDATE Course
Set MaxStudents = 25,
    CourseCost = CourseCost * 1.05
WHERE CourseId = 'DB1508A'
go
SELECT 'After', CourseID, MaxStudents, CourseCost
From Course
WHERE CourseId = 'DB1508A'
go

--WHERE condition on the UPDATE does not exist
SELECT 'Before', CourseID, MaxStudents, CourseCost
From Course
WHERE CourseId = 'DB1508A'
go
UPDATE Course
Set MaxStudents = 25,
    CourseCost = CourseCost * 1.05
WHERE CourseId = 'DB1508' --note the missing last character
go
SELECT 'After', CourseID, MaxStudents, CourseCost
From Course
WHERE CourseId = 'DB1508A'
go