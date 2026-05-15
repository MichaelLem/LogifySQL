USE [Logify]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InsertNewCompany]
    @CompanyName NVARCHAR(100),
    @CompanyEmail NVARCHAR(255)
AS

BEGIN
    SET NOCOUNT ON;

    DECLARE @NewCompanyId INT;

    INSERT INTO dbo.Company
    (
        CompanyName,
        CompanyEmail
    )
    VALUES
    (
        @CompanyName,
        @CompanyEmail
    );

    SET @NewCompanyId = SCOPE_IDENTITY();

    SELECT @NewCompanyId AS CompanyId;
END;
