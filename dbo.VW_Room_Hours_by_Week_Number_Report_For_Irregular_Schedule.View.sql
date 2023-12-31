USE [V3_Neurology]
GO
/****** Object:  View [dbo].[VW_Room_Hours_by_Week_Number_Report_For_Irregular_Schedule]    Script Date: 7/21/2023 4:01:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE view  [dbo].[VW_Room_Hours_by_Week_Number_Report_For_Irregular_Schedule]
as 
with [RoomHoursbyWeek] as
(
	select [first name]+' '+[last name]  Provider,[schedule interval],'Week '+ cast((DATEPART(WEEK,day([clinic date])))as varchar) [Clinic Schedule Week],
	sum((casT((DATEDIFF(MINUTE,[Clinic Start Time],[Clinic End Time])) as float)/60)* [Rooms Required]) [Total Room Hours Week]
	from Provider_Irregular_Schedule_FindRoom_ReferenceTable PRS 
	left join [employee_master] EM on PRS.Provider=EM.[full name]  
	group by [first name]+' '+[last name] ,[Clinic Schedule Week],[schedule interval],[clinic date]
)
	selecT Provider,[schedule interval],'Room Hours by Week Number' 'Chart',[Clinic Schedule Week],[Total Room Hours Week] 
	from [RoomHoursbyWeek]








GO
