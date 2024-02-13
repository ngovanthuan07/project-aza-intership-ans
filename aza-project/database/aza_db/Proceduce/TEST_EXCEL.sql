USE AZA;
GO

EXEC [dbo].[usp_DeliveryExcel]
    @P_delivery_cd         = N'' ,
    @P_delivery_nm         = N'' ,
    @P_delivery_kn         = N'' ,
    @P_address             = NULL ,
    @P_tel                 = N'' ,
    @P_delivery_class_1    = N'' ,
    @P_delivery_class_2    = N'' ,
    @P_delivery_class_3    = N''
