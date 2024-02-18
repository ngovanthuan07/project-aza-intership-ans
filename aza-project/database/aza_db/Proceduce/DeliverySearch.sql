USE [AZA]
GO

IF OBJECT_ID('dbo.usp_DeliverySearch', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].[usp_DeliverySearch]
GO

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[usp_DeliverySearch]
(
     @P_delivery_cd                                  NVARCHAR(6)    = ''
,    @P_delivery_nm                                  NVARCHAR(80)   = ''
,    @P_delivery_kn                                  NVARCHAR(80)   = ''
,    @P_address                                      NVARCHAR(100)  = ''
,    @P_tel                                          NVARCHAR(20)   = ''
,    @P_delivery_class_1                             NVARCHAR(50)   = ''
,    @P_delivery_class_2                             NVARCHAR(50)   = ''
,    @P_delivery_class_3                             NVARCHAR(50)   = ''
,    @P_order_by_column                              VARCHAR(20)    = 'delivery_cd'
,    @P_sort_type                                    VARCHAR(20)    = 'ASC'
,    @P_current_page                                 INT            = 1
,    @P_limit                                        INT            = 10
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
         @w_prefecture_cd               NVARCHAR(50) = 'prefecture_div'
      ,  @w_delivery_class_cd_1         NVARCHAR(50) = 'delivery_class_1_div'
      ,  @w_delivery_class_cd_2         NVARCHAR(50) = 'delivery_class_2_div'
      ,  @w_delivery_class_cd_3         NVARCHAR(50) = 'delivery_class_3_div'
      ,  @w_start INT

    SET @w_start = @P_limit * (@P_current_page - 1)

    CREATE TABLE #RESULT(
        delivery_cd                 NVARCHAR(6)
    ,   delivery_nm                 NVARCHAR(max)
    ,   delivery_kn                 NVARCHAR(max)
	,	zip_cd						NVARCHAR(8)
    ,   delivery_addr               NVARCHAR(max)
    ,   tel                         NVARCHAR(20)
	,	fax							NVARCHAR(20)
	,	delivery_class_1			NVARCHAR(80)
	,	delivery_class_2			NVARCHAR(80)
	,	delivery_class_3			NVARCHAR(80)
	,	remark						NVARCHAR(1000)
	,	cre_date					DATETIME2
	,	cre_user					NVARCHAR(50)
	,	upd_date					DATETIME2
	,	upd_user					NVARCHAR(50)
    )

    INSERT INTO #RESULT
    SELECT
            d.delivery_cd
        ,   CONCAT(d.delivery_nm1, d.delivery_nm2)
        ,   CONCAT(d.delivery_kn1, d.delivery_kn2)
		,	d.zip_cd
        ,   CONCAT(slv_pre.lib_val_nm, d.city_nm, d.town_nm, d.apartment_nm)
        ,   d.tel
		,	d.fax
		,	slv_dc_1.lib_val_nm
		,	slv_dc_2.lib_val_nm
		,	slv_dc_3.lib_val_nm
		,	d.remark
		,	d.cre_date
		,	cre_m_user.user_nm
		,	d.upd_date
		,	upd_m_user.user_nm
    FROM [dbo].[m_delivery]     AS d
    LEFT OUTER JOIN s_lib_val   AS slv_pre    ON   (
        d.prefecture_cd         =  slv_pre.lib_val_cd
    AND slv_pre.lib_cd          =  @w_prefecture_cd
    )
    LEFT OUTER JOIN s_lib_val   AS slv_dc_1   ON    (
        d.delivery_class_1      =  slv_dc_1.lib_val_cd
    AND slv_dc_1.lib_cd         =  @w_delivery_class_cd_1
    )
    LEFT OUTER JOIN s_lib_val   AS slv_dc_2   ON    (
        d.delivery_class_2      =  slv_dc_2.lib_val_cd
    AND slv_dc_2.lib_cd         =  @w_delivery_class_cd_2
    )
    LEFT OUTER JOIN s_lib_val   AS slv_dc_3   ON    (
        d.delivery_class_3      =  slv_dc_3.lib_val_cd
    AND slv_dc_3.lib_cd         =  @w_delivery_class_cd_3
    )
    LEFT OUTER JOIN m_users     AS cre_m_user ON     (
		d.cre_user			    =  cre_m_user.user_cd 
	AND cre_m_user.del_flg		= 0
	) 
	LEFT OUTER JOIN m_users     AS upd_m_user  ON    (
		d.upd_user			    = upd_m_user.user_cd
	AND upd_m_user.del_flg		= 0
    )
    WHERE (d.del_flg = 0)
    AND   (
       @P_delivery_cd           IS NULL
    OR d.delivery_cd            LIKE N'%' + @P_delivery_cd + '%'
    )
    AND   (
       @P_delivery_nm           IS NULL
    OR d.delivery_nm1           LIKE N'%' + @P_delivery_nm + '%'
    )
    AND   (
       @P_delivery_nm           IS NULL
    OR d.delivery_nm2           LIKE N'%' + @P_delivery_nm + '%'
    )
    AND    (
       @P_delivery_kn           IS NULL 
    OR d.delivery_kn1           LIKE N'%' + @P_delivery_kn  + '%'
    )
    AND     (
       @P_delivery_kn           IS NULL
    OR d.delivery_kn2           LIKE N'%' + @P_delivery_kn + '%'
    )
    AND     (
       @P_address               IS NULL
    OR CONCAT(slv_pre.lib_val_nm, d.city_nm, d.town_nm, d.apartment_nm)
                                LIKE N'%' + @P_address + '%'           
    )       
    AND     (
       @P_tel                   IS NULL
    OR d.tel                    LIKE N'%' + @P_tel + '%'
    )      
    AND    (
       @P_delivery_class_1      =  '0'
    OR slv_dc_1.lib_val_cd      = @P_delivery_class_1
    )
    AND    (
       @P_delivery_class_2      =  '0'
    OR slv_dc_2.lib_val_cd      =  @P_delivery_class_2
    )
    AND     (
       @P_delivery_class_3      =  '0'
    OR slv_dc_3.lib_val_cd      = @P_delivery_class_3      
    )

    SELECT *
    FROM #RESULT AS rs
    ORDER BY
        CASE @P_sort_type
             WHEN 'ASC'
             THEN
                   CASE @P_order_by_column
                        WHEN 'delivery_cd'      THEN rs.delivery_cd
                        WHEN 'delivery_nm'      THEN rs.delivery_nm
                        WHEN 'delivery_kn'      THEN rs.delivery_kn
                        WHEN 'address'          THEN rs.delivery_addr
                        WHEN 'tel'              THEN rs.tel
                        WHEN 'delivery_class_1' THEN rs.delivery_class_1
                        WHEN 'delivery_class_2' THEN rs.delivery_class_2
                        WHEN 'delivery_class_3' THEN rs.delivery_class_3
             END
        END ASC,
        CASE @P_sort_type
             WHEN 'DESC'
             THEN
                   CASE @P_order_by_column
                        WHEN 'delivery_cd'      THEN rs.delivery_cd
                        WHEN 'delivery_nm'      THEN rs.delivery_nm
                        WHEN 'delivery_kn'      THEN rs.delivery_kn
                        WHEN 'address'          THEN rs.delivery_addr
                        WHEN 'tel'              THEN rs.tel
                        WHEN 'delivery_class_1' THEN rs.delivery_class_1
                        WHEN 'delivery_class_2' THEN rs.delivery_class_2
                        WHEN 'delivery_class_3' THEN rs.delivery_class_3
             END
        END DESC
    OFFSET @w_start ROWS 
    FETCH NEXT @P_limit ROWS ONLY;

	SELECT  COUNT(1) AS 'totalItems'
    FROM    #RESULT;
    
-- Drop Temp
    DROP TABLE #RESULT;  
END;
