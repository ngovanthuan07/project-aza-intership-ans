IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPC_105_SCHEDULE_DATA_INQ1]') AND type in (N'P', N'PC'))
DROP PROCEDURE SPC_105_SCHEDULE_DATA_INQ1

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- +--TEST--+
-- EXEC SPC_105_SCHEDULE_DATA_INQ1 '2023/10/06', '000002', 1

--****************************************************************************************
--*   											
--*  処理概要/process overview	:	refer ベンチ and 見積/発注
--*  
--*  作成日/create date			:	2023/10/02											
--*　作成者/creater				:	ANS796 - tuannt@ans-asia.com
--*   					
--*  更新日/update date			:  	
--*　更新者/updater				:　 								     	 
--*　更新内容/update content	:	　	
--****************************************************************************************
CREATE PROCEDURE [dbo].[SPC_105_SCHEDULE_DATA_INQ1]
	@P_date					NVARCHAR(10)	= ''
,	@P_emp_cd				NVARCHAR(10)	= ''
,	@P_schedule_type		INT				= 0	--1:現場、2:配送
,	@P_login_emp_cd			NVARCHAR(10)	= ''
AS									
BEGIN								
	SET NOCOUNT ON;	
	
	DECLARE 
		@w_shipment_date			NVARCHAR(10) = ''
	,	@w_collect_date				NVARCHAR(10) = ''
	,	@w_datetime_schedule		DATETIME	 = NULL
	,	@w_current_day				DATETIME2	= SYSDATETIME()	
	--
	CREATE TABLE #TBL_ESTIMTE(
		idx							INT			identity(1,1)
	,   estimate_no 				INT
	,	estimate_branch_no 			INT
	,	work_no						INT
	,	work_div					NVARCHAR(3)
	,	work_input_div				NVARCHAR(80)
	,	people_amount				DECIMAL(9,0)
	,	work_time					NVARCHAR(20)
	,	operation_content			NVARCHAR(MAX)
	,	clothes						NVARCHAR(MAX)
	,	flg							INT
	,	purchase_no					INT
	,	is_deleted					INT
	,	work_date					NVARCHAR(MAX)
    )
	CREATE TABLE #TBL_ESTIMTE_DATA(
		idx							INT			identity(1,1)
	,   estimate_no 				NVARCHAR(30)
	,	estimate_branch_no 			NVARCHAR(10)
	,	emp_cd						NVARCHAR(10)
	,	emp_nm						NVARCHAR(50)
	,	customer_nm1				NVARCHAR(50)
	,	estimate_input_div			NVARCHAR(3)
	,	matter_nm					NVARCHAR(100)
	,	onsite_deli_message			NVARCHAR(2000)
	,	cre_datetime				NVARCHAR(50)
	,	document_link				NVARCHAR(2000)
	,	item_cd						NVARCHAR(MAX)
	,	item_nm						NVARCHAR(MAX)
	,	work_no						INT
	,	work_div					NVARCHAR(3)
	,	work_input_div				NVARCHAR(80)
	,	people_amount				DECIMAL(9,0)
	,	work_time					NVARCHAR(20)
	,	operation_content			NVARCHAR(MAX)
	,	clothes						NVARCHAR(MAX)
	,	delivery_nm					NVARCHAR(2000)
	,	purchase_no					INT
	,	total_weight				NVARCHAR(MAX)
	,	body_value					NVARCHAR(MAX)
	,	flg							INT
	,	is_deleted					INT
	,	work_date					NVARCHAR(MAX)
    )
	--
	CREATE TABLE #TBL_ITEM_TMP(
		idx							INT			identity(1,1)
	,   estimate_no 				INT
	,	estimate_branch_no 			INT
	,	item_cd						NVARCHAR(MAX)
	,	item_nm						NVARCHAR(MAX)
	,	total_weight				DECIMAL(20, 0)
	,	body_value					DECIMAL(20, 0)
	,	item_qty					NVARCHAR(MAX)
    )
	--
	CREATE TABLE #TBL_ITEM(
		idx							INT			identity(1,1)
	,	estimate_no 				INT
	,	estimate_branch_no 			INT
	,	item_cd						NVARCHAR(MAX)
	,	item_nm						NVARCHAR(MAX)
	,	total_weight				DECIMAL(30, 0)
	,	body_value					DECIMAL(30, 0)
    )
	--
	CREATE TABLE #TBL_EMP(
		idx							INT			identity(1,1)
	,	emp_cd 						NVARCHAR(10)
	,	emp_cd_hidden 				NVARCHAR(10)
	,	emp_nm			 			NVARCHAR(500)
	,	purchase_no					INT
	,	flg							NVARCHAR(1)
	,	extra_div					NVARCHAR(1)
	,	shift_day_div				NVARCHAR(2)
    )
	--
	CREATE TABLE #TBL_SCHEDULE_GROUP(
		idx							INT			identity(1,1)
	,	group_schedule_no			BIGINT
    )
	--
	CREATE TABLE #TBL_DELETED_EST_D(
		idx							INT			identity(1,1)
	,	estimate_no 				INT
	,	estimate_branch_no 			INT
	,	del_date					DATETIME2(7)
    )
	--
	CREATE TABLE #TBL_SCHEDULE_COUNT_CHILD(
		idx							INT			identity(1,1)
	,	schedule_no 				BIGINT
	,	count_child		 			INT
    )
	--
	CREATE TABLE #TBL_SCHEDULE_EMP(
		idx							INT			identity(1,1)
	,	emp_cd 						NVARCHAR(10)
	,	outsourcing_purchase_no		NVARCHAR(20)
    )
	--
	CREATE TABLE #TBL_ESTIMTE_SHOW_BRANCH(
		idx							INT			identity(1,1)
	,   estimate_no 				INT
    )
	--
	CREATE TABLE #TBL_STATUS_ESTIMATE(
		idx								INT			identity(1,1)
	,   estimate_no 					INT
	,	estimate_branch_no 				INT
	,	w_is_estimate_confirm_div		NVARCHAR(1)
	,	w_is_billing_confirm_div_est	NVARCHAR(1)
	,	w_is_arrangement_confirm_div	NVARCHAR(1)
	,	w_is_billing_confirm_div_sales	NVARCHAR(1)
	,	w_is_arrangement_exist			BIT
	,	work_no							INT
	,	work_div						NVARCHAR(3)
	,	work_input_div					NVARCHAR(80)
    )
	--
	INSERT INTO #TBL_SCHEDULE_COUNT_CHILD
	SELECT
		t_schedule.schedule_no
	,	ISNULL(COUNT(tmp_schedule_count.schedule_no), 0) + 1	AS child_schedule_no 
	FROM t_schedule 
	LEFT OUTER JOIN t_schedule AS tmp_schedule_count ON(
		t_schedule.schedule_consultation_date	= tmp_schedule_count.schedule_consultation_date
	AND t_schedule.schedule_consultation_div	= tmp_schedule_count.schedule_consultation_div
	AND t_schedule.schedule_no					= tmp_schedule_count.group_schedule_no
	AND tmp_schedule_count.schedule_div			<> 1
	AND tmp_schedule_count.del_flg				= 0
	)
	where 
		t_schedule.schedule_consultation_date	= @P_date
	AND t_schedule.schedule_consultation_div	= @P_schedule_type
	AND t_schedule.schedule_div					= 1 
	AND t_schedule.del_flg = 0
	AND (
			@P_emp_cd							= ''
		OR	t_schedule.group_schedule_no		IS NOT NULL
		OR	t_schedule.schedule_emp				= @P_emp_cd
	)
	GROUP BY t_schedule.schedule_no
	--
	SET @w_datetime_schedule = CONVERT(DATETIME, @P_date)
	--
	IF @P_emp_cd <> ''
	BEGIN
		INSERT INTO #TBL_SCHEDULE_GROUP
		SELECT DISTINCT
			group_schedule_no
		FROM
			t_schedule WITH(NOLOCK)
		INNER JOIN t_schedule_emp WITH(NOLOCK) ON (
			t_schedule.schedule_no					= t_schedule_emp.schedule_no
		AND	t_schedule_emp.del_flg					= 0
		)
		WHERE
			t_schedule.del_flg						= 0
		AND	t_schedule.schedule_consultation_date	= @P_date
		AND	t_schedule.schedule_consultation_div	= @P_schedule_type
		AND t_schedule_emp.emp_cd					= @P_emp_cd
	END
	--
	--Estimate data
	INSERT INTO #TBL_ESTIMTE
	SELECT
		t_estimate_h.estimate_no
	,	t_estimate_h.estimate_branch_no
	,	t_estimate_work.estimate_work_no
	,	t_estimate_work.work_div
	,	CASE t_estimate_work.estimate_work_date_div
		WHEN
			'1' THEN shipment_way_div.lib_val_nm
		WHEN
			'2' THEN shipment_print_way_div.lib_val_nm
		WHEN
			'3' THEN use_start_way_div.lib_val_nm
		WHEN
			'4' THEN use_end_way_div.lib_val_nm
		WHEN
			'5' THEN collect_print_way_div.lib_val_nm
		WHEN
			'6' THEN collection_way_div.lib_val_nm
		ELSE
			''
		END
	,	people_amount
	,	work_time
	,	operation_content
	,	clothes
	--,	@P_schedule_type
	,	IIF((
					(
						t_estimate_work.estimate_work_date_div	= 2
					AND	t_estimate_work.work_div				IN ('03')
					)
				OR	(
						t_estimate_work.estimate_work_date_div	IN (5)
					AND	t_estimate_work.work_div				IN ('03')
					)
			), 2, 1)
	,	0
	--,	IIF(t_estimate_work.del_flg = 1, 1, 0)
	,	IIF(t_estimate_h.del_flg = 1, 1, 0)
	,	t_estimate_work.work_date
	FROM
		t_estimate_h WITH(NOLOCK)
		/*t_arrangement_h WITH(NOLOCK)
	INNER JOIN t_estimate_h WITH(NOLOCK)
	ON (
		t_arrangement_h.estimate_no = t_estimate_h.estimate_no
	AND t_arrangement_h.estimate_branch_no = t_estimate_h.estimate_branch_no
	AND t_estimate_h.del_flg = 0
	)*/
	LEFT OUTER JOIN (
		SELECT
			estimate_no
		,	estimate_branch_no
		,	MIN(del_flg) AS min_del_flg
		FROM 
			t_estimate_work WITH(NOLOCK)
		GROUP BY
			estimate_no
		,	estimate_branch_no
	) AS tbl_est_work_min_flg ON(
		t_estimate_h.estimate_no				= tbl_est_work_min_flg.estimate_no
	AND	t_estimate_h.estimate_branch_no			= tbl_est_work_min_flg.estimate_branch_no
	)
	LEFT OUTER JOIN (
		SELECT
			estimate_no
		,	estimate_branch_no
		,	del_flg
		,	IIF(del_flg = 1, MAX(del_date), MAX(cre_date)) AS max_date
		FROM 
			t_estimate_work WITH(NOLOCK)
		GROUP BY
			estimate_no
		,	estimate_branch_no
		,	del_flg
	) AS tbl_est_work ON(
		t_estimate_h.estimate_no				= tbl_est_work.estimate_no
	AND	t_estimate_h.estimate_branch_no			= tbl_est_work.estimate_branch_no
	AND tbl_est_work_min_flg.min_del_flg		= tbl_est_work.del_flg
	)
	INNER JOIN t_estimate_work WITH(NOLOCK) ON(
		tbl_est_work.estimate_no				= t_estimate_work.estimate_no
	AND	tbl_est_work.estimate_branch_no			= t_estimate_work.estimate_branch_no
	AND (
		(	
			tbl_est_work.del_flg				= 0
		AND	t_estimate_work.del_flg				= 0
		AND	t_estimate_work.cre_date			= tbl_est_work.max_date
		)
		OR
		(
			tbl_est_work.del_flg				= 1
		AND	tbl_est_work.max_date				= t_estimate_work.del_date
		)
	)
	--AND	(t_estimate_work.del_flg				= 0 OR (t_estimate_work.del_flg = 1 AND t_estimate_work.del_schedule IS NULL))
	--AND	t_estimate_work.del_flg					= 0
	)
	LEFT OUTER JOIN s_lib_val AS shipment_way_div ON(
		shipment_way_div.lib_cd					= 'shipment_way_div'
	AND t_estimate_work.work_div				= shipment_way_div.lib_val_cd	
	AND	t_estimate_work.estimate_work_date_div	= '1'
	)
	LEFT OUTER JOIN s_lib_val AS shipment_print_way_div ON(
		shipment_print_way_div.lib_cd			= 'shipment_print_way_div'
	AND t_estimate_work.work_div				= shipment_print_way_div.lib_val_cd	
	AND	t_estimate_work.estimate_work_date_div	= '2'
	)
	LEFT OUTER JOIN s_lib_val AS use_start_way_div ON(
		use_start_way_div.lib_cd				= 'use_start_way_div'
	AND t_estimate_work.work_div				= use_start_way_div.lib_val_cd	
	AND	t_estimate_work.estimate_work_date_div	= '3'
	)
	LEFT OUTER JOIN s_lib_val AS use_end_way_div ON(
		use_end_way_div.lib_cd					= 'use_end_way_div'
	AND t_estimate_work.work_div				= use_end_way_div.lib_val_cd	
	AND	t_estimate_work.estimate_work_date_div	= '4'
	)
	LEFT OUTER JOIN s_lib_val AS collect_print_way_div ON(
		collect_print_way_div.lib_cd			= 'collect_print_way_div'
	AND t_estimate_work.work_div				= collect_print_way_div.lib_val_cd	
	AND	t_estimate_work.estimate_work_date_div	= '5'
	)
	LEFT OUTER JOIN s_lib_val AS collection_way_div ON(
		collection_way_div.lib_cd				= 'collection_way_div'
	AND t_estimate_work.work_div				= collection_way_div.lib_val_cd	
	AND	t_estimate_work.estimate_work_date_div	= '6'
	)
	WHERE
		--t_arrangement_h.del_flg					= 0
		t_estimate_work.work_date				= @P_date
	AND	t_estimate_work.work_div				<> ''
	AND	t_estimate_h.estimate_input_div			IN	(1, 3, 5, 6, 7)
	--AND t_estimate_h.del_flg					= 0
	--AND	t_arrangement_h.is_arrangement_confirm_div	=	'1'
	AND	(
			--現場 data
			--@P_schedule_type							= 1
		--AND 
		(
				(
					t_estimate_work.estimate_work_date_div	= 1
				AND	t_estimate_work.work_div				IN ('18', '19')
				)
			OR	(
					t_estimate_work.estimate_work_date_div	= 2
				AND	t_estimate_work.work_div				IN ('04', '06', '15', '16', '17', '18')
				)
			OR	(
					t_estimate_work.estimate_work_date_div	IN (3, 4)
				AND	t_estimate_work.work_div				IN ('1', '2', '3', '4', '5', '6', '7', '8', '9')
				)
			OR	(
					t_estimate_work.estimate_work_date_div	= 5
				AND	t_estimate_work.work_div				IN ('04', '07','10', '11')
				)
			OR	(
					t_estimate_work.estimate_work_date_div	= 6
				AND	t_estimate_work.work_div				IN ('13', '14', '15')
				)
			)
		OR	(
				--配送 data
			--	@P_schedule_type								= 2
			--AND 
			(
					(
						t_estimate_work.estimate_work_date_div	= 2
					AND	t_estimate_work.work_div				IN ('03')
					)
				OR	(
						t_estimate_work.estimate_work_date_div	IN (5)
					AND	t_estimate_work.work_div				IN ('03')
					)
			)
		)
	)
	--
	INSERT INTO #TBL_ESTIMTE_SHOW_BRANCH
	SELECT 
		estimate_no 
	FROM (
		SELECT 
			estimate_no
		, estimate_branch_no
		FROM #TBL_ESTIMTE
		GROUP BY
		estimate_no, estimate_branch_no) AS tbl_est_group
	GROUP BY
		tbl_est_group.estimate_no
	HAVING COUNT(tbl_est_group.estimate_branch_no) > 1

	--SELECT '#TBL_ESTIMTE', * FROM #TBL_ESTIMTE

	-- Purchase data
	INSERT INTO #TBL_ESTIMTE
	SELECT
		0
	,	0
	,	t_purchase_work.purchase_work_no
	,	t_purchase_work.work_div
	,	CASE t_purchase_work.purchase_work_date_div
		WHEN
			'1' THEN item_arrival_way_div.lib_val_nm
		WHEN
			'2' THEN use_start_way_div.lib_val_nm
		WHEN
			'3' THEN use_end_way_div.lib_val_nm
		WHEN
			'4' THEN item_return_way_div.lib_val_nm
		ELSE
			''
		END
	,	NULL						AS people_amount
	,	work_time
	,	''						AS operation_content
	,	''						AS clothes
	--,	@P_schedule_type
	,	IIF((
						t_purchase_work.purchase_work_date_div	IN (1, 4)
					AND	t_purchase_work.work_div				IN ('1', '12')
					), 2, 1)
	,	t_purchase_h.purchase_no
	--,	IIF(t_purchase_work.del_flg = 1, 1, 0)
	,	IIF(t_purchase_h.del_flg = 1, 1, 0)
	,	t_purchase_work.work_date
	FROM
		t_purchase_h WITH(NOLOCK)
	LEFT OUTER JOIN (
		SELECT
			purchase_no
		,	MIN(del_flg) AS min_del_flg
		FROM 
			t_purchase_work WITH(NOLOCK)
		GROUP BY
			purchase_no
	) AS tbl_pur_work_min_flg ON(
		t_purchase_h.purchase_no				= tbl_pur_work_min_flg.purchase_no
	)
	LEFT OUTER JOIN (
		SELECT
			purchase_no
		,	del_flg
		,	IIF(del_flg = 1, MAX(del_date), MAX(cre_date)) AS max_date
		FROM 
			t_purchase_work WITH(NOLOCK)
		GROUP BY
			purchase_no
		,	del_flg
	) AS tbl_pur_work ON(
		t_purchase_h.purchase_no				= tbl_pur_work.purchase_no
	AND tbl_pur_work_min_flg.min_del_flg		= tbl_pur_work.del_flg
	)
	LEFT OUTER JOIN t_purchase_work WITH(NOLOCK) ON(
		tbl_pur_work.purchase_no				= t_purchase_work.purchase_no
	AND (
		(	
			tbl_pur_work.del_flg				= 0
		AND	t_purchase_work.del_flg				= 0
		AND	t_purchase_work.cre_date			= tbl_pur_work.max_date
		)
		OR
		(
			tbl_pur_work.del_flg				= 1
		AND	tbl_pur_work.max_date				= t_purchase_work.del_date
		)
		)
	)
	/*LEFT OUTER JOIN t_purchase_work WITH(NOLOCK) ON(
		t_purchase_h.purchase_no		= t_purchase_work.purchase_no
	--AND	t_purchase_work.del_flg			= 0
	)*/
	LEFT OUTER JOIN s_lib_val AS item_arrival_way_div ON(
		item_arrival_way_div.lib_cd				= 'item_arrival_way_div'
	AND t_purchase_work.work_div				= item_arrival_way_div.lib_val_cd	
	AND	t_purchase_work.purchase_work_date_div	= '1'
	)
	LEFT OUTER JOIN s_lib_val AS use_start_way_div ON(
		use_start_way_div.lib_cd				= 'use_start_way_div'
	AND t_purchase_work.work_div				= use_start_way_div.lib_val_cd	
	AND	t_purchase_work.purchase_work_date_div	= '2'
	)
	LEFT OUTER JOIN s_lib_val AS use_end_way_div ON(
		use_end_way_div.lib_cd					= 'use_end_way_div'
	AND t_purchase_work.work_div				= use_end_way_div.lib_val_cd	
	AND	t_purchase_work.purchase_work_date_div	= '3'
	)
	LEFT OUTER JOIN s_lib_val AS item_return_way_div ON(
		item_return_way_div.lib_cd				= 'item_return_way_div'
	AND t_purchase_work.work_div				= item_return_way_div.lib_val_cd	
	AND	t_purchase_work.purchase_work_date_div	= '4'
	)
	WHERE
		--t_purchase_h.del_flg					= 0
	--AND	
		t_purchase_work.work_date				= @P_date
	AND	t_purchase_work.work_div				<> ''
	AND	(
			--現場 data
		--	@P_schedule_type							= 1
		--AND 
		(
				(
					--t_purchase_work.purchase_work_date_div	= 1
					t_purchase_work.purchase_work_date_div	= 1
				AND	t_purchase_work.work_div				IN ('6', '7', '8', '9', '10', '11')
				)
			OR	(
					t_purchase_work.purchase_work_date_div	IN (2, 3)
				AND	t_purchase_work.work_div				IN ('10', '11', '12', '13', '14', '15')
				)
			OR	(
					t_purchase_work.purchase_work_date_div	= 4
				AND	t_purchase_work.work_div				IN ('6', '7', '8', '9', '10')
				)
			)
		OR	(
				--配送 data
			--	@P_schedule_type								= 2
			--AND 
			(
					(
						t_purchase_work.purchase_work_date_div	IN (1, 4)
					AND	t_purchase_work.work_div				IN ('1', '12')
					)
			)
		)
	)
