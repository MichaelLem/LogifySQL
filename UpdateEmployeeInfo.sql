CREATE OR ALTER PROCEDURE dbo.UpdateEmployeeInfo

    @EmployeeId INT,
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @SSN NVARCHAR(20),
    @Email NVARCHAR(150),
    @PhoneNumber NVARCHAR(25),
    @HourlyRate DECIMAL(6,2)

AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Employee
    SET HourlyRate = @HourlyRate
    WHERE EmployeeId = @EmployeeId;

    UPDATE dbo.Person
    SET FirstName = @FirstName,
        LastName = @LastName,
        SSN = @SSN,
        Email = @Email,
        PhoneNumber = @PhoneNumber,
        UpdatedAt = GETDATE()
    WHERE EmployeeId = @EmployeeId;

END