USE [AZA]
GO

IF OBJECT_ID('dbo.[usp_UpdateDelivery]', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_UpdateDelivery]
GO
CREATE PROCEDURE [dbo].[usp_UpdateDelivery]
    @p_delivery_cd nvarchar(6),
    @p_delivery_nm1 varchar(80),
    @p_delivery_kn1 varchar(80),
    @p_delivery_nm2 varchar(80),
    @p_delivery_kn2 varchar(80),
    @p_zip_cd nvarchar(8),
    @p_prefecture_cd nvarchar(2),
    @p_city_nm nvarchar(24),
    @p_town_nm nvarchar(32),
    @p_apartment_nm nvarchar(32),
    @p_address1 nvarchar(200),
    @p_address2 nvarchar(200),
    @p_tel nvarchar(20),
    @p_fax nvarchar(20),
    @p_delivery_class_1 nvarchar(3),
    @p_delivery_class_2 nvarchar(3),
    @p_delivery_class_3 nvarchar(3),
    @p_remark nvarchar(1000),
    @p_cre_user nvarchar(50),
    @p_cre_prg nvarchar(50),
    @p_cre_ip nvarchar(20),
    @p_cre_date datetime2(7)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION
        
         UPDATE [dbo].[m_delivery]
        SET
            [delivery_nm1] = @p_delivery_nm1,
            [delivery_kn1] = @p_delivery_kn1,
            [delivery_nm2] = @p_delivery_nm2,
            [delivery_kn2] = @p_delivery_kn2,
            [zip_cd] = @p_zip_cd,
            [prefecture_cd] = @p_prefecture_cd,
            [city_nm] = @p_city_nm,
            [town_nm] = @p_town_nm,
            [apartment_nm] = @p_apartment_nm,
            [address1] = @p_address1,
            [address2] = @p_address2,
            [tel] = @p_tel,
            [fax] = @p_fax,
            [delivery_class_1] = @p_delivery_class_1,
            [delivery_class_2] = @p_delivery_class_2,
            [delivery_class_3] = @p_delivery_class_3,
            [remark] = @p_remark,
            [upd_user] = @p_upd_user,
            [upd_prg] = @p_upd_prg,
            [upd_ip] = @p_upd_ip,
            [upd_date] = @p_upd_date,
            [del_user] = @p_del_user,
            [del_prg] = @p_del_prg,
            [del_ip] = @p_del_ip,
            [del_date] = @p_del_date,
            [del_flg] = @p_del_flg
        WHERE [delivery_cd] = @p_delivery_cd;
   
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        PRINT(ERROR_MESSAGE());
        ROLLBACK TRANSACTION;
    END CATCH;
END;
