CREATE PROCEDURE dbo.ValidateUserLogin
	@Username NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT
		u.UserAccountId,
		u.EmployeeId,
		u.Username,
		u.PasswordHash
	FROM 
		DBO.UserAccount AS u
	WHERE u.Username = @Username  
	AND u.IsActive = 1; 
END