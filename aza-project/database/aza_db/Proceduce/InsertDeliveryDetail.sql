USE [AZA]
GO

IF OBJECT_ID('dbo.[usp_InsertDelivery]', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_InsertDelivery]
GO
CREATE PROCEDURE [dbo].[usp_InsertDelivery]
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
        
        INSERT INTO [dbo].[m_delivery] (
            [delivery_cd], [delivery_nm1], [delivery_kn1], [delivery_nm2], [delivery_kn2],
            [zip_cd], [prefecture_cd], [city_nm], [town_nm], [apartment_nm], [address1],
            [address2], [tel], [fax], [delivery_class_1], [delivery_class_2], [delivery_class_3],
            [remark], [cre_user], [cre_prg], [cre_ip], [cre_date]
        )
        VALUES (
            @p_delivery_cd, @p_delivery_nm1, @p_delivery_kn1, @p_delivery_nm2, @p_delivery_kn2,
            @p_zip_cd, @p_prefecture_cd, @p_city_nm, @p_town_nm, @p_apartment_nm, @p_address1,
            @p_address2, @p_tel, @p_fax, @p_delivery_class_1, @p_delivery_class_2, @p_delivery_class_3,
            @p_remark, @p_cre_user, @p_cre_prg, @p_cre_ip, @p_cre_date
        )
   
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        PRINT(ERROR_MESSAGE());
        ROLLBACK TRANSACTION;
    END CATCH;
END;
