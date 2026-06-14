CREATE OR ALTER PROCEDURE dbo.DeleteEmployee
    @EmployeeId INT
AS
BEGIN
    SET NOCOUNT OFF;

    UPDATE dbo.Employee
	SET IsActive = 0
	WHERE EmployeeId = @EmployeeId;

END