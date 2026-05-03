CREATE OR ALTER PROCEDURE dbo.DeleteEmployee
    @EmployeeId INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Employee
	SET IsActive = 0
	WHERE EmployeeId = @EmployeeId;

END