USE [AZA]
GO

IF OBJECT_ID('dbo.usp_DeliverySearch', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_DeliverySearch]
GO

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_DeliverySearch]
(
     @Param_delivery_cd                                  NVARCHAR(6)  = ''
,    @Param_delivery_nm1                                 NVARCHAR(80) = ''
,    @Param_delivery_nm2                                 NVARCHAR(80) = ''
,    @Param_delivery_kn1                                 NVARCHAR(80) = ''
,    @Param_delivery_kn2                                 NVARCHAR(80) = ''
,    @Param_prefecture                                   NVARCHAR(80) = ''
,    @Param_city_nm                                      NVARCHAR(24) = ''
,    @Param_town_nm                                      NVARCHAR(32) = ''
,    @Param_apartment_nm                                 NVARCHAR(32) = ''
,    @Param_tel                                          NVARCHAR(20) = ''
,    @Param_delivery_class_1                             NVARCHAR(50) = ''
,    @Param_delivery_class_2                             NVARCHAR(50) = ''
,    @Param_delivery_class_3                             NVARCHAR(50) = ''
,    @OrderByColumn                                      VARCHAR(20) = 'd4'
,    @TypeSort                                           VARCHAR(20) = 'ASC'
,    @CurrentPage                                        INT = 1
,    @Limit                                              INT = 10
,    @TotalItem                                          INT OUT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
         @define_prefecture_cd          NVARCHAR(50) = 'prefecture_div'
      ,  @define_delivery_class_cd_1    NVARCHAR(50) = 'delivery_class_1_div'
      ,  @define_delivery_class_cd_2    NVARCHAR(50) = 'delivery_class_2_div'
      ,  @define_delivery_class_cd_3    NVARCHAR(50) = 'delivery_class_3_div'
      ,  @sql_query_temp                NVARCHAR(MAX)
      ,  @start INT
    SET @start = @Limit * (@currentPage - 1)

    CREATE TABLE #TempDeliverySearchResults(
         delivery_cd    NVARCHAR(80)
,        delivery_nm1   NVARCHAR(80)
,        delivery_nm2   NVARCHAR(80)
,        delivery_kn1   NVARCHAR(80)
,        delivery_kn2   NVARCHAR(80)
,        lib_val_nm     NVARCHAR(80)
,        city_nm        NVARCHAR(80) 
,        town_nm        NVARCHAR(80)
,        apartment_nm   NVARCHAR(80)
,        tel            NVARCHAR(80)
,        lib_val_nm1    NVARCHAR(80)
,        lib_val_nm2    NVARCHAR(80)
,        lib_val_nm3    NVARCHAR(80)
    )
    INSERT INTO #TempDeliverySearchResults
    SELECT  d.delivery_cd,
            d.delivery_nm1,
            d.delivery_nm2,
            d.delivery_kn1,
            d.delivery_kn2,
            slv_pre.lib_val_nm,
            d.city_nm,
            d.town_nm,
            d.apartment_nm,
            d.tel,
            slv_dc_1.lib_val_nm,
            slv_dc_2.lib_val_nm,
            slv_dc_3.lib_val_nm
    FROM [dbo].[m_delivery] AS d
    LEFT OUTER JOIN s_lib_val AS slv_pre
        ON d.prefecture_cd = slv_pre.lib_val_cd
        AND slv_pre.lib_cd = @define_prefecture_cd
    LEFT OUTER JOIN s_lib_val AS slv_dc_1
        ON d.delivery_class_1 = slv_dc_1.lib_val_cd
        AND slv_dc_1.lib_cd = @define_delivery_class_cd_1
    LEFT OUTER JOIN s_lib_val AS slv_dc_2
        ON d.delivery_class_2 = slv_dc_2.lib_val_cd
        AND slv_dc_2.lib_cd = @define_delivery_class_cd_2
    LEFT OUTER JOIN s_lib_val AS slv_dc_3
        ON d.delivery_class_3 = slv_dc_3.lib_val_cd
        AND slv_dc_3.lib_cd = @define_delivery_class_cd_3
    WHERE
        ((d.delivery_cd LIKE N'%' + @Param_delivery_cd + '%') OR (@Param_delivery_cd IS NULL))
         AND
        ((d.delivery_nm1 LIKE N'%' + @Param_delivery_nm1 + '%') OR (@Param_delivery_nm1 IS NULL))
         AND
        ((d.delivery_nm2 LIKE N'%' + @Param_delivery_nm2 + '%') OR (@Param_delivery_nm2 IS NULL))
         AND
        ((d.delivery_kn1 LIKE N'%' + @Param_delivery_kn1 + '%') OR (@Param_delivery_kn1 IS NULL))
        AND
        ((d.delivery_kn2 LIKE N'%' + @Param_delivery_kn2 + '%') OR (@Param_delivery_kn2 IS NULL))
        AND
        (
            (
                slv_pre.lib_val_nm LIKE N'%' + @Param_prefecture + '%'
            ) 
            OR (@Param_prefecture IS NULL OR @Param_prefecture = '')
        )
        --
         AND
        ((d.city_nm LIKE N'%' + @Param_city_nm + '%') OR (@Param_city_nm IS NULL))
         AND
        ((d.town_nm LIKE N'%' + @Param_town_nm + '%') OR (@Param_town_nm IS NULL))
         AND
        ((d.apartment_nm LIKE N'%' + @Param_apartment_nm + '%') OR (@Param_apartment_nm IS NULL))
         AND
        ((d.tel LIKE N'%' + @Param_tel + '%') OR (@Param_tel IS NULL))
         AND
         (
            ( slv_dc_1.lib_val_nm LIKE N'%' + @Param_delivery_class_1 + '%') 
             OR (@Param_delivery_class_1 IS NULL OR @Param_delivery_class_1 = '')
         )
         AND
         (
            ( slv_dc_2.lib_val_nm LIKE N'%' + @Param_delivery_class_2 + '%') 
             OR (@Param_delivery_class_2 IS NULL OR @Param_delivery_class_2 = '')
         )
         AND
         (
            ( slv_dc_3.lib_val_nm LIKE N'%' + @Param_delivery_class_3 + '%') 
            OR (@Param_delivery_class_3 IS NULL OR @Param_delivery_class_3 = '')
         )

        SELECT @TotalItem = COUNT(1) FROM #TempDeliverySearchResults;

        SET @sql_query_temp = '
        SELECT *
        FROM @TempDeliverySearchResults AS tdsr
        ORDER BY ' + 
            CASE 
                WHEN @OrderByColumn = 'd4'  THEN 'tdsr.delivery_cd'
                WHEN @OrderByColumn = 'd5'  THEN 'tdsr.delivery_nm1, tdsr.delivery_nm2'
                WHEN @OrderByColumn = 'd6'  THEN 'tdsr.delivery_kn1, tdsr.delivery_kn2'
                WHEN @OrderByColumn = 'd7'  THEN 'tdsr.lib_val_nm, tdsr.city_nm, tdsr.town_nm, tdsr.apartment_nm'
                WHEN @OrderByColumn = 'd8'  THEN 'tdsr.tel'
                WHEN @OrderByColumn = 'd9'  THEN 'tdsr.lib_val_nm'
                WHEN @OrderByColumn = 'd10' THEN 'tdsr.lib_val_nm'
            END + ' ' + @TypeSort + '
        OFFSET ' +  CONVERT(VARCHAR, @start) + ' ROWS 
        FETCH NEXT ' + CONVERT(VARCHAR, @Limit)  + ' ROWS ONLY'

    EXEC sp_executesql @sql_query_temp


-- Drop the temporary table when done
    DROP TABLE #TempDeliverySearchResults;  
END;
