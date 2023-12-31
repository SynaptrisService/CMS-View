USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Room_Hours_Request_by_Weekday_and_Division_Report_For_Irregular_Schedule]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE view [dbo].[VW_Room_Hours_Request_by_Weekday_and_Division_Report_For_Irregular_Schedule]
as
with [RoomHoursWeekday] as
(
	select [first name]+' '+[last name] Provider,[schedule interval],DATEname(weekDAY,[clinic date])[Work Days],
	sum((casT((DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time])) as float)/60)* [Rooms Required]) [Total Room Hours Weekday]
	from Provider_Irregular_Schedule_FindRoom_ReferenceTable PRS 
	left join [employee_master] EM on PRS.Provider=EM.[full name]  
	group by [first name]+' '+[last name] ,[Work Days],[schedule interval],[clinic date]
 ),
[clinichrs] as
( 
	select distinct [first name]+' '+[last name] Provider,[schedule interval],DATEname(weekDAY,[clinic date])[Work Days],
	((casT((DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time])) as float)/60)) [Total Clinic Hours Week]
	from Provider_Irregular_Schedule_FindRoom_ReferenceTable PRS 
	left join [employee_master] EM on PRS.Provider=EM.[full name] 
)
	selecT RH.Provider,RH.[schedule interval],'Room Hours Request by Weekday vs Division' 'Chart', RH.[Work Days],RH.[Total Room Hours Weekday],CH.[Total Clinic Hours Week]
	,RSM.[Avg Room Hours] [Division Average]
	from [RoomHoursWeekday]  RH 
	left join clinichrs CH on RH.Provider=CH.Provider and RH.[schedule interval]=CH.[schedule interval] and RH.[Work Days]=CH.[Work Days]
	left join [VW_Room_Scheduling_Metrics_Report]  RSM on RH.Provider=RSM.Provider and RH.[schedule interval]=CH.[schedule interval] 
	

	
	










GO
