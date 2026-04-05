CREATE DATABASE Logify;
GO

CREATE TABLE Companies (
	CompanyId INT IDENTITY(1,1) NOT NULL,
	CompanyName NVARCHAR(100) NOT NULL,
	IsActive BIT NOT NULL DEFAULT 1,
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME,
	PRIMARY KEY (CompanyId),
	CONSTRAINT UQ_Companies_Name 
		UNIQUE (CompanyName)
);

CREATE TABLE Roles (
	RoleId INT IDENTITY (1,1) NOT NULL,
	CompanyId INT NOT NULL,
	RoleName NVARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL DEFAULT 1,
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME,
	PRIMARY KEY (RoleId),
	CONSTRAINT FK_Roles_CompanyId
		FOREIGN KEY (CompanyId)
		REFERENCES Companies(CompanyId),
	CONSTRAINT UQ_Roles_CompanyId_RoleName
		UNIQUE (CompanyId, RoleName),
	CONSTRAINT UQ_Roles_RoleId_CompanyId 
		UNIQUE (RoleId, CompanyId)
);

CREATE TABLE Employees (
	EmployeeId INT IDENTITY (1,1) NOT NULL,
	CompanyId INT NOT NULL,
	RoleId INT NOT NULL,
	IsActive BIT NOT NULL DEFAULT 1,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	HourlyRate DECIMAL(6,2) NOT NULL,
	DateHired DATE NOT NULL,
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME,
	PRIMARY KEY (EmployeeId),
	CONSTRAINT FK_Employees_CompanyId
		FOREIGN KEY (CompanyId)
		REFERENCES Companies(CompanyId),
	CONSTRAINT FK_Employees_RoleId_CompanyId
		FOREIGN KEY (RoleId, CompanyId)
		REFERENCES Roles(RoleId, CompanyId),
	CONSTRAINT CK_Employees_HourlyRate
		CHECK (HourlyRate >= 0)
);

CREATE TABLE Contacts (
	ContactId INT IDENTITY(1,1) NOT NULL,
	EmployeeId INT NOT NULL,
	Email NVARCHAR(255) NOT NULL,
	PhoneNumber NVARCHAR(20),
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME,
	PRIMARY KEY (ContactId),
	CONSTRAINT FK_Contacts_EmployeeId
		FOREIGN KEY (EmployeeId)
		REFERENCES Employees(EmployeeId),
	CONSTRAINT UQ_Contacts_EmployeeId 
		UNIQUE(EmployeeId),
	CONSTRAINT UQ_Contacts_Email 
		UNIQUE(Email)
);

CREATE TABLE PayPeriods (
	PayPeriodId INT IDENTITY(1,1) NOT NULL,
	CompanyId INT NOT NULL,
	StartDate DATE NOT NULL,
	EndDate DATE NOT NULL,
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	PRIMARY KEY (PayPeriodId),
	CONSTRAINT FK_PayPeriods_CompanyID
		FOREIGN KEY (CompanyId)
		REFERENCES Companies(CompanyId),
	CONSTRAINT CK_PayPeriods_StartDate
		CHECK (EndDate > StartDate)
);

CREATE TABLE TimeEntries (
	TimeEntryId INT IDENTITY(1,1) NOT NULL,
	EmployeeId INT NOT NULL,
	PayPeriodId INT NOT NULL,
	ClockIn DATETIME NOT NULL,
	ClockOut DATETIME,
	Notes NVARCHAR(250),
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME,
	PRIMARY KEY (TimeEntryId),
	CONSTRAINT CK_TimeEntries_ClockOut
		CHECK(ClockOut IS NULL OR ClockOut > ClockIn),
	CONSTRAINT FK_TimeEntries_Employees
		FOREIGN KEY (EmployeeId)
		REFERENCES Employees(EmployeeId),
	CONSTRAINT FK_TimeEntries_PayPeriodId
		FOREIGN KEY (PayPeriodId)
		REFERENCES PayPeriods(PayPeriodId),
	CONSTRAINT UQ_TimeEntries_Employee_ClockIn
		UNIQUE (EmployeeId, ClockIn)
);

CREATE TABLE UserAccounts (
	UserAccountId INT IDENTITY(1,1) NOT NULL,
	EmployeeId INT NOT NULL,
	Username NVARCHAR(50) NOT NULL,
	PasswordHash NVARCHAR(255) NOT NULL,
	IsActive BIT NOT NULL DEFAULT 1,
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME,
	PRIMARY KEY (UserAccountId),
	CONSTRAINT FK_UserAccounts_EmployeeId
		FOREIGN KEY (EmployeeId)
		REFERENCES Employees(EmployeeId),
	CONSTRAINT UQ_UserAccounts_EmployeeId
		UNIQUE (EmployeeId),
	CONSTRAINT UQ_UserAccounts_Username
		UNIQUE (Username)
);