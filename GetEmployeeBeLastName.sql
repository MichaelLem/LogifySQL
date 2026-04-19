CREATE OR ALTER PROCEDURE dbo.GetEmployeesByLastName
    @LastName NVARCHAR(50)   -- Paramater1
	,@RoleId INT
AS
BEGIN
    SET NOCOUNT ON;

SELECT dbo.Person.FirstName, dbo.Person.LastName, dbo.Person.Email, dbo.Employee.DateHired, dbo.Role.RoleName
FROM   dbo.Employee INNER JOIN
             dbo.Person ON dbo.Employee.EmployeeId = dbo.Person.EmployeeId INNER JOIN
             dbo.Role ON dbo.Employee.RoleId = dbo.Role.RoleId
WHERE (dbo.Person.LastName = @LastName)
AND (dbo.Role.RoleId = @RoleId)
END;
GO

-- Example usage:
-- EXEC dbo.GetEmployeesByLastName @LastName = 'Smith';s