USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Financial_Year]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE view [dbo].[VW_Financial_Year]
AS 
SELECT 
CASE 
	 when month(getdate()) < 7 then convert(datetime ,CONVERT(VARCHAR(5),year(getdate())-1)+'-07-01',101)
ELSE 
	 convert(datetime ,CONVERT(VARCHAR(5),year(getdate()))+'-07-01',101)
END  [Start Date],
case 
	 when month(getdate()) < 7 then  convert(datetime,CONVERT(VARCHAR(5),year(getdate())) +'-06-30',101) 
ELSE 
	 convert(datetime ,CONVERT(VARCHAR(5),year(getdate())+1) + '-06-30',101)
END [End Date]

GO
