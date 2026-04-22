CREATE OR ALTER PROCEDURE dbo.GetRoleList
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        RoleId,
		RoleName
    FROM dbo.Role
END;
GO