CREATE OR ALTER PROCEDURE dbo.GetEmployeeById
    @EmployeeId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        c.CompanyName,
        c.CompanyId,
        r.RoleName,
        r.RoleId,
        p.FirstName,
        p.LastName,
        p.SSN,
        p.Email,
        p.PhoneNumber,
		e.HourlyRate
        e.DateHired
    FROM dbo.Employee e
    INNER JOIN dbo.Person p
        ON e.EmployeeId = p.EmployeeId
    INNER JOIN dbo.Role r
        ON e.RoleId = r.RoleId
    INNER JOIN dbo.Company c
        ON e.CompanyId = c.CompanyId
    WHERE e.EmployeeId = @EmployeeId;
END;
GO