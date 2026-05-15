USE [Logify]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UpdateCompanyPrimaryContactEmployeeId]
    @CompanyId INT,
    @PrimaryContactEmployeeId INT
AS
BEGIN
    SET NOCOUNT OFF;

    UPDATE dbo.Company
    SET PrimaryContactEmployeeId  = @PrimaryContactEmployeeId 
    WHERE CompanyId = @CompanyId;
END;
