USE [Logify]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UpdateEmployeePay]
    @EmployeeId INT,
    @HourlyRate DECIMAL(6,2)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Employee
    SET HourlyRate = @HourlyRate
    WHERE EmployeeId = @EmployeeId;
END
GO