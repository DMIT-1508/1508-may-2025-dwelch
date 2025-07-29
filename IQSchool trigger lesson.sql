use IQSchool
go

DROP TRIGGER IF EXISTS TR_Student_Update
go

CREATE TRIGGER TR_Student_Update
ON Student
FOR Update
AS
PRINT 'Executing trigger now'
Select * from inserted
Select * from deleted
Select * from student
ROLLBACK Transaction
Select * from inserted
Select * from deleted
Select * from student
PRINT 'trigger complete'
RETURN
go

--REMEMBER you CAN NOT execute a trigger directly
--you MUST issue the appropriate dml command to fire the trigger

UPdate student
set BalanceOwing = 50
where studentID = 199912010

--what is expected
-- one row in Inserted  (after image)
-- one row in Deleted (before image)
-- all rows included the updated row for the students

update student
set BalanceOwing = 50

--note no where clause which means ALL rows in the table will be affected
--what is expected
-- all student rows in Inserted  (after image)
-- all student rows in Deleted (before image)
-- all the updated rows for the students (after image)

UPdate student
set BalanceOwing = 50
where studentID = 555555555

--what is expected
-- NO row in Inserted  (after image)
-- NO row in Deleted (before image)
-- all rows for the students BUT NO CHANGES because the studentid does not exist