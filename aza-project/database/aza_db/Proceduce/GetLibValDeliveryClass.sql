USE AZA;

IF OBJECT_ID('[dbo].[usp_GetLibValDeliveryClass]', 'P') IS NOT NULL
    DROP PROCEDURE [dbo].usp_GetLibValDeliveryClass
GO

CREATE PROCEDURE [dbo].[usp_GetLibValDeliveryClass]
AS
BEGIN
    SELECT slv.lib_cd
    ,      slv.lib_val_cd
    ,      slv.lib_val_nm
    FROM s_lib_val AS slv
    WHERE slv.lib_cd = 'delivery_class_1_div'

    SELECT slv.lib_cd
    ,      slv.lib_val_cd
    ,      slv.lib_val_nm
    FROM s_lib_val AS slv
    WHERE slv.lib_cd = 'delivery_class_2_div'

    SELECT slv.lib_cd
    ,      slv.lib_val_cd
    ,      slv.lib_val_nm
    FROM s_lib_val AS slv
    WHERE slv.lib_cd = 'delivery_class_3_div'

    SELECT slv.lib_cd
    ,      slv.lib_val_cd
    ,      slv.lib_val_nm
    FROM s_lib_val AS slv
    WHERE slv.lib_cd = 'prefecture_div'

END;
