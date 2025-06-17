-- the use command will ensure that the indicated database
--	will be made the active database for this script

use IQSchool
go

-- WARNING!!!!!!!!!!!!!!!!!!!!
--
-- Using SELECT * to obtain your field from a table is FORBIDDEN in this course
-- Any query using the * to your fields will result in a mark of zero for the question
--


-- The Select clause indicates the columns to be report on
-- The From clause indicates the source of the data to be used (table(s))
-- By default the column header of your report is the name of the field that you have selected
--		on the SELECt clause
-- You can alter the column name by adding a string after the column
-- You can replace a column with an expression
--		eg. concatenation of columns display the first and last name as a single column

--SELECT firstname, lastname, city
--SELECT firstname 'First', lastname 'Last', city
--SELECT firstname + ' ' + lastname 'Name', city
SELECT lastname + ', ' + firstname 'Name', city
FROM Student
go

-- the Order by clause will reorganize the display of your information
--    it is the last step in processing your query
-- the default for ordering is asc (ascending)
-- you can order by desc (descending)
-- you can have multiple columns for sorting
-- each column can have their own sort direction
-- optional you can refer to the column in the SELECT by column number (eg 1, 2, ...

SELECT firstname, lastname, city, StudentID
FROM Student
--ORDER BY lastname, firstname 
--ORDER BY lastname desc, firstname 
ORDER BY 2 desc, firstname 
go

-- The Where clause follows the FROM clause
-- The Where clause "filters" the data on the database such that ONLY the record
--		that pass the where clause condition are returned to the query
-- NOTE: the condition can use a column (table attribute) that is NOT in the columns to
--		be returned BUT MUST be in the data source (FROM table(s))
-- There are several forms of the where clause

--Relative operator test
-- Relative operators are = > < >= <= != or <>

SELECT firstname, lastname, city, BalanceOwing
FROM Student
--WHERE StudentID = 200522220
--WHERE LastName = 'Petroni'
--WHERE BalanceOwing > 0
--WHERE LastName != 'Petroni'
WHERE LastName <> 'Petroni'
go

-- Multiple conditions
-- one can use the Logial operators of "and" and/or "or" between your conditions
-- truth tables
--     Condition   A   B   Result
--        and      T   T    true and record is part of result
--                 T   F    fails and record is NOT part of results
--                 F   T    fails and record is NOT part of results
--                 F   F    fails and record is NOT part of results

--        or       T   T    true and record is part of result
--                 T   F    true and record is part of result
--                 F   T    true and record is part of result
--                 F   F    fails and record is NOT part of results

--NOTE: when you use multiple condition you MUST code the entire condition, no shortcuts

-- Display a list of student fullnames and city who have a balance between $10000 and $20000 inclusive
SELECT Lastname + ', ' + FirstName, city, BalanceOwing
FROM Student
WHERE BalanceOwing >= 10000.00 and BalanceOwing <= 20000.00
go

-- Between criteria syntax

--syntax WHERE attriute [NOT] BETWEEN value1 and value2
SELECT Lastname + ', ' + FirstName, city, BalanceOwing
FROM Student
--WHERE BalanceOwing BETWEEN 10000.00 and 20000.00
WHERE BalanceOwing NOT BETWEEN 10000.00 and 20000.00
       and BalanceOwing > 0
go

-- What if I had a list of items to check against
-- Is there a short way of specifying the list
--Yes
-- list operator which is: [NOT] IN (list of values)

-- Select the student from Edmonton, Calgary and Leduc
SELECT Lastname + ', ' + FirstName, city, BalanceOwing
FROM Student
--WHERE City IN ('Edmonton','Calgary','Leduc')
WHERE City = 'Edmonton' or City = 'Calgary' or city = 'Leduc'