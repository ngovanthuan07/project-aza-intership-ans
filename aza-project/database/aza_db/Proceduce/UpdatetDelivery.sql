USE [AZA]
GO

IF OBJECT_ID('dbo.[usp_UpdateDelivery]', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_UpdateDelivery]
GO
CREATE PROCEDURE [dbo].[usp_UpdateDelivery]
        @P_delivery_cd               NVARCHAR(6)
,       @P_delivery_nm1              VARCHAR(80)
,       @P_delivery_kn1              VARCHAR(80)
,       @P_delivery_nm2              VARCHAR(80)
,       @P_delivery_kn2              VARCHAR(80)
,       @P_zip_cd                    NVARCHAR(8)
,       @P_prefecture_cd             NVARCHAR(2)
,       @P_city_nm                   NVARCHAR(24)
,       @P_town_nm                   NVARCHAR(32)
,       @P_apartment_nm              NVARCHAR(32)
,       @P_address1                  NVARCHAR(200)
,       @P_address2                  NVARCHAR(200)
,       @P_tel                       NVARCHAR(20)
,       @P_fax                       NVARCHAR(20)
,       @P_delivery_class_1          NVARCHAR(3)
,       @P_delivery_class_2          NVARCHAR(3)
,       @P_delivery_class_3          NVARCHAR(3)
,       @P_remark                    NVARCHAR(1000)
,       @P_upd_user                  NVARCHAR(50)
,       @P_upd_prg                   NVARCHAR(50)
,       @P_upd_ip                    NVARCHAR(20)
,       @P_upd_date                  DATETIME2(7)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION
        
        UPDATE [dbo].[m_delivery]
        SET
              [delivery_nm1]                  =     @P_delivery_nm1
        ,     [delivery_kn1]                  =     @P_delivery_kn1
        ,     [delivery_nm2]                  =     @P_delivery_nm2
        ,     [delivery_kn2]                  =     @P_delivery_kn2
        ,     [zip_cd]                        =     @P_zip_cd
        ,     [prefecture_cd]                 =     @P_prefecture_cd
        ,     [city_nm]                       =     @P_city_nm
        ,     [town_nm]                       =     @P_town_nm
        ,     [apartment_nm]                  =     @P_apartment_nm
        ,     [address1]                      =     @P_address1
        ,     [address2]                      =     @P_address2
        ,     [tel]                           =     @P_tel
        ,     [fax]                           =     @P_fax
        ,     [delivery_class_1]              =     @P_delivery_class_1
        ,     [delivery_class_2]              =     @P_delivery_class_2
        ,     [delivery_class_3]              =     @P_delivery_class_3
        ,     [remark]                        =     @P_remark
        ,     [upd_user]                      =     @P_upd_user
        ,     [upd_prg]                       =     @P_upd_prg
        ,     [upd_ip]                        =     @P_upd_ip
        ,     [upd_date]                      =     @P_upd_date
        WHERE [delivery_cd]                   =     @P_delivery_cd;
        SELECT (1)
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        PRINT(ERROR_MESSAGE());
        ROLLBACK TRANSACTION;
    END CATCH;
END;
