USE [AZA]
GO

IF OBJECT_ID('dbo.usp_DeliveryExcel', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_DeliveryExcel]
GO

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_DeliveryExcel]
(
     @p_delivery_cd                                  NVARCHAR(6)  = ''
,    @p_delivery_nm                                  NVARCHAR(80) = ''
,    @p_delivery_kn                                  NVARCHAR(80) = ''
,    @p_address                                      NVARCHAR(100) = ''
,    @p_tel                                          NVARCHAR(20) = ''
,    @p_delivery_class_1                             NVARCHAR(50) = ''
,    @p_delivery_class_2                             NVARCHAR(50) = ''
,    @p_delivery_class_3                             NVARCHAR(50) = ''
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
         @w_prefecture_cd               NVARCHAR(50) = 'prefecture_div'
      ,  @w_delivery_class_cd_1         NVARCHAR(50) = 'delivery_class_1_div'
      ,  @w_delivery_class_cd_2         NVARCHAR(50) = 'delivery_class_2_div'
      ,  @w_delivery_class_cd_3         NVARCHAR(50) = 'delivery_class_3_div'

    SELECT
            d.delivery_cd                                                           AS '納入先コード'
    ,       CONCAT(d.delivery_nm1, d.delivery_nm2)                                  AS '納入先名' 
    ,       CONCAT(d.delivery_kn1, d.delivery_kn2)                                  AS 'フリガナ'
    ,       d.zip_cd                                                                AS  '郵便番号'
    ,       CONCAT(slv_pre.lib_val_nm, d.city_nm, d.town_nm, d.apartment_nm)        AS  '住所'
    ,       d.tel                                                                   AS '電話番号'
    ,       d.fax                                                                   AS 'FAX番号'
    ,       slv_dc_1.lib_val_nm                                                     AS '納入先分類１'
    ,       slv_dc_2.lib_val_nm                                                     AS '納入先分類２'
    ,       slv_dc_3.lib_val_nm                                                     AS '納入先分類３'
    ,       d.remark                                                                AS '備考'
    ,       d.cre_date                                                              AS '登録日付'
    ,       crmu.user_nm                                                            AS '登録利用者'
    ,       d.upd_date                                                              AS '最終更新'
    ,       udmu.user_nm                                                            AS '最終利用者名'
    FROM [dbo].[m_delivery]     AS    d
    LEFT OUTER JOIN s_lib_val   AS    slv_pre
                                ON   (d.prefecture_cd = slv_pre.lib_val_cd)
    AND                              (slv_pre.lib_cd = @w_prefecture_cd)
    
    LEFT OUTER JOIN s_lib_val   AS   slv_dc_1
                                ON   (d.delivery_class_1 = slv_dc_1.lib_val_cd)
    AND                              (slv_dc_1.lib_cd = @w_delivery_class_cd_1)
    
    LEFT OUTER JOIN s_lib_val   AS   slv_dc_2
                                ON  (d.delivery_class_2 = slv_dc_2.lib_val_cd)
    AND                             (slv_dc_2.lib_cd = @w_delivery_class_cd_2)
    LEFT OUTER JOIN s_lib_val   AS   slv_dc_3
                                ON  (d.delivery_class_3 = slv_dc_3.lib_val_cd)
    AND                             (slv_dc_3.lib_cd = @w_delivery_class_cd_3)
    LEFT OUTER JOIN m_users     AS   crmu
                                ON  (d.cre_user = crmu.user_cd)
    LEFT OUTER JOIN m_users     AS   udmu
                                ON  (d.upd_user = udmu.user_cd)
    WHERE 
        (d.delivery_cd          LIKE N'%' + @p_delivery_cd + '%'        OR @p_delivery_cd       IS NULL)      AND
        (d.delivery_nm1         LIKE N'%' + @p_delivery_nm + '%'        OR @p_delivery_nm       IS NULL)      AND
        (d.delivery_nm2         LIKE N'%' + @p_delivery_nm + '%'        OR @p_delivery_nm       IS NULL)      AND
        (d.delivery_kn1         LIKE N'%' + @p_delivery_kn  + '%'       OR @p_delivery_kn       IS NULL)      AND
        (d.delivery_kn2         LIKE N'%' + @p_delivery_kn + '%'        OR  @p_delivery_kn      IS NULL)      AND
        (CONCAT(slv_pre.lib_val_nm, d.city_nm, d.town_nm, d.apartment_nm) LIKE N'%' + @p_address + '%' OR @p_address IS NULL)       AND
        (d.tel                  LIKE N'%' + @p_tel + '%'                OR @p_tel               IS NULL)      AND
        (slv_dc_1.lib_val_cd    =           @p_delivery_class_1         OR @p_delivery_class_1  IS NULL
                                                                        OR @p_delivery_class_1 = '')          AND
        (slv_dc_2.lib_val_cd    =           @p_delivery_class_2         OR @p_delivery_class_2  IS NULL
                                                                        OR @p_delivery_class_2 = '')          AND
        (slv_dc_3.lib_val_cd    =           @p_delivery_class_3         OR @p_delivery_class_3 IS NULL
                                                                        OR @p_delivery_class_3 = '')
END;
