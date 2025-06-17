-- Simple Exercise 1

use IQSchool
go

-- Select all the information from the club table
SELECT ClubId, ClubName
FROM Club

-- NOTE using the following query would result in a mark of zero for the answer
--SELECT *
--FROM Club
go

-- Select the FirstNames and LastNames of all the students
-- Display the names in on column (first last)
-- Give an appropriate title to the column
-- Order by the last name.
--Optionally IF your column aliases is a single word string, you could omit the single quotes 
--		around the column aliases title

--SELECT FirstName + ' ' + LastName 'Name'
SELECT FirstName + ' ' + LastName Name
FROM Student
ORDER BY LastName

go

-- Select all the CourseId and CourseName of all the coureses. Use the column aliases of
-- Course ID and Course Name
--Optionally you could use the 'as' indicated when specifying your column aliases titles


--SELECT CourseId 'Course ID', CourseName 'Course Name'
SELECT CourseId as 'Course ID', CourseName 'Course Name'
FROM Course

go

-- Select all the course information for courseID 'DMIT1001'
-- NOTE: sql is not case sensitive

SELECT CourseId ID, CourseName Name, CourseHours 'Hours', MaxStudents 'Max Limit', Coursecost Cost
FROM Course
WHERE courseid = 'dmit1001'
go

-- Select the Staff names who have positionID of 3
SELECT Lastname + ', ' + Firstname Staff
FROM Staff
WHERE PositionID = 3
go

-- Select the CourseNames whos CourseHours are less than 96
SELECT Coursename
FROM Course
WHERE CourseHours < 96
go

-- Select from the registrations the studentID's, OfferingCode and mark where the Mark is between 70 and 80

SELECT studentid Student, OfferingCode Offering, Mark
FROM Registration
--WHERE Mark > 70 and Mark < 80 
--WHERE Mark >= 71 and Mark <= 79
WHERE Mark BETWEEN 71 and 79
go

-- Select the staff in positions 1,2 and 3. Display the staff name and position.
SELECT Firstname + ' ' + LastName, Positionid
FROM Staff
--WHERE PositionID IN (1,2,3)
WHERE PositionID NOT IN (1,2,3)
go

