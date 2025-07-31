use MovieTriggers
go

DROP TRIGGER IF EXISTS TR_MovieCharacter_Insert_Update
DROP TRIGGER IF EXISTS TR_Agent_Update
DROP TRIGGER IF EXISTS TR_MovieCharacter_Delete
DROP TRIGGER IF EXISTS TR_MovieAgent_Insert_Update_A
DROP TRIGGER IF EXISTS TR_MovieAgent_Insert_Update_B
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

CREATE TRIGGER TR_Agent_Update
ON Agent
FOR Update
AS
--BEGIN
	IF @@rowcount > 0 and update(agentfee)
	BEGIN
		IF exists (SELECT *
					FROM inserted inner join deleted
						on inserted.AgentID = deleted.AgentID
					WHERE inserted.AgentFee > 2 * deleted.AgentFee)
		BEGIN
			ROLLBACK TRANSACTION
			RAISERROR('Agent fee increase is too much',16,1)
		END
	END
--END
RETURN

go

CREATE TRIGGER TR_MovieCharacter_Delete
ON MovieCharacter
FOR DELETE
AS
--BEGIN
	IF @@rowcount > 0 
	BEGIN
	--the deleted table has the same structure and definition as the MovieCharacter table
	--the deleted table has any records that were removed from the MovieCharacter table
	--the relationship between MovieCharacter and Agent is on the AgentID
	--the deleted table hasthe agentid value of the deleted record(s)
		IF exists (SELECT *
					FROM deleted inner join Agent
						on deleted.AgentID = Agent.AgentID
					WHERE Agent.AgentFee >= 50)
		BEGIN
			ROLLBACK TRANSACTION
			RAISERROR('Agent makes too much. Cannot delete movie character',16,1)
		END
	END
--END
RETURN
go

--check all agents and movie characters
CREATE TRIGGER TR_MovieAgent_Insert_Update_A
ON MovieCharacter
FOR Insert,Update
AS

	IF @@rowcount > 0 and update(agentid)
	BEGIN
	--remember the dml action has already taken place
	--any changes to the database has already taken place
	--that means the "real" table has the new data in it

	--this test checks all agents and all characters
		IF exists (SELECT *
					FROM MovieCharacter
					GROUP BY MovieCharacter.AgentID
					HAVING count(*) > 2)
		BEGIN
			ROLLBACK TRANSACTION
			RAISERROR('Agent cannot represent more than 2 movie characters',16,1)
		END
	END

RETURN
go

--OR

--check only movie characters and their agents inserted or updated
CREATE TRIGGER TR_MovieAgent_Insert_Update_B
ON MovieCharacter
FOR Insert,Update
AS
BEGIN
	IF @@rowcount > 0 and update(agentid)
	BEGIN
		IF exists (SELECT *
					FROM MovieCharacter inner join Inserted
						on MovieCharacter.agentid = inserted.AgentID
					GROUP BY MovieCharacter.AgentID
					HAVING count(*) > 2)
		BEGIN
			ROLLBACK TRANSACTION
			RAISERROR('Agent cannot represent more than 2 movie characters',16,1)
		END
	END
END
RETURN
go