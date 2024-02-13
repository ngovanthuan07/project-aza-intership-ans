USE [AZA]
GO

EXEC [dbo].[usp_InsertDelivery]
    @P_delivery_cd = 'CD0015',
    @P_delivery_nm1 = 'Delivery Name 1',
    @P_delivery_kn1 = 'Delivery Kana 1',
    @P_delivery_nm2 = 'Delivery Name 2',
    @P_delivery_kn2 = 'Delivery Kana 2',
    @P_zip_cd = '12345678',
    @P_prefecture_cd = '01',
    @P_city_nm = 'City Name',
    @P_town_nm = 'Town Name',
    @P_apartment_nm = 'Apt Name',
    @P_address1 = 'Address Line 1',
    @P_address2 = 'Address Line 2',
    @P_tel = '123-456-7890',
    @P_fax = '987-654-3210',
    @P_delivery_class_1 = '999',
    @P_delivery_class_2 = '999',
    @P_delivery_class_3 = '999',
    @P_remark = 'This is a test remark.',
    @P_cre_user = 'TestUser',
    @P_cre_prg = 'TestProgram',
    @P_cre_ip = '127.0.0.1',
    @P_cre_date = NULL

EXEC [dbo].[usp_UpdatetDelivery]
    @P_delivery_cd = 'CD0014',
    @P_delivery_nm1 = 'Delivery Name 1',
    @P_delivery_kn1 = 'Delivery Kana 1',
    @P_delivery_nm2 = 'Delivery Name 2',
    @P_delivery_kn2 = 'Delivery Kana 2',
    @P_zip_cd = '5435452',
    @P_prefecture_cd = '01',
    @P_city_nm = 'City Name',
    @P_town_nm = 'Town Name',
    @P_apartment_nm = 'Apt Name',
    @P_address1 = 'Address Line 1',
    @P_address2 = 'Address Line 2',
    @P_tel = '123-456-7890',
    @P_fax = '987-654-3210',
    @P_delivery_class_1 = '999',
    @P_delivery_class_2 = '999',
    @P_delivery_class_3 = '999',
    @P_remark = 'This is a test remark.',
    @P_upd_user = NULL,
    @P_upd_prg = NULL,
    @P_upd_ip = NULL,
    @P_upd_date = NULL,
    @P_del_user = NULL,
    @P_del_prg = NULL,
    @P_del_ip = NULL,
    @P_del_date = NULL,
    @P_del_flg = 0; 

SELECT * FROM [dbo].[m_delivery] WHERE [delivery_cd] = 'CD0014';

