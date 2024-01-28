USE AZA;
GO

DECLARE @Result INT;  -- Đảm bảo rằng biến được khai báo ở đây

EXEC [dbo].[usp_DeliverySearch]
    @Param_delivery_cd         = N'' ,
    @Param_delivery_nm1        = N'' ,
    @Param_delivery_nm2        = N'' ,
    @Param_delivery_kn1        = N'' ,
    @Param_delivery_kn2        = N'' ,
    @Param_prefecture           = N'' ,
    @Param_city_nm             = N'' ,
    @Param_town_nm             = N'' ,
    @Param_apartment_nm        = N'' ,
    @Param_tel                 = N'' ,
    @Param_delivery_class_1    = N'' ,
    @Param_delivery_class_2    = N'' ,
    @Param_delivery_class_3    = N'' ,
    @OrderByColumn       = 'd4',
    @TypeSort            = 'ASC'   ,
    @CurrentPage                = 3 ,                        
    @Limit                = 10,
    @TotalItem = @Result OUTPUT;

PRINT 'Received value from OUTPUT: ' + CAST(@Result AS NVARCHAR(10));
