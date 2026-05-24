CREATE PROCEDURE dbo.InsertUserAccount
    @EmployeeId INT,
    @Username NVARCHAR(50),
    @PasswordHash NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.UserAccount
    (
        EmployeeId,
        Username,
        PasswordHash,
        IsActive
    )
    VALUES
    (
        @EmployeeId,
        @Username,
        @PasswordHash,
        1
    );
END