USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Provider_Irregular_Schedule_Approval_Report]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE VIEW [dbo].[VW_Provider_Irregular_Schedule_Approval_Report]
As
Select Distinct ISD.* from Provider_Irregular_Schedule_Approval_Report ISD inner join
 (
 Select [Created On],Provider,[Schedule Interval],max([Schedule Updated On])[Schedule Updated On]
 from  [Kezava_DM_V3_Neurology].[dbo].[2_18_Provider Irregular Schedule] 
 group by  [Created On],Provider,[Schedule Interval]
 )SQ 
 on ISD.[Created On]=SQ.[Created On] 
 and ISD.Provider=SQ.Provider
 and ISD.[Schedule Interval]=SQ.[Schedule Interval] 
 and ISD.[Schedule Updated On]=SQ.[Schedule Updated On]
GO
