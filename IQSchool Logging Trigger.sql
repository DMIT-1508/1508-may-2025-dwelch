use IQSchool
go

DROP TABLE CourseChanges
go

CREATE Table CourseChanges
(
LogID int IDENTITY(1,1) not null
	Constraint PK_CourseChanges_LogID primary key clustered,
ChangeDate datetime not null
	Constraint DF_CourseChanges_ChangeDate Default GetDate(),
OldCourseCost money not null,
NewCourseCost money not null,
CourseID char(8) not null
)
go

Create TRIGGER TR_Log_Course_Update
ON Course
FOR Update
AS
IF @@ROWCOUNT > 0 and update(coursecost)
BEGIN
	--we wish to place a new record(s) into the log table
	--	for course(s) that have changed their cost
	-- where is the data to record?
	--   new cost: inserted
	--   old cost: deleted
	--what about the date?
	--   can use the log table default OR use getdate()
	--What about the courseid
	--   in both inserted and deleted, can use either

	-- how do I use the VALUES on the insert command
	-- HERE YOU DON'T USE VALUES
	-- instead one uses the SELECT on the Insert
	INSERT INTO CourseChanges(OldCourseCost, NewCourseCost, CourseID)
	SELECT deleted.coursecost, inserted.CourseCost, inserted.CourseId
	FROM Inserted inner join deleted
			on inserted.courseid = deleted.courseid
	if @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('Log of course cost change failed.',16,1)
	END
END
RETURN