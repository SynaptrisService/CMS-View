USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Room_Hold_Scheduling_Metrics_Report]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE VIEW [dbo].[VW_Room_Hold_Scheduling_Metrics_Report] as 
SELECT [first name]+' '+[last name] [Provider],PRS.[Division Name],[Clinic Type],[Clinic Specialty],[Clinic Schedule Week],[Work Days],[location]
,sum((casT((DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time])) as float)/60)) as[Clinic Hours],[Rooms Required]
,sum((casT((DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time])) as float)/60))*[Rooms Required] as [Room Hours]
,(sum((casT((DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time])) as float)/60))*[Rooms Required])/[Rooms Required] as [Avg Room Hours]
from Provider_Room_Hold_Schedule PRS left join [Employee_Master] EM on PRS.Provider=EM.[full name]
group by [Provider],PRS.[Division Name],[Clinic Type],[Clinic Specialty],[Clinic Schedule Week],[Work Days]
,[location],[Rooms Required],[first name]+' '+[last name]



GO
