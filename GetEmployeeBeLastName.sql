USE [Logify]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeesByLastName]    Script Date: 5/3/2026 11:42:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   PROCEDURE [dbo].[GetEmployeesByLastName]
    @LastName NVARCHAR(50),
    @RoleId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        c.CompanyName,
        c.CompanyId,
        p.FirstName,
        p.LastName,
        p.SSN,
        p.Email,
        p.PhoneNumber,
        e.HourlyRate,
        e.EmployeeId,
        e.DateHired,
        e.IsActive
    FROM dbo.Employee e
    INNER JOIN dbo.Person p 
        ON e.EmployeeId = p.EmployeeId 
    INNER JOIN dbo.Role r 
        ON e.RoleId = r.RoleId
    INNER JOIN dbo.Company c 
        ON e.CompanyId = c.CompanyId
    WHERE p.LastName = @LastName
      AND r.RoleId = @RoleId
END;
