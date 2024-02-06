CREATE PROCEDURE [dbo].[usp_InsertDelivery]
    @delivery_cd nvarchar(6),
    @delivery_nm1 varchar(80),
    @delivery_kn1 varchar(80),
    @delivery_nm2 varchar(80),
    @delivery_kn2 varchar(80),
    @zip_cd nvarchar(8),
    @prefecture_cd nvarchar(2),
    @city_nm nvarchar(24),
    @town_nm nvarchar(32),
    @apartment_nm nvarchar(32),
    @address1 nvarchar(200),
    @address2 nvarchar(200),
    @tel nvarchar(20),
    @fax nvarchar(20),
    @delivery_class_1 nvarchar(3),
    @delivery_class_2 nvarchar(3),
    @delivery_class_3 nvarchar(3),
    @remark nvarchar(1000),
    @cre_user nvarchar(50),
    @cre_prg nvarchar(50),
    @cre_ip nvarchar(20),
    @cre_date datetime2(7),
    @upd_user nvarchar(50),
    @upd_prg nvarchar(50),
    @upd_ip nvarchar(20),
    @upd_date datetime2(7),
    @del_user nvarchar(50),
    @del_prg nvarchar(50),
    @del_ip nvarchar(20),
    @del_date datetime2(7),
    @del_flg int
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO [dbo].[m_delivery] (
            [delivery_cd], [delivery_nm1], [delivery_kn1], [delivery_nm2], [delivery_kn2],
            [zip_cd], [prefecture_cd], [city_nm], [town_nm], [apartment_nm], [address1],
            [address2], [tel], [fax], [delivery_class_1], [delivery_class_2], [delivery_class_3],
            [remark], [cre_user], [cre_prg], [cre_ip], [cre_date], [upd_user], [upd_prg],
            [upd_ip], [upd_date], [del_user], [del_prg], [del_ip], [del_date], [del_flg]
        )
        VALUES (
            @delivery_cd, @delivery_nm1, @delivery_kn1, @delivery_nm2, @delivery_kn2,
            @zip_cd, @prefecture_cd, @city_nm, @town_nm, @apartment_nm, @address1,
            @address2, @tel, @fax, @delivery_class_1, @delivery_class_2, @delivery_class_3,
            @remark, @cre_user, @cre_prg, @cre_ip, @cre_date, @upd_user, @upd_prg,
            @upd_ip, @upd_date, @del_user, @del_prg, @del_ip, @del_date, @del_flg
        );

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        -- Handle the error as per your requirements (logging, raising an error, etc.)
        -- For example:
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISEERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;