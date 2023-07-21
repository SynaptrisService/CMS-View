USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Change_Request_Provider_Status]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE view [dbo].[VW_Change_Request_Provider_Status]
AS
SELECT 
'Provider, hold' [Provider]
,[Percentage]
--,Case when [Percentage] >= 86 then 'No' Else 'Yes' End as 'Show Status'
FROM [VW_Provider_Overview_Report] where [Percentage] <=86

GO
