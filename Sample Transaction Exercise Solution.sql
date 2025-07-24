use IQSchool
go

DROP PROCEDURE IF EXISTS RegisterStudentTransaction

go
-- 1. Create a stored procedure called ‘RegisterStudentTransaction’ that accepts StudentID
--		and offering code as parameters. If the number of students in that course and semester
--		are not greater than the Max Students for that course, add a record to the Registration
--		table and add the cost of the course to the students balance. If the registration would
--		cause the course in that semester to have greater than MaxStudents for that course
--		raise an error

--    Another test that could have been in this procedure was to check if the student is already
--    registered in the course for the offering
--    this check was omitted so that the procedure can abort on the INSERT command

CREATE PROCEDURE RegisterStudentTransaction(@studentid int = null, @offeringcode int = null)
as
-- declaring local variables
DECLARE @maxstudents int
DECLARE @currentclasssize int
DECLARE @coursecost decimal(6,2)

-- declare special local variables to contain the results of the dml statements
DECLARE @error int, @rowcount int

-- check parameters have been submitted
IF (@studentid is null or @offeringcode is null)
BEGIN
	RAISERROR('Missing input parameter. Must supply both student id and offering code',16,1)
END
ELSE
BEGIN
	--get the class max size
	SELECT @maxstudents = MaxStudents
	FROM Course inner join Offering
		on Course.CourseId = Offering.CourseId
		WHERE OfferingCode = @offeringcode

	--get the current number of students registered in the offering
	SELECT @currentclasssize = COUNT(Registration.OfferingCode)
	FROM Registration inner join Offering
	       On Registration.OfferingCode = Offering.OfferingCode
	WHERE Registration.OfferingCode = @offeringcode

    --get the current cost of the course
	--note: this select could be combined with obtaining the max student value
	--      OR
	--      this select could be delayed until later in the transaction
	SELECT @coursecost = CourseCost
	FROM Course inner join Offering
		on Course.CourseId = Offering.CourseId
		WHERE OfferingCode = @offeringcode

	IF (@currentclasssize >= @maxstudents)
	BEGIN
		-- class is full. unable to add any more students
		RAISERROR('The class is full. Unable to register student',16,1)
	END
	ELSE
	BEGIN
		-- this is the start of the transaction (logical unit of work LUW)
		-- Actions: a) add a record to the registration table for the student (INSERT)
		--          b) update the BalanceOwning on the student table (UPDATE)


		-- start the transaction
		BEGIN TRANSACTION
		--do the first dml statement
		--use incominng paramenters, Mark = 0, WithdrawYN defaults to N
		INSERT INTO Registration (OfferingCode, StudentID, Mark)
		VALUES (@offeringcode, @studentid, 0)

		--remember AFTER EACH dml statement you MUST check success or failure
		--if the statement fails you MUST send a user friendly error message
		--checking to see if something is successful, @@ERROR
		--Depending on the dml statement, you may ALSO need to check how many rows were affected, @@ROWCOUNT
		--It is a good practice to capture these two system values to check within the transaction AFTER EACH
		--		dml statement BECAUSE each dml statement ALTERS the system values
		SELECT @error = @@ERROR, @rowcount = @@ROWCOUNT
		IF(@error <> 0)
		BEGIN
			--INSERT aborted for some reason
			--actions required
			--the transaction has failed at some point, does not matter where point, it matters that it failed
			--place the database back into the state it was in at the start of the transaction
			ROLLBACK TRANSACTION
			--send a user friendly error message
			RAISERROR('Unable to register student. Registration failed.',16,1)
			--proceed to the end of the procedure
		END
		ELSE
		BEGIN
			-- success in Action a)
			-- do Action b)

			--this statement will force an error on the update
			--  such that a record is not found
			--this statement will be removed once the check for the update testing has been done
			--Set @studentid = 202510001

			UPDATE Student
			SET BalanceOwing += @coursecost
			WHERE StudentID = @studentid

			--capture the results of the update statement
			SELECT @error = @@ERROR, @rowcount = @@ROWCOUNT

			--check the success of the update
			IF (@error <> 0)
			BEGIN
				--Update aborted for some reason
				ROLLBACK TRANSACTION
				--send a user friendly error message
				RAISERROR('Unable to udpate student balance owning. Registration failed.',16,1)
				--proceed to the end of the procedure
			END
			ELSE
			BEGIN
				--remember an update can succeed BUT NOT alter any records
				--NO alternation to the database was done
				--NO abort happened
				--we need to concern if NO altenation is actually an ERROR (logical error)
				IF (@rowcount = 0)
				BEGIN
					--Update did not alternate database for some reason
				ROLLBACK TRANSACTION
				--send a user friendly error message
				RAISERROR('Student balance owning not changed. Registration failed.',16,1)
				--proceed to the end of the procedure
				END
				ELSE
				BEGIN
					--at this point in the transaction, all work in the LUW has successfully completed
					--the changes to the database can be made permenant
					COMMIT TRANSACTION
					--proceed to the end of the procedure
				END
			END
		END
	END
END
RETURN
go

-- testing
SELect studentid
from Student
where studentid not in (Select distinct studentid
					    from Registration
						where OfferingCode = 1000)
go
-- use studentid = 198933540 offering = 1000 good
-- cost 816.75 balance 0
--add 1 to max students for DMIT1514
Update Course
Set MaxStudents += 1
where CourseId = 'DMIT1514'
-- max students 9 
go
--good test
exec RegisterStudentTransaction 198933540, 1000

