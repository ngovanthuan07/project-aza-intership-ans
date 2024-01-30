USE [AZA]
GO

IF OBJECT_ID('dbo.usp_DeliverySearch', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_DeliverySearch]
GO

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_DeliverySearch]
(
     @p_delivery_cd                                  NVARCHAR(6)  = ''
,    @p_delivery_nm                                  NVARCHAR(80) = ''
,    @p_delivery_kn                                  NVARCHAR(80) = ''
,    @p_address                                      NVARCHAR(100) = ''
,    @p_tel                                          NVARCHAR(20) = ''
,    @p_delivery_class_1                             NVARCHAR(50) = ''
,    @p_delivery_class_2                             NVARCHAR(50) = ''
,    @p_delivery_class_3                             NVARCHAR(50) = ''
,    @p_order_by_column                              VARCHAR(20) = 'delivery_cd'
,    @p_sort_type                                    VARCHAR(20) = 'ASC'
,    @p_current_page                                 INT = 1
,    @p_limit                                        INT = 10
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
         @w_prefecture_cd               NVARCHAR(50) = 'prefecture_div'
      ,  @w_delivery_class_cd_1         NVARCHAR(50) = 'delivery_class_1_div'
      ,  @w_delivery_class_cd_2         NVARCHAR(50) = 'delivery_class_2_div'
      ,  @w_delivery_class_cd_3         NVARCHAR(50) = 'delivery_class_3_div'
      ,  @w_sql_query_temp              NVARCHAR(MAX)
      ,  @w_start INT

    SET @w_start = @p_limit * (@p_current_page - 1)

    CREATE TABLE #TempDeliverySearchResults(
         delivery_cd    NVARCHAR(80)  NULL
,        delivery_nm1   NVARCHAR(80)  NULL
,        delivery_nm2   NVARCHAR(80)  NULL
,        delivery_kn1   NVARCHAR(255) NULL
,        delivery_kn2   NVARCHAR(255) NULL
,        address        NVARCHAR(255) NULL
,        tel            NVARCHAR(80)  NULL
,        lib_val_nm1_dc NVARCHAR(80)  NULL
,        lib_val_cd1_dc NVARCHAR(80)  NULL
,        lib_val_nm2_dc NVARCHAR(80)  NULL
,        lib_val_cd2_dc NVARCHAR(80)  NULL
,        lib_val_nm3_dc NVARCHAR(80)  NULL
,        lib_val_cd3_dc NVARCHAR(80)  NULL
    )

    INSERT INTO #TempDeliverySearchResults
    SELECT  d.delivery_cd
    ,       d.delivery_nm1
    ,       d.delivery_nm2
    ,       d.delivery_kn1
    ,       d.delivery_kn2
    ,       CONCAT(slv_pre.lib_val_nm, d.city_nm, d.town_nm, d.apartment_nm) AS  'address'
    ,       d.tel
    ,       slv_dc_1.lib_val_nm  
    ,       slv_dc_1.lib_val_cd
    ,       slv_dc_2.lib_val_nm
    ,       slv_dc_2.lib_val_cd
    ,       slv_dc_3.lib_val_nm
    ,       slv_dc_3.lib_val_cd
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
        
       

        SELECT *
        FROM #TempDeliverySearchResults AS tdsr
        ORDER BY
            CASE 
                WHEN @p_order_by_column = 'delivery_cd' AND @p_sort_type = 'ASC'       THEN tdsr.delivery_cd
            END ASC,
            CASE 
                WHEN @p_order_by_column = 'delivery_cd' AND @p_sort_type = 'DESC'      THEN tdsr.delivery_cd
            END DESC,
            CASE 
                WHEN @p_order_by_column = 'delivery_nm' AND @p_sort_type = 'ASC'       THEN CONCAT(tdsr.delivery_nm1, tdsr.delivery_nm2)
            END ASC,
            CASE 
                WHEN @p_order_by_column = 'delivery_nm' AND @p_sort_type = 'DESC'      THEN CONCAT(tdsr.delivery_nm1, tdsr.delivery_nm2)
            END DESC,
            CASE 
                WHEN @p_order_by_column = 'delivery_kn'      AND @p_sort_type = 'ASC'  THEN CONCAT(tdsr.delivery_kn1, tdsr.delivery_kn2)
            END ASC,
            CASE 
                WHEN @p_order_by_column = 'delivery_kn'      AND @p_sort_type = 'DESC' THEN CONCAT(tdsr.delivery_kn1, tdsr.delivery_kn2)
            END DESC,
            CASE 
                WHEN @p_order_by_column = 'address'          AND @p_sort_type = 'ASC'  THEN tdsr.address
            END ASC,
            CASE 
                WHEN @p_order_by_column = 'address'          AND @p_sort_type = 'DESC' THEN tdsr.address
            END DESC,
            CASE 
                WHEN @p_order_by_column = 'tel'              AND @p_sort_type = 'ASC'  THEN tdsr.tel
            END ASC,
            CASE 
                WHEN @p_order_by_column = 'tel'              AND @p_sort_type = 'DESC' THEN tdsr.tel
            END DESC,
            CASE
                WHEN @p_order_by_column = 'delivery_class_1' AND @p_sort_type = 'ASC'  THEN tdsr.lib_val_cd1_dc
            END ASC,
            CASE 
                WHEN @p_order_by_column = 'delivery_class_1' AND @p_sort_type = 'DESC' THEN tdsr.lib_val_cd1_dc
            END DESC,
            CASE
                WHEN @p_order_by_column = 'delivery_class_2' AND @p_sort_type = 'ASC'  THEN tdsr.lib_val_cd2_dc
            END ASC,
            CASE 
                WHEN @p_order_by_column = 'delivery_class_2' AND @p_sort_type = 'DESC' THEN tdsr.lib_val_cd2_dc
            END DESC,
            CASE
                WHEN @p_order_by_column = 'delivery_class_3' AND @p_sort_type = 'ASC'  THEN  tdsr.lib_val_cd3_dc
            END ASC,
            CASE 
                WHEN @p_order_by_column = 'delivery_class_3' AND @p_sort_type = 'DESC' THEN tdsr.lib_val_cd3_dc
            END DESC
        OFFSET @w_start ROWS 
        FETCH NEXT @p_limit ROWS ONLY;


	SELECT  COUNT(1) AS 'TotalItem'
    FROM    #TempDeliverySearchResults;
    
-- Drop Temp
    DROP TABLE #TempDeliverySearchResults;  
END;
