--Memories Forever database creation

--If this is the first time running this script
-- Step 1: Uncomment create database command
-- Step 2: highlight command and execute
-- Step 3: Comment out the create database command

--CREATE DATABASE MemoriesForever

use MemoriesForever
go

DROP TABLE IF EXISTS ProjectItem
DROP TABLE IF EXISTS Project
DROP TABLE IF EXISTS ProjectType
DROP TABLE IF EXISTS Client
DROP TABLE IF EXISTS Staff
DROP TABLE IF EXISTS StaffType
DROP TABLE IF EXISTS Item
DROP TABLE IF EXISTS ItemType
go

CREATE TABLE ItemType
(	ItemTypeID		int NOT NULL
		CONSTRAINT PK_ItemType_ItemTypeID primary key clustered,
	ItemTypeDescription varchar(50) NOT NULL
)
go
CREATE TABLE Item
(
	ItemID			int IDENTITY(1,1) NOT NULL
		CONSTRAINT PK_Item_ItemID primary key clustered,
	ItemDescription varchar(50) NOT NULL,
	PricePerDay		smallmoney NOT NULL
		CONSTRAINT CK_Item_PricePerDay CHECK (PricePerDay >= 0.00),
	ItemTypeID		int NOT NULL
	    CONSTRAINT FK_ItemItemType_ItemTypeID Foreign Key (ItemTypeID)
		   REFERENCES ItemType(ItemtypeID)
)
go
CREATE TABLE StaffType
(
	StaffTypeID		int NOT NULL
		CONSTRAINT PK_StaffType_StaffTypeID primary key clustered,
	StaffTypeDescription	varchar(50) NOT NULL
)
go
CREATE TABLE Staff
(
	StaffID		int NOT NULL
		CONSTRAINT PK_Staff_StaffID primary key clustered,
	FirstName	varchar(30) NOT NULL,
	LastName	varchar(50) NOT NULL,
	Phone		char(12) NOT NULL
		CONSTRAINT CK_Staff_Phone CHECK (Phone like '[1-9][0-9][0-9]-[1-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
	Wage		money NOT NULL
		CONSTRAINT CK_Staff_Wage CHECK (Wage > 0)
		Constraint DF_Staff_Wage Default 9.5,
	HireDate	Datetime NOT NULL
		Constraint CK_Staff_HireDate Check(HireDate >= GetDate()),
	StaffTypeID		int NOT NULL
	    CONSTRAINT FK_StaffStaffType_StaffTypeID Foreign Key (StaffTypeID)
		   REFERENCES StaffType(StaffTypeID)
)
go
CREATE TABLE Client
(
	ClientID	int IDENTITY(1,1) NOT NULL
		CONSTRAINT PK_Client_ClientID primary key clustered,
	Organization varchar(100) NULL,
	FirstName	varchar(50) NOT NULL,
	LastName	varchar(50) NOT NULL,
	Phone		char(12) NOT NULL
		CONSTRAINT CK_Client_Phone CHECK (Phone like '[1-9][0-9][0-9]-[1-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
	Address		varchar(30) NOT NULL,
	City		varchar(30) NOT NULL,
	Province	char(2) NOT NULL,
	PC			char(6) NOT NULL,
		CONSTRAINT CK_Client_PC CHECK (PC like '[a-zA-Z][0-9]a-zA-Z][0-9][a-zA-Z][0-9]'),
	Email		varchar(100) NULL
)
go
CREATE TABLE ProjectType
(
	ProjectTypeCode			int NOT NULL
		CONSTRAINT PK_ProjectType_ProjectTypeCode primary key clustered,
	ProjectTypeDescription	varchar(50) NOT NULL
)
go
CREATE TABLE Project
(
	ProjectID		int IDENTITY(1,1) NOT NULL
		CONSTRAINT PK_Project_ProjectID primary key clustered,
	ProjectDescription	varchar(250) NOT NULL,
	InDate			DateTime NOT NULL
		CONSTRAINT DF_Project_InDate DEFAULT GETDATE(),
	OutDate			DateTime NULL,
	Estimate		money	NOT NULL
		CONSTRAINT CK_Project_Estimate CHECK (Estimate >= 0),
	ProjectTypeCode	int NOT NULL
	    CONSTRAINT FK_ProjectProjectType_ProjectTypeCode Foreign Key (ProjectTypeCode)
		   REFERENCES ProjectType(ProjectTypeCode),
	ClientID		int NOT NULL
	    CONSTRAINT FK_ProjectClient_ClientID Foreign Key (ClientID)
		   REFERENCES Client(ClientID),
	StaffID			int NOT NULL
	    CONSTRAINT FK_ProjectStaff_StaffID Foreign Key (StaffID)
		   REFERENCES Staff(StaffID),
	SubTotal		money NOT NULL
		CONSTRAINT CK_Project_SubTotal CHECK (SubTotal >= 0),
	GST		money NOT NULL
		CONSTRAINT CK_Project_GST CHECK (GST >= 0),
	Total			money NOT NULL
		CONSTRAINT CK_Project_Total CHECK (Total >= 0),
	CONSTRAINT CK_Project_InDateOutDate CHECK (OutDate >= InDate),
	CONSTRAINT CK_Project_SubTotalGSTTotal CHECK (Subtotal + GST = Total)
)
go
CREATE TABLE ProjectItem
(
	ProjectID		int NOT NULL
	    CONSTRAINT FK_ProjectItemProject_ProjectID Foreign Key (ProjectID)
		   REFERENCES Project(ProjectID),
	ItemID			int NOT NULL
	    CONSTRAINT FK_ProjectItemItem_ItemID Foreign Key (ItemID)
		   REFERENCES Item(ItemID),
	CheckInNotes	varchar(250) NULL,
	CheckOutNotes	varchar(250) NULL,
	DateOut			DateTime NULL,
	DateIn			DateTime NULL,
	ExtPrice		money NOT NULL
		CONSTRAINT CK_ProjectItem_ExtPrice CHECK (ExtPrice >= 0),
	HistoricalPrice	money NOT NULL
		CONSTRAINT CK_ProjectItem_HistoricalPrice CHECK (HistoricalPrice >= 0),
	Days			decimal NOT NULL
		CONSTRAINT CK_ProjectItem_Days CHECK (Days >= 0),
	CONSTRAINT PK_ProjectItem_ProjectIDItemID primary key clustered (ProjectID, ItemID),
	CONSTRAINT CK_ProjectItem_InDateOutDate CHECK (DateOut >= DateIn)
)

CREATE INDEX IX_ProjectItem_ProjectID ON ProjectItem(ProjectID)
CREATE INDEX IX_ProjectItem_ItemID ON ProjectItem(ItemID)
CREATE INDEX IX_Project_ClientID ON Project(ClientID)
CREATE INDEX IX_Project_StaffID ON Project(StaffID)
CREATE INDEX IX_Project_ProjectTypeCode ON Project(ProjectTypeCode)
CREATE INDEX IX_Staff_StaffTypeID ON Staff(StaffTypeID)
CREATE INDEX IX_Item_ItemTypeID ON Item(ItemTypeID)
go