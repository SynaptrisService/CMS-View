USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Clinic_Irregular_Schedule_Approval_Report]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE VIEW [dbo].[VW_Clinic_Irregular_Schedule_Approval_Report]
As
Select Distinct ISD.* from [Clinic_Irregular_Schedule_Inprogress_Detail] ISD inner join
 (
 Select [Created On],[Clinic Type],[Clinic Specialty],[Schedule Interval],max([Schedule Updated On])[Schedule Updated On]
 from  [Kezava_DM_V3_Neurology].[dbo].[2_19_Clinic Irregular Schedule] 
 group by  [Created On],[Clinic Type],[Clinic Specialty],[Schedule Interval]
 )SQ 
 on ISD.[Created On]=SQ.[Created On] 
 and ISD.[Clinic Type]=SQ.[Clinic Type]
 and ISD.[Clinic Specialty]=SQ.[Clinic Specialty]
 and ISD.[Schedule Interval]=SQ.[Schedule Interval] 
 and ISD.[Schedule Updated On]=SQ.[Schedule Updated On]

GO
