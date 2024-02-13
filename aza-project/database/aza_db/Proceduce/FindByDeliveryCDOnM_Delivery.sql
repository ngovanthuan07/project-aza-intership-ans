USE [AZA]
GO

IF OBJECT_ID('dbo.usp_FindByDeliveryCDOnM_Delivery', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_FindByDeliveryCDOnM_Delivery]
GO

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_FindByDeliveryCDOnM_Delivery]
(
     @P_delivery_cd                                  NVARCHAR(6)    = ''
)
AS
BEGIN
    SELECT *
	FROM [dbo].[m_delivery] m_d
	WHERE m_d.delivery_cd = @P_delivery_cd
END;
