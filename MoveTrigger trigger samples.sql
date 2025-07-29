use MovieTriggers
go

DROP TRIGGER IF EXISTS TR_MovieCharacter_Insert_Update
go

CREATE TRIGGER TR_MovieCharacter_Insert_Update
ON MovieCharacter
FOR Insert, Update
AS

-- @@ROWCOUNT indicates the number of rows affected
--		therefore unless we have affected at least one row, DON'T bother doing any more trigger action
-- the update(attribute) condition is used to check
--		if the indicated attribute is being changed on the UPDATE dml SET clause
-- if the update(attribute) field is NOT being changed in the UPDATE dml statement, DON'T bother doing any more trigger action
--NOTE!!!!! on the Insert dml command update(attribute) will ALWAYS be true
IF @@ROWCOUNT > 0 and update(characterwage)
BEGIN
	--the following print statement is ONLY within this trigger as a learning tool
	--triggers do NOT have print statements
	--if this trigger was put into production, this print statement would be removed
	PRINT 'inside trigger testing'

	--this is where you ask your test question to determine IF the data is correct
	--the question you create is to test for a ROLLBACK situation
	--if the character wage is negative, the data is bad, rollback any changes to the database
	IF EXISTS (Select * 
			   From inserted
			   WHERE Characterwage  < 0)
	BEGIN
		PRINT 'trigger conidtion fires the rollback'
		ROLLBACK TRANSACTION
		RAISERROR('Character wage cannot be negative',16,1)
	END

	PRINT 'ending trigger testing'
END

RETURN
go

--testing of the trigger
SELECT * From MovieCharacter
INSERT INTO MovieCharacter(CharacterName, CharacterMovie,CharacterRating,Characterwage,AgentID)
VALUES('Don Welch','Data Is Good', null, 1500.00,3)
SELECT * From MovieCharacter
go
SELECT * From MovieCharacter
INSERT INTO MovieCharacter(CharacterName, CharacterMovie,CharacterRating,Characterwage,AgentID)
VALUES('Shirely Ujest','Data Is Bad', null, -1500.00,3)
SELECT * From MovieCharacter
go
SELECT * From MovieCharacter
Update MovieCharacter
SET Characterwage = 150.00
where CharacterName = 'Don Welch'
SELECT * From MovieCharacter
go
SELECT * From MovieCharacter
Update MovieCharacter
SET CharacterRating = 'G'
where CharacterName = 'Don Welch'
SELECT * From MovieCharacter
go
SELECT * From MovieCharacter
Update MovieCharacter
SET Characterwage = 150.00
where CharacterName = 'Donnie Welch'
SELECT * From MovieCharacter
go
SELECT * From MovieCharacter
Update MovieCharacter
SET Characterwage = -150.00
where CharacterName = 'Don Welch'
SELECT * From MovieCharacter
go