USE AZA;
GO

EXEC [dbo].[usp_DeliverySearch]
    @p_delivery_cd         = N'' ,
    @p_delivery_nm         = N'' ,
    @p_delivery_kn         = N'' ,
    @p_address             = NULL ,
    @p_tel                 = N'' ,
    @p_delivery_class_1    = N'' ,
    @p_delivery_class_2    = N'' ,
    @p_delivery_class_3    = N'',
    @p_order_by_column             = 'delivery_dc',
    @p_sort_type                  = 'DESC',
    @p_current_page               = 1,
    @p_limit                     = 10
