--	Create a stored procedure called ‘AddClub’ to add a new club record.

DROP Procedure IF EXISTS AddClub
DROP Procedure IF EXISTS DeleteClub
DROP Procedure IF EXISTS UpdateClub
DROP PROCEDURE IF EXISTS FireStaff
go

CREATE PROCEDURE AddClub(@ClubID varchar(10) = null, @ClubName varchar(50) = null)
as
-- set up any local variables

-- check incoming parameters have values
if (@ClubID is null or @ClubName is null)
BEGIN
	RAISERROR('Missing a required parameter', 16,1)
END
ELSE
BEGIN
	-- determine type of DML statement
	-- remember for Update and Delete you must pre-check that row exist
	--		to change/delete
	-- type:Insert

	--create dml statement using the parameters as your values
	INSERT INTO Club(ClubId, ClubName)
	VALUES (@ClubID, @ClubName)

	-- following the execution of the DML command the SYSTEM will
	--		set FOR YOU the value of @@ERROR
	-- ANY value other than 0 for @@ERROR is BAD
	-- Check to see if the execution of the DML statement was successful (@@ERROR = 0)
	IF (@@ERROR <> 0)
	BEGIN
		-- since @@ERROR is something other than 0, some error, does not matter what the error is,
		--		has occured and the procedure MUST send a user friendly error message back
		RAISERROR('Unable to add your club', 16,1)
	END

	-- at this point there is for this dml command no need for the "false" path of the IF statement
	-- therfore it should be removed
	--ELSE
	--BEGIN
	--END
END
RETURN
go
--testing
--good
exec AddClub 'xxx','good new club test'
--bad
exec AddClub 'xxx'
exec AddClub null,'good new club test'
exec AddClub 'xxx','bad duplicate club test'
go
-- Create a stored procedure called ‘DeleteClub’ to delete a club record.

CREATE PROCEDURE DeleteClub(@ClubID varchar(10) = null)
as
if (@ClubID is null)
BEGIN
	RAISERROR('Missing a required parameter', 16,1)
END
ELSE
BEGIN
	-- determine type of DML statement
	-- remember for Update and Delete you must pre-check that row exist
	--		to change/delete
	-- type:delete
	IF not exists (SELECT * FROM Club WHERE ClubId = @ClubID)
	BEGIN
		-- there would be no rows affected by the execution of this procedure
		--		with the supplied parameter value BECAUSE no row were found
		--		using the select command
		--therefore, send a user frienld message back
		RAISERROR ('There is no club with that id on file. Delete not done.',16,1)
	END
	ELSE
	BEGIN
		--create dml statement using the parameters as your values
		DELETE Club
		WHERE ClubId = @ClubID
		IF (@@ERROR <> 0)
		BEGIN
			RAISERROR('Delete club failed.', 16,1)
		END
	END
END
RETURN
go
--testing
--good
exec DeleteClub 'xxx'
--bad
exec DeleteClub 
exec DeleteClub 'xxx'
go
-- Create a stored procedure called ‘Updateclub’ to update a club record. Do not update the
-- primary key!
CREATE PROCEDURE UpdateClub(@ClubID varchar(10) = null, @ClubName varchar(50) = null)
as
if (@ClubID is null or @ClubName is null)
BEGIN
	RAISERROR('Missing a required parameter', 16,1)
END
ELSE
BEGIN
	-- type:update
	IF not exists (SELECT * FROM Club WHERE ClubId = @ClubID)
	BEGIN
		RAISERROR ('There is no club with that id on file. Update not done.',16,1)
	END
	ELSE
	BEGIN
		--create dml statement using the parameters as your values
		Update Club
		SET ClubName = @ClubName
		WHERE ClubId = @ClubID
		IF (@@ERROR <> 0)
		BEGIN
			RAISERROR('Update club failed.', 16,1)
		END
	END
END
RETURN
go
--testing
--good
exec AddClub 'xxx','add a club for testing'
exec UpdateClub 'xxx','change the club name'
--bad
exec UpdateClub
exec UpdateClub 'xxx'
exec UpdateClub null,'change the club name'
exec UpdateClub 'xxxx','clubid not found'
go
--Create a stored procedure called ‘FireStaff’ that will accept a StaffID as a parameter. Fire the
--staff member by updating the record for that staff and entering today’s date as the
--DateReleased
CREATE PROCEDURE FireStaff(@StaffID smallint = null)
as
if (@StaffID is null)
BEGIN
	RAISERROR('Missing a required parameter', 16,1)
END
ELSE
BEGIN
	-- type:update
	IF not exists (SELECT * FROM Staff WHERE StaffId = @StaffID)
	BEGIN
		RAISERROR ('There is no staff member with that id on file. Update not done.',16,1)
	END
	ELSE
	BEGIN
		--create dml statement using the parameters as your values
		Update Staff
		SET DateReleased = GetDate()
		WHERE StaffID = @StaffID
		IF (@@ERROR <> 0)
		BEGIN
			RAISERROR('staff firing failed.', 16,1)
		END
	END
END
RETURN
go
--testing
--good

exec FireStaff 2
--bad
exec FireStaff
exec FireStaff 22
go