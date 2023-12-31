USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Clinic_Regular_Scheduling_Metrics_Report]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE VIEW [dbo].[VW_Clinic_Regular_Scheduling_Metrics_Report] as 
SELECT PRS.[Clinic Type],PRS.[Clinic Specialty],PRS.[Division Name],[Clinic Schedule Week],[Work Days],[location]
,sum((casT((DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time])) as float)/60)) as[Clinic Hours],[Rooms Required]
,sum((casT((DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time])) as float)/60))*[Rooms Required] as [Room Hours]
,(sum((casT((DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time])) as float)/60))*[Rooms Required])/[Rooms Required] as [Avg Room Hours]
from Clinic_Regular_Schedule PRS left join [Clinic_Specialty] EM on PRS.[Clinic Type]=EM.[Clinic Type] and PRS.[Clinic Specialty]=PRS.[Clinic Specialty]
group by PRS.[Clinic Type],PRS.[Clinic Specialty],PRS.[Division Name],[Clinic Schedule Week],[Work Days]
,[location],[Rooms Required]




GO
