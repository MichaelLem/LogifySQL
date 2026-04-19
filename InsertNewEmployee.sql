CREATE OR ALTER PROCEDURE dbo.InsertNewEmployee
    @CompanyId INT,
    @RoleId INT,
    @HourlyRate DECIMAL(6,2),
    @DateHired DATE,
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @SSN NVARCHAR(11),
    @Email NVARCHAR(255),
    @PhoneNumber NVARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @NewEmployeeId INT;

    INSERT INTO dbo.Employee
    (
        CompanyId,
        RoleId,
        IsActive,
        HourlyRate,
        DateHired
    )
    VALUES
    (
        @CompanyId,
        @RoleId,
        1,
        @HourlyRate,
        @DateHired
    );

    SET @NewEmployeeId = SCOPE_IDENTITY();

    INSERT INTO dbo.Person
    (
        EmployeeId,
        FirstName,
        LastName,
        SSN,
        Email,
        PhoneNumber
    )
    VALUES
    (
        @NewEmployeeId,
        @FirstName,
        @LastName,
        @SSN,
        @Email,
        @PhoneNumber
    );
END;
GO