USE [AZA]
GO

IF OBJECT_ID('dbo.[usp_DeleteDelivery]', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_DeleteDelivery]
GO
CREATE PROCEDURE [dbo].[usp_DeleteDelivery]
        @P_delivery_cd           NVARCHAR(6)
,       @P_del_user              NVARCHAR(50)
,       @P_del_prg               NVARCHAR(50)
,       @P_del_ip                NVARCHAR(20)
,       @P_del_date              DATETIME2(7)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION
        
        UPDATE [dbo].[m_delivery]
        SET
              [del_user]         =        @P_del_user  
        ,     [del_prg]          =        @P_del_prg
        ,     [del_ip]           =        @P_del_ip
        ,     [del_date]         =        @P_del_date
        ,     [del_flg]          =        1
        WHERE [delivery_cd]      =        @P_delivery_cd;
        SELECT (1) AS result
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        PRINT(ERROR_MESSAGE());
        ROLLBACK TRANSACTION;
    END CATCH;
END;