--SELECT '#TBL_ESTIMTE', * FROM #TBL_ESTIMTE
	/*------------------------*/
	--	GET ITEM DATA
	INSERT INTO #TBL_DELETED_EST_D
	SELECT
		t_estimate_d.estimate_no
	,	t_estimate_d.estimate_branch_no
	,	MAX(t_estimate_d.del_date)
	FROM
		#TBL_ESTIMTE
	INNER JOIN t_estimate_h WITH(NOLOCK) ON(
		#TBL_ESTIMTE.purchase_no			= 0
	AND	#TBL_ESTIMTE.estimate_no			= t_estimate_h.estimate_no
	AND	#TBL_ESTIMTE.estimate_branch_no		= t_estimate_h.estimate_branch_no
	)
	INNER JOIN t_estimate_d WITH(NOLOCK) ON(
		t_estimate_h.estimate_no			= t_estimate_d.estimate_no
	AND	t_estimate_h.estimate_branch_no		= t_estimate_d.estimate_branch_no
	)
	WHERE
		t_estimate_h.del_flg				= 1
	GROUP BY
		t_estimate_d.estimate_no
	,	t_estimate_d.estimate_branch_no
--SELECT * FROM #TBL_DELETED_EST_D
	--Estimate data
	INSERT INTO #TBL_ITEM_TMP
	SELECT DISTINCT
		t_estimate_d.estimate_no
	,	t_estimate_d.estimate_branch_no
	,	t_estimate_d.item_cd
	,	t_estimate_d.item_nm
	,	ISNULL(m_item.total_weight, 0)
	,	CAST(m_item.body_vertical AS DECIMAL(18, 0)) * CAST(m_item.body_horizontal AS DECIMAL(18, 0)) * CAST(m_item.body_height AS DECIMAL(18, 0))
	,	FORMAT(IIF((t_estimate_d.is_set_item_div = 1 OR m_item.stock_div = 2), t_estimate_d.sales_qty,
			IIF((t_estimate_h.shipment_print_way_div = #TBL_ESTIMTE.work_div)
				, t_estimate_d.shipment_plan_qty, t_estimate_d.return_plan_qty))
		, '###,#0')
	FROM
		#TBL_ESTIMTE
	INNER JOIN t_estimate_h WITH(NOLOCK) ON(
		#TBL_ESTIMTE.purchase_no			= 0
	AND	#TBL_ESTIMTE.estimate_no			= t_estimate_h.estimate_no
	AND	#TBL_ESTIMTE.estimate_branch_no		= t_estimate_h.estimate_branch_no
	AND	(
			#TBL_ESTIMTE.work_div			= t_estimate_h.shipment_print_way_div
		OR
			#TBL_ESTIMTE.work_div			= t_estimate_h.collect_print_way_div
		)
	)
	LEFT OUTER JOIN #TBL_DELETED_EST_D ON(
		#TBL_ESTIMTE.estimate_no			= #TBL_DELETED_EST_D.estimate_no
	AND	#TBL_ESTIMTE.estimate_branch_no		= #TBL_DELETED_EST_D.estimate_branch_no
	)
	INNER JOIN t_estimate_d WITH(NOLOCK) ON(
		t_estimate_h.estimate_no			= t_estimate_d.estimate_no
	AND	t_estimate_h.estimate_branch_no		= t_estimate_d.estimate_branch_no
	AND	(
			#TBL_DELETED_EST_D.del_date		= t_estimate_d.del_date
		OR	t_estimate_d.del_flg			= 0
	)
	)
	LEFT OUTER JOIN m_item WITH(NOLOCK) ON(
		m_item.item_cd						= t_estimate_d.item_cd
	AND	m_item.del_flg						= 0
	)
	WHERE
		t_estimate_d.item_cd				<> ''
	AND	t_estimate_d.item_cd				NOT IN ('510190')
	AND	t_estimate_d.estimate_detail_div	IN ('1', '3')
	AND t_estimate_d.is_set_item_div = 0
		AND ((m_item.stock_div = 1)
			OR ((m_item.stock_div = 2 ) AND
             ((m_item.item_cd IN ('510010','800001','800020','800111','801338','801564'))
             OR (m_item.item_class_1_div != '')
             OR (m_item.item_class_2_div != '')
             )) 
		)
	--
	INSERT INTO #TBL_ITEM
	SELECT 
		Results.estimate_no,
		Results.estimate_branch_no,
		STUFF((
			SELECT '、' + [item_cd]
			FROM #TBL_ITEM_TMP 
			WHERE (
				#TBL_ITEM_TMP.estimate_no			= Results.estimate_no
			AND #TBL_ITEM_TMP.estimate_branch_no	= Results.estimate_branch_no
			) 
			FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
		  ,1,1,'') AS item_cd,
		STUFF((
			SELECT '、、' + [item_nm] +'、' + [item_qty]
			FROM #TBL_ITEM_TMP 
			WHERE (
				#TBL_ITEM_TMP.estimate_no			= Results.estimate_no
			AND #TBL_ITEM_TMP.estimate_branch_no	= Results.estimate_branch_no
			) 
			FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
		  ,1,2,'') AS item_nm,
		STUFF((
			SELECT SUM([total_weight])
			FROM #TBL_ITEM_TMP 
			WHERE (
				#TBL_ITEM_TMP.estimate_no			= Results.estimate_no
			AND #TBL_ITEM_TMP.estimate_branch_no	= Results.estimate_branch_no
			) 
			GROUP BY
				#TBL_ITEM_TMP.estimate_no
			,	#TBL_ITEM_TMP.estimate_branch_no
			FOR XML PATH(''),TYPE).value('(./text())[1]','DECIMAL(30, 0)')
		  ,1,0,'') AS total_weight,
		STUFF((
			SELECT SUM([body_value])
			FROM #TBL_ITEM_TMP 
			WHERE (
				#TBL_ITEM_TMP.estimate_no			= Results.estimate_no
			AND #TBL_ITEM_TMP.estimate_branch_no	= Results.estimate_branch_no
			)
			GROUP BY
				#TBL_ITEM_TMP.estimate_no
			,	#TBL_ITEM_TMP.estimate_branch_no
			FOR XML PATH(''),TYPE).value('(./text())[1]','DECIMAL(30, 0)')
		  ,1,0,'') AS body_value
	FROM #TBL_ITEM_TMP Results
	GROUP BY 
		Results.estimate_no
	,	Results.estimate_branch_no

	--Purchase data
	TRUNCATE TABLE #TBL_ITEM_TMP
	INSERT INTO #TBL_ITEM_TMP
	SELECT DISTINCT
		t_purchase_d.purchase_no
	,	0
	,	t_purchase_d.item_cd
	,	t_purchase_d.item_nm
	,	m_item.total_weight
	,	CAST(m_item.body_vertical AS INT) * CAST(m_item.body_horizontal AS INT) * CAST(m_item.body_height AS INT)
	,	FORMAT(t_purchase_d.purchase_qty, '###,#0')
	FROM
		#TBL_ESTIMTE
	INNER JOIN t_purchase_h WITH(NOLOCK) ON(
		#TBL_ESTIMTE.purchase_no			<> 0
	AND	#TBL_ESTIMTE.purchase_no			= t_purchase_h.purchase_no
	AND	t_purchase_h.del_flg				= 0
	)
	INNER JOIN t_purchase_d WITH(NOLOCK) ON(
		t_purchase_h.purchase_no			= t_purchase_d.purchase_no
	AND	t_purchase_d.del_flg					= 0
	)
	LEFT OUTER JOIN m_item WITH(NOLOCK) ON(
		m_item.item_cd						= t_purchase_d.item_cd
	AND	m_item.del_flg						= 0
	)
	WHERE
		t_purchase_d.item_cd				<> ''
	AND	t_purchase_d.item_cd				NOT IN ('510190')
	--
	INSERT INTO #TBL_ITEM
	SELECT 
		Results.estimate_no,
		Results.estimate_branch_no,
		STUFF((
			SELECT '、' + [item_cd]
			FROM #TBL_ITEM_TMP 
			WHERE (
				#TBL_ITEM_TMP.estimate_no			= Results.estimate_no
			AND #TBL_ITEM_TMP.estimate_branch_no	= Results.estimate_branch_no
			) 
			FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
		  ,1,1,'') AS item_cd,
		STUFF((
			SELECT '、、' + [item_nm] +'、' + [item_qty]
			FROM #TBL_ITEM_TMP 
			WHERE (
				#TBL_ITEM_TMP.estimate_no			= Results.estimate_no
			AND #TBL_ITEM_TMP.estimate_branch_no	= Results.estimate_branch_no
			)
			FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
		  ,1,2,'') AS item_nm,
		STUFF((
			SELECT SUM([total_weight])
			FROM #TBL_ITEM_TMP 
			WHERE (
				#TBL_ITEM_TMP.estimate_no			= Results.estimate_no
			AND #TBL_ITEM_TMP.estimate_branch_no	= Results.estimate_branch_no
			)
			GROUP BY
				#TBL_ITEM_TMP.estimate_no
			,	#TBL_ITEM_TMP.estimate_branch_no
			FOR XML PATH(''),TYPE).value('(./text())[1]','DECIMAL(30, 0)')
		  ,1,0,'') AS total_weight,
		STUFF((
			SELECT SUM([body_value])
			FROM #TBL_ITEM_TMP 
			WHERE (
				#TBL_ITEM_TMP.estimate_no			= Results.estimate_no
			AND #TBL_ITEM_TMP.estimate_branch_no	= Results.estimate_branch_no
			)
			GROUP BY
				#TBL_ITEM_TMP.estimate_no
			,	#TBL_ITEM_TMP.estimate_branch_no
			FOR XML PATH(''),TYPE).value('(./text())[1]','DECIMAL(30, 0)')
		  ,1,0,'') AS body_value
	FROM #TBL_ITEM_TMP Results
	GROUP BY 
		Results.estimate_no
	,	Results.estimate_branch_no
	--
--SELECT '#TBL_ITEM', * FROM #TBL_ITEM
	INSERT INTO #TBL_ESTIMTE_DATA
	SELECT 
		t_estimate_h.estimate_no
	,	t_estimate_h.estimate_branch_no
	,	t_estimate_h.emp_cd			
	,	t_estimate_h.emp_nm	
	,	t_estimate_h.customer_nm1
	,	estimate_input_div								
	,	matter_nm
	,	onsite_deli_message
    ,   FORMAT(t_estimate_h.cre_date , 'yyyy/MM/dd HH:mm:ss')		AS cre_datetime
	,	document_link
	,	#TBL_ITEM.item_cd
	,	#TBL_ITEM.item_nm
	,	#TBL_ESTIMTE.work_no
	,	#TBL_ESTIMTE.work_div
	,	#TBL_ESTIMTE.work_input_div
	,	#TBL_ESTIMTE.people_amount
	,	#TBL_ESTIMTE.work_time
	,	#TBL_ESTIMTE.operation_content
	,	#TBL_ESTIMTE.clothes
	--,	IIF(t_estimate_h.customer_cd <> t_estimate_h.delivery_cd, 
	--		IIF(m_customer.sch_customer_nm <> '', m_customer.sch_customer_nm, m_delivery.sch_delivery_nm) 
	--		, t_estimate_h.delivery_city_nm)
	--																AS delivery_nm
	,	CASE
			WHEN t_estimate_h.customer_cd = t_estimate_h.delivery_cd THEN t_estimate_h.delivery_city_nm
			WHEN t_estimate_h.customer_cd <> t_estimate_h.delivery_cd AND ISNULL(m_delivery.sch_delivery_nm, '') <> ''
				THEN m_delivery.sch_delivery_nm
			WHEN t_estimate_h.customer_cd <> t_estimate_h.delivery_cd AND ISNULL(customer_delivery.sch_customer_nm, '') <> '' 
				THEN customer_delivery.sch_customer_nm
			WHEN t_estimate_h.customer_cd <> t_estimate_h.delivery_cd AND ISNULL(m_delivery.sch_delivery_nm, '') = ''
				THEN t_estimate_h.delivery_city_nm
			WHEN t_estimate_h.customer_cd <> t_estimate_h.delivery_cd AND ISNULL(t_estimate_h.delivery_cd, '') = ''
				THEN t_estimate_h.delivery_city_nm
		END															AS delivery_nm
	,	#TBL_ESTIMTE.purchase_no
	,	FORMAT(#TBL_ITEM.total_weight, '###,#0')					AS total_weight
	,	FORMAT(#TBL_ITEM.body_value, '###,#0')						AS body_value
	,	#TBL_ESTIMTE.flg
	,	#TBL_ESTIMTE.is_deleted
	,	#TBL_ESTIMTE.work_date
	FROM #TBL_ESTIMTE
	INNER JOIN t_estimate_h WITH(NOLOCK) ON(
		#TBL_ESTIMTE.estimate_no		= t_estimate_h.estimate_no
	AND #TBL_ESTIMTE.estimate_branch_no	= t_estimate_h.estimate_branch_no
	)
	LEFT JOIN t_estimate_attachment WITH(NOLOCK)
	ON (
		t_estimate_h.estimate_no		= t_estimate_attachment.estimate_no
	AND t_estimate_h.estimate_branch_no = t_estimate_attachment.estimate_branch_no
	AND t_estimate_attachment.del_flg	= 0
	)
	LEFT JOIN m_customer WITH(NOLOCK)
	ON (
		t_estimate_h.customer_cd	= m_customer.customer_cd
	AND m_customer.del_flg			= 0
	)
	LEFT JOIN m_delivery WITH(NOLOCK)
	ON (
		t_estimate_h.delivery_cd	= m_delivery.delivery_cd
	AND m_delivery.del_flg			= 0
	)
	LEFT OUTER JOIN m_customer AS customer_delivery		WITH(NOLOCK)
	ON	(
		t_estimate_h.delivery_cd	=	customer_delivery.customer_cd
	AND	customer_delivery.del_flg	=	0
	)
	LEFT OUTER JOIN m_users AS #TBL_USER_CRE WITH(NOLOCK) 
	ON(  --1:1
        t_estimate_h.cre_user	= #TBL_USER_CRE.user_cd
    AND #TBL_USER_CRE.del_flg	= 0
    )
    LEFT OUTER JOIN m_users AS #TBL_USER_UPD WITH(NOLOCK) 
	ON(  --1:1
        t_estimate_h.upd_user	= #TBL_USER_UPD.user_cd
    AND #TBL_USER_UPD.del_flg	= 0
    )
	--8/31
	LEFT OUTER JOIN m_customer_employee WITH(NOLOCK) ON(
		m_customer.customer_cd			= m_customer_employee.customer_cd
	AND t_estimate_h.customer_emp_no	= m_customer_employee.customer_emp_no
	AND m_customer_employee.del_flg		= 0
	)
	LEFT OUTER JOIN #TBL_ITEM ON(
		t_estimate_h.estimate_no		= #TBL_ITEM.estimate_no
	AND	t_estimate_h.estimate_branch_no	= #TBL_ITEM.estimate_branch_no
	)
	WHERE
		#TBL_ESTIMTE.purchase_no		= 0
	UNION
	SELECT 
		#TBL_ESTIMTE.estimate_no
	,	#TBL_ESTIMTE.estimate_branch_no
	,	t_purchase_h.emp_cd			
	,	t_purchase_h.emp_nm	
	,	t_purchase_h.vendor_nm1 AS customer_nm1
	,	'' AS estimate_input_div						
	,	matter_nm
	,	onsite_deli_message
    ,   FORMAT(t_purchase_h.cre_date , 'yyyy/MM/dd HH:mm:ss')		AS cre_datetime
	,	'' AS document_link
	,	#TBL_ITEM.item_cd
	,	#TBL_ITEM.item_nm
	,	#TBL_ESTIMTE.work_no
	,	#TBL_ESTIMTE.work_div
	,	#TBL_ESTIMTE.work_input_div
	,	#TBL_ESTIMTE.people_amount
	,	#TBL_ESTIMTE.work_time
	,	#TBL_ESTIMTE.operation_content
	,	#TBL_ESTIMTE.clothes
	--,	IIF(t_purchase_h.vendor_cd <> t_purchase_h.return_vendor_cd, 
	--			IIF(m_vendor.sch_vendor_nm <> '', m_vendor.sch_vendor_nm, vendor_delivery.sch_vendor_nm) 
	--			, t_purchase_h.return_vendor_city_nm) 
	--													AS delivery_nm
	,	CASE
			WHEN t_purchase_h.vendor_cd = t_purchase_h.return_vendor_cd THEN t_purchase_h.return_vendor_city_nm
			WHEN t_purchase_h.vendor_cd <> t_purchase_h.return_vendor_cd AND ISNULL(vendor_delivery.sch_vendor_nm, '') <> ''
				THEN vendor_delivery.sch_vendor_nm
			WHEN t_purchase_h.vendor_cd <> t_purchase_h.return_vendor_cd AND ISNULL(vendor_delivery.sch_vendor_nm, '') = ''
				THEN t_purchase_h.return_vendor_city_nm
			WHEN t_purchase_h.vendor_cd <> t_purchase_h.return_vendor_cd AND ISNULL(t_purchase_h.return_vendor_cd, '') = ''
				THEN t_purchase_h.return_vendor_city_nm
		END															AS delivery_nm
	,	#TBL_ESTIMTE.purchase_no
	,	FORMAT(#TBL_ITEM.total_weight, '###,#0')		AS total_weight
	,	FORMAT(#TBL_ITEM.body_value, '###,#0')			AS body_value
	,	#TBL_ESTIMTE.flg
	,	#TBL_ESTIMTE.is_deleted
	,	#TBL_ESTIMTE.work_date
	FROM #TBL_ESTIMTE
	INNER JOIN t_purchase_h WITH(NOLOCK) ON(
		#TBL_ESTIMTE.purchase_no		= t_purchase_h.purchase_no
	--AND t_purchase_h.del_flg			= 0
	)
	LEFT OUTER JOIN m_vendor WITH(NOLOCK) ON(
		t_purchase_h.vendor_cd			= m_vendor.vendor_cd
	AND m_vendor.del_flg				= 0
	)
	LEFT OUTER JOIN m_vendor AS vendor_delivery WITH(NOLOCK) ON(
		t_purchase_h.return_vendor_cd	= vendor_delivery.vendor_cd
	AND vendor_delivery.del_flg			= 0
	)
	LEFT OUTER JOIN #TBL_ITEM ON(
		#TBL_ITEM.estimate_branch_no	= 0
	AND	t_purchase_h.purchase_no		= #TBL_ITEM.estimate_no
	)
	WHERE
		#TBL_ESTIMTE.purchase_no		<> 0
	--Get employee
	--社内
	INSERT INTO #TBL_EMP
	SELECT
		m_employee.emp_cd
	,	''
	,	m_employee.emp_nm
	,	0
	,	1
	,	''
	,	''
	FROM
		t_shift WITH(NOLOCK)
	LEFT OUTER JOIN	m_employee WITH(NOLOCK) ON(
		t_shift.emp_cd			= m_employee.emp_cd
	AND	m_employee.del_flg		= 0
	)
	--LEFT OUTER JOIN t_schedule WITH(NOLOCK) ON (
	--	t_schedule.schedule_emp					= m_employee.emp_cd
 --   AND t_schedule.schedule_consultation_date	= @P_date
	--AND t_schedule.schedule_consultation_div	= @P_schedule_type
	--AND t_schedule.del_flg						= 0
	--)
	WHERE
		t_shift.del_flg			= 0
	AND	t_shift.shift_date		= @w_datetime_schedule
	AND t_shift.shift_day_div	IN ('1', '2', '3')
	--AND t_schedule.schedule_emp IS NULL
	--外部
--select 'aaa', * from #TBL_ESTIMTE
	INSERT INTO #TBL_EMP
	SELECT DISTINCT
		''															AS emp_cd
	--,	t_purchase_h.emp_cd											AS emp_cd_hidden
	,	t_purchase_subcontractor.purchase_subcontractor_detail_no	AS emp_cd_hidden
	,	t_purchase_subcontractor.subcontractor						AS emp_nm
	,	t_purchase_subcontractor.purchase_no						AS purchase_no
	,	2
	,	''
	,	''
	FROM
		#TBL_ESTIMTE
	INNER JOIN	t_purchase_subcontractor WITH(NOLOCK) ON (
		#TBL_ESTIMTE.purchase_no			<> 0
	AND	#TBL_ESTIMTE.purchase_no			= t_purchase_subcontractor.purchase_no
	)
	INNER JOIN t_purchase_h WITH(NOLOCK) ON (
		#TBL_ESTIMTE.purchase_no			<> 0
	AND #TBL_ESTIMTE.purchase_no			= t_purchase_h.purchase_no
	AND t_purchase_h.del_flg				<> 1
	)
	INNER JOIN t_purchase_work WITH(NOLOCK) ON (
		t_purchase_subcontractor.purchase_no			<> 0
	AND t_purchase_subcontractor.purchase_no			= t_purchase_work.purchase_no
	AND t_purchase_subcontractor.purchase_work_no		= t_purchase_work.purchase_work_no
	AND #TBL_ESTIMTE.work_div							= t_purchase_work.work_div
	)
	LEFT OUTER JOIN t_estimate_delete_schedule ON(
		t_estimate_delete_schedule.estimate_branch_no	= 0
	AND	t_purchase_work.purchase_no						= t_estimate_delete_schedule.estimate_no
	AND	t_purchase_work.work_div						= t_estimate_delete_schedule.work_div
	AND	t_purchase_work.work_date						= t_estimate_delete_schedule.work_date
	--AND t_estimate_delete_schedule.del_flg				= 0
	)
	WHERE
		t_purchase_subcontractor.del_flg				= 0
	AND	t_purchase_work.work_date						= @P_date
	AND	#TBL_ESTIMTE.flg								= @P_schedule_type							
	AND	(
		t_estimate_delete_schedule.del_flg				= 0 
		OR t_estimate_delete_schedule.del_flg			IS NULL
	)
	---
--SELECT '#TBL_EMP', * FROM #TBL_EMP
	INSERT INTO #TBL_EMP
	SELECT
		t_schedule_employee_plus.emp_cd
	,	''
	,	m_employee.emp_nm
	,	0
	,	1
	,	t_schedule_employee_plus.extra_div
	,	t_schedule_employee_plus.shift_day_div
	FROM
		t_schedule_employee_plus WITH(NOLOCK)
	LEFT OUTER JOIN m_employee WITH(NOLOCK) ON(
		t_schedule_employee_plus.emp_cd							= m_employee.emp_cd
	AND	m_employee.del_flg										= 0
	)
	--LEFT OUTER JOIN t_schedule WITH(NOLOCK) ON (
	--	t_schedule.schedule_emp									= m_employee.emp_cd
 --   AND t_schedule.schedule_consultation_date					= @P_date
	--AND t_schedule.schedule_consultation_div					= @P_schedule_type
	--AND t_schedule.del_flg										= 0
	--)
	WHERE
		t_schedule_employee_plus.schedule_consultation_date		= @P_date
	AND t_schedule_employee_plus.schedule_consultation_div		= @P_schedule_type
	AND t_schedule_employee_plus.del_flg						= 0
	--AND t_schedule.schedule_emp IS NULL
	--
	INSERT INTO #TBL_SCHEDULE_EMP
	SELECT DISTINCT
		t_schedule_emp.emp_cd
	,	ISNULL(t_schedule_emp.outsourcing_purchase_no, '0')
	FROM
		t_schedule_emp
	INNER JOIN t_schedule ON(
		t_schedule_emp.schedule_no				= t_schedule.schedule_no
	AND t_schedule.del_flg						= 0
	)
	LEFT OUTER JOIN #TBL_EMP ON(
		t_schedule_emp.outsourcing_purchase_no	<> '0'
	AND	t_schedule_emp.outsourcing_purchase_no	<> ''
	AND	t_schedule_emp.outsourcing_purchase_no	= #TBL_EMP.purchase_no
	AND	t_schedule_emp.emp_cd					= #TBL_EMP.emp_cd_hidden
	)
	WHERE
		t_schedule.del_flg						= 0
	AND	t_schedule.schedule_consultation_date	= @P_date
	AND	t_schedule.schedule_consultation_div	= @P_schedule_type
	AND (
			@P_emp_cd							= ''
		OR	t_schedule.schedule_emp				= @P_emp_cd
	)
	--SELECT '#TBL_SCHEDULE_EMP', * FROM #TBL_SCHEDULE_EMP
	--
--SELECT '#TBL_ESTIMTE_DATA', * FROM #TBL_ESTIMTE_DATA

	-- INSERT TO #TBL_STATUS_ESTIMATE
	INSERT INTO
		#TBL_STATUS_ESTIMATE
	SELECT
		#TBL_ESTIMTE_DATA.estimate_no
	,	#TBL_ESTIMTE_DATA.estimate_branch_no
	,	(
			SELECT 
				ISNULL(is_estimate_confirm_div,'0')
			FROM t_estimate_h WITH(NOLOCK)
			WHERE
				del_flg				= 0
			AND estimate_no			= #TBL_ESTIMTE_DATA.estimate_no
			AND estimate_branch_no	= #TBL_ESTIMTE_DATA.estimate_branch_no
		)
	,	(
			SELECT 
				ISNULL(is_billing_confirm_div,'0')
			FROM t_estimate_h WITH(NOLOCK)
			WHERE
				del_flg				= 0
			AND estimate_no			= #TBL_ESTIMTE_DATA.estimate_no
			AND estimate_branch_no	= #TBL_ESTIMTE_DATA.estimate_branch_no
		)
	,	(
			SELECT
				ISNULL(is_arrangement_confirm_div,'0')
			FROM t_arrangement_h WITH(NOLOCK)
			WHERE
				del_flg				= 0
			AND estimate_no			= #TBL_ESTIMTE_DATA.estimate_no
			AND estimate_branch_no	= #TBL_ESTIMTE_DATA.estimate_branch_no 
		)
	,	(
			SELECT
				ISNULL(is_billing_confirm_div,'0')
			FROM t_sales_h WITH(NOLOCK)
			WHERE
				del_flg = 0
			AND estimate_no			= #TBL_ESTIMTE_DATA.estimate_no
			AND estimate_branch_no	= #TBL_ESTIMTE_DATA.estimate_branch_no 
		)
	,	(
			SELECT
				1
			FROM t_arrangement_h WITH(NOLOCK)
			WHERE
				del_flg				= 0
			AND estimate_no			= #TBL_ESTIMTE_DATA.estimate_no
			AND estimate_branch_no	= #TBL_ESTIMTE_DATA.estimate_branch_no 
		)
	,	#TBL_ESTIMTE_DATA.work_no
	,	#TBL_ESTIMTE_DATA.work_div
	,	#TBL_ESTIMTE_DATA.work_input_div
	FROM
		#TBL_ESTIMTE_DATA

	--[0]スケジュール
	SELECT DISTINCT
		t_schedule.schedule_no
	,	t_schedule.schedule_consultation_date	
	,	t_schedule.schedule_consultation_div
	,	t_schedule.schedule_div
	,	t_schedule.group_schedule_no
	,	t_schedule.schedule_block
	,	t_schedule.schedule_time
	,	t_schedule.schedule_emp
	,	ISNULL(t_schedule.outsourcing_purchase_no, '0')										AS outsourcing_purchase_no
	,	IIF(t_schedule.is_copied_row = 1, '('+IIF((t_schedule.outsourcing_purchase_no <> '0' AND t_schedule.outsourcing_purchase_no != ''), 
			#TBL_EMP.emp_nm, m_employee.emp_nm) + ')', IIF((t_schedule.outsourcing_purchase_no <> '0' AND t_schedule.outsourcing_purchase_no != ''), 
			#TBL_EMP.emp_nm, m_employee.emp_nm)	)
																							AS schedule_emp_nm
	,	m_employee.emp_cd																	AS schedule_emp_cd
	,	t_schedule.estimate_purchase_no
	,	IIF(t_schedule.is_copied_row = 1, '(' + 
			IIF(t_schedule.estimate_purchase_div = '1' AND #TBL_ESTIMTE_SHOW_BRANCH.estimate_no IS NOT NULL, t_schedule.estimate_purchase_no+'-'+t_schedule.estimate_branch_no
			, t_schedule.estimate_purchase_no) 
			+ ')', IIF(t_schedule.estimate_purchase_div = '1' AND #TBL_ESTIMTE_SHOW_BRANCH.estimate_no IS NOT NULL, t_schedule.estimate_purchase_no+'-'+t_schedule.estimate_branch_no
			, t_schedule.estimate_purchase_no) ) AS estimate_purchase_show
	,	t_schedule.work_input_div
	,	t_schedule.schedule_confirm_div
	,	t_schedule.vehicle_cd
	,	IIF(t_schedule_check.schedule_no IS NOT NULL, t_schedule_check.is_confirm, t_schedule.delivery_status_div) AS delivery_status_div
	,	t_schedule.arrangement_display_div
	,	t_schedule.estimate_purchase_div
	,	t_schedule.estimate_branch_no
	,	ISNULL(t_schedule.contact_detail, '')		AS contact_detail
	,	IIF(t_schedule.is_copied_row = 1, '(' + m_vehicle.vehicle_nm + ')', m_vehicle.vehicle_nm) AS vehicle_nm
	,	m_vehicle.schedule_display_color
	,	t_schedule.display_order
	,	t_shift.shift_day_div
	,	#TBL_ESTIMTE_DATA.estimate_no 		
	,	#TBL_ESTIMTE_DATA.estimate_branch_no 
	,	#TBL_ESTIMTE_DATA.work_input_div			AS work_input_nm
	,	#TBL_ESTIMTE_DATA.work_no					AS work_no
	,	#TBL_ESTIMTE_DATA.work_div					AS work_div
	--,	#TBL_ESTIMTE_DATA.work_input_div			AS work_input_div
	,	#TBL_ESTIMTE_DATA.people_amount				AS people_amount
	,	#TBL_ESTIMTE_DATA.operation_content			AS operation_content
	,	#TBL_ESTIMTE_DATA.work_time					AS work_time
	,	#TBL_ESTIMTE_DATA.clothes					AS clothes
	,	#TBL_ESTIMTE_DATA.delivery_nm
	,	#TBL_ESTIMTE_DATA.emp_cd				
	,	#TBL_ESTIMTE_DATA.emp_nm				
	,	#TBL_ESTIMTE_DATA.customer_nm1		
	,	#TBL_ESTIMTE_DATA.estimate_input_div	
	,	#TBL_ESTIMTE_DATA.matter_nm			
	,	#TBL_ESTIMTE_DATA.onsite_deli_message	
	,	#TBL_ESTIMTE_DATA.cre_datetime		
	,	#TBL_ESTIMTE_DATA.document_link		
	,	#TBL_ESTIMTE_DATA.item_cd				
	,	#TBL_ESTIMTE_DATA.item_nm
	,	#TBL_ESTIMTE_DATA.total_weight
	,	#TBL_ESTIMTE_DATA.body_value
	,	ISNULL(#TBL_SCHEDULE_COUNT_CHILD.count_child, 0)		AS count_child
	,	ISNULL(t_schedule.is_copied_row, 0)						AS is_copied_row
	,	IIF(#TBL_ESTIMTE_SHOW_BRANCH.estimate_no IS NULL, 0, 1) AS is_branch_show
	,	IIF(#TBL_ESTIMTE_DATA.estimate_no IS NOT NULL OR #TBL_ESTIMTE_DATA.purchase_no IS NOT NULL, 1, 0) AS is_disable_select
	,	ISNULL(t_schedule.text_yotei, '')		AS text_yotei
	,	IIF(
			(
				(
					#TBL_STATUS_ESTIMATE.w_is_estimate_confirm_div		= '1'
					AND #TBL_STATUS_ESTIMATE.w_is_billing_confirm_div_est	= '0'
					AND #TBL_STATUS_ESTIMATE.w_is_arrangement_confirm_div	= '1'
					AND #TBL_STATUS_ESTIMATE.w_is_billing_confirm_div_sales = '0'
				)
			OR
				(		
						#TBL_STATUS_ESTIMATE.w_is_estimate_confirm_div		= '1'
					AND #TBL_STATUS_ESTIMATE.w_is_billing_confirm_div_est	= '0'
					AND #TBL_STATUS_ESTIMATE.w_is_arrangement_exist			= 0
					AND #TBL_STATUS_ESTIMATE.w_is_billing_confirm_div_sales = '0'
				)
			OR
				(
					     #TBL_STATUS_ESTIMATE.w_is_billing_confirm_div_est = '1'
					AND EXISTS (SELECT 1 FROM t_estimate_h  WITH(NOLOCK) WHERE estimate_no = #TBL_STATUS_ESTIMATE.estimate_no AND estimate_branch_no = #TBL_STATUS_ESTIMATE.estimate_branch_no AND t_estimate_h.del_flg = 0)
				) 
			OR	#TBL_ESTIMTE_DATA.estimate_no = 0
			),
			0,
			1
		)			AS status_estimate
	FROM
		t_schedule WITH(NOLOCK)
	LEFT OUTER JOIN m_vehicle WITH(NOLOCK) ON(
		t_schedule.vehicle_cd					= m_vehicle.vehicle_cd
	AND	m_vehicle.del_flg						= 0
	)
	LEFT OUTER JOIN m_employee WITH(NOLOCK) ON(
		t_schedule.schedule_emp					= m_employee.emp_cd
	AND	m_employee.del_flg						= 0
	)
	LEFT OUTER JOIN t_shift WITH(NOLOCK) ON (
		t_shift.emp_cd							= m_employee.emp_cd
	AND t_shift.del_flg							= 0 
	AND	t_shift.shift_date						= @w_datetime_schedule
	)
	LEFT OUTER JOIN #TBL_ESTIMTE_DATA ON(
	(
		(
				t_schedule.estimate_purchase_div		= '1'
			AND #TBL_ESTIMTE_DATA.purchase_no			= 0
			AND	t_schedule.estimate_purchase_no			= #TBL_ESTIMTE_DATA.estimate_no
			AND	t_schedule.estimate_branch_no			= #TBL_ESTIMTE_DATA.estimate_branch_no
			--AND #TBL_ESTIMTE_DATA.is_deleted			= 0
			)
		OR (
			t_schedule.estimate_purchase_div		<> '1'
		AND #TBL_ESTIMTE_DATA.purchase_no			<> 0
		AND	t_schedule.estimate_purchase_no			= #TBL_ESTIMTE_DATA.purchase_no
		)
	)
	AND	t_schedule.work_no						= #TBL_ESTIMTE_DATA.work_no
	--AND	t_schedule.schedule_consultation_div	= #TBL_ESTIMTE_DATA.flg
	--AND #TBL_ESTIMTE_DATA.is_deleted			= 0
	)
	LEFT OUTER JOIN #TBL_EMP ON(
		t_schedule.outsourcing_purchase_no		<> '0'
	AND	t_schedule.outsourcing_purchase_no		<> ''
	AND	t_schedule.outsourcing_purchase_no		= #TBL_EMP.purchase_no
	AND	t_schedule.schedule_emp					= #TBL_EMP.emp_cd_hidden
	)
	LEFT OUTER JOIN #TBL_SCHEDULE_GROUP ON (
		t_schedule.schedule_no					= #TBL_SCHEDULE_GROUP.group_schedule_no
	AND t_schedule.schedule_div					= 1
	)
	LEFT OUTER JOIN #TBL_SCHEDULE_COUNT_CHILD ON(
		t_schedule.schedule_no					= #TBL_SCHEDULE_COUNT_CHILD.schedule_no
	AND t_schedule.schedule_div					= 1
	)
	LEFT OUTER JOIN #TBL_ESTIMTE_SHOW_BRANCH ON(
		t_schedule.estimate_purchase_div		= '1'
	AND	t_schedule.estimate_purchase_no			= #TBL_ESTIMTE_SHOW_BRANCH.estimate_no
	)
	LEFT OUTER JOIN #TBL_STATUS_ESTIMATE WITH(NOLOCK) ON (
		#TBL_STATUS_ESTIMATE.estimate_no				= #TBL_ESTIMTE_DATA.estimate_no
	AND #TBL_STATUS_ESTIMATE.estimate_branch_no			= #TBL_ESTIMTE_DATA.estimate_branch_no
	AND #TBL_STATUS_ESTIMATE.work_no					= #TBL_STATUS_ESTIMATE.work_no
	AND #TBL_STATUS_ESTIMATE.work_div					= #TBL_STATUS_ESTIMATE.work_div
	AND #TBL_STATUS_ESTIMATE.work_input_div				= #TBL_STATUS_ESTIMATE.work_input_div
	)
	LEFT OUTER JOIN t_schedule_check WITH(NOLOCK) ON(
		t_schedule.schedule_no							= t_schedule_check.schedule_no
	AND	t_schedule_check.del_flg						= 0
	)
	WHERE
		t_schedule.del_flg						= 0
	AND	t_schedule.schedule_consultation_date	= @P_date
	AND	t_schedule.schedule_consultation_div	= @P_schedule_type
	AND (
			@P_emp_cd							= ''
		OR	#TBL_SCHEDULE_GROUP.group_schedule_no IS NOT NULL
		OR	t_schedule.schedule_emp				= @P_emp_cd
	)
	ORDER BY
		t_schedule.display_order
	,	t_schedule.schedule_no
	--[1] 車両
	SELECT
		m_vehicle.vehicle_cd
	,	m_vehicle.vehicle_nm
	,	IIF(m_vehicle.schedule_display_color <> '', 'sch-' + m_vehicle.schedule_display_color, '') AS schedule_display_color
	FROM
		m_vehicle WITH(NOLOCK)
	LEFT OUTER JOIN t_schedule WITH(NOLOCK) ON (
		t_schedule.vehicle_cd					= m_vehicle.vehicle_cd
    AND t_schedule.schedule_consultation_date	= @P_date
	AND t_schedule.del_flg						= 0
	)
	WHERE
		m_vehicle.del_flg				= 0
    AND t_schedule.vehicle_cd			IS NULL
	AND	m_vehicle.schedule_display_div	= 1

	--[2] スタッフ
	SELECT
		#TBL_EMP.emp_cd
	,	#TBL_EMP.emp_nm
	,	#TBL_EMP.emp_cd_hidden
	,	#TBL_EMP.purchase_no
	,	ISNULL(#TBL_EMP.extra_div, '')		AS extra_div
	,	ISNULL(#TBL_EMP.shift_day_div, '')	AS shift_day_div
	FROM
		#TBL_EMP
	LEFT OUTER JOIN #TBL_SCHEDULE_EMP ON(
		(
			#TBL_EMP.emp_cd								<> ''
		AND	#TBL_EMP.emp_cd								= #TBL_SCHEDULE_EMP.emp_cd
		AND	#TBL_SCHEDULE_EMP.outsourcing_purchase_no	= 0
		)
	OR	(
			#TBL_EMP.emp_cd								= ''
		AND	#TBL_EMP.emp_cd_hidden						= #TBL_SCHEDULE_EMP.emp_cd
		AND	#TBL_EMP.purchase_no						= #TBL_SCHEDULE_EMP.outsourcing_purchase_no
		)
	)
	LEFT OUTER JOIN m_employee WITH(NOLOCK) ON(
		#TBL_EMP.emp_cd									= m_employee.emp_cd
	AND	m_employee.del_flg								= 0
	)
	WHERE
		#TBL_SCHEDULE_EMP.emp_cd						IS NULL
	AND	(
			#TBL_EMP.purchase_no						<> 0
		OR
			#TBL_EMP.extra_div							<> ''
		OR	(
				@P_schedule_type						= '1'
			AND	m_employee.department_cd				= '500'
			)
		OR	(
				@P_schedule_type						= '2'
			AND	m_employee.department_cd				= '600'
			)
	)
	ORDER BY
		flg				ASC
	,	#TBL_EMP.emp_cd	ASC
	,	emp_nm			ASC

	--[3] t_estimate_h
	SELECT DISTINCT
		#TBL_ESTIMTE_DATA.estimate_no 		
	,	#TBL_ESTIMTE_DATA.estimate_branch_no 	
	,	#TBL_ESTIMTE_DATA.emp_cd				
	,	#TBL_ESTIMTE_DATA.emp_nm				
	--,	IIF (#TBL_ESTIMTE_DATA.is_deleted = 1 AND #TBL_ESTIMTE_DATA.purchase_no = 0, 
	--		#TBL_ESTIMTE_DATA.customer_nm1 + '　キャンセル', #TBL_ESTIMTE_DATA.customer_nm1)	AS customer_nm1
	,	IIF (#TBL_ESTIMTE_DATA.is_deleted = 1, 
		#TBL_ESTIMTE_DATA.customer_nm1 + '　キャンセル', #TBL_ESTIMTE_DATA.customer_nm1)	AS customer_nm1
	,	#TBL_ESTIMTE_DATA.estimate_input_div	
	,	#TBL_ESTIMTE_DATA.matter_nm			
	,	#TBL_ESTIMTE_DATA.onsite_deli_message	
	,	#TBL_ESTIMTE_DATA.cre_datetime		
	,	#TBL_ESTIMTE_DATA.document_link		
	,	#TBL_ESTIMTE_DATA.item_cd				
	,	#TBL_ESTIMTE_DATA.item_nm				
	,	#TBL_ESTIMTE_DATA.work_no				
	,	#TBL_ESTIMTE_DATA.work_div			
	,	#TBL_ESTIMTE_DATA.work_input_div		
	,	#TBL_ESTIMTE_DATA.people_amount		
	,	#TBL_ESTIMTE_DATA.work_time			
	,	#TBL_ESTIMTE_DATA.operation_content	
	,	#TBL_ESTIMTE_DATA.clothes				
	,	#TBL_ESTIMTE_DATA.delivery_nm			
	,	#TBL_ESTIMTE_DATA.purchase_no
	,	#TBL_ESTIMTE_DATA.work_date
	,	IIF(#TBL_ESTIMTE_DATA.is_deleted = 1, 1, 0) AS  flg_del
	,   t_estimate_delete_schedule.del_flg			AS	del_schedule	
	,	t_schedule.estimate_purchase_no
	,	IIF(#TBL_ESTIMTE_SHOW_BRANCH.estimate_no IS NULL, #TBL_ESTIMTE_DATA.estimate_no, 
			#TBL_ESTIMTE_DATA.estimate_no + '-' + #TBL_ESTIMTE_DATA.estimate_branch_no) AS estimate_no_show
	,	IIF(
					(
						(
							#TBL_STATUS_ESTIMATE.w_is_estimate_confirm_div		= '1'
							AND #TBL_STATUS_ESTIMATE.w_is_billing_confirm_div_est	= '0'
							AND #TBL_STATUS_ESTIMATE.w_is_arrangement_confirm_div	= '1'
							AND #TBL_STATUS_ESTIMATE.w_is_billing_confirm_div_sales = '0'
						)
					OR
						(		
								#TBL_STATUS_ESTIMATE.w_is_estimate_confirm_div		= '1'
							AND #TBL_STATUS_ESTIMATE.w_is_billing_confirm_div_est	= '0'
							AND #TBL_STATUS_ESTIMATE.w_is_arrangement_exist			= 0
							AND #TBL_STATUS_ESTIMATE.w_is_billing_confirm_div_sales = '0'
						)
					OR
						(
								 #TBL_STATUS_ESTIMATE.w_is_billing_confirm_div_est = '1'
							AND EXISTS (SELECT 1 FROM t_estimate_h  WITH(NOLOCK) WHERE estimate_no = #TBL_STATUS_ESTIMATE.estimate_no AND estimate_branch_no = #TBL_STATUS_ESTIMATE.estimate_branch_no AND t_estimate_h.del_flg = 0)
						) 
					OR	#TBL_ESTIMTE_DATA.estimate_no = 0
					),
					0,
					1
				)			AS status_estimate
	FROM
		#TBL_ESTIMTE_DATA
	LEFT OUTER JOIN t_estimate_delete_schedule WITH(NOLOCK) ON(
	(
			t_estimate_delete_schedule.estimate_no			= #TBL_ESTIMTE_DATA.estimate_no
		AND	t_estimate_delete_schedule.estimate_branch_no	= #TBL_ESTIMTE_DATA.estimate_branch_no
		AND	t_estimate_delete_schedule.work_div				= #TBL_ESTIMTE_DATA.work_div
		AND t_estimate_delete_schedule.estimate_work_no		= #TBL_ESTIMTE_DATA.work_no
	)
	OR
	(
			t_estimate_delete_schedule.estimate_no			= #TBL_ESTIMTE_DATA.purchase_no
		AND	t_estimate_delete_schedule.work_div				= #TBL_ESTIMTE_DATA.work_div
		AND t_estimate_delete_schedule.estimate_work_no		= #TBL_ESTIMTE_DATA.work_no
	)
	)
	LEFT OUTER JOIN t_schedule WITH(NOLOCK) ON(
		((
		t_schedule.estimate_purchase_div		= '1'
	AND #TBL_ESTIMTE_DATA.purchase_no			= 0
	AND	t_schedule.estimate_purchase_no			= #TBL_ESTIMTE_DATA.estimate_no
	AND	t_schedule.estimate_branch_no			= #TBL_ESTIMTE_DATA.estimate_branch_no
	)
	OR (
		t_schedule.estimate_purchase_div		<> '1'
	AND #TBL_ESTIMTE_DATA.purchase_no			<> 0
	AND	t_schedule.estimate_purchase_no			= #TBL_ESTIMTE_DATA.purchase_no
	
	))
	AND	t_schedule.work_no						= #TBL_ESTIMTE_DATA.work_no
	AND	t_schedule.schedule_consultation_date	= @P_date
	AND	t_schedule.schedule_consultation_div	= @P_schedule_type
	AND t_schedule.del_flg						= 0
	)
	LEFT OUTER JOIN #TBL_ESTIMTE_SHOW_BRANCH ON(
		#TBL_ESTIMTE_DATA.estimate_no			= #TBL_ESTIMTE_SHOW_BRANCH.estimate_no
	)
	LEFT OUTER JOIN #TBL_STATUS_ESTIMATE WITH(NOLOCK) ON (
		#TBL_STATUS_ESTIMATE.estimate_no				= #TBL_ESTIMTE_DATA.estimate_no
	AND #TBL_STATUS_ESTIMATE.estimate_branch_no			= #TBL_ESTIMTE_DATA.estimate_branch_no
	AND #TBL_STATUS_ESTIMATE.work_no					= #TBL_STATUS_ESTIMATE.work_no
	AND #TBL_STATUS_ESTIMATE.work_div					= #TBL_STATUS_ESTIMATE.work_div
	AND #TBL_STATUS_ESTIMATE.work_input_div				= #TBL_STATUS_ESTIMATE.work_input_div
	)
	WHERE
		t_schedule.estimate_purchase_no			IS NULL
	AND (t_estimate_delete_schedule.del_flg		IS NULL OR t_estimate_delete_schedule.del_flg = 0)
	AND	#TBL_ESTIMTE_DATA.flg					= @P_schedule_type
	-----
	--[4] 担当者別項目制御
	SELECT
		emp_cd
	,	item_idx
	,	control_div
	,	item_width
	FROM
		t_schedule_emp_item_control WITH(NOLOCK)
	WHERE
		t_schedule_emp_item_control.del_flg						= 0
	--AND	t_schedule_emp_item_control.schedule_date				= @P_date
	AND	t_schedule_emp_item_control.emp_cd						= @P_login_emp_cd
	--AND	t_schedule_emp_item_control.schedule_div				= @P_schedule_type
	--
	--[5] スケジュール相談日判定
	SELECT
		FORMAT(schedule_consultation_date, 'yyyy/MM/dd') AS schedule_consultation_date
	,	schedule_div
	,	schedule_consultation_div
	,	setting_div
	FROM
		t_schedule_consultation_date WITH(NOLOCK)
	WHERE
		t_schedule_consultation_date.del_flg						= 0
	AND	t_schedule_consultation_date.schedule_consultation_date		= @P_date
	AND t_schedule_consultation_date.schedule_div					= @P_schedule_type
	--[6]作業区分「オペ/リハ」の合計人数が○○人超えたら要相談日
	SELECT
		ctl_cd
	,	ctl_nm
	,	ctl_val
	FROM
		s_ctl
	WHERE
		s_ctl.del_flg			= 0
	AND s_ctl.ctl_cd			= 'consultation_ex_number'
	-----
	--[7] 公休の担当者一覧表示
	SELECT
		m_employee.emp_cd
	,	m_employee.emp_nm
	,	t_shift.shift_day_div
	FROM
		t_shift WITH(NOLOCK)
	LEFT OUTER JOIN	m_employee WITH(NOLOCK) ON(
		t_shift.emp_cd			= m_employee.emp_cd
	AND	m_employee.del_flg		= 0
	)
	WHERE
		t_shift.del_flg			= 0
	AND	t_shift.shift_date		= @w_datetime_schedule
	AND t_shift.shift_day_div	IN ('4', '5')
	AND	(
		(
			@P_schedule_type						= '1'
		AND	m_employee.department_cd				= '500'
		)
	OR	(
			@P_schedule_type						= '2'
		AND	m_employee.department_cd				= '600'
		)
	)
	--[8] 外部担当者
	SELECT
		t_schedule_employee_plus.schedule_consultation_date
	,	t_schedule_employee_plus.schedule_consultation_div
	,	t_schedule_employee_plus.emp_cd
	,	m_employee.emp_nm
	FROM
		t_schedule_employee_plus WITH(NOLOCK)
	LEFT OUTER JOIN m_employee WITH(NOLOCK) ON(
		t_schedule_employee_plus.emp_cd			= m_employee.emp_cd
	AND	m_employee.del_flg						= 0
	)
	WHERE
		t_schedule_employee_plus.schedule_consultation_date		= @P_date
	AND t_schedule_employee_plus.schedule_consultation_div		= @P_schedule_type
	AND t_schedule_employee_plus.del_flg						= 0
	--[9] Vehicle
	SELECT
		t_schedule_vehicle.schedule_no
	,	t_schedule_vehicle.schedule_d_no
	,	t_schedule_vehicle.vehicle_cd
	,	IIF(t_schedule_vehicle.is_copied_row = 1, '(' + m_vehicle.vehicle_nm + ')', m_vehicle.vehicle_nm) AS vehicle_nm
	,	IIF(m_vehicle.schedule_display_color <> '', 'sch-' + m_vehicle.schedule_display_color, '') AS schedule_display_color
	,	IIF(t_schedule_vehicle.is_copied_row = 1, 1, 0) AS	copied_row
	FROM
		t_schedule_vehicle
	INNER JOIN t_schedule ON(
		t_schedule_vehicle.schedule_no			= t_schedule.schedule_no
	AND t_schedule.del_flg						= 0
	)
	LEFT OUTER JOIN m_vehicle WITH(NOLOCK) ON(
		t_schedule_vehicle.vehicle_cd			= m_vehicle.vehicle_cd
	AND	m_vehicle.del_flg						= 0
	)
	WHERE
		t_schedule.del_flg						= 0
	AND	t_schedule.schedule_consultation_date	= @P_date
	AND	t_schedule.schedule_consultation_div	= @P_schedule_type
	AND (
			@P_emp_cd							= ''
		OR	t_schedule.schedule_emp				= @P_emp_cd
	)
	ORDER BY
		t_schedule_vehicle.schedule_no
	,	t_schedule_vehicle.schedule_d_no
	--[10] 担当者
	SELECT
		t_schedule_emp.schedule_no
	,	t_schedule_emp.schedule_d_no
	,	t_schedule_emp.schedule_time
	,	t_schedule_emp.emp_cd				AS schedule_emp
	,	ISNULL(t_schedule_emp.outsourcing_purchase_no, '0')									AS outsourcing_purchase_no
	,	IIF(t_schedule_emp.is_copied_row = 1, '('+IIF((t_schedule_emp.outsourcing_purchase_no <> '0' AND t_schedule_emp.outsourcing_purchase_no != ''), 
			t_purchase_subcontractor.subcontractor, m_employee.emp_nm) + ')', IIF((t_schedule_emp.outsourcing_purchase_no <> '0' AND t_schedule_emp.outsourcing_purchase_no != ''), 
			t_purchase_subcontractor.subcontractor, m_employee.emp_nm)	)
																							AS schedule_emp_nm
	,	t_schedule_emp.shift_day_div
	,	IIF(t_schedule_emp.is_copied_row = 1, 1, 0)		AS copied_row
	FROM
		t_schedule_emp
	INNER JOIN t_schedule ON(
		t_schedule_emp.schedule_no				= t_schedule.schedule_no
	AND t_schedule.del_flg						= 0
	)
	LEFT OUTER JOIN m_employee WITH(NOLOCK) ON(
		t_schedule_emp.emp_cd					= m_employee.emp_cd
	AND	m_employee.del_flg						= 0
	)
	--LEFT OUTER JOIN #TBL_EMP ON(
	--	t_schedule_emp.outsourcing_purchase_no	<> '0'
	--AND	t_schedule_emp.outsourcing_purchase_no	<> ''
	--AND	t_schedule_emp.outsourcing_purchase_no	= #TBL_EMP.purchase_no
	--AND	t_schedule_emp.emp_cd					= #TBL_EMP.emp_cd_hidden
	--)
	LEFT OUTER JOIN t_purchase_subcontractor ON(
		t_schedule_emp.outsourcing_purchase_no	= t_purchase_subcontractor.purchase_no
	AND	t_schedule_emp.emp_cd					= t_purchase_subcontractor.purchase_subcontractor_detail_no
	AND	t_purchase_subcontractor.del_flg		= 0
	)
	WHERE
		t_schedule.del_flg						= 0
	AND	t_schedule.schedule_consultation_date	= @P_date
	AND	t_schedule.schedule_consultation_div	= @P_schedule_type
	AND (
			@P_emp_cd							= ''
		OR	t_schedule.schedule_emp				= @P_emp_cd
	)
	ORDER BY
		t_schedule_emp.schedule_no
	,	t_schedule_emp.schedule_d_no
	----
	DROP TABLE #TBL_ITEM
	DROP TABLE #TBL_ITEM_TMP
	DROP TABLE #TBL_ESTIMTE
	DROP TABLE #TBL_EMP
	DROP TABLE #TBL_ESTIMTE_DATA
	DROP TABLE #TBL_SCHEDULE_GROUP
	DROP TABLE #TBL_DELETED_EST_D
	DROP TABLE #TBL_SCHEDULE_COUNT_CHILD
	DROP TABLE #TBL_SCHEDULE_EMP
	DROP TABLE #TBL_ESTIMTE_SHOW_BRANCH
	DROP TABLE #TBL_STATUS_ESTIMATE
END

