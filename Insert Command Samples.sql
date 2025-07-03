--Add the following records into the Club Table
--ClubID	ClubName
--NASAPIC		Camera and Picture Club
--Hockey		Student Hockey
--Dance			NAIT Student Dancing

-- Each INSERT can be done within its own batch
-- Steps
--  1) ALWAYS check your pkey for the table and determind
--		whether a value needs to be supplied or not
--  
--    IF the pkey is an IDENTITY pkey, then you DO NOT
--			supplied a value for that attribute BECAUSE
--			the sql system will supply the value
--
--	  IF the pkey is NOT an IDENTITY pkey, then you MUST
--			supply the value for that attribute
--
--Create your insert command with the column attribute
--		List
--    a) typically the list is in the same order as the
--			attributes on the table
--    b) the order of the column attribute list dicates the
--			order of the supplied values
--    c) if an attribute has a DEFAULT constraint, then you
--          have 3 options:
--			: include the attribute in the list and supply a value
--			: include the attribute in the list and use DEFAULT and the constraint kicks in
--          : omit the attribute from the list and the constraint kicks in
--    d) if the attribute defined as nullable, use the keyword
--				null if you have no value
INSERT INTO Club(ClubId,ClubName)
VALUES ('NASAPIC','Camera and Picture Club')
go
INSERT INTO Club(ClubId,ClubName)
VALUES ('Hockey','Student Hockey')
INSERT INTO Club(ClubId,ClubName)
VALUES ('DANCE','NAIT Student Dancing')
go

--2. Add the following records into the Course Table
--   MaxStudents can be null
--   CourseCost and MaxStudents have a default of 0

-- CourseID CourseName CourseHours MaxStudents CourseCost
-- DB1508A DataBase Design 10 32 160.00
-- DB1508B Query Your Database 20 null 350.00
-- DB1508C Maintaining Data 6 25 DEFAULT
-- DB1508D Trigger Not Your Horse 15  300.00

-- CourseID is NOT an IDENTITY attribute
INSERT INTO Course (CourseId, CourseName, CourseHours, MaxStudents, CourseCost)
VALUES('DB1508A','DataBase Design',10, 32, 160.00)
INSERT INTO Course (CourseId, CourseName, CourseHours, MaxStudents, CourseCost)
VALUES('DB1508B','Query Your Database',20, null, 350.00)
INSERT INTO Course (CourseId, CourseName, CourseHours, MaxStudents, CourseCost)
VALUES('DB1508C','Maintaining Data',20, 25, DEFAULT)
-- note MaxStudents has been removed from the column attribute list which
--		should cause the system to invoke the default constraint for the attribute
INSERT INTO Course (CourseId, CourseName, CourseHours,  CourseCost)
VALUES('DB1508D','Trigger Not Your Horse',15, 300.00)
go

-- using a subsquery as on of your values
-- insert an instructor 
-- since I do not know the pkey value for the position Instructor, I will use a
--		scalar subquery to obtain the need value
INSERT INTO Staff(StaffID, FirstName, LastName, DateHIred, DateReleased,PositionID,LoginID)
VALUES(12,'Don','Welch',DEFAULT,null,(SELECT PositionID From Position WHERE PositionDescription = 'Instructor'),null)
go


use LearningDB
go

--using an IDENTITY insert
-- NOTE: the pkey value is NOT supplied
--
-- Description, CurrentPrice, CurrentCost

INSERT INTO Items(Description,CurrentPrice,CurrentCost)
VALUES ('8 X 4 X 2 deck planks - Cedar', 9.75, 6.78)
go
-- NOTE the order of the column attribute list does not match the 
--		attribute table order
INSERT INTO Items(Description,CurrentCost,CurrentPrice)
VALUES ('8 X 4 X 2 deck planks - Spruce', 3.75, 6.78)
go
INSERT INTO Items(CurrentCost,Description,CurrentPrice)
VALUES (6.75,'12 X 4 X 2 deck planks - Spruce',  9.35)
go

--an alternative way of specfying your multiple inserts into a
--		single table within one insert
INSERT INTO Items(Description,CurrentPrice,CurrentCost) VALUES
('8 X 4 X 2 deck planks - ManMade', 9.75, 6.78),
('12 X 4 X 2 deck planks - ManMade', 14.75, 8.78),
('8 X 4 X 4 deck planks - ManMade', 12.75, 9.78),
('12 X 4 X 4 deck planks - ManMade', 16.75, 12.78)
go