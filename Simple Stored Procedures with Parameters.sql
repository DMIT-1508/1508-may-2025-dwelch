use IQSchool
go
--Create a procedure using the samples from Variable and Flow Control

--Creating a procedure syntax
--CREATE PROCEDURE proc-name
--as
--    sql statements
--RETURN

--removing a procedure
--DROP PROCEDURE proc-name

--executing a procedure
--EXEC proc-name or EXECUTE proc-name

DROP PROCEDURE IF EXISTS ClubActivity
DROP PROCEDURE IF EXISTS StudentMoneyStatus
DROP PROCEDURE IF EXISTS StudentThere
go

-- CLASS STANDARD!!!
-- ALL parameters unless explicitly stated MUST have a default value
--  and that value is to be null

CREATE PROCEDURE ClubActivity(@clubid varchar(10) = null)
as

--create a variable using the DELCARE statement
DECLARE @results varchar(40)
DECLARE @count int

-- CHECK that your incoming parameters have been given a value
--      that is expected in running the procedure

IF (@clubid is null)
BEGIN
    -- missing parameter would not be able to execute procedure logic
    RaisError('Missing parameter value for Clubid.',16,1)
END
ELSE
BEGIN
    -- parameter value is present, continue procedure execution

    -- use the variables within a query
    -- Note: only one scalar value is assigned to the variable
    SELECT @count = COUNT(*)
    FROM Activity
    WHERE ClubId = @clubid

    -- use flow of control command to set the results variable depending
    -- on the count

    -- CLASS STANDARD, WILL BE MARKED FOR, YOU MUST USE THE BEGIN/END ON EACH
    --     CODING BLOCK WITHIN YOUR FLOW OF CONTROL STATEMENTS!!!!!!!!!!!!!
    IF @count > 2
    BEGIN
        SET @results = 'is a successful club!'
    END
    ELSE
    BEGIN
        SET @results = 'needs more members!'
    END

    -- used to display text within your results table
    -- note the variables used in the PRINT are strings already (varchar(nn))

    PRINT 'Club: ' + @clubid + ' ' + @results
END
RETURN
go

-- assign a value to the Parameter(aka variable) 
--SET @clubid = 'CSS' -- > 2
--SET @clubid = 'CHESS' -- = 1
--SET @clubid = 'BOB' -- does not exist
--execute the stored procedure with a value for clubid
EXEC ClubActivity 'CSS'
--missing parameter test
EXEC ClubActivity
go

--Create a variable called studentID and give it a value.
--Create additional variables as needed to solve your problem.
--Each course has a cost. If the total of the costs for the courses the
--student is registered in is more than the total of the payments that student has
--made, then print ‘balance owing!’ otherwise print ‘Paid in full! Welcome to IQ
--School!’
--Do Not use the BalanceOwing field in your solution

--create variables
--variables can be created on the "fly" when needed, 
--  however, it is nice to have all variable at the top of your code in one place
CREATE PROCEDURE StudentMoneyStatus(@studentid int = null)
as
DECLARE @totalcoursecost decimal(8,2), @totalpayments money

IF ( @studentid is null)
BEGIN
    -- missing parameter would not be able to execute procedure logic
    RaisError( 'Missing parameter value for student id.', 16,1)
    --goes to the end of the IF-BEGIN/END-ELSE-BEGIN/END
