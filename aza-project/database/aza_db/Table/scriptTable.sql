CREATE DATABASE [AZA]
GO
USE [AZA]
GO
/****** Object:  Table [dbo].[m_delivery]    Script Date: 22/1/2024 4:23:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[m_delivery](
	[delivery_cd] [nvarchar](6) NOT NULL,
	[delivery_nm1] [varchar](80) NULL,
	[delivery_nm2] [varchar](80) NULL,
	[sch_delivery_nm] [nvarchar](50) NULL,
	[delivery_kn1] [varchar](80) NULL,
	[delivery_kn2] [varchar](80) NULL,
	[zip_cd] [nvarchar](8) NULL,
	[prefecture_cd] [nvarchar](2) NULL,
	[city_nm] [nvarchar](24) NULL,
	[town_nm] [nvarchar](32) NULL,
	[apartment_nm] [nvarchar](32) NULL,
	[address1] [nvarchar](200) NULL,
	[address2] [nvarchar](200) NULL,
	[tel] [nvarchar](20) NULL,
	[fax] [nvarchar](20) NULL,
	[delivery_class_1] [nvarchar](3) NULL,
	[delivery_class_2] [nvarchar](3) NULL,
	[delivery_class_3] [nvarchar](3) NULL,
	[remark] [nvarchar](1000) NULL,
	[memo] [nvarchar](50) NULL,
	[cre_user] [nvarchar](50) NULL,
	[cre_prg] [nvarchar](50) NULL,
	[cre_ip] [nvarchar](20) NULL,
	[cre_date] [datetime2](7) NULL,
	[upd_user] [nvarchar](50) NULL,
	[upd_prg] [nvarchar](50) NULL,
	[upd_ip] [nvarchar](20) NULL,
	[upd_date] [datetime2](7) NULL,
	[del_user] [nvarchar](50) NULL,
	[del_prg] [nvarchar](50) NULL,
	[del_ip] [nvarchar](20) NULL,
	[del_date] [datetime2](7) NULL,
	[del_flg] [int] NULL,
 CONSTRAINT [PK_m_delivery] PRIMARY KEY CLUSTERED 
(
	[delivery_cd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[m_users]    Script Date: 22/1/2024 4:23:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[m_users](
	[user_cd] [nvarchar](50) NOT NULL,
	[user_nm] [nvarchar](50) NULL,
	[user_kn_nm] [nvarchar](30) NULL,
	[user_ab_nm] [nvarchar](20) NULL,
	[password] [nvarchar](128) NULL,
	[user_kind_div] [nvarchar](2) NULL,
	[emp_cd] [nvarchar](10) NULL,
	[vendor_cd] [nvarchar](6) NULL,
	[vendor_emp_no] [int] NULL,
	[account_image_path] [nvarchar](255) NULL,
	[frame_color_div] [nvarchar](1) NULL,
	[auth_role_div] [nvarchar](3) NULL,
	[last_login_date] [datetime2](7) NULL,
	[last_logout_date] [datetime2](7) NULL,
	[remember_token] [nvarchar](60) NULL,
	[memo] [nvarchar](50) NULL,
	[cre_user] [nvarchar](50) NULL,
	[cre_prg] [nvarchar](50) NULL,
	[cre_ip] [nvarchar](20) NULL,
	[cre_date] [datetime2](7) NULL,
	[upd_user] [nvarchar](50) NULL,
	[upd_prg] [nvarchar](50) NULL,
	[upd_ip] [nvarchar](20) NULL,
	[upd_date] [datetime2](7) NULL,
	[del_user] [nvarchar](50) NULL,
	[del_prg] [nvarchar](50) NULL,
	[del_ip] [nvarchar](20) NULL,
	[del_date] [datetime2](7) NULL,
	[del_flg] [int] NULL,
 CONSTRAINT [PK_m_users] PRIMARY KEY CLUSTERED 
(
	[user_cd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[s_lib]    Script Date: 22/1/2024 4:23:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[s_lib](
	[lib_cd] [nvarchar](50) NOT NULL,
	[lib_nm] [nvarchar](50) NULL,
	[lib_val_cd_digit] [int] NULL,
	[change_perm_div] [nvarchar](1) NULL,
	[screen_type] [nvarchar](1) NULL,
	[memo] [nvarchar](200) NULL,
	[cre_user] [nvarchar](50) NULL,
	[cre_prg] [nvarchar](50) NULL,
	[cre_ip] [nvarchar](20) NULL,
	[cre_date] [datetime2](7) NULL,
	[upd_user] [nvarchar](50) NULL,
	[upd_prg] [nvarchar](50) NULL,
	[upd_ip] [nvarchar](20) NULL,
	[upd_date] [datetime2](7) NULL,
	[del_user] [nvarchar](50) NULL,
	[del_prg] [nvarchar](50) NULL,
	[del_ip] [nvarchar](20) NULL,
	[del_date] [datetime2](7) NULL,
	[del_flg] [int] NULL,
 CONSTRAINT [PK_s_lib] PRIMARY KEY CLUSTERED 
(
	[lib_cd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[s_lib_val]    Script Date: 22/1/2024 4:23:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[s_lib_val](
	[lib_cd] [nvarchar](50) NOT NULL,
	[lib_val_cd] [nvarchar](20) NOT NULL,
	[lib_val_nm] [nvarchar](80) NULL,
	[lib_val_kn_nm] [nvarchar](80) NULL,
	[lib_val_ab_nm] [nvarchar](80) NULL,
	[num_remarks1] [int] NULL,
	[num_remarks2] [int] NULL,
	[num_remarks3] [int] NULL,
	[char_remarks1] [nvarchar](50) NULL,
	[char_remarks2] [nvarchar](50) NULL,
	[char_remarks3] [nvarchar](50) NULL,
	[inspection_check_div] [nvarchar](1) NULL,
	[inspection_onsite_check_div] [nvarchar](1) NULL,
	[inspection_content_check] [nvarchar](1000) NULL,
	[inspection_cleaning_div] [nvarchar](1) NULL,
	[inspection_onsite_cleaning_div] [nvarchar](1) NULL,
	[inspection_content_cleaning] [nvarchar](1000) NULL,
	[inspection_confirm_div] [nvarchar](1) NULL,
	[inspection_onsite_confirm_div] [nvarchar](1) NULL,
	[inspection_content_confirm] [nvarchar](1000) NULL,
	[disp_order] [int] NULL,
	[ini_target_div] [nvarchar](1) NULL,
	[memo] [nvarchar](200) NULL,
	[cre_user] [nvarchar](50) NULL,
	[cre_prg] [nvarchar](50) NULL,
	[cre_ip] [nvarchar](20) NULL,
	[cre_date] [datetime2](7) NULL,
	[upd_user] [nvarchar](50) NULL,
	[upd_prg] [nvarchar](50) NULL,
	[upd_ip] [nvarchar](20) NULL,
	[upd_date] [datetime2](7) NULL,
	[del_user] [nvarchar](50) NULL,
	[del_prg] [nvarchar](50) NULL,
	[del_ip] [nvarchar](20) NULL,
	[del_date] [datetime2](7) NULL,
	[del_flg] [int] NULL,
 CONSTRAINT [PK_s_lib_val] PRIMARY KEY CLUSTERED 
(
	[lib_cd] ASC,
	[lib_val_cd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[s_message]    Script Date: 22/1/2024 4:23:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[s_message](
	[message_cd] [nvarchar](4) NOT NULL,
	[type] [int] NULL,
	[message_nm] [nvarchar](20) NULL,
	[message] [nvarchar](100) NULL,
	[memo] [nvarchar](50) NULL,
	[cre_user] [nvarchar](50) NULL,
	[cre_prg] [nvarchar](50) NULL,
	[cre_ip] [nvarchar](20) NULL,
	[cre_date] [datetime2](7) NULL,
	[upd_user] [nvarchar](50) NULL,
	[upd_prg] [nvarchar](50) NULL,
	[upd_ip] [nvarchar](20) NULL,
	[upd_date] [datetime2](7) NULL,
	[del_user] [nvarchar](50) NULL,
	[del_prg] [nvarchar](50) NULL,
	[del_ip] [nvarchar](20) NULL,
	[del_date] [datetime2](7) NULL,
	[del_flg] [int] NULL,
 CONSTRAINT [PK_s_message] PRIMARY KEY CLUSTERED 
(
	[message_cd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
