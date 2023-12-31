USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Room_Irregular_Scheduling_Metrics_Report]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE view [dbo].[VW_Room_Irregular_Scheduling_Metrics_Report] 
as 
	SELECT [first name]+' '+[last name] [Provider],[Schedule interval],PRS.[Division Name],[Clinic Type],[Clinic Specialty]
	,DATEPART(WEEK,day([clinic date]))[Clinic Schedule Week],DATEname(weekDAY,[clinic date])[Work Days],[location]
	,sum((casT((DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time])) as float)/60)) as[Clinic Hours]
	,[Rooms Required],sum((casT((DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time])) as float)/60))*[Rooms Required] as [Room Hours]
	,(sum((casT((DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time])) as float)/60))*[Rooms Required])/[Rooms Required] as [Avg Room Hours]
	from Provider_Irregular_Schedule_detail PRS left join [employee_master] EM on PRS.Provider=EM.[full name]
	group by [Provider],PRS.[Division Name],[Clinic Type],[Clinic Specialty],[Clinic Schedule Week],[Work Days]
	,[location],[Rooms Required],[first name]+' '+[last name],[Schedule interval],[clinic date]



GO
