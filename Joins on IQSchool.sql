use IQSchool
go

SELECT Left(FirstName,1) + ' ' + Lastname 'Staff' ,PositionDescription 'Position'
		
FROM Position INNER JOIN Staff
	ON Position.PositionID = staff.PositionID
Order by LastName
go

-- Select Student full names and the course ID's they are 
--   registered in, order by student name

-- student names ( Students  )
-- courseid ( Offering  )

-- Join is necessary: Students -> Registration -> Offering

SELECT LastName + ', ' + FirstName 'Student',
		CourseID 'Course'
FROM Student Inner JOIN Registration
		ON Student.StudentID = Registration.StudentID
	  INNER JOIN Offering
	    ON Registration.OfferingCode = Offering.OfferingCode
Order by 1 -- reminder you can use the column number on clause
go

-- Select the Student full name, courseID's and 
--   marks for studentID 199899200

-- student names ( Student )
-- courseid ( Offering )
-- marks ( Regisgtration )

-- on the FROM clause you CAN use an alias for the table name
-- WHY: sometimes is quicker to type the alias then the table name
--the alias name MUST be unique
--VERY IMPORTANTT!!! if you use the alias name then you MUST
--					 use the alias name throughout the query
--YES, you can mix using alias names and full table names on your query

-- Syntax:  FROM tablename aliasname INNER JOIN tablename aliasname

SELECT LastName + ', ' + FirstName 'Student',
		CourseID 'Course',
		Mark
FROM Student s Inner JOIN Registration r
		ON s.StudentID = r.StudentID
	  INNER JOIN Offering 
	    ON r.OfferingCode = Offering.OfferingCode
WHERE s.studentID = 199899200
go

-- What Staff Full Names have taught IT System Administration?

-- Staff Names ( Staff )
-- Technical Support Staff values is in ( Position  )

--the join will use the PositionID
--I have NO idea what the id is for the position description

SELECT FirstName + ' ' + LastName,PositionDescription, p.PositionID
FROM Staff s INNER JOIN Position p
	ON s.PositionID = p.PositionID
WHERE PositionDescription = 'Technical Support Staff'
go

--How to display all records of a particular table joined to another
--		table IF there is NO pkey = Fkey in existence?

-- use another version of JOINS: Right OUTER and Left OUTER join
--
-- The use of the Right or Left depends on the position in your
--		join of the table that has the excess data

--get all positions regardless of whether they are filled or not

-- We all the records from Position
--What side of the JOIN statement is the Position table coded? : Right side

-- NOTE: the missing data from the other table will be null

SELECT FirstName + ' ' + LastName,PositionDescription, p.PositionID
FROM Staff s Right Outer JOIN Position p
	ON s.PositionID = p.PositionID --on is the relationship
go

--so the LEFT OUTER JOIN would not work here because it is taking
--		all the records from the left table on the JOIN

SELECT FirstName + ' ' + LastName,PositionDescription, p.PositionID
FROM Staff s Left Outer JOIN Position p
	ON s.PositionID = p.PositionID --on is the relationship
go

--NOTE by switching the order of the tables on the FROM, using the
--	LEFT OUTER JOIN works again

SELECT FirstName + ' ' + LastName,PositionDescription, p.PositionID
FROM Position p Left Outer JOIN  Staff s
	ON s.PositionID = p.PositionID --on is the relationship
go

-- CAN one use ALL INNER JOIN and LEFT OUTER JOIN and RIGHT OUTER JOIN
--   in the same query
-- YES !!!!!!!!!!