--bad tests
-- use studentid = 198933540 offering = 1000 bad class full
exec RegisterStudentTransaction 198933540, 1000
-- use studentid = 199812010 offering = 1014 bad duplicate INSERT FAIL
exec RegisterStudentTransaction 199812010, 1014
-- use studentid = 199899200 offering = 1014 bad student not found for UPDATE FAIL
exec RegisterStudentTransaction 199899200, 1014

--2 Create a procedure called ‘StudentPaymentTransaction’ that accepts Student ID and
--  paymentamount and paymenttype as parameters. 
--Add the payment to the payment table and adjust the students balance owing to reflect the payment
--NOTE: the payment pkey is not an identity, so a calculation will be done
--			to create the next pkey value
DROP PROCEDURE IF EXISTS StudentPaymentTransaction
go
CREATE PROCEDURE StudentPaymentTransaction(@studentid int = null, 
										   @paymentamount decimal(6,2) = null,
										   @paymenttype tinyint = null)
AS
DECLARE @nextpaymentid int
DECLARE @error int,@rowcount int

IF (@studentid is null or @paymentamount is null or @paymenttype is null)
BEGIN
	RAISERROR('missing a parameter value',16,1)
END
ELSE
BEGIN
	BEGIN TRANSACTION
	--typically the pkey for a table like Payment would have an IDENTITY pkey
	--   each means that the pkey would be generated by the system
	--HOWEVER, in this sample database, the pkey is not an IDENTITY
	--		therefore we will automatically calculate the next available pkey value
	
	SELECT @nextpaymentid = MAX(paymentid) + 1
	FROM Payment

	INSERT INTO Payment(PaymentID, PaymentDate, Amount, PaymentTypeID, StudentID)
	VALUES(@nextpaymentid,GETDATE(),@paymentamount,@paymenttype,@studentid)
	SELECT @error = @@ERROR, @rowcount = @@ROWCOUNT

	--possible results for an insert is either works or not works
	IF (@error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('Payment was not recorded. Payment Failed',16,1)
	END
	ELSE
	BEGIN
		PRINT 'step 3'
		UPDATE Student
		SET BalanceOwing -= @paymentamount
		WHERE StudentID = @studentid
		SELECT @error = @@ERROR, @rowcount = @@ROWCOUNT

		--possible reuslts for an update is: works with changes, abort with error
		--	AND does not abort BUT no rows affected (ROWCOUNT)
		IF (@error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			RAISERROR('Student Balance not updated. Recording failed',16,1)
		END
		ELSE
		BEGIN
			IF (@rowcount = 0)
			BEGIN
				ROLLBACK TRANSACTION
				RAISERROR('Student Balance not updated. Student not found',16,1)
			END
			ELSE
			BEGIN
				COMMIT TRANSACTION
			END
		END
	END
END

RETURN
go


--testing
--student id 200122100
--balance owning: 19849.00
--payment type 1-6
--due to the size of the payment amount field , max payment is 9999.99 
EXEC StudentPaymentTransaction 200122100, 9800.00, 6
GO

--4 Create a stored procedure called ‘DisappearingStudent’ that accepts a StudentID as a
--  parameter and deletes all records pertaining to that student. It should look like that
--  student was never in IQSchool 

--consideration : Student is a parent to Payment, Registration and Activity
--					therefore, deletes must be done to child tables first then Student
DROP PROCEDURE IF EXISTS DisappearingStudent
go
CREATE PROCEDURE DisappearingStudent(@studentid int = null)
as
DECLARE @error int,@rowcount int
IF (@studentid is null)
BEGIN
	RAISERROR('missing a parameter value',16,1)
END
ELSE
BEGIN
	BEGIN TRANSACTION
	DELETE Payment
	WHERE StudentID = @studentid
	SELECT @error = @@ERROR, @rowcount = @@ROWCOUNT
	IF (@error <> 0)
	BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('Unable to remove student payments.',16,1)
	END
	ELSE
	BEGIN
		DELETE Activity
		WHERE StudentID = @studentid
		SELECT @error = @@ERROR, @rowcount = @@ROWCOUNT
		IF (@error <> 0)
		BEGIN
			ROLLBACK TRANSACTION
			RAISERROR('Unable to remove student activities.',16,1)
		END
		ELSE
		BEGIN
			DELETE Registration
			WHERE StudentID = @studentid
			SELECT @error = @@ERROR, @rowcount = @@ROWCOUNT
			IF (@error <> 0)
			BEGIN
				ROLLBACK TRANSACTION
				RAISERROR('Unable to remove student registrations.',16,1)
			END
			ELSE
			BEGIN
				DELETE Student
				WHERE StudentID = @studentid
				SELECT @error = @@ERROR, @rowcount = @@ROWCOUNT
				IF (@error <> 0)
				BEGIN
					ROLLBACK TRANSACTION
					RAISERROR('Unable to remove student activities.',16,1)
				END
				ELSE
				BEGIN
					IF (@rowcount = 0)
					BEGIN
						ROLLBACK TRANSACTION
						RAISERROR('Student does not exists.',16,1)
					END
					ELSE
					BEGIN
					    COMMIT TRANSACTION
					END
				END
			END
		END
	END
END
RETURN
go

exec DisappearingStudent 200122100