END
ELSE
BEGIN

    --one could optionally set starting default values for the other two variable
    --   however the aggregate functions will assign a value
    SET @totalcoursecost = 0.00
    SET @totalpayments = 0.00

    -- using IF EXISTS determine if the student exists BEFORE attempting
    --      to do the calculations
    --NOTE Instead of using the *, I like using a primary key attribute
    IF EXISTS(SELECT studentid 
              FROM Student  
              WHERE StudentID = @studentid)
    BEGIN
        --student exists

        --it does not matter which order you obtain your values for your test
        --  in this example AS LONG AS you obtain the values BEFORE attempting to test

        --Calculate the total cost of all courses that the student is taking
        SELECT @totalcoursecost = SUM(CourseCost)
        FROM Course INNER JOIN Offering
                ON Course.CourseId =  Offering.CourseId
                    INNER JOIN Registration
                ON Offering.OfferingCode = Registration.OfferingCode
        WHERE @studentid = StudentID

        --Calcuate the total payments of the student
        SELECT @totalpayments = SUM(Amount)
        FROM Payment
        WHERE @studentid = StudentID

        --this is referred to as a nested-IF
        --note this IF statement is within a coding code of an OUTER IF statement
        --note the CAST function to use an integer as a string in my print command
        IF @totalcoursecost > @totalpayments
        BEGIN
            -- true path
            PRINT 'Student:' + CAST(@studentid as varchar(10)) + ' has balance owning'
        END
        ELSE
        BEGIN
            -- false path
            PRINT 'Student:' + CAST(@studentid as varchar(10)) + ' is paid in full'
        END
    END
    ELSE
    BEGIN
        --student does not exist
        --note the CONVERT function to use an integer as a string in my print command
        --Even though on a PRINT you can do concatenation, building your output 
        --      character message, this is NOT allowed within the RAISERROR
        --Solution:
        --  declare a variable and set the variable to your concatenated string
        --  then use the variable within your RAISERROR
        DECLARE @msg varchar(100) = 'Student:' + CONVERT(varchar(10),@studentid) + ' does not exist on file.'
        RaisError(@msg , 16,1)
    END
END
RETURN
go

--assign staring values to my variables
--SET @studentid = 199800200 --does not exist
--SET @studentid = 199899200 --does exist with balance owning
--SET @studentid = 199966250 --does exist paid in full
exec StudentMoneyStatus 199966250
exec StudentMoneyStatus 
go

--Create two variable to hold a student''s first name and last name. 
--If the student name already is in the table 
--then print ‘We already have a student with the name firstname lastname!’ 
--Other wise print ‘Welcome firstname lastname!’

CREATE PROCEDURE StudentThere(@firstname varchar(25) = null, 
                              @lastname varchar(35) = null)
as
-- You can combine both the declaration and setting of an initial value to variables
--    on the DECLARE statement
--DECLARE @firstname varchar(25) = 'Don'
--DECLARE @lastname varchar(35) = 'Welch'

--DECLARE @firstname varchar(25) = 'Peter'
--DECLARE @lastname varchar(35) = 'Codd'
IF ( @firstname is null or @lastname is null)
BEGIN
    -- missing parameter would not be able to execute procedure logic
    RaisError( 'Missing parameter value for first name and/or last name .',16, 1)
END
ELSE
BEGIN
    -- in this example, one does not actually need data from the table
    -- one needs only to know if the data is on the table (IF EXISTS)
    IF EXISTS (SELECT studentid
                FROM Student
                WHERE @firstname = FirstName and
                      LastName = @lastname)
    BEGIN
        PRINT 'We already have a student with the name ' + @firstname + ' ' + @lastname 
    END
    ELSE
    BEGIN
    Print 'Welcome '  + @firstname + ' ' + @lastname 
    END
END
RETURN
go

--DECLARE @firstname varchar(25) = 'Don'
--DECLARE @lastname varchar(35) = 'Welch'

--DECLARE @firstname varchar(25) = 'Peter'
--DECLARE @lastname varchar(35) = 'Codd'

--order of your parameter values on the EXECUTE command MUST match
--  the expected order within the stored procedure
EXECUTE StudentThere 'Peter','Codd'
exec StudentThere 'Peter'
--NOTE, when you have multiple parameters and you are missing
--      a parameter within the mist of the parameter values
--      any preceeding missing parameter MUST have a 'null' keyword
--      placed in the appropriate position in the parameter list
exec StudentThere null,'Codd'
exec StudentThere 
go