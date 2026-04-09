CREATE DATABASE Logify;
GO

USE Logify;
GO

CREATE TABLE Company (
	CompanyId INT IDENTITY(1,1) NOT NULL,
	CompanyName NVARCHAR(100) NOT NULL,
	IsActive BIT NOT NULL DEFAULT 1,
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME,
	PRIMARY KEY (CompanyId),
	CONSTRAINT UQ_Company_Name 
		UNIQUE (CompanyName)
);
GO

CREATE TABLE PayPeriod (
	PayPeriodId INT IDENTITY(1,1) NOT NULL,
	StartDate DATE NOT NULL,
	EndDate DATE NOT NULL,
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	PRIMARY KEY (PayPeriodId),
	CONSTRAINT CK_PayPeriod_StartDate
		CHECK (EndDate > StartDate)
);
GO

CREATE TABLE Role (
	RoleId INT IDENTITY (1,1) NOT NULL,
	RoleName NVARCHAR(50) NOT NULL,
	IsActive BIT NOT NULL DEFAULT 1,
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME,
	PRIMARY KEY (RoleId)
);
GO

CREATE TABLE Employee (
	EmployeeId INT IDENTITY (1,1) NOT NULL,
	CompanyId INT NOT NULL,
	RoleId INT NOT NULL,
	IsActive BIT NOT NULL DEFAULT 1,
	HourlyRate DECIMAL(6,2) NOT NULL,
	DateHired DATE NOT NULL,
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME,
	PRIMARY KEY (EmployeeId),
	CONSTRAINT FK_Employee_CompanyId
		FOREIGN KEY (CompanyId)
		REFERENCES Company(CompanyId),
	CONSTRAINT FK_Employee_RoleId
		FOREIGN KEY (RoleId)
		REFERENCES Role(RoleId),
	CONSTRAINT CK_Employee_HourlyRate
		CHECK (HourlyRate >= 0)
);
GO

CREATE TABLE UserAccount (
	UserAccountId INT IDENTITY(1,1) NOT NULL,
	EmployeeId INT NOT NULL,
	Username NVARCHAR(50) NOT NULL,
	PasswordHash NVARCHAR(255) NOT NULL,
	IsActive BIT NOT NULL DEFAULT 1,
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME,
	PRIMARY KEY (UserAccountId),
	CONSTRAINT FK_UserAccount_EmployeeId
		FOREIGN KEY (EmployeeId)
		REFERENCES Employee(EmployeeId),
	CONSTRAINT UQ_UserAccount_EmployeeId
		UNIQUE (EmployeeId),
	CONSTRAINT UQ_UserAccount_Username
		UNIQUE (Username)
);
GO

CREATE TABLE Person (
	PersonId INT IDENTITY(1,1) NOT NULL,
	EmployeeId INT NOT NULL,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	Email NVARCHAR(255) NOT NULL,
	PhoneNumber NVARCHAR(20),
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME,
	PRIMARY KEY (PersonId),
	CONSTRAINT FK_Person_EmployeeId
		FOREIGN KEY (EmployeeId)
		REFERENCES Employee(EmployeeId),
	CONSTRAINT UQ_Person_EmployeeId 
		UNIQUE(EmployeeId),
	CONSTRAINT UQ_Person_Email 
		UNIQUE(Email)
);
GO

CREATE TABLE TimeEntry (
	TimeEntryId INT IDENTITY(1,1) NOT NULL,
	EmployeeId INT NOT NULL,
	PayPeriodId INT NOT NULL, 
	ClockIn DATETIME NOT NULL,
	ClockOut DATETIME,
	Notes NVARCHAR(250),
	CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
	UpdatedAt DATETIME,
	PRIMARY KEY (TimeEntryId),
	CONSTRAINT CK_TimeEntry_ClockOut
		CHECK(ClockOut IS NULL OR ClockOut > ClockIn),
	CONSTRAINT FK_TimeEntry_Employee
		FOREIGN KEY (EmployeeId)
		REFERENCES Employee(EmployeeId),
	CONSTRAINT FK_TimeEntry_PayPeriodId
		FOREIGN KEY (PayPeriodId)
		REFERENCES PayPeriod(PayPeriodId),
	CONSTRAINT UQ_TimeEntry_Employee_ClockIn
		UNIQUE (EmployeeId, ClockIn)
);
GO




