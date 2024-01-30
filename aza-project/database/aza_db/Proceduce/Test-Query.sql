USE [AZA]
GO

IF OBJECT_ID('dbo.[usp_Test]', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_Test]
GO

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_Test]
AS
BEGIN
    SET NOCOUNT ON;
	SELECT *
	FROM m_delivery

    SET NOCOUNT ON;
	SELECT *
	FROM s_lib
	
	SET NOCOUNT ON;
	SELECT *
	FROM s_lib_val
END;


