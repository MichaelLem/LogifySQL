CREATE PROCEDURE dbo.ValidateUserLogin
	@Username NVARCHAR(50),
	@Password NVARCHAR(100)
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
		AND u.PasswordHash = @Password
		AND u.IsActive = 1; 
END