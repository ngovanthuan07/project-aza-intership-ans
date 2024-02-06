USE [AZA]
GO

EXEC [dbo].[usp_InsertDelivery]
    @p_delivery_cd = 'CD0015',
    @p_delivery_nm1 = 'Delivery Name 1',
    @p_delivery_kn1 = 'Delivery Kana 1',
    @p_delivery_nm2 = 'Delivery Name 2',
    @p_delivery_kn2 = 'Delivery Kana 2',
    @p_zip_cd = '12345678',
    @p_prefecture_cd = '01',
    @p_city_nm = 'City Name',
    @p_town_nm = 'Town Name',
    @p_apartment_nm = 'Apt Name',
    @p_address1 = 'Address Line 1',
    @p_address2 = 'Address Line 2',
    @p_tel = '123-456-7890',
    @p_fax = '987-654-3210',
    @p_delivery_class_1 = '999',
    @p_delivery_class_2 = '999',
    @p_delivery_class_3 = '999',
    @p_remark = 'This is a test remark.',
    @p_cre_user = 'TestUser',
    @p_cre_prg = 'TestProgram',
    @p_cre_ip = '127.0.0.1',
    @p_cre_date = NULL

EXEC [dbo].[usp_UpdatetDelivery]
    @p_delivery_cd = 'CD0014',
    @p_delivery_nm1 = 'Delivery Name 1',
    @p_delivery_kn1 = 'Delivery Kana 1',
    @p_delivery_nm2 = 'Delivery Name 2',
    @p_delivery_kn2 = 'Delivery Kana 2',
    @p_zip_cd = '5435452',
    @p_prefecture_cd = '01',
    @p_city_nm = 'City Name',
    @p_town_nm = 'Town Name',
    @p_apartment_nm = 'Apt Name',
    @p_address1 = 'Address Line 1',
    @p_address2 = 'Address Line 2',
    @p_tel = '123-456-7890',
    @p_fax = '987-654-3210',
    @p_delivery_class_1 = '999',
    @p_delivery_class_2 = '999',
    @p_delivery_class_3 = '999',
    @p_remark = 'This is a test remark.',
    @p_upd_user = NULL,
    @p_upd_prg = NULL,
    @p_upd_ip = NULL,
    @p_upd_date = NULL,
    @p_del_user = NULL,
    @p_del_prg = NULL,
    @p_del_ip = NULL,
    @p_del_date = NULL,
    @p_del_flg = 0; 

SELECT * FROM [dbo].[m_delivery] WHERE [delivery_cd] = 'CD0014';

