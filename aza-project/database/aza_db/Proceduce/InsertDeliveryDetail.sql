USE [AZA]
GO

IF OBJECT_ID('dbo.[usp_InsertDelivery]', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_InsertDelivery]
GO
CREATE PROCEDURE [dbo].[usp_InsertDelivery]
     @P_delivery_nm1                    VARCHAR(80)
,    @P_delivery_kn1                    VARCHAR(80)
,    @P_delivery_nm2                    VARCHAR(80)
,    @P_delivery_kn2                    VARCHAR(80)
,    @P_zip_cd                          NVARCHAR(8)
,    @P_prefecture_cd                   NVARCHAR(2)
,    @P_city_nm                         NVARCHAR(24)
,    @P_town_nm                         NVARCHAR(32)
,    @P_apartment_nm                    NVARCHAR(32)
,    @P_address1                        NVARCHAR(200)
,    @P_address2                        NVARCHAR(200)
,    @P_tel                             NVARCHAR(20)
,    @P_fax                             NVARCHAR(20)
,    @P_delivery_class_1                NVARCHAR(3)
,    @P_delivery_class_2                NVARCHAR(3)
,    @P_delivery_class_3                NVARCHAR(3)
,    @P_remark                          NVARCHAR(1000)
,    @P_cre_user                        NVARCHAR(50)
,    @P_cre_prg                         NVARCHAR(50)
,    @P_cre_ip                          NVARCHAR(20)
,    @P_cre_date                        DATETIME2(7)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION

        DECLARE @w_unique_id NVARCHAR(6);

        SET @w_unique_id = (SELECT RIGHT('00000' + CAST(ISNULL(MAX(CAST([delivery_cd] AS INT)), 0) + 1 AS NVARCHAR(6)), 6) FROM [dbo].[m_delivery]);

        
        INSERT INTO [dbo].[m_delivery] (
                          [delivery_cd] 
        ,                 [delivery_nm1] 
        ,                 [delivery_kn1] 
        ,                 [delivery_nm2] 
        ,                 [delivery_kn2]
        ,                 [zip_cd] 
        ,                 [prefecture_cd] 
        ,                 [city_nm] 
        ,                 [town_nm] 
        ,                 [apartment_nm] 
        ,                 [address1]
        ,                 [address2] 
        ,                 [tel] 
        ,                 [fax] 
        ,                 [delivery_class_1] 
        ,                 [delivery_class_2] 
        ,                 [delivery_class_3]
        ,                 [remark] 
        ,                 [cre_user] 
        ,                 [cre_prg] 
        ,                 [cre_ip] 
        ,                 [cre_date]
        ,                 [del_flg]
        )
        VALUES (
                          LEFT(@w_unique_id, 6)
        ,                 @P_delivery_nm1
        ,                 @P_delivery_kn1
        ,                 @P_delivery_nm2
        ,                 @P_delivery_kn2
        ,                 @P_zip_cd
        ,                 @P_prefecture_cd
        ,                 @P_city_nm
        ,                 @P_town_nm
        ,                 @P_apartment_nm
        ,                 @P_address1
        ,                 @P_address2
        ,                 @P_tel
        ,                 @P_fax
        ,                 @P_delivery_class_1
        ,                 @P_delivery_class_2
        ,                 @P_delivery_class_3
        ,                 @P_remark
        ,                 @P_cre_user
        ,                 @P_cre_prg
        ,                 @P_cre_ip
        ,                 @P_cre_date
        ,                 0
        )
        SELECT @w_unique_id AS delivery_cd
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        PRINT(ERROR_MESSAGE());
        ROLLBACK TRANSACTION;
    END CATCH;
END;
