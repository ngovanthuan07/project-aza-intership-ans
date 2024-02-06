IF  EXISTS (
	SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[dbo].[SPC_016_DELIVERY_SEARCH_FND1]') AND type in (N'P', N'PC'))
DROP PROCEDURE SPC_016_DELIVERY_SEARCH_FND1

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE SPC_016_DELIVERY_SEARCH_FND1
    @P_delivery_cd              NVARCHAR(6)         =   ''
,   @P_delivery_nm              NVARCHAR(MAX)       =   ''
,   @P_delivery_kn              NVARCHAR(MAX)       =   ''
,   @P_delivery_adr             NVARCHAR(200)       =   ''
,   @P_delivery_tel             NVARCHAR(20)        =   ''
,   @P_delivery_class_1         NVARCHAR(3)			=   ''
,   @P_delivery_class_2         NVARCHAR(3)			=   ''
,   @P_delivery_class_3         NVARCHAR(3)			=   ''
,   @P_page                     INT                 =   1
,   @P_page_size                INT                 =   10
,   @P_type						INT					=	0
AS
BEGIN
    SET NOCOUNT ON
    -------------------------------------------------------------
    DECLARE 
		@delimiter				nvarchar(1)			= ' '
	,	@to_delimiter			nvarchar(1)			= '%'
	,	@totalRecord            bigint              = 0
    ,   @pageMax                int                 = 0
    ,   @SQL_JIN                NVARCHAR(MAX)       = '' -- sql join
    ,   @SQL_CND                NVARCHAR(MAX)       = '' -- sql condition search
	,	@delivery_class_1_div   NVARCHAR(MAX)		= 'delivery_class_1_div'
	,	@delivery_class_2_div   NVARCHAR(MAX)		= 'delivery_class_2_div'
	,	@delivery_class_3_div   NVARCHAR(MAX)		= 'delivery_class_3_div'
	,	@prefecture_div			NVARCHAR(MAX)		= 'prefecture_div'
	--
    SET @P_delivery_cd                  =  dbo.FNC_SPLIP_AND_REPLACE_SPACE(@P_delivery_cd, @delimiter, @to_delimiter)
    --SET @P_delivery_nm                  =  dbo.FNC_SPLIP_AND_REPLACE_SPACE(@P_delivery_nm, @delimiter, @to_delimiter)
    --SET @P_delivery_kn                  =  dbo.FNC_SPLIP_AND_REPLACE_SPACE(@P_delivery_kn, @delimiter, @to_delimiter)
    --SET @P_delivery_adr                 =  dbo.FNC_SPLIP_AND_REPLACE_SPACE(@P_delivery_adr, @delimiter, @to_delimiter)
    SET @P_delivery_tel                 =  dbo.FNC_SPLIP_AND_REPLACE_SPACE(@P_delivery_tel, @delimiter, @to_delimiter)
    -------------------------------------------------------------
    
    -- CREATE TABLE TEMP #RESULT
    CREATE TABLE #RESULT(
        delivery_cd                 nvarchar(6)
    ,   delivery_nm                 nvarchar(max)
    ,   delivery_kn                 nvarchar(max)
	,	zip_cd						nvarchar(8)
    ,   delivery_addr               nvarchar(max)
    ,   tel                         nvarchar(20)
	,	fax							nvarchar(20)
	,	delivery_class_1			nvarchar(80)
	,	delivery_class_2			nvarchar(80)
	,	delivery_class_3			nvarchar(80)
	,	remark						nvarchar(1000)
	,	cre_date					datetime2
	,	cre_user					nvarchar(50)
	,	upd_date					datetime2
	,	upd_user					nvarchar(50)
    )
	---------------------------------------------------------------
	SET @SQL_JIN = 'LEFT OUTER JOIN s_lib_val AS lib_1 WITH(NOLOCK) ON (' +
						'm_delivery.delivery_class_1	= lib_1.lib_val_cd ' +
					'AND lib_1.lib_cd					LIKE ''%' + @delivery_class_1_div + '%'' '
					+ ' )' +
					'LEFT OUTER JOIN s_lib_val AS lib_2 WITH(NOLOCK) ON (' +
						'm_delivery.delivery_class_2	= lib_2.lib_val_cd ' +
					'AND lib_2.lib_cd					LIKE ''%' + @delivery_class_2_div + '%'' '
					+ ' )' +
					'LEFT OUTER JOIN s_lib_val AS lib_3 WITH(NOLOCK) ON (' +
						'm_delivery.delivery_class_3	= lib_3.lib_val_cd ' +
					'AND lib_3.lib_cd					LIKE ''%' + @delivery_class_3_div + '%'' '
					+ ' )' +
					'LEFT OUTER JOIN s_lib_val AS lib_4 WITH(NOLOCK) ON (' +
						'm_delivery.prefecture_cd		= lib_4.lib_val_cd ' +
					'AND lib_4.lib_cd					LIKE ''%' + @prefecture_div + '%'' '
					+ ' )' +	 
					'LEFT OUTER JOIN m_users AS cre_m_user WITH(NOLOCK) ON( ' +
						'm_delivery.cre_user			= cre_m_user.user_cd ' +
					'AND cre_m_user.del_flg				= 0 ' +
					') ' +
					'LEFT OUTER JOIN m_users AS upd_m_user WITH(NOLOCK) ON( ' +
						'm_delivery.upd_user			= upd_m_user.user_cd ' +
					'AND upd_m_user.del_flg				= 0 ' +
					')'
    ---------------------------------------------------------------
    IF (@P_delivery_cd <> '')
	BEGIN
	SET @SQL_CND = @SQL_CND + 'AND m_delivery.delivery_cd  LIKE ''%' + @P_delivery_cd + '%'''
	END
	IF (@P_delivery_nm <> '')
	BEGIN
		--SET @SQL_CND = @SQL_CND + 'AND m_delivery.delivery_nm1 +  m_delivery.delivery_nm2  LIKE ''%' + @P_delivery_nm + '%'' '
		SET @SQL_CND = @SQL_CND + ' AND ' + [dbo].[FNC_SEARCH_LIKE](@P_delivery_nm, 'm_delivery.delivery_nm1 +  m_delivery.delivery_nm2')
	END
	IF (@P_delivery_kn <> '')
	BEGIN
		--SET @SQL_CND = @SQL_CND + 'AND m_delivery.delivery_kn1 + m_delivery.delivery_kn2  LIKE ''%' + @P_delivery_kn + '%'' '
		SET @SQL_CND = @SQL_CND + ' AND ' + [dbo].[FNC_SEARCH_LIKE](@P_delivery_kn, 'm_delivery.delivery_kn1 + m_delivery.delivery_kn2')
	END
	IF (@P_delivery_adr <> '')
	BEGIN
		--SET @SQL_CND = @SQL_CND + 'AND lib_4.lib_val_nm + m_delivery.city_nm + m_delivery.town_nm + m_delivery.apartment_nm  LIKE ''%' + @P_delivery_adr + '%'' '
		SET @SQL_CND = @SQL_CND + ' AND ' + [dbo].[FNC_SEARCH_LIKE](@P_delivery_adr, 'lib_4.lib_val_nm + m_delivery.city_nm + m_delivery.town_nm + m_delivery.apartment_nm')
	END
	IF (@P_delivery_tel <> '')
	BEGIN
	SET @SQL_CND = @SQL_CND + 'AND m_delivery.tel  LIKE ''%' + @P_delivery_tel + '%'' '
	END
	IF (@P_delivery_class_1 <> '')
    BEGIN
        SET @SQL_CND = @SQL_CND + 'AND m_delivery.delivery_class_1 LIKE ''%' + @P_delivery_class_1 + '%'' '
    END
	IF (@P_delivery_class_2 <> '')
    BEGIN
        SET @SQL_CND = @SQL_CND + 'AND m_delivery.delivery_class_2 LIKE ''%' + @P_delivery_class_2 + '%'' '
    END
	IF (@P_delivery_class_3 <> '')
    BEGIN
        SET @SQL_CND = @SQL_CND + 'AND m_delivery.delivery_class_3 LIKE ''%' + @P_delivery_class_3 + '%'' '
    END
    ---------------------------------------------------------------
    EXEC(
        'INSERT INTO #RESULT 
         SELECT
            m_delivery.delivery_cd
        ,   CONVERT(NVARCHAR(MAX), m_delivery.delivery_nm1 + m_delivery.delivery_nm2)
        ,   CONVERT(NVARCHAR(MAX), m_delivery.delivery_kn1 +  m_delivery.delivery_kn2)
		,	m_delivery.zip_cd
        ,   lib_4.lib_val_nm + '' '' + m_delivery.city_nm + '' '' + m_delivery.town_nm + '' '' + m_delivery.apartment_nm
        ,   m_delivery.tel
		,	m_delivery.fax
		,	lib_1.lib_val_nm
		,	lib_2.lib_val_nm
		,	lib_3.lib_val_nm
		,	m_delivery.remark
		,	m_delivery.cre_date
		,	cre_m_user.user_nm
		,	m_delivery.upd_date
		,	upd_m_user.user_nm
        FROM m_delivery WITH(NOLOCK) '
        + @SQL_JIN +
        'WHERE  (m_delivery.del_flg = 0) '
        + @SQL_CND +
        'GROUP BY
            m_delivery.delivery_cd
        ,   CONVERT(NVARCHAR(MAX), m_delivery.delivery_nm1 + m_delivery.delivery_nm2)
        ,   CONVERT(NVARCHAR(MAX), m_delivery.delivery_kn1 +  m_delivery.delivery_kn2)
		,	m_delivery.zip_cd
        ,   lib_4.lib_val_nm + '' '' + m_delivery.city_nm + '' '' + m_delivery.town_nm + '' '' + m_delivery.apartment_nm
        ,   m_delivery.tel
		,	m_delivery.fax
		,	lib_1.lib_val_nm
		,	lib_2.lib_val_nm
		,	lib_3.lib_val_nm
		,	m_delivery.remark
		,	m_delivery.cre_date
		,	cre_m_user.user_nm
		,	m_delivery.upd_date
		,	upd_m_user.user_nm
        ORDER BY
            m_delivery.delivery_cd ASC'
    )
    -------------------------------------------------------------
	IF CAST(@P_type AS INT) = 0
		BEGIN
			-- return dataset
			--[0]
			SELECT
				*                   
			FROM #RESULT
			ORDER BY #RESULT.delivery_cd ASC
			offset (@P_page-1) * @P_page_size rows
			fetch next @P_page_size rows only;

			SET @totalRecord    = (SELECT COUNT(*) FROM #RESULT)
			SET @pageMax        = CEILING(CAST(@totalRecord AS FLOAT) / @P_page_size)
			IF  @pageMax = 0
			BEGIN
				SET @pageMax = 1
			END
			IF @P_page > @pageMax
			BEGIN
				SET @P_page = @pageMax
			END
			--[1]
			SELECT
				@totalRecord    AS totalRecord
			,   @pageMax        AS pageMax
			,   @P_page         AS [page]
			,   @P_page_size    AS pagesize
		END
	ELSE
		BEGIN
			SELECT
				delivery_cd
			,   delivery_nm
			,   delivery_kn
			,	zip_cd
			,   delivery_addr
			,   tel
			,	fax
			,	delivery_class_1
			,	delivery_class_2
			,	delivery_class_3
			,	remark
			,	FORMAT(cre_date , 'yyyy/MM/dd HH:mm:ss')
			,	cre_user
			,	FORMAT(upd_date , 'yyyy/MM/dd HH:mm:ss')
			,	upd_user                
			FROM #RESULT
			ORDER BY #RESULT.delivery_cd ASC
		END
		-------------------------------------------------------------
		
    DROP TABLE #RESULT
END
