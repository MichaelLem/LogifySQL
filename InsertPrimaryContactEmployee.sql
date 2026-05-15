USE [Logify]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InsertPrimaryContactEmployee]
    @CompanyId INT,
    @RoleId INT,
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Email NVARCHAR(255),
    @PhoneNumber NVARCHAR(20) = NULL,
    @DateHired DATE,
    @HourlyRate DECIMAL(6,2)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @NewEmployeeId INT;

    INSERT INTO dbo.Employee
    (
        CompanyId,
        RoleId,
        IsActive,
        DateHired,
        HourlyRate
    )
    VALUES
    (
        @CompanyId,
        @RoleId,
        1,
        @DateHired,
        @HourlyRate
    );

    SET @NewEmployeeId = SCOPE_IDENTITY();

    INSERT INTO dbo.Person
    (
        EmployeeId,
        FirstName,
        LastName,
        Email,
        PhoneNumber
    )
    VALUES
    (
        @NewEmployeeId,
        @FirstName,
        @LastName,
        @Email,
        @PhoneNumber
    );
    SELECT @NewEmployeeId AS EmployeeId;
END